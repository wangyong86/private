# Design Structure

This reference provides reusable structures for implementation-facing technical designs. Select the
smallest structure that still exposes the important decisions and evidence.

## 1. Opening

Start with a short status block or paragraph:

```text
Status: draft / proposed / partially implemented / implemented
Audience: implementers, reviewers, operators
Decision owner:
Design time horizon and baseline revision:
Relationship of current HEAD and prototypes to that baseline:
Scope:
Out of scope:
Primary evidence:
```

Then give a decision summary. A reviewer should understand the chosen direction, the preserved
correctness source, and the largest unresolved risk before reading the full history.

## 2. Problem Definition

Describe the current behavior in operational terms:

```text
workload or operation
  -> current stages
  -> repeated or amplified work
  -> user-visible or system cost
```

Include scale, frequency, and the conditions under which the problem appears. Separate functional
defects, performance inefficiency, operational burden, and future capacity limits.

Define success with measurable outcomes and explicit non-goals. If the target depends on environment
or workload, include that condition in the target.

Explain why the primary workload is representative, adversarial, boundary-seeking, or otherwise
decision-relevant. For a deliberately worst-case workload, state which boundary creates the maximum
work and list the ordinary cases that prevent overfitting.

If an incumbent alternative exists, define paired comparison metrics for latency distribution, total
persisted size, build/rebuild, write amplification, and lifecycle cost. A goal to "approach" another
structure is incomplete without naming both the performance ratio and the resource advantage that
justifies retaining the proposed structure.

## 3. Baseline or Current Mental Model

Reconstruct the current system before proposing changes:

* entry points and eligibility;
* data and metadata ownership;
* read or execution path;
* write, creation, or publication path;
* cleanup and invalidation;
* failure and fallback behavior;
* current observability;
* code map.

Use one flow diagram for sequence and one table for ownership if needed. Avoid introducing proposal
names in the current-state diagram.

For an initial design after prototypes already exist, reconstruct the named pre-prototype baseline in
this section. Put later prototype behavior in a compact evidence section rather than substituting it
for the baseline mental model.

## 4. Requirements and Invariants

Requirements describe desired behavior. Invariants describe conditions that must always remain true.

Useful invariant categories:

* authoritative state and derived accelerators;
* completeness and conservative behavior;
* ordering and comparison semantics;
* identity, generation, and visibility;
* coordinate or identifier stability;
* concurrency and ownership;
* failure atomicity;
* cleanup and resource lifetime;
* mixed-version behavior.

Number hard invariants so implementation and tests can cite them.

## 5. Design Layers

Present the proposal from outer to inner or coarse to fine. For each layer answer:

```text
input:
output:
authoritative or derived:
eligibility:
algorithm:
fallback:
corruption behavior:
state ownership:
cost:
observability:
output cardinality and normalization:
integrity layer and validation limits:
```

If two structures solve different problems, show their composition explicitly. Do not merge
navigation, filtering, caching, and correctness into one vague component.

## 6. Decision Record

Use this compact form for each consequential choice:

```text
Decision:
Context:
Chosen option:
Why this option was considered and its key advantage:
Correctness argument:
Compatibility impact:
Read-path cost:
Write/lifecycle cost:
Alternatives rejected:
Evidence:
Risks and mitigations:
Reconsider when:
```

The "reconsider when" field prevents a temporary implementation constraint from becoming an
unquestioned permanent rule.

Keep two questions distinct: "why must this option be considered?" and "why was this option chosen?"
A user request to answer the first question expands the required analysis; it does not answer the
second. Selection must follow from explicit preferences, requirements, constraints, evidence, and
tradeoffs. If no preference was stated, do not invent one.

## 7. Alternatives Table

Use a common comparison frame:

| Option | Solves | Correctness complexity | Read cost | Write cost | State size | Compatibility | Operational risk |
| --- | --- | --- | --- | --- | --- | --- | --- |

Do not compare one option's best case with another option's worst case. Include "keep the current
system" when it is a legitimate choice. Explain why each non-obvious option entered the design space;
do not discuss an option only as a foil for the selected implementation. Do not mark an option as
preferred merely because the requester specifically asked for its inclusion rationale.

## 8. Compatibility Matrix

Avoid the single word "compatible." Split directions and states:

| Producer | Consumer | Behavior | Fallback | Error condition | Migration |
| --- | --- | --- | --- | --- | --- |
| old | new | ... | ... | ... | ... |
| new | old | ... | ... | ... | ... |
| mixed | new | ... | ... | ... | ... |

Also cover configuration absence, optional capability absence, schema mismatch, partial publication,
and declared corruption.

## 9. Lifecycle

For persisted or shared state, define:

```text
build or create
  -> validate
  -> publish
  -> observe/use
  -> replace or invalidate
  -> reclaim
```

Name the atomic publication point. Explain crash behavior before and after it. If copies or rebuilds
change physical identity, state which references must be regenerated.

## 10. Performance and Resource Model

Use units that correspond to implementation work:

```text
cost = fixed setup
     + objects visited * per-object cost
     + bytes read or written
     + units decoded or processed
     + result delivery
     + cleanup
```

Show best, expected, and worst cases when behavior depends on selectivity, locality, overlap, cache,
or concurrency. Pair read gains with build time, storage, write amplification, memory footprint, and
operational maintenance.

Maintain an experiment table with identity and dependency columns. Mark historical or cross-context
numbers and prohibit arithmetic across incomparable rows.

When the target is evaluated against an incumbent, include explicit ratios such as candidate/incumbent
latency and candidate/incumbent total persisted size. If thresholds are unknown, define the ratios and
freeze thresholds in the experiment manifest before observing the decisive result.

## 11. Implementation Plan

Order work by dependency and risk:

1. observability and correctness oracle;
2. minimal format or interface boundary;
3. narrow implementation with conservative fallback;
4. focused correctness cases;
5. paired performance validation;
6. broader types, modes, or concurrency;
7. default enablement and cost-based selection.

Each stage should have an acceptance condition and rollback or disable mechanism. Avoid combining
multiple performance mechanisms in the first measurable change unless they cannot operate
independently.

## 12. Validation Matrix

Cover at least:

* normal hit, miss, empty input, boundary, duplicate, and null-like states;
* supported and unsupported eligibility;
* feature enabled and disabled equivalence;
* old, new, mixed, and partially available state;
* restart, rebuild, replacement, and cleanup;
* warm and cold resource state;
* low and high selectivity or load;
* concurrency modes that change ownership;
* intentional metadata or protocol corruption where applicable.

For range-, span-, shard-, or partition-producing designs, include zero, one, and multiple disjoint
results, overlap/adjacency normalization, duplicate boundary values, and cap-triggered complete
fallback. A loop that happens to process several single results is not automatically a first-class
multi-result contract.

Separate corruption coverage into byte/block checksums, page-local structure, cross-page or
cross-object semantic relationships, and validation against authoritative state. State what a valid
checksum with incorrect semantics would do.

For performance, record operation counts and end-to-end distributions separately. A benchmark that
does not verify the actual path is not valid evidence for the intended mechanism.

## 13. Observability

For each optimization provide enough counters to answer:

* Was it eligible?
* Did it run?
* How much work did it inspect, reject, and process?
* What physical resources did it read, write, allocate, or decode?
* Did it fall back, and why?
* Which generation, mode, or implementation produced the result?

Keep diagnostics cheap when disabled. Measure instrumentation overhead for short operations and keep
instrumented latency out of the primary end-to-end result.

## 14. Open Questions

An open question should be actionable:

```text
Question:
Why it affects the decision:
Current evidence:
How to resolve it:
Decision deadline or dependent stage:
```

Avoid ending with broad requests for more testing. Name the experiment, code inspection, format
decision, or operational owner required.

## 15. Final Review Checklist

* Does the summary state the actual decision?
* Can a new maintainer trace one operation end to end?
* Are baseline/current behavior and proposed behavior visibly separate?
* Is every accelerator tied to an authoritative correctness source?
* Is the design baseline explicit and distinct from later prototypes?
* Would the problem statement and decision logic survive removal of the prototype-results section?
* Are optional absence and corruption handled differently?
* Are compatibility directions explicit?
* Do performance numbers carry experiment identity?
* Are dependent improvements and inclusive timers kept separate?
* Are write, storage, recovery, invalidation, and cleanup covered?
* Are incumbent-relative performance and size goals both covered?
* Are multiple-result contracts and checksum/semantic integrity boundaries explicit where relevant?
* Does every implementation stage have a correctness and measurement gate?
* Are source links and code anchors current?
* Are unresolved claims labeled and paired with a resolution plan?
