#!/usr/bin/env python3
"""Deterministically validate a local review report.

The standalone service used this logic during post-processing. This smaller
adapter keeps only review-core checks: changed-line anchors, structured fix
locations, and decision consistency.
"""

from __future__ import annotations

import argparse
import ast
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Any


SEVERITY_RANK = {
    "blocking": 0,
    "important": 1,
    "suggestion": 2,
    "nit": 3,
}
FIX_OPERATIONS = {
    "replace",
    "insert_before",
    "insert_after",
    "delete",
    "create",
}
REQUIRED_TOP_LEVEL = {
    "meta",
    "decision",
    "summary",
    "findings",
    "praise",
    "open_questions",
    "review_followup",
    "dismissed_findings",
}


def normalize_repo_path(value: Any) -> str:
    path = str(value or "").replace("\\", "/").strip()
    if path.startswith("./"):
        path = path[2:]
    return path


def parse_diff_header_path(raw: str) -> str:
    value = raw.strip()
    if value.startswith('"'):
        try:
            decoded = ast.literal_eval(value)
            try:
                value = decoded.encode("latin-1").decode("utf-8")
            except (UnicodeEncodeError, UnicodeDecodeError):
                value = decoded
        except (SyntaxError, ValueError):
            value = value.strip('"')
    elif "\t" in value:
        value = value.split("\t", 1)[0]
    if value == "/dev/null":
        return ""
    if value.startswith("a/") or value.startswith("b/"):
        value = value[2:]
    return normalize_repo_path(value)


def positive_int(value: Any) -> int | None:
    if isinstance(value, bool):
        return None
    try:
        result = int(value)
    except (TypeError, ValueError):
        return None
    return result if result > 0 else None


def parse_added_locations(diff_text: str) -> set[tuple[str, int]]:
    """Return (repo-relative path, new-line) pairs for diff '+' lines."""
    locations: set[tuple[str, int]] = set()
    current_file: str | None = None
    new_line: int | None = None

    for raw_line in diff_text.splitlines():
        if raw_line.startswith("+++ "):
            current_file = parse_diff_header_path(raw_line[4:]) or None
            new_line = None
            continue

        hunk = re.match(r"^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@", raw_line)
        if hunk:
            new_line = int(hunk.group(1))
            continue

        if current_file is None or new_line is None:
            continue
        if raw_line.startswith("\\"):
            continue
        if raw_line.startswith("+"):
            locations.add((current_file, new_line))
            new_line += 1
        elif raw_line.startswith("-"):
            continue
        else:
            new_line += 1

    return locations


def code_lines(value: Any) -> list[str]:
    return str(value or "").replace("\r\n", "\n").replace("\r", "\n").splitlines()


def read_head_file(
    repo_path: Path,
    head_sha: str,
    file_path: str,
) -> tuple[list[str] | None, bool]:
    env = os.environ.copy()
    env["GIT_OPTIONAL_LOCKS"] = "0"
    if head_sha:
        result = subprocess.run(
            ["git", "-C", str(repo_path), "show", f"{head_sha}:{file_path}"],
            capture_output=True,
            env=env,
            check=False,
        )
        if result.returncode == 0:
            return code_lines(result.stdout.decode("utf-8", errors="replace")), True

    local_path = repo_path / file_path
    if local_path.is_file():
        return code_lines(local_path.read_text(encoding="utf-8", errors="replace")), True
    return None, False


def find_exact_ranges(
    source_lines: list[str],
    needle: list[str],
) -> list[tuple[int, int]]:
    if not needle or len(needle) > len(source_lines):
        return []
    size = len(needle)
    return [
        (index + 1, index + size)
        for index in range(len(source_lines) - size + 1)
        if source_lines[index:index + size] == needle
    ]


def validate_fix_group(
    blocks: list[dict[str, Any]],
    repo_path: Path,
    head_sha: str,
    file_cache: dict[str, tuple[list[str] | None, bool]],
) -> str | None:
    normalized_files = []
    for block in blocks:
        if not isinstance(block, dict):
            return "fix_code_blocks 必须是对象数组"
        operation = str(block.get("operation") or "").strip().lower()
        file_path = normalize_repo_path(block.get("file"))
        block["operation"] = operation
        block["file"] = file_path
        normalized_files.append(file_path)
        if operation not in FIX_OPERATIONS:
            return "fix_code_blocks[].operation 缺失或非法"
        if (
            not file_path
            or file_path.startswith("/")
            or ".." in Path(file_path).parts
        ):
            return "fix_code_blocks[].file 不是有效的仓库相对路径"

    if len(set(normalized_files)) != 1:
        return "同一 finding 的 fix_code_blocks 必须按文件分别验证"

    file_path = normalized_files[0]
    if file_path not in file_cache:
        file_cache[file_path] = read_head_file(repo_path, head_sha, file_path)
    source_lines, file_exists = file_cache[file_path]

    if any(block["operation"] == "create" for block in blocks):
        if len(blocks) != 1:
            return "同一新建文件只允许一个 create 修改块"
        block = blocks[0]
        if file_exists:
            return "create 操作的目标文件已存在"
        if not code_lines(block.get("code")):
            return "create 操作缺少新文件内容"
        return None

    if not file_exists or source_lines is None:
        return "无法从审查 commit 读取修改目标文件"

    ranges: list[tuple[int, int]] = []
    for block in blocks:
        operation = block["operation"]
        start = positive_int(block.get("base_start_line"))
        end = positive_int(block.get("base_end_line"))
        original = code_lines(block.get("original_code"))
        code = code_lines(block.get("code"))
        if start is None or end is None or end < start:
            return "fix_code_blocks 缺少有效的 base_start_line/base_end_line"
        if not original:
            return "fix_code_blocks[].original_code 不能为空"
        if operation == "delete":
            if code:
                return "delete 操作的 code 必须为空"
        elif not code:
            return f"{operation} 操作的 code 不能为空"
        if operation == "replace" and original == code:
            return "replace 操作没有产生任何修改"

        exact = (
            end <= len(source_lines)
            and source_lines[start - 1:end] == original
        )
        if not exact:
            matches = find_exact_ranges(source_lines, original)
            if len(matches) != 1:
                return "original_code 无法在审查 commit 中唯一定位"
            start, end = matches[0]
            block["base_start_line"] = start
            block["base_end_line"] = end
        ranges.append((start, end))

    ranges.sort()
    previous_end = 0
    for start, end in ranges:
        if start <= previous_end:
            return "同一文件的 fix_code_blocks 修改范围重叠"
        previous_end = end
    return None


def validate_primary_location(
    finding: dict[str, Any],
    added_locations: set[tuple[str, int]],
) -> str | None:
    file_path = normalize_repo_path(finding.get("file"))
    line = positive_int(finding.get("line"))
    finding["file"] = file_path
    if not file_path or line is None:
        return "finding 缺少有效的 file/line"
    if (file_path, line) not in added_locations:
        return "问题行不在本次新增/修改行（diff + 行）中"

    end_line = finding.get("end_line")
    if end_line is not None:
        parsed_end = positive_int(end_line)
        if parsed_end is None or parsed_end < line:
            return "finding 的 end_line 无效"
        finding["end_line"] = parsed_end
    finding["line"] = line
    return None


def default_assessment(finding: dict[str, Any], dismissed: bool = False) -> dict[str, str]:
    severity = finding.get("severity", "suggestion")
    return {
        "issue_exists": "可能存在" if not dismissed else "不存在",
        "trigger_probability": (
            "high"
            if severity == "blocking"
            else "medium"
            if severity == "important"
            else "low"
        ),
        "trigger_scenario": str(
            finding.get("trigger")
            or finding.get("message")
            or "候选 finding 缺少具体触发场景"
        ),
        "importance": str(
            finding.get("message")
            or "候选 finding 缺少影响说明"
        ),
    }


def expected_decision(findings: list[dict[str, Any]]) -> str:
    severities = {
        finding.get("severity")
        for finding in findings
        if isinstance(finding, dict)
    }
    if "blocking" in severities:
        return "REQUEST_CHANGES"
    if "important" in severities:
        return "APPROVE_WITH_COMMENTS"
    return "APPROVE"


def merge_source_agents(first: Any, second: Any) -> str:
    names: list[str] = []
    for value in (first, second):
        for name in str(value or "").split(","):
            name = name.strip()
            if name and name not in names:
                names.append(name)
    return ",".join(names)


def mechanically_deduplicate(
    findings: list[dict[str, Any]],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Mirror combine.py's exact-key dedup without semantic merging."""
    kept: dict[tuple[str, str, str], dict[str, Any]] = {}
    duplicates: list[dict[str, Any]] = []
    for finding in findings:
        key = (
            normalize_repo_path(finding.get("file")),
            str(finding.get("line", "")),
            str(finding.get("subcategory", "")),
        )
        previous = kept.get(key)
        if previous is None:
            kept[key] = finding
            continue
        merged_sources = merge_source_agents(
            previous.get("source_agent"),
            finding.get("source_agent"),
        )
        if SEVERITY_RANK.get(
            finding.get("severity"), 99
        ) < SEVERITY_RANK.get(previous.get("severity"), 99):
            finding["source_agent"] = merged_sources
            duplicates.append(previous)
            kept[key] = finding
        else:
            previous["source_agent"] = merged_sources
            duplicates.append(finding)
    return list(kept.values()), duplicates


def move_to_dismissed(
    review: dict[str, Any],
    finding: dict[str, Any],
    reason: str,
) -> None:
    finding["dismissal_reason"] = reason
    finding.setdefault("fix_code_blocks", [])
    finding.setdefault("assessment", default_assessment(finding, dismissed=True))
    review.setdefault("dismissed_findings", []).append(finding)


def validate_review(
    review: dict[str, Any],
    diff_text: str,
    repo_path: Path,
    head_sha: str,
    rewrite: bool,
) -> tuple[list[str], list[str]]:
    fatal_errors: list[str] = []
    recovered_errors: list[str] = []
    missing = sorted(REQUIRED_TOP_LEVEL - set(review))
    if missing:
        fatal_errors.append(f"缺少顶层字段: {', '.join(missing)}")
    if not isinstance(review.get("findings"), list):
        fatal_errors.append("findings 必须是数组")
        return fatal_errors, recovered_errors
    if not isinstance(review.get("dismissed_findings"), list):
        fatal_errors.append("dismissed_findings 必须是数组")
        return fatal_errors, recovered_errors

    added = parse_added_locations(diff_text)
    file_cache: dict[str, tuple[list[str] | None, bool]] = {}
    kept: list[dict[str, Any]] = []

    for index, finding in enumerate(review["findings"]):
        if not isinstance(finding, dict):
            fatal_errors.append(f"findings[{index}] 不是对象")
            continue

        location_error = validate_primary_location(finding, added)
        fix_error: str | None = None
        blocks = finding.get("fix_code_blocks")
        if location_error is None and isinstance(blocks, list):
            grouped: dict[str, list[dict[str, Any]]] = {}
            for block in blocks:
                if isinstance(block, dict):
                    grouped.setdefault(
                        normalize_repo_path(block.get("file")), []
                    ).append(block)
            if not grouped:
                fix_error = None
            elif len(grouped) > 1:
                for file_path, file_blocks in grouped.items():
                    fix_error = validate_fix_group(
                        file_blocks,
                        repo_path,
                        head_sha,
                        file_cache,
                    )
                    if fix_error:
                        break
            else:
                only_blocks = next(iter(grouped.values()))
                fix_error = validate_fix_group(
                    only_blocks,
                    repo_path,
                    head_sha,
                    file_cache,
                )
        elif location_error is None:
            fix_error = "fix_code_blocks 必须是数组"

        error = location_error or fix_error
        if error:
            if rewrite:
                recovered_errors.append(f"findings[{index}]: {error}")
                move_to_dismissed(
                    review,
                    finding,
                    error if error.startswith("问题行") else f"修改代码无法精确定位：{error}",
                )
            else:
                fatal_errors.append(f"findings[{index}]: {error}")
            continue
        finding["location_valid"] = True
        kept.append(finding)

    if rewrite:
        deduplicated, duplicates = mechanically_deduplicate(kept)
        for duplicate in duplicates:
            move_to_dismissed(
                review,
                duplicate,
                "与另一条 finding 重复，主 finding 已保留",
            )
        review["findings"] = deduplicated
        review["decision"] = expected_decision(deduplicated)
    else:
        _, duplicates = mechanically_deduplicate(kept)
        if duplicates:
            fatal_errors.append(
                f"存在 {len(duplicates)} 条相同 (file, line, subcategory) 的重复 finding"
            )
        expected = expected_decision(review["findings"])
        if review.get("decision") != expected:
            fatal_errors.append(
                f"decision 与 active findings 不一致: "
                f"{review.get('decision')} != {expected}"
            )
    return fatal_errors, recovered_errors


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Validate changed-line anchors, fix blocks, and decision."
    )
    parser.add_argument("--review", required=True, type=Path)
    parser.add_argument("--diff", required=True, type=Path)
    parser.add_argument("--repo-path", required=True, type=Path)
    parser.add_argument("--head-sha", default="")
    parser.add_argument(
        "--rewrite",
        action="store_true",
        help="Move invalid active findings to dismissed_findings and rewrite JSON.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        review = json.loads(args.review.read_text(encoding="utf-8"))
        diff_text = args.diff.read_text(encoding="utf-8", errors="replace")
    except (OSError, json.JSONDecodeError) as exc:
        print(f"读取输入失败: {exc}", file=sys.stderr)
        return 2

    if not isinstance(review, dict):
        print("review JSON 顶层必须是对象", file=sys.stderr)
        return 2

    fatal_errors, recovered_errors = validate_review(
        review,
        diff_text,
        args.repo_path,
        args.head_sha,
        args.rewrite,
    )
    if args.rewrite:
        args.review.write_text(
            json.dumps(review, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print(
            f"已重写 {args.review}: active={len(review.get('findings', []))} "
            f"dismissed={len(review.get('dismissed_findings', []))} "
            f"decision={review.get('decision')}"
        )

    for error in recovered_errors:
        print(f"[review-validation] recovered: {error}", file=sys.stderr)

    if fatal_errors:
        for error in fatal_errors:
            print(f"[review-validation] {error}", file=sys.stderr)
        return 1

    print(
        f"[review-validation] OK active={len(review.get('findings', []))} "
        f"dismissed={len(review.get('dismissed_findings', []))} "
        f"decision={review.get('decision')}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
