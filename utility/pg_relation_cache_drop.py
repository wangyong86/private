#!/usr/bin/env python3
"""
Drop Linux page cache for PostgreSQL relation files.

This tool accepts a libpq connection string plus either repeated table names
or a file containing one table name per line. For each requested table it
discovers:

- the table heap files
- descendant partition heap files
- toast table files
- all index files for the table/partitions/toast relations
- auxiliary forks such as _fsm, _vm, and _init
- all segment files for each fork

Actual cache dropping is done with posix_fadvise(..., DONTNEED) on each file.
That is a best-effort Linux file-level page-cache eviction mechanism.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from collections import OrderedDict, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Sequence, Tuple

import psycopg2
from psycopg2.extensions import connection as PgConnection


SUPPORTED_ROOT_RELKINDS = {"r", "p", "m"}
RELKIND_NAMES = {
    "r": "table",
    "p": "partitioned table",
    "m": "materialized view",
    "i": "index",
    "I": "partitioned index",
    "t": "toast table",
}


ROOT_RESOLUTION_SQL = """
WITH input(name) AS (
    SELECT trim(value)
    FROM unnest(%s::text[]) AS value
    WHERE trim(value) <> ''
)
SELECT
    input.name AS input_name,
    to_regclass(input.name)::oid AS oid
FROM input;
"""


ROOT_METADATA_SQL = """
SELECT
    c.oid::bigint AS oid,
    c.relkind,
    format('%%I.%%I', n.nspname, c.relname) AS qualified_name
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE c.oid = ANY(%s::oid[]);
"""


RELATION_DISCOVERY_SQL = """
WITH RECURSIVE root(input_name, oid) AS (
    SELECT *
    FROM unnest(%s::text[], %s::oid[]) AS t(input_name, oid)
),
descendants(input_name, oid) AS (
    SELECT input_name, oid
    FROM root
    UNION ALL
    SELECT d.input_name, i.inhrelid
    FROM descendants AS d
    JOIN pg_inherits AS i ON i.inhparent = d.oid
),
tables AS (
    SELECT DISTINCT d.input_name, d.oid
    FROM descendants AS d
    JOIN pg_class AS c ON c.oid = d.oid
    WHERE c.relkind IN ('r', 'p', 'm')
),
storage_relations AS (
    SELECT input_name, oid, 'table'::text AS relation_role
    FROM tables
    UNION ALL
    SELECT t.input_name, i.indexrelid, 'index'::text
    FROM tables AS t
    JOIN pg_index AS i ON i.indrelid = t.oid
    UNION ALL
    SELECT t.input_name, c.reltoastrelid, 'toast'::text
    FROM tables AS t
    JOIN pg_class AS c ON c.oid = t.oid
    WHERE c.reltoastrelid <> 0
    UNION ALL
    SELECT t.input_name, i.indexrelid, 'toast_index'::text
    FROM tables AS t
    JOIN pg_class AS c ON c.oid = t.oid
    JOIN pg_index AS i ON i.indrelid = c.reltoastrelid
    WHERE c.reltoastrelid <> 0
)
SELECT DISTINCT
    s.input_name,
    s.relation_role,
    c.oid::bigint AS oid,
    format('%%I.%%I', n.nspname, c.relname) AS qualified_name,
    c.relkind,
    pg_relation_filepath(c.oid) AS relpath
FROM storage_relations AS s
JOIN pg_class AS c ON c.oid = s.oid
JOIN pg_namespace AS n ON n.oid = c.relnamespace
ORDER BY s.input_name, s.relation_role, qualified_name;
"""


@dataclass(frozen=True)
class RootRelation:
    input_name: str
    oid: int
    qualified_name: str
    relkind: str


@dataclass(frozen=True)
class RelationStorage:
    input_name: str
    relation_role: str
    oid: int
    qualified_name: str
    relkind: str
    relpath: str


@dataclass(frozen=True)
class CacheDropResult:
    path: Path
    size_bytes: int
    dropped: bool


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Discover PostgreSQL relation files for the given tables and drop "
            "their Linux page cache with posix_fadvise(DONTNEED)."
        )
    )
    parser.add_argument(
        "--conninfo",
        help=(
            "libpq connection string, for example "
            "'host=/tmp dbname=postgres user=postgres'; "
            "if omitted, infer connection parameters from the current psql default connection"
        ),
    )
    parser.add_argument(
        "--table",
        dest="tables",
        action="append",
        default=[],
        help="table name to process; may be repeated, schema-qualified names are recommended",
    )
    parser.add_argument(
        "--table-file",
        help="file containing one table name per line; blank lines and lines starting with # are ignored",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="resolve and print relation files without dropping cache",
    )
    parser.add_argument(
        "--checkpoint",
        action="store_true",
        help="run CHECKPOINT before file discovery to improve eviction effectiveness",
    )
    parser.add_argument(
        "--fsync",
        action="store_true",
        help="fsync each relation file before DONTNEED; slower but can drop more dirty cache",
    )
    parser.add_argument(
        "--quiet",
        action="store_true",
        help="reduce per-file output and only print high-level summary",
    )
    return parser.parse_args(argv)


def load_table_names(cli_tables: Sequence[str], table_file: str | None) -> List[str]:
    names: List[str] = []
    names.extend(cli_tables)

    if table_file:
        with open(table_file, "r", encoding="utf-8") as handle:
            for raw_line in handle:
                line = raw_line.strip()
                if not line or line.startswith("#"):
                    continue
                names.append(line)

    deduped: "OrderedDict[str, None]" = OrderedDict()
    for name in names:
        trimmed = name.strip()
        if trimmed:
            deduped[trimmed] = None

    result = list(deduped.keys())
    if not result:
        raise ValueError("no table names were provided; use --table and/or --table-file")
    return result


def infer_connection_kwargs_from_psql() -> Dict[str, str]:
    try:
        result = subprocess.run(
            ["psql", "-XAtqc", r"\conninfo"],
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError as exc:
        raise RuntimeError(
            "psql was not found in PATH; provide --conninfo explicitly"
        ) from exc
    except subprocess.CalledProcessError as exc:
        stderr = exc.stderr.strip()
        detail = f": {stderr}" if stderr else ""
        raise RuntimeError(
            "failed to infer connection parameters from psql; provide --conninfo explicitly"
            f"{detail}"
        ) from exc

    fields: Dict[str, str] = {}
    for raw_line in result.stdout.splitlines():
        if "|" not in raw_line:
            continue
        key, value = raw_line.split("|", 1)
        key = key.strip()
        value = value.strip()
        if key:
            fields[key] = value

    dbname = fields.get("Database")
    user = fields.get("Client User")
    port = fields.get("Server Port")
    host = fields.get("Socket Directory") or fields.get("Host")

    missing = [
        name
        for name, value in (
            ("Database", dbname),
            ("Client User", user),
            ("Server Port", port),
        )
        if not value
    ]
    if missing:
        raise RuntimeError(
            "psql connection info was incomplete; missing fields: " + ", ".join(missing)
        )

    kwargs = {
        "dbname": dbname,
        "user": user,
        "port": port,
    }
    if host:
        kwargs["host"] = host

    return kwargs


def connect_db(conninfo: str | None) -> PgConnection:
    if conninfo:
        conn = psycopg2.connect(conninfo)
    else:
        conn = psycopg2.connect(**infer_connection_kwargs_from_psql())
    conn.autocommit = True
    return conn


def fetch_scalar(cur, sql: str) -> str:
    cur.execute(sql)
    row = cur.fetchone()
    if not row or row[0] is None:
        raise RuntimeError(f"query returned no value: {sql}")
    return row[0]


def resolve_root_relations(conn: PgConnection, table_names: Sequence[str]) -> List[RootRelation]:
    with conn.cursor() as cur:
        cur.execute(ROOT_RESOLUTION_SQL, (list(table_names),))
        rows = cur.fetchall()

        oid_by_name: Dict[str, int | None] = {name: None for name in table_names}
        for input_name, oid in rows:
            oid_by_name[input_name] = oid

        missing = [name for name, oid in oid_by_name.items() if oid is None]
        if missing:
            raise RuntimeError(
                "could not resolve the following table names: " + ", ".join(missing)
            )

        oid_list = [int(oid_by_name[name]) for name in table_names]
        cur.execute(ROOT_METADATA_SQL, (oid_list,))
        meta_rows = cur.fetchall()

    meta_by_oid = {
        int(oid): (qualified_name, relkind)
        for oid, relkind, qualified_name in meta_rows
    }

    roots: List[RootRelation] = []
    unsupported: List[str] = []
    for name in table_names:
        oid = int(oid_by_name[name])
        qualified_name, relkind = meta_by_oid[oid]
        if relkind not in SUPPORTED_ROOT_RELKINDS:
            unsupported.append(
                f"{name} -> {qualified_name} ({RELKIND_NAMES.get(relkind, relkind)})"
            )
            continue
        roots.append(
            RootRelation(
                input_name=name,
                oid=oid,
                qualified_name=qualified_name,
                relkind=relkind,
            )
        )

    if unsupported:
        raise RuntimeError(
            "unsupported root relation kinds; only ordinary tables, partitioned tables, "
            "and materialized views are accepted: " + "; ".join(unsupported)
        )

    return roots


def discover_relation_storage(
    conn: PgConnection, roots: Sequence[RootRelation]
) -> List[RelationStorage]:
    input_names = [root.input_name for root in roots]
    root_oids = [root.oid for root in roots]

    with conn.cursor() as cur:
        cur.execute(RELATION_DISCOVERY_SQL, (input_names, root_oids))
        rows = cur.fetchall()

    storage: List[RelationStorage] = []
    for input_name, relation_role, oid, qualified_name, relkind, relpath in rows:
        if relpath is None:
            continue
        storage.append(
            RelationStorage(
                input_name=input_name,
                relation_role=relation_role,
                oid=int(oid),
                qualified_name=qualified_name,
                relkind=relkind,
                relpath=relpath,
            )
        )

    return storage


def expand_relation_files(data_directory: Path, relpath: str) -> List[Path]:
    relative_path = Path(relpath)
    base_path = data_directory / relative_path
    parent_dir = base_path.parent
    base_name = base_path.name

    if not parent_dir.is_dir():
        return []

    pattern = re.compile(
        rf"^{re.escape(base_name)}(?:_(?:fsm|vm|init))?(?:\.\d+)?$"
    )

    paths: List[Path] = []
    for entry in os.scandir(parent_dir):
        if not entry.is_file(follow_symlinks=True):
            continue
        if pattern.match(entry.name):
            paths.append(Path(entry.path))

    return sorted(paths)


def group_files_by_path(
    data_directory: Path, storage_rows: Sequence[RelationStorage]
) -> Tuple[Dict[Path, List[RelationStorage]], List[Tuple[RelationStorage, List[Path]]]]:
    by_path: Dict[Path, List[RelationStorage]] = defaultdict(list)
    expanded_rows: List[Tuple[RelationStorage, List[Path]]] = []

    for row in storage_rows:
        files = expand_relation_files(data_directory, row.relpath)
        expanded_rows.append((row, files))
        for file_path in files:
            by_path[file_path].append(row)

    return by_path, expanded_rows


def drop_file_cache(path: Path, do_fsync: bool, dry_run: bool) -> CacheDropResult:
    size_bytes = path.stat().st_size
    if dry_run:
        return CacheDropResult(path=path, size_bytes=size_bytes, dropped=False)

    flags = os.O_RDONLY
    if hasattr(os, "O_CLOEXEC"):
        flags |= os.O_CLOEXEC

    fd = os.open(path, flags)
    try:
        if do_fsync:
            os.fsync(fd)
        os.posix_fadvise(fd, 0, 0, os.POSIX_FADV_DONTNEED)
    finally:
        os.close(fd)

    return CacheDropResult(path=path, size_bytes=size_bytes, dropped=True)


def format_size(size_bytes: int) -> str:
    units = ["B", "KiB", "MiB", "GiB", "TiB"]
    value = float(size_bytes)
    for unit in units:
        if value < 1024.0 or unit == units[-1]:
            if unit == "B":
                return f"{int(value)}{unit}"
            return f"{value:.1f}{unit}"
        value /= 1024.0
    return f"{size_bytes}B"


def maybe_checkpoint(conn: PgConnection, enabled: bool) -> None:
    if not enabled:
        return
    with conn.cursor() as cur:
        cur.execute("CHECKPOINT")


def print_discovery_summary(
    roots: Sequence[RootRelation],
    expanded_rows: Sequence[Tuple[RelationStorage, List[Path]]],
    quiet: bool,
) -> None:
    print("Resolved roots:")
    for root in roots:
        kind_name = RELKIND_NAMES.get(root.relkind, root.relkind)
        print(f"  - {root.input_name} -> {root.qualified_name} [{kind_name}]")

    if quiet:
        return

    print("\nDiscovered relation storage:")
    for row, files in expanded_rows:
        kind_name = RELKIND_NAMES.get(row.relkind, row.relkind)
        print(
            f"  - {row.input_name}: {row.qualified_name} "
            f"[{row.relation_role}, {kind_name}]"
        )
        if files:
            for file_path in files:
                print(f"      {file_path}")
        else:
            print("      <no matching files found on disk>")


def run(argv: Sequence[str]) -> int:
    args = parse_args(argv)
    table_names = load_table_names(args.tables, args.table_file)

    if not hasattr(os, "posix_fadvise") or not hasattr(os, "POSIX_FADV_DONTNEED"):
        raise RuntimeError("this platform does not support os.posix_fadvise(..., DONTNEED)")

    conn = connect_db(args.conninfo)
    try:
        maybe_checkpoint(conn, args.checkpoint)

        with conn.cursor() as cur:
            data_directory = Path(fetch_scalar(cur, "SHOW data_directory"))

        roots = resolve_root_relations(conn, table_names)
        storage_rows = discover_relation_storage(conn, roots)
        file_map, expanded_rows = group_files_by_path(data_directory, storage_rows)
    finally:
        conn.close()

    print_discovery_summary(roots, expanded_rows, args.quiet)

    if not file_map:
        print("\nNo relation files were found for the requested tables.", file=sys.stderr)
        return 1

    action = "Would drop" if args.dry_run else "Dropping"
    print(f"\n{action} cache for {len(file_map)} files under {data_directory}")

    total_bytes = 0
    dropped_files = 0
    for path in sorted(file_map.keys()):
        result = drop_file_cache(path, do_fsync=args.fsync, dry_run=args.dry_run)
        total_bytes += result.size_bytes
        if result.dropped:
            dropped_files += 1

        if not args.quiet:
            owners = ", ".join(
                f"{row.qualified_name}:{row.relation_role}" for row in file_map[path]
            )
            verb = "would drop" if args.dry_run else "dropped"
            print(f"  - {verb}: {path} ({format_size(result.size_bytes)}) [{owners}]")

    summary_verb = "would target" if args.dry_run else "dropped"
    print(
        f"\nSummary: {summary_verb} {len(file_map)} files, total size {format_size(total_bytes)}"
    )
    if not args.dry_run and args.fsync:
        print("Note: --fsync was enabled before DONTNEED on each file.")
    elif not args.dry_run:
        print("Note: eviction is best-effort; consider --checkpoint and/or --fsync for stronger results.")

    return 0


def main() -> None:
    try:
        raise SystemExit(run(sys.argv[1:]))
    except KeyboardInterrupt:
        raise SystemExit("interrupted")
    except Exception as exc:  # pragma: no cover - CLI top-level error path
        raise SystemExit(f"error: {exc}")


if __name__ == "__main__":
    main()
