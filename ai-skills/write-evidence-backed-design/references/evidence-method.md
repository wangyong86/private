# Evidence Method

This reference defines how to collect, compare, and communicate evidence in a technical design.

## 1. Source Hierarchy

Select the design time horizon before applying the source hierarchy. For a pre-prototype design, code
at the named baseline revision governs the system description; later working-tree or branch code is
prototype evidence even when it is executable.

Use the narrowest authoritative source available:

| Claim | Preferred evidence |
| --- | --- |
| Baseline/current control flow | executable code and call sites at the selected horizon |
| Persisted representation | reader, writer, validation, and recovery code |
| Supported behavior | focused tests plus current implementation |
| Ownership and invalidation | lifecycle code and state transitions |
| Historical intent | accepted change history and prior design records |
| Performance | raw paired samples, counters, and profiles |
| Future behavior | explicit proposal and validation plan |
| Prototype feasibility | experimental code plus focused tests and identified limitations |

Comments and existing documents help locate the model, but they do not override executable behavior
at the selected horizon. When sources disagree, document the disagreement and identify which source
governs results for the state being designed.

## 2. Claim Strength

Use language that matches the evidence:

| Evidence | Appropriate wording |
| --- | --- |
| Code inspection only | "the current path calls" or "the implementation permits" |
| Experimental branch or partial prototype | "the prototype demonstrates" with explicit maturity and baseline |
| Focused correctness test | "validated for these cases" |
| Paired end-to-end samples | "improved by X under this experiment" |
| Counter plus timer/profile agreement | "the improvement is attributable to" |
| Derived bound | "upper bound" or "investigation target" |
| Design hypothesis | "expected" or "to be measured" |
| Missing evidence | "unknown" and a measurement plan |

Do not turn a call-path removal into a latency claim without wall-time evidence. Do not turn a
logical work reduction into a physical I/O claim without byte or read counters.

## 3. Experiment Identity

Every reusable experiment should have an identity record:

```text
experiment_id:
design_time_horizon:
baseline_revision:
revision:
artifact_maturity:
build_mode:
hardware:
operating_environment:
dataset_or_workload:
operation:
parameters:
feature_configuration:
plan_or_path_check:
connection_and_concurrency:
cache_and_storage_state:
instrumentation:
warmup:
sample_count:
execution_order:
reported_statistics:
correctness_check:
raw_artifacts:
notes:
```

Two results are directly comparable only when all material identity fields are equal or the changed
field is the controlled variable. If revisions, cache states, instrumentation, processes, workloads,
or execution paths differ, label the comparison as historical or directional.

Prototype results must identify both the system state they build on and the target design claim they
support. Do not promote a prototype's object model, single-result assumption, format, or eligibility
gate into the proposal merely because the measurement used it.

## 4. Evidence Ledger

Maintain a compact table while researching:

| Claim ID | Claim | Class | Source | Experiment | Dependencies | Confidence | Draft use |
| --- | --- | --- | --- | --- | --- | --- | --- |
| C1 | Baseline or current behavior | baseline/current | code path | - | - | high | mental model |
| C2 | Feature changes work count | validated | counters | E1 | C1 | high | mechanism |
| C3 | Feature improves latency | validated | paired samples | E1 | C1,C2 | high | result |
| C4 | Follow-up may help | estimated | upper bound | - | C2 | medium | roadmap |

The ledger prevents an attractive old number from entering the final document without its baseline
or conditions.

## 5. Capability Dependency Accounting

Create a table showing which capabilities are present in each experiment:

| Experiment | Foundation | Capability A | Capability B | Capability C | Result |
| --- | --- | --- | --- | --- | --- |
| E0 | on | off | off | off | baseline |
| E1 | on | on | off | off | marginal A |
| E2 | on | on | on | off | marginal B after A |
| E3 | on | on | on | on | combined |

Valid direct calculations are:

```text
E1 - E0: marginal A in the E0 context
E2 - E1: marginal B after A
E3 - E0: combined result
```

They do not prove that A and B are independent. If B shares caches, removes work already removed by
A, or changes A's eligibility, use a factorial experiment before claiming standalone contributions.

## 6. Timer and Counter Rules

Before interpreting a timer, write its exact boundaries and containment:

```text
outer stage
  setup
  inner stage A
  inner stage B
  cleanup
```

Never sum the outer stage with A and B. Compute a residual only as:

```text
residual = outer - known non-overlapping children
```

Call it a residual, not a specific function cost, until a direct timer or profile isolates it.

Counters should reflect actual operations, not proxy values. Useful classes include:

* objects considered, rejected, opened, and destroyed;
* metadata and data units visited;
* comparisons and callbacks;
* input, candidate, processed, and output units;
* allocations and bytes initialized;
* logical, physical, compressed, and decompressed bytes;
* cache hits, misses, reloads, and retries;
* calls returning data versus end-of-input.

## 7. Paired Measurement Protocol

For short operations:

1. keep the process or connection stable;
2. warm each state after changing synchronized configuration;
3. alternate or randomize variants;
4. separate instrumentation runs from latency runs;
5. validate the actual execution path for every variant;
6. collect enough samples to report distribution and drift;
7. retain per-block statistics rather than only a merged percentile;
8. reject samples with path, workload, lifecycle, or background-state changes.

Report at least sample count, minimum, median, upper percentiles, maximum, mean, and a spread metric.
For longer or noisy workloads, include confidence intervals or repeated-run distributions.

## 8. Performance Bounds

Use three distinct quantities:

* **theoretical ceiling**: all time in a parent stage, rarely achievable;
* **investigation target**: the portion plausibly connected to the candidate work;
* **validated gain**: paired end-to-end improvement supported by operation evidence.

Do not present the ceiling as an estimate. When multiple candidates overlap, provide a combined
realistic target rather than summing their individual ceilings.

## 9. Missing Evidence

When a comparison is missing, write the exact next experiment:

```text
hypothesis:
controlled variable:
fixed conditions:
operation counters:
internal timing or profile:
end-to-end statistic:
correctness oracle:
acceptance condition:
```

This is more useful than an unsupported precise number and makes the design reviewable before the
experiment is run.
