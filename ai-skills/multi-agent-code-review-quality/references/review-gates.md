# Review Gates

Read this reference when a review crosses versioned storage, multiple
producer/consumer modules, parallel execution, or an optimization path whose
activation is not obvious from the final result.

## Candidate Evidence

Every candidate uses this additional evidence model:

```text
introduced_by: pr | pre-existing | changed-but-pre-existing | uncertain
pr_effect: introduced | expanded-trigger | worsened-outcome | removed-mitigation | none | uncertain
anchor_kind: added | modified | deleted | omission
anchor_evidence: diff hunk or changed contract that anchors the issue
base_evidence: exact behavior or source evidence at the target base
head_evidence: exact changed behavior or source evidence at the review head
authority: authoritative data/check versus lossy accelerator or cache; use
           `not-applicable` for findings without an authority distinction
consumer_paths: producer -> adapter -> consumer -> final materialization
activation_proof: how the trigger reaches the changed path; state "not-proven"
                  when a test only checks an equivalent final result; use
                  `not-applicable` when no optimized path is claimed
performance_basis: measured | inferred | none
benchmark_status: run | not-run | not-applicable
benchmark_evidence: command, artifact, or null
correctness_impact: none | possible | confirmed
performance_impact: none | possible | confirmed
```

Use `pre-existing` when the same defect is present in the base and the PR does
not change the relevant behavior. Use `changed-but-pre-existing` when the PR
touches the area but does not introduce the root cause; it may still be a PR
finding when `pr_effect` is `expanded-trigger`, `worsened-outcome`, or
`removed-mitigation`. Only `pr_effect=none` belongs exclusively in follow-up.

## Baseline Attribution

1. Identify the exact changed hunk and the relevant caller or consumer.
2. Read the base version with `git show <base>:<path>`.
3. Compare the trigger, guard, and outcome in base and head.
4. Record the smallest evidence that proves introduction or pre-existence.

Do not use a shifted line number, a changed file, or a new comment as proof that
the underlying code changed.

## Persisted-Format Gate

When a diff changes a format or metadata path, inspect the complete lifecycle:

```text
writer -> persisted layout -> reader -> rescan
                         -> compaction/ObjectStore copy
                         -> malformed metadata validation
                         -> version upgrade/downgrade boundary
```

Check field widths against configuration limits, optional-section publication,
legacy readers, and all writers. A new reader path is not compatible merely
because fresh indexes can be built.

## Consumer and Materialization Gate

For new state, callbacks, projection flags, or late materialization, enumerate
the paths separately:

- scalar/index scan;
- vector/index scan;
- aggregate scan;
- residual-qual and fallback path;
- runtime-filter path;
- parallel worker path;
- rescan/reuse path.

Trace each path to the point where the final values are read. A producer-side
flag or a successful first fetch does not prove that every consumer completed
the required materialization.

## Parallel Ownership Gate

For parallel changes, state explicitly:

- what is in DSM and what remains worker-local;
- how workers claim pages, ranges, or runs;
- whether navigation metadata is shared, recomputed, or intentionally repeated;
- how empty ownership, worker abort, rescan, and reader reuse behave;
- whether the behavior is a correctness property or only a performance tradeoff.

Do not call worker-local repeated metadata work a bug without a concrete bad
outcome or measured regression.

## Activation and Test-Artifact Gate

For every optimization or fallback test, identify the input/state that enters
the target branch. Final row counts alone are insufficient when both the fast
path and the authoritative fallback return the same rows. Use a path counter,
debug statistic, assertion, explain evidence, fault injection, or another
observable activation signal when needed.

Review SQL, expected `.out`, schema upgrade scripts, schedule/manifest files,
and build registration together. Fresh-install coverage does not imply upgrade
coverage.

## Performance Evidence Gate

Label each performance statement:

- `performance_basis=measured`: benchmark or production trace exists;
- `performance_basis=inferred`: bounded cost is evident from the changed code
  but no measurement exists;
- `benchmark_status=not-run`: the relevant benchmark was not executed.

Also state whether correctness impact is none, possible, or confirmed. Keep
optimization opportunities separate from blocking correctness or compatibility
findings.

## External Review Provenance

When reviewing an existing external comment, preserve:

```text
source: system and URL or API
comment_id:
author:
created_at:
reviewed_commit:
external_comment_refs: list of source, comment_id, author, created_at,
                       reviewed_commit, and disposition
disposition: candidate | follow-up | dismissed | merged | unresolved
```

Separate the external reviewer's wording from the main agent's independent
validation. If the source cannot be fetched, report that limitation instead of
reconstructing a comment.

## Reviewer Routing

Use the smallest set of cross-cutting reviewers that covers the diff:

| Changed area | Required check |
| --- | --- |
| metadata, serialization, versions, GUC limits | `persisted-compatibility` |
| new producer state, callbacks, projection, late materialization | `consumer-materialization` |
| DSM, shared cursor, worker state, rescan | `parallel-activation` |
| accelerator, fallback, boundary test, expected output | `parallel-activation` plus `test-quality` |
| any external review or suspected master defect | `baseline-attribution` |

Run the ordinary five directions in addition when their risk applies. These
routes are defaults for coverage, not a mandate to dispatch every specialist
on a trivial change.
