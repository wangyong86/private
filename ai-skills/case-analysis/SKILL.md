---
name: case-analysis
description: Analyze MatrixDB regression or isolation2 cases when a test fails, slows, hangs, or returns an unexpected result. Use for case diagnosis and optimization-impact analysis; do not use for standalone source explanation or regression-dashboard summaries.
---

# Case Analysis

State the conclusion in an order a reader can check: what the test is for, what it expects, why this run failed, and what to do.

## Route the request

Choose the narrowest applicable mode before investigating:

- **Case design**: explain what the case is intended to verify and how its sessions, transactions, faults, or expected results express that intent.
- **Case failure or performance**: explain the case first, then diagnose the failure, slowdown, timeout, hang, or unexpected result from the available runtime and source evidence.
- **Optimization impact**: compare the baseline and optimized paths first, then decide whether the optimization is the cause, a necessary trigger, an amplifier, an exposure of an existing case issue, or unrelated.
- **Source mechanism only**: use `matrixdb-code-analysis` instead when no case diagnosis is requested.
- **Regression dashboard only**: use `matrixdb-regression-report` instead when the task is only to summarize a run or its diffs.

Do not begin from a single error line, stack symbol, wait event, or optimization name. If the test intent or the expected result cannot yet be stated, inspect the case SQL, expected output, relevant configuration, and changed source until it can.

## Analysis order

Open with one or two sentences that state why the observed result differs from the expected result. Name the mechanism, not the diff text. Then use these four sections, in this order. Do not put the fix in the opening.

1. **测试本意**

   State the behavior, invariant, or concurrency property under test. Identify the role of each important session, transaction, fault, DDL, or assertion. For an optimization-impact case, also state which execution path the optimization is supposed to change.

2. **预期结果**

   State what should be emitted or preserved, and where that expectation comes from: the checked-in answer, the case's own assertions, or the current source and documented semantics. Keep these apart when they disagree. If an answer file was rewritten, name the revision it records. A diff's `-` line is the answer under test; a `+` line is what that run printed.

3. **失败原因**

   Use the smallest amount of runtime evidence and source tracing that connects the expected result to the observed failure. Separate observed facts, code-derived inferences, and unresolved possibilities. Check complete dependency chains when sessions, locks, faults, background workers, or distributed execution are involved. Attribute the failure to product behavior, case orchestration, environment state, or a stale answer. An optimization's presence in a plan or stack is not by itself the cause.

4. **处置意见**

   Give one bounded next action: fix the product path, fix the case, re-record the answer only after the expected plan is settled, or leave the behavior. Name at least one edit that would hide the failure without fixing it. Do not claim a validation that was not run. Do not modify the case, resume faults, or change configuration unless the user explicitly asks.

## Boundaries

- Keep the workflow as simple as the case allows. Do not add generic database troubleshooting steps that do not affect the conclusion.
- Default to read-only analysis. Do not resume faults, cancel backends, restart services, alter test files, or change configuration unless the user explicitly requests that action.
- An intervention used to recover a live test is not evidence that the test is fixed or passed; report it separately from an independent validation run.
- Preserve existing worktree changes and follow repository-local instructions when source inspection or edits are required.

## Response shape

```text
差异原因：
（一两句，只说明为什么和预期不同）

测试本意：
预期结果：
失败原因：
处置意见：
```

For a case-design question, stop after 测试本意 and 预期结果. For a diagnosis, include the evidence boundary inside 失败原因 or 处置意见.
