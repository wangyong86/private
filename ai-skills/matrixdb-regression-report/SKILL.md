---
name: matrixdb-regression-report
description: Inspect MatrixDB regression-dashboard run URLs and produce a read-only decision report covering run metadata, pipeline status, failed tasks, diff files, and optionally every diff hunk whose changed lines match a keyword. Use when a user shares a regression URL with key, run, and view parameters or asks to triage a MatrixDB regression run. Do not use it to cancel, retry, or modify a run.
---

# MatrixDB Regression Report

Use the bundled script rather than rediscovering the dashboard's private API from
the frontend bundle. It establishes the session cookie in memory and performs GET
requests only.

## Workflow

1. Run the script against the exact shared URL supplied by the user. Opening that
   URL exchanges its `key` query value for an in-memory session cookie.

   ```bash
   python3 /home/wy/.codex/skills/matrixdb-regression-report/scripts/fetch_regression.py '<regression-url>'
   ```

2. The script locates the requested run, fetches its pipeline tree, selects tasks
   whose status is `failed` or `timeout`, and fetches each task's `run-test` diff.

3. It parses the unified diffs into files and hunks. For a focused review, add a
   keyword; add `--show-hunks` when surrounding context is needed:

   ```bash
   python3 /home/wy/.codex/skills/matrixdb-regression-report/scripts/fetch_regression.py \
     '<regression-url>' --keyword mars3options --show-hunks
   ```

4. Use the generated Markdown as evidence for the response. Lead with the run
   status and decision-relevant failures. Separate
   observed API data from interpretation. List pipelines, failed tasks, affected
   files, hunk counts, and exact matching changed lines or hunks.

   Pipeline regression runs normally build the requested head in the build
   task, publish a binary artifact, and let each test task download that
   artifact into a newly created test cluster. Treat this as a full rebuild and
   a fresh runtime by default. Do not explain a diff with a stale binary or
   stale cluster unless the build, artifact-download, or cluster-start logs
   explicitly show a failure or an older revision being used. For example,
   run106's `compile matrixdb` task succeeded, the test log extracted
   `Artifact-matrixdb.gzip`, and the test task created its own cluster; its
   runtime output must therefore be analyzed as output from the run's rebuilt
   artifact.

   For every answer-file diff, keep these facts separate:

   - actual runtime answer: the line emitted by the run;
   - expected-file content: the answer currently checked into the tested head;
   - source/design expectation: what the current source and documented
     semantics say should be emitted.

   A commit that edits an expected file does not prove that runtime behavior
   was synchronized. Report which answer files match the observed runtime,
   which remain unsynchronized, and whether a remaining mismatch is a source
   behavior issue, a test-answer issue, or an unverified design expectation.

5. Treat the `key` query value and session cookie as credentials. Never print the
   full input URL, key, cookie, or request headers. The script intentionally reports
   only the origin and run ID.

6. This workflow is read-only. A request to inspect or summarize a run does not
   authorize expected-file updates, reruns, cancellation, or other mutations. Apply
   repository changes only when the user separately requests them.

## Script Interface

```text
fetch_regression.py URL [--keyword TEXT] [--show-hunks] [--timeout SECONDS]
```

Inputs:

- `URL` is required. It must be an HTTP or HTTPS dashboard URL containing a
  positive integer `run` query parameter. The shared URL normally also contains
  the credential-bearing `key` parameter.
- `--keyword TEXT` keeps only hunks where a changed `+` or `-` line contains
  `TEXT`, case-insensitively. It does not remove failed tasks from the report.
- `--show-hunks` prints complete selected unified-diff hunks. With a keyword it
  expands matching hunks; without a keyword it prints every available diff hunk.
- `--timeout SECONDS` sets the positive per-request timeout; the default is 30.
- The script reads no stdin, configuration file, or required environment variable.

Outputs:

- Standard output is a Markdown report containing run metadata, pipeline states,
  failed-task details, a diff-file inventory, and optional matching lines or full
  hunks. It can be redirected to a file by the caller; the script itself writes no
  files.
- Standard error receives a single `error: ...` diagnostic for dashboard or
  response failures. Argument validation errors use `argparse`'s normal stderr
  format.
- Exit status is `0` when a report was rendered, `1` for a dashboard/request/data
  error, and `2` for invalid command-line arguments.

Network behavior is GET-only. The cookie jar, shared-link key, and retrieved data
remain in process memory and are not intentionally persisted.

## Report Modes

- With no keyword, the report gives run metadata, pipeline status, failed tasks,
  and a per-task diff inventory.
- `--keyword TEXT` restricts the hunk inventory to hunks where a changed `+` or `-`
  line contains `TEXT` (case-insensitive) and lists the matching changed lines.
- `--show-hunks` includes the complete matching unified-diff hunks. Without a
  keyword, this can be large and should be used only when the user needs raw detail.
- `--timeout SECONDS` changes the per-request timeout when the service is slow.

If a failed task has no `run-test` step or no diff output, retain it in the failure
table and state that no displayable regression diff was available. Do not treat an
empty diff as a successful task.
