---
name: write-evidence-backed-design
description: Create or revise implementation-facing technical design documents from source code, repository history, measurements, and operational evidence. Use when a design must explain the current system, define invariants and compatibility, compare alternatives, justify decisions, integrate experiments without double counting, or give reviewers a traceable implementation and validation plan. Suitable for backend subsystems, storage formats, execution paths, protocols, runtimes, and performance-sensitive changes; not intended for product marketing, API-only reference, or evidence-free ideation.
---

# Write Evidence-Backed Design

## Overview

Produce a reviewable design whose claims can be traced to code, tests, measurements, or clearly
marked estimates. Build the reader's mental model before proposing changes, separate facts from
plans, and make correctness, compatibility, lifecycle cost, and validation first-class sections.

When the request is for an initial or pre-prototype design, reconstruct the selected baseline before
inspecting the prototype as a solution. Use prototypes as evidence about feasibility and cost, not as
the architecture outline. A design should still make sense if its prototype-results section is
removed.

## Required Resources

Read both references before drafting a substantial design:

* [Evidence Method](references/evidence-method.md) defines evidence classes, experiment identity,
  dependency accounting, and claim strength.
* [Design Structure](references/design-structure.md) provides the document architecture, decision
  record, invariant, compatibility, rollout, and review templates.

Use only the sections that serve the task. A small design can be compact, but it must retain the
fact/proposal boundary and the evidence identity for any quantitative claim.

## Workflow

### 1. Confirm the Deliverable

Establish before writing:

* document path and expected language;
* primary audience and decision owner;
* whether the task is analysis-only or authorizes edits;
* scope, exclusions, and required comparison points;
* whether measurements are historical, current, or still required.

When details are discoverable from the repository, inspect them rather than asking. Ask only when a
missing choice would materially change the design.

### 2. Establish Sources of Truth

First select the design time horizon: current accepted implementation, a named historical baseline,
or a greenfield system. Record how the working tree, experimental branch, and historical artifacts
relate to that horizon. For an initial design requested from before experimental work, the selected
baseline revision governs the current-system description; later prototype code is evidence, not
current state.

Create a source map before synthesizing. Within the selected time horizon, use this precedence unless
the repository establishes a different one:

1. executable code and persisted format at the selected horizon;
2. focused tests and expected behavior at that horizon;
3. configuration and lifecycle wiring at that horizon;
4. commit history and accepted design decisions;
5. benchmark artifacts and raw samples;
6. existing documents and comments;
7. estimates and proposals.

Existing prose is an input, not automatic truth. Resolve disagreement in favor of executable behavior
at the selected horizon, then call out stale documentation and later experimental divergence
explicitly.

### 3. Reconstruct the Baseline or Current System

Trace one representative operation end to end:

```text
entry and eligibility
  -> planning or dispatch
  -> metadata and state acquisition
  -> core processing
  -> result delivery
  -> cleanup and failure handling
```

For each stage record ownership, inputs, outputs, fallback, invalidation, and observable counters.
Name the authoritative representation and any accelerators layered above it. Do not describe a
planned abstraction as if the code already implements it.

Maintain a short state strip when multiple timelines exist:

```text
selected baseline -> proposed target
                   -> later prototype evidence (non-authoritative)
```

Do not let the chronology of prototype patches become the structure of an initial design.

### 4. Classify Every Material Claim

Use a small vocabulary consistently:

* **Baseline**: observable at the explicitly selected historical or pre-change design horizon.
* **Current**: observable in the accepted implementation when the selected horizon is now.
* **Validated**: baseline or current behavior supported by an appropriate test or measurement.
* **Prototype**: implemented only in an experimental, partial, or later-than-baseline state.
* **Specialized**: correct only under an explicitly narrow eligibility gate.
* **Proposed**: not implemented.
* **Estimated**: derived or predicted, not directly measured.
* **Unknown**: evidence is insufficient; include a measurement or investigation plan.

Keep these categories separate in prose, diagrams, and tables. A specialized implementation is not
proof that the underlying algorithm requires the same specialization. Prototype is a maturity label,
not a synonym for validated or current.

### 5. Build a Capability Dependency Graph

Before combining historical work, write the dependency relationships:

```text
foundation
  -> capability A
       -> capability B
  -> capability C
       -> capability D
```

Mark which experiment baseline already includes which capabilities. Treat overlapping work,
inclusive timers, nested stages, and reused caches as dependent until a factorial experiment proves
independence.

Never add improvements from different baselines merely because each number is positive. Prefer a
direct end-to-end comparison between the earliest and latest state, with intermediate comparisons
used only for attribution.

### 6. Maintain an Evidence Ledger

For each quantitative result record enough identity to decide whether comparisons are valid:

* revision and build mode;
* dataset or workload identity;
* operation and parameters;
* configuration and feature state;
* process, connection, and concurrency model;
* cache and storage state;
* warm-up, sample count, ordering, and statistics;
* instrumentation state;
* correctness and actual-path checks;
* raw artifact location when available.

Label cross-run or cross-revision values as historical references. If the required comparison is
missing, specify the exact paired experiment instead of manufacturing a precise residual.

### 7. Define the Problem and Success Criteria

State the expensive or incorrect behavior in operational units: calls, objects, rows, bytes,
allocations, messages, pages, locks, retries, or lifecycle transitions. Then define:

* functional objective;
* measurable performance or resource objective;
* correctness invariants;
* compatibility commitment;
* non-goals;
* conditions under which the design should fall back or stay disabled.

Explain why the primary workload was selected. Say whether it is representative, adversarial,
boundary-seeking, or merely convenient, and name the broader cases needed to prevent overfitting.

When an incumbent or alternative structure exists, define success relative to it across all material
axes, not latency alone. Include performance distributions, total persisted size, build/rebuild cost,
write or WAL amplification, and operational maintenance. If numeric gates are not yet justified,
define the ratios and require thresholds to be frozen before the decisive experiment.

Avoid setting a target solely from the best observed sample. Use paired distributions and specify the
accepted environment.

### 8. Present the Design as Layered Decisions

Treat a request to explain why an option was considered as a scope requirement, not as evidence that
the user prefers that option. Keep option-inclusion rationale separate from selection rationale and
record explicit user preferences separately. Choose only from stated requirements, discovered
constraints, evidence, and tradeoffs; a question that expands the design space does not select an
answer within it.

For each design decision include:

1. the problem it solves;
2. why this option belongs in the design space and its distinguishing advantage;
3. the chosen mechanism;
4. why it is correct;
5. why it fits existing ownership and lifecycle boundaries;
6. alternatives considered;
7. read, write, memory, storage, and operational costs;
8. fallback and corruption behavior;
9. evidence or expected measurement;
10. conditions that would trigger reconsideration.

Prefer a small number of strong abstractions. A navigation structure, correctness source, cache,
and execution accelerator should not silently acquire each other's responsibilities.

Define output cardinality explicitly. If an operation can return zero, one, or many ranges, spans,
owners, messages, or candidates, make the collection type, ordering, normalization, cap, and complete
fallback part of the interface. Do not infer a single-result contract from a point-query prototype.

For persisted metadata, separate integrity layers: byte or block integrity (for example checksums),
page-local structure, cross-object semantic consistency, and validation against authoritative data.
State which coherently written but semantically wrong states each layer can and cannot detect.

### 9. Cover the Whole Lifecycle

Do not stop at the hot read path. Address, as applicable:

* creation and publication;
* update, merge, compaction, or rebuild;
* concurrency and visibility;
* restart, recovery, and partial failure;
* invalidation and schema evolution;
* deletion and resource reclamation;
* downgrade or mixed-version behavior;
* observability and support procedures.

Distinguish an unavailable optional capability from a declared capability whose data is corrupt.
Fallback is appropriate for the former; silent fallback can hide correctness failures in the latter.

### 10. Write the Validation Plan Before Final Claims

Use three mutually reinforcing evidence classes:

* result equivalence or a trusted correctness oracle;
* operation counters that prove the intended path changed;
* end-to-end measurements supported by narrow timers or profiles.

Keep instrumented and uninstrumented latency runs separate. Report distributions and raw sample
identity, not a single best time. Treat derived residuals as investigation pointers, not named
function costs.

Keep prototype evidence proportional to its role. In an initial system design, summarize it in a
compact evidence ledger or appendix and use it to support decisions; do not narrate every optimization
patch or organize the proposal around the experiment sequence.

### 11. Review the Draft as a Maintainer

Before finishing, verify:

* the first architecture diagram matches the selected baseline or accepted current implementation;
* the selected design horizon is explicit, and later prototypes are not presented as its current state;
* every proposal is visibly marked as a proposal;
* the problem and decisions remain understandable without the prototype-results section;
* every exact number has an experiment identity;
* no dependent or inclusive values are summed twice;
* every optimization names its correctness source and fallback;
* compatibility directions are explicit rather than summarized as "compatible";
* read-path gains are paired with write, memory, storage, and lifecycle costs;
* comparison goals include the incumbent's performance and total size when relevant;
* no request to explain an option has been presented as evidence that the user selected it;
* multi-result cases and checksum-versus-semantic validation boundaries are explicit;
* open questions contain a concrete way to resolve them;
* code and document links resolve;
* the conclusion states what is known, what was chosen, and what remains unproven.

## Output Standard

A substantial design should normally contain:

```text
title and status
decision summary
problem and scope
baseline or current mental model
requirements and non-goals
proposed or current design
correctness invariants
compatibility and failure behavior
alternatives and tradeoffs
performance/resource evidence
implementation and rollout
validation and observability
open questions
code and source map
```

Use diagrams only when they clarify flow, ownership, hierarchy, or dependency. Tables are preferred
for exact mappings, experiment identities, compatibility matrices, and option comparisons.

Write direct engineering prose. Explain why a choice is valid before describing it as fast. When
evidence is incomplete, give the bounded hypothesis and the measurement needed to resolve it.
