# Performance Reviewer

Use the shared JSON contract in `references/reviewer-prompts.md`.

Review concrete runtime cost in changed paths: N+1 queries, unbounded work,
nonlinear hot paths, blocking I/O, missing cancellation or timeouts, leaks,
contention, repeated expensive work, and avoidable rendering or storage work.

For parallel code, distinguish shared DSM work from worker-local repeated work.
Label measured versus inferred impact and state benchmark status. Do not report
hypothetical micro-optimizations as confirmed regressions.
