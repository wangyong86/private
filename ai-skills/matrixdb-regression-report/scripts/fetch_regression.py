#!/usr/bin/env python3
"""Fetch a MatrixDB regression run and print a read-only Markdown report."""

from __future__ import annotations

import argparse
import http.cookiejar
import json
import re
import shlex
import sys
import urllib.error
import urllib.parse
import urllib.request
from typing import Any, Dict, Iterable, List, Optional, Tuple


FAILURE_STATUSES = {"failed", "timeout"}
RUN_TEST_RE = re.compile(r"run[-_ ]?test", re.IGNORECASE)


class DashboardError(RuntimeError):
    """Raised when the dashboard cannot provide a complete report."""


class DashboardClient:
    def __init__(self, dashboard_url: str, timeout: float) -> None:
        parsed = urllib.parse.urlsplit(dashboard_url)
        if parsed.scheme not in {"http", "https"} or not parsed.netloc:
            raise DashboardError("the dashboard URL must use http or https")

        query = urllib.parse.parse_qs(parsed.query)
        run_values = query.get("run", [])
        if not run_values or not run_values[0].isdigit() or int(run_values[0]) <= 0:
            raise DashboardError("the dashboard URL must contain a positive run parameter")

        self.run_id = int(run_values[0])
        self.origin = f"{parsed.scheme}://{parsed.netloc}"
        self.timeout = timeout
        cookie_jar = http.cookiejar.CookieJar()
        self.opener = urllib.request.build_opener(
            urllib.request.HTTPCookieProcessor(cookie_jar)
        )

        # Opening the shared link exchanges its key for an HttpOnly session cookie.
        self._open(dashboard_url).read()

    def _open(self, url: str) -> Any:
        request = urllib.request.Request(
            url,
            headers={"Accept": "application/json, text/plain, */*", "User-Agent": "matrixdb-regression-report/1"},
        )
        try:
            return self.opener.open(request, timeout=self.timeout)
        except urllib.error.HTTPError as exc:
            detail = ""
            try:
                payload = exc.read().decode("utf-8", errors="replace")
                parsed = json.loads(payload)
                detail = str(parsed.get("error") or parsed.get("message") or "")
            except (ValueError, AttributeError):
                pass
            suffix = f": {detail}" if detail else ""
            raise DashboardError(f"dashboard request failed with HTTP {exc.code}{suffix}") from exc
        except urllib.error.URLError as exc:
            raise DashboardError(f"dashboard request failed: {exc.reason}") from exc

    def get_json(self, path: str, query: Optional[Dict[str, Any]] = None) -> Any:
        url = self.origin + path
        if query:
            url += "?" + urllib.parse.urlencode(query)
        with self._open(url) as response:
            try:
                return json.load(response)
            except (ValueError, UnicodeDecodeError) as exc:
                raise DashboardError(f"dashboard returned invalid JSON for {path}") from exc

    def get_text(self, path: str, query: Optional[Dict[str, Any]] = None) -> str:
        url = self.origin + path
        if query:
            url += "?" + urllib.parse.urlencode(query)
        with self._open(url) as response:
            return response.read().decode("utf-8", errors="replace")

    def find_run(self) -> Optional[Dict[str, Any]]:
        limit = 100
        offset = 0
        while True:
            payload = self.get_json(
                "/api/regression/runs", {"limit": limit, "offset": offset}
            )
            items = payload.get("items", []) if isinstance(payload, dict) else []
            for item in items:
                if str(item.get("id")) == str(self.run_id):
                    return item
            total = int(payload.get("total", 0)) if isinstance(payload, dict) else 0
            offset += limit
            if not items or offset >= total:
                return None

    def get_tree(self) -> Dict[str, Any]:
        payload = self.get_json(f"/api/regression/runs/{self.run_id}/tree")
        if not isinstance(payload, dict):
            raise DashboardError("run tree response was not an object")
        return payload

    def get_task(self, pipeline: str, task_id: str) -> Dict[str, Any]:
        payload = self.get_json(
            f"/api/regression/runs/{self.run_id}/task",
            {"pipeline": pipeline, "task_id": task_id},
        )
        if not isinstance(payload, dict):
            raise DashboardError("task response was not an object")
        return payload

    def get_diff(
        self, pipeline: str, task_id: str, task_run_id: str, step_name: str
    ) -> str:
        return self.get_text(
            f"/api/regression/runs/{self.run_id}/log-preview",
            {
                "pipeline": pipeline,
                "task_id": task_id,
                "task_run_id": task_run_id,
                "step_name": step_name,
                "diff_only": "1",
            },
        )


def relative_path(path: str) -> str:
    prefix = "/workspace/matrixdb/"
    return path[len(prefix) :] if path.startswith(prefix) else path


def parse_diff(text: str) -> List[Dict[str, Any]]:
    files: List[Dict[str, Any]] = []
    current_file: Optional[Dict[str, Any]] = None
    current_hunk: Optional[Dict[str, Any]] = None

    for line in text.splitlines():
        if line.startswith("diff "):
            try:
                tokens = shlex.split(line)
            except ValueError:
                tokens = line.split()
            old_path = tokens[-2] if len(tokens) >= 3 else "unknown"
            new_path = tokens[-1] if len(tokens) >= 2 else "unknown"
            current_file = {
                "command": line,
                "old_path": relative_path(old_path),
                "new_path": relative_path(new_path),
                "hunks": [],
            }
            files.append(current_file)
            current_hunk = None
        elif line.startswith("--- "):
            old_path = line[4:].split("\t", 1)[0]
            if current_file is None:
                current_file = {
                    "command": "",
                    "old_path": relative_path(old_path),
                    "new_path": "unknown",
                    "hunks": [],
                }
                files.append(current_file)
            else:
                current_file["old_path"] = relative_path(old_path)
        elif line.startswith("+++ "):
            new_path = line[4:].split("\t", 1)[0]
            if current_file is not None:
                current_file["new_path"] = relative_path(new_path)
        elif line.startswith("@@ "):
            if current_file is None:
                current_file = {
                    "command": "",
                    "old_path": "unknown",
                    "new_path": "unknown",
                    "hunks": [],
                }
                files.append(current_file)
            current_hunk = {"header": line, "lines": []}
            current_file["hunks"].append(current_hunk)
        elif current_hunk is not None:
            current_hunk["lines"].append(line)

    return files


def changed_lines(hunk: Dict[str, Any]) -> Iterable[str]:
    for line in hunk.get("lines", []):
        if line.startswith(("+", "-")) and not line.startswith(("+++", "---")):
            yield line


def matching_hunks(
    diff_files: List[Dict[str, Any]], keyword: Optional[str]
) -> List[Tuple[Dict[str, Any], Dict[str, Any]]]:
    matches: List[Tuple[Dict[str, Any], Dict[str, Any]]] = []
    lowered = keyword.lower() if keyword else None
    for diff_file in diff_files:
        for hunk in diff_file.get("hunks", []):
            if lowered is None or any(lowered in line.lower() for line in changed_lines(hunk)):
                matches.append((diff_file, hunk))
    return matches


def markdown_cell(value: Any) -> str:
    return str(value if value not in (None, "") else "-").replace("|", "\\|").replace("\n", " ")


def format_time(value: Any) -> str:
    return str(value or "-")


def collect_failures(client: DashboardClient, tree: Dict[str, Any], keyword: Optional[str]) -> List[Dict[str, Any]]:
    failures: List[Dict[str, Any]] = []
    for pipeline in tree.get("pipelines", []):
        pipeline_name = str(pipeline.get("name") or "unknown")
        for stage in pipeline.get("stages", []):
            for task in stage.get("tasks", []):
                if str(task.get("status") or "").lower() not in FAILURE_STATUSES:
                    continue
                record: Dict[str, Any] = {
                    "pipeline": pipeline_name,
                    "stage": stage.get("name") or stage.get("id") or "-",
                    "task": task.get("name") or task.get("id") or "unknown",
                    "task_id": str(task.get("id") or ""),
                    "status": task.get("status") or "unknown",
                    "step": "-",
                    "diff_text": "",
                    "diff_files": [],
                    "matches": [],
                    "error": "",
                }
                try:
                    detail = client.get_task(pipeline_name, record["task_id"])
                    steps = detail.get("steps", [])
                    run_step = next(
                        (
                            step
                            for step in steps
                            if RUN_TEST_RE.search(
                                f"{step.get('id', '')} {step.get('name', '')}"
                            )
                        ),
                        None,
                    )
                    if run_step is None:
                        record["error"] = "no run-test step"
                    elif not detail.get("run_id"):
                        record["error"] = "task has no run ID"
                    else:
                        step_name = str(run_step.get("id") or run_step.get("name") or "")
                        record["step"] = run_step.get("name") or step_name
                        record["diff_text"] = client.get_diff(
                            pipeline_name,
                            record["task_id"],
                            str(detail["run_id"]),
                            step_name,
                        ).rstrip()
                        record["diff_files"] = parse_diff(record["diff_text"])
                        record["matches"] = matching_hunks(record["diff_files"], keyword)
                        if not record["diff_files"]:
                            record["error"] = "no displayable regression diff"
                except DashboardError as exc:
                    record["error"] = str(exc)
                failures.append(record)
    return failures


def render_report(
    client: DashboardClient,
    run: Optional[Dict[str, Any]],
    tree: Dict[str, Any],
    failures: List[Dict[str, Any]],
    keyword: Optional[str],
    show_hunks: bool,
) -> str:
    lines: List[str] = [f"# MatrixDB Regression Run {client.run_id}", ""]
    lines.extend(
        [
            f"- Dashboard: `{client.origin}` (credentials omitted)",
            f"- Status: `{(run or {}).get('status', 'unknown')}`",
            f"- Repository: `{(run or {}).get('repo_full_name', '-')}`",
            f"- Pull request: `{(run or {}).get('pr_number', '-')}`",
            f"- Branch: `{(run or {}).get('source_branch', '-')}` -> `{(run or {}).get('target_branch', '-')}`",
            f"- Head: `{(run or {}).get('head_sha', '-')}`",
            f"- Requested by: `{(run or {}).get('requested_by_name') or (run or {}).get('requested_by') or '-'}`",
            f"- Started: `{format_time((run or {}).get('started_at'))}`",
            f"- Finished: `{format_time((run or {}).get('finished_at'))}`",
            "",
            "## Pipelines",
            "",
            "| Pipeline | Status | Failed tasks |",
            "|---|---|---:|",
        ]
    )
    for pipeline in tree.get("pipelines", []):
        failed_count = sum(
            1
            for stage in pipeline.get("stages", [])
            for task in stage.get("tasks", [])
            if str(task.get("status") or "").lower() in FAILURE_STATUSES
        )
        lines.append(
            f"| {markdown_cell(pipeline.get('name'))} | {markdown_cell(pipeline.get('status'))} | {failed_count} |"
        )

    lines.extend(
        [
            "",
            "## Failed Tasks",
            "",
            "| Pipeline | Task | Status | Step | Diff files | Diff hunks | Matching hunks | Note |",
            "|---|---|---|---|---:|---:|---:|---|",
        ]
    )
    for failure in failures:
        diff_file_count = len(failure["diff_files"])
        hunk_count = sum(len(item.get("hunks", [])) for item in failure["diff_files"])
        lines.append(
            "| {pipeline} | {task} | {status} | {step} | {files} | {hunks} | {matches} | {note} |".format(
                pipeline=markdown_cell(failure["pipeline"]),
                task=markdown_cell(failure["task"]),
                status=markdown_cell(failure["status"]),
                step=markdown_cell(failure["step"]),
                files=diff_file_count,
                hunks=hunk_count,
                matches=len(failure["matches"]),
                note=markdown_cell(failure["error"]),
            )
        )

    lines.extend(["", "## Diff Inventory", ""])
    inventory_count = 0
    for failure in failures:
        if not failure["diff_files"]:
            continue
        inventory_count += 1
        lines.append(f"### {failure['pipeline']} / {failure['task']}")
        lines.append("")
        for diff_file in failure["diff_files"]:
            total = len(diff_file.get("hunks", []))
            matched = sum(
                1
                for matched_file, _ in failure["matches"]
                if matched_file is diff_file
            )
            path = diff_file.get("old_path") or diff_file.get("new_path") or "unknown"
            suffix = f", {matched} matching" if keyword else ""
            lines.append(f"- `{path}`: {total} hunk(s){suffix}")
        lines.append("")
    if inventory_count == 0:
        lines.append("No failed task exposed a displayable regression diff.")
        lines.append("")

    if keyword:
        lines.extend([f"## Keyword Matches: `{keyword}`", ""])
        found = False
        for failure in failures:
            if not failure["matches"]:
                continue
            found = True
            lines.append(f"### {failure['pipeline']} / {failure['task']}")
            lines.append("")
            for diff_file, hunk in failure["matches"]:
                path = diff_file.get("old_path") or diff_file.get("new_path") or "unknown"
                lines.append(f"- `{path}` `{hunk['header']}`")
                lines.append("")
                output_lines = hunk.get("lines", []) if show_hunks else [
                    line
                    for line in changed_lines(hunk)
                    if keyword.lower() in line.lower()
                ]
                lines.append("```diff")
                if show_hunks:
                    lines.append(hunk["header"])
                lines.extend(output_lines)
                lines.append("```")
                lines.append("")
        if not found:
            lines.append("No changed diff line matched the keyword.")
            lines.append("")
    elif show_hunks:
        lines.extend(["## Diff Hunks", ""])
        for failure in failures:
            for diff_file, hunk in failure["matches"]:
                path = diff_file.get("old_path") or diff_file.get("new_path") or "unknown"
                lines.extend(
                    [
                        f"### {failure['pipeline']} / {failure['task']} / `{path}`",
                        "",
                        "```diff",
                        hunk["header"],
                        *hunk.get("lines", []),
                        "```",
                        "",
                    ]
                )

    return "\n".join(lines).rstrip() + "\n"


def parse_args(argv: Optional[List[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Print a read-only report for a MatrixDB regression dashboard run."
    )
    parser.add_argument("url", help="shared regression dashboard URL")
    parser.add_argument(
        "--keyword",
        help="include hunks whose changed lines contain this text (case-insensitive)",
    )
    parser.add_argument(
        "--show-hunks",
        action="store_true",
        help="print complete matching hunks instead of only matching changed lines",
    )
    parser.add_argument(
        "--timeout", type=float, default=30.0, help="per-request timeout in seconds"
    )
    args = parser.parse_args(argv)
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    return args


def main(argv: Optional[List[str]] = None) -> int:
    args = parse_args(argv)
    try:
        client = DashboardClient(args.url, args.timeout)
        run = client.find_run()
        tree = client.get_tree()
        failures = collect_failures(client, tree, args.keyword)
        sys.stdout.write(
            render_report(
                client, run, tree, failures, args.keyword, args.show_hunks
            )
        )
        return 0
    except DashboardError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
