# Review Gates

These gates are the review core that must survive conversion from the
standalone service. They are semantic gates, not deployment requirements.

## Changed-Hunk Attribution

1. Identify the exact changed hunk and its caller or consumer.
2. Read the target-base version with `git show <base>:<path>`.
3. Compare trigger, guard, and outcome in base and head.
4. Record the smallest evidence proving the PR effect.

Do not use a changed file, shifted line number, new comment, or PR description
as proof that the underlying defect was introduced. Pure pre-existing issues
are follow-ups.

## Persisted Format

For metadata or format changes, inspect:

```text
writer -> persisted layout -> reader -> rescan
                         -> compaction/ObjectStore copy
                         -> malformed metadata validation
                         -> version upgrade/downgrade boundary
```

Check field widths against configuration limits, optional-section publication,
all writers, legacy readers, and upgrade behavior. Fresh-index success is not
compatibility evidence.

## Consumer and Materialization

For new state, callbacks, projection flags, or late materialization, enumerate
the paths separately:

- scalar/index scan;
- vector/index scan;
- aggregate scan;
- residual-qual and fallback path;
- runtime-filter path;
- parallel worker path;
- rescan/reuse path.

Trace every path to final materialization. A producer-side flag or successful
first fetch does not prove that all consumers materialize the required values.

## Parallel Ownership

For parallel changes, state:

- what is in DSM and what remains worker-local;
- how workers claim pages, ranges, or runs;
- whether navigation metadata is shared, recomputed, or intentionally repeated;
- how empty ownership, abort, rescan, and reader reuse behave;
- whether the issue is correctness or only a measured/inferred cost.

Worker-local repeated metadata work is not automatically a correctness bug.

## Optimization Activation

For an accelerator or fallback test, identify the input/state that enters the
target branch. Equal final rows are insufficient when both fast and fallback
paths return the same result. Prefer a path counter, assertion, debug statistic,
fault injection, explain/runtime evidence, or another observable signal.

Review SQL, expected output, migration scripts, build registration, and
schedule/manifest together. Fresh-install coverage does not imply upgrade
coverage.

## Performance Evidence

Every performance statement must label:

- `performance_basis=measured` only when a benchmark or production trace exists;
- `performance_basis=inferred` when bounded cost is evident from code;
- `benchmark_status=not-run` when the relevant benchmark was not executed.

State correctness impact and performance impact separately. Do not promote an
unbenchmarked opportunity to a confirmed regression.

## External Review History

When an explicit history file is supplied, preserve:

```text
source
comment_id
author
created_at
reviewed_commit
disposition
```

Separate the external wording from independent validation. If history cannot be
read, report that limitation instead of reconstructing it.

## Noise and Severity

- `blocking`: likely production incident, data loss, security issue, crash, or
  critical behavior failure;
- `important`: likely bug, serious regression, broken contract, or important
  missing coverage;
- `suggestion`: worth fixing without direct merge risk;
- `nit`: low-cost cleanup, used sparingly.

Candidate discovery and final publication use different thresholds. Send a
candidate to validation when it has a changed-hunk anchor, a concrete trigger,
and code evidence, even if runtime confirmation is pending or the repair spans
multiple components. The validator may keep it as a downgraded suggestion or
open question and must label the uncertainty.

Dismiss candidates with no concrete trigger, no actionable repair or
verification direction, no PR effect, or a severity disproportionate to the
evidence. Do not dismiss solely because no benchmark was run or because a safe
fix cannot be represented as one local edit.

For test coverage, verify the internal branch that owns the changed behavior.
An outer plan-node name, equal final rows, or a successful fallback does not
prove that a changed scanner subtype, rescan lifecycle, materialization stage,
or accelerator branch executed. A test that demonstrably exercises a sibling
implementation is a concrete coverage finding, not a generic request for more
tests.
