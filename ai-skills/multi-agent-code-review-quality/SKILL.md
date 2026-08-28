---
name: multi-agent-code-review-quality
description: Use when designing, improving, or running a quality-focused multi-agent PR code review workflow with specialist reviewers, a validator, and a main agent that synthesizes evidence and feedback.
---

# Multi-Agent Code Review Quality

## Overview

Use a narrow multi-agent review loop to improve finding quality, not breadth.
The main agent acts as the serial validator: it selects up to five focused
review directions, collects concise evidence bundles, validates attribution and
contracts, and returns a prioritized Chinese review summary.

## Core Rules

- Every final PR finding must point to a changed hunk (added, modified, deleted,
  or a documented omission exposed by the changed behavior). A defect that is
  only present in unchanged base code is a separate pre-existing follow-up.
- Every candidate must classify attribution as `pr`, `pre-existing`,
  `changed-but-pre-existing`, or `uncertain`, with evidence from both the base
  and head. Do not infer attribution from the PR description.
- Correctness, compatibility, test coverage, and performance risk are separate
  categories. A static performance concern is not a measured regression.

## Workflow

1. Build review context.
   - Identify repo path, source branch, target branch, changed files, full diff, code-only diff, and test-only diff if available.
   - Note PR title/description, custom checklist, and previous human feedback when available.
   - Record the external review source, comment id, author, timestamp, and
     reviewed commit when the task is driven by an existing review.
   - For every risky path, inspect both `git diff base...head` and
     `git show base:<path>`; preserve the exact base/head evidence in the
     candidate bundle.
   - Do not let PR description create or suppress findings by itself; use it only to understand intent.

2. Dispatch five quality reviewers when subagents are available.
   - `logic-architecture`: correctness, edge cases, error paths, cross-module contract breakage.
   - `language-maintainability`: language/framework pitfalls, misleading comments/contracts, maintainability issues that affect future correctness.
   - `performance-runtime`: concrete performance regressions, unbounded work, blocking I/O, leaks, contention.
   - `test-quality`: missing or weakened tests for changed behavior, brittle tests, implementation/test mismatch.
   - `independent-verifier`: high-evidence issues missed by the specialists; avoid routine duplicates.
   - Add scoped cross-cutting reviewers when the diff changes the relevant
     area: `baseline-attribution`, `persisted-compatibility`,
     `consumer-materialization`, and `parallel-activation`. These are additive
     checks, not a requirement to run every reviewer for every PR.

3. Require reviewer outputs as candidate findings, not final comments.
   - Each reviewer returns at most 5 candidates by default. When validating a
     fixed external comment set, process every comment and attach a disposition
     even if the normal noise budget would be exceeded.
   - Each candidate must include `file`, `line`, `severity`, `category`,
     `message`, `trigger`, `evidence`, `fix`, `anchor_kind`, `introduced_by`,
     `pr_effect`, `base_evidence`, `head_evidence`; `authority`,
     `activation_proof`, `performance_basis`, `benchmark_status`,
     `correctness_impact`, and `performance_impact` are required when relevant
     and otherwise use `not-applicable`/`none`; `external_comment_refs` and
     `disposition` are required when reviewing an existing external comment;
     `consumer_paths` is required for cross-module or materialization findings.
     See
     [references/review-gates.md](references/review-gates.md).
   - Reviewers must also return `coverage_notes`: files reviewed, risky areas checked, and candidates intentionally dropped.

4. Main agent validates and merges.
   - Drop candidates with no changed-hunk anchor. For omission findings, anchor
     the missing coverage to the changed behavior or test contract that exposes
     it.
   - Keep a candidate as a PR finding when its `pr_effect` is not `none` or
     `uncertain`; a pre-existing root cause can still be a PR finding when the
     change expands its trigger, worsens its outcome, or removes mitigation.
     Pure pre-existing items remain follow-ups.
   - Merge duplicates across reviewers; keep the clearest evidence and all source reviewer names.
   - For `blocking` and `important`, verify surrounding code and caller/test context before keeping.
   - For persistence, check reader/writer, compaction/ObjectStore, rescan,
     version boundaries, field widths, and upgrade paths.
   - For cross-module state or late materialization, trace producer -> adapter
     -> scalar/vector consumer -> final materialization, including aggregate,
     fallback, and parallel paths.
   - For parallel changes, record DSM contents, worker-local state, shared work
     allocation, rescan/abort behavior, and any intentionally repeated work.
   - For optimization findings, prove that the test activates the optimized
     path; final row-count equality alone is not path evidence.
   - Require separate `performance_basis` and `benchmark_status` values and
     state when no benchmark was run.
   - Downgrade theoretical issues; dismiss style preferences unless they affect correctness or contract clarity.
   - Target no more than 15 final findings for open-ended reviews; when
     validating a fixed external set, preserve a disposition for every item and
     only deduplicate independent findings after that accounting.

5. Return feedback in Chinese.
   - Lead with final decision: `REQUEST_CHANGES`, `APPROVE_WITH_COMMENTS`, or `APPROVE`.
   - Group findings by severity.
   - Include concise evidence and concrete trigger scenario for each finding.
   - Include a short "review coverage" note summarizing which risk areas were checked and where confidence is limited.
   - Include dismissed/merged summary only when useful for transparency.

## Severity

- `blocking`: merge is likely to cause production incident, data loss, security issue, crash, or critical behavior failure.
- `important`: likely bug, serious regression, broken public contract, or meaningful missing test for important changed behavior.
- `suggestion`: worth fixing, but merge is not directly unsafe.
- `nit`: low-cost cleanup; use sparingly and never as filler.

Performance findings must additionally state `correctness impact`,
`performance impact`, `performance_basis`, and `benchmark_status`; inferred
opportunities should not be presented as confirmed regressions.

## Main Agent Gates

Keep a candidate only when all gates pass:

- A changed-hunk anchor exists in the diff; omission findings identify the
  changed behavior or test contract that exposes the omission.
- Failure mode is concrete: input/state -> bad outcome.
- Existing guards, callers, tests, or framework behavior do not already prevent it.
- Severity is defensible.
- Suggested fix is the smallest credible fix, whether local or cross-module.

If any gate fails, dismiss or downgrade. Do not preserve noisy candidates merely because multiple reviewers mentioned them.

## When To Read The Reference

Read [references/reviewer-prompts.md](references/reviewer-prompts.md) when you need reusable reviewer prompts, output schema, or a main-agent synthesis prompt for running this workflow. Read [references/review-gates.md](references/review-gates.md) when the diff involves persistence/versioning, cross-module materialization, parallel ownership, optimization activation, or an external review.

## Common Mistakes

- Running all reviewers for every trivial PR. For small or test-only changes, use fewer reviewers and keep the same validation gates.
- Letting independent review duplicate specialists. It should only add missed high-evidence issues.
- Reporting unchanged-code problems. Mention them as optional follow-up only if the user asks; they are not PR findings.
- Treating a changed file as proof that every line in it changed. Validate the
  exact diff hunk before reporting a pre-existing defect.
- Treating fresh-install tests as upgrade coverage, or SQL output equality as
  proof that a pruning/fast path executed. Pair SQL, expected output, schema
  migrations, and build manifests as one test contract.
- Calling worker-local repeated SUMMARY/FENCE work a correctness failure
  without first checking the declared ownership model and measuring the cost.
- Claiming a cross-module consumer is covered without tracing the final
  materialization or aggregate path.
- Treating `fix_code_blocks` as a place for speculative rewrites. Keep code snippets local, minimal, and consistent with repository APIs.
- Hiding uncertainty. Use the coverage note to state limited context instead of inventing findings.
