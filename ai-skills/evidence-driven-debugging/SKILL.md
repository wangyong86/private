---
name: evidence-driven-debugging
description: Investigate intermittent, concurrent, cross-layer, or data-corruption bugs by locating evidence boundaries and testing concrete mechanisms.
---

# Evidence-Driven Debugging

Use this skill when a failure is probabilistic, concurrency-sensitive, crosses
object or subsystem boundaries, corrupts data/state, or has an uncertain first
failure point. For a deterministic, local failure, use the short path below;
escalate only when it stops producing decisive evidence.

## Triage

- Write the smallest failing symptom and the invariant that should hold.
- Preserve the test oracle: before the mechanism is understood, do not relax
  an assertion, refresh a baseline, or hide the failure with retries.
- Separate observed facts, evidence-backed inferences, and unverified
  hypotheses.

Use the short path when the failure is stable, local, and its relevant
boundary is already clear: inspect that path, perform the smallest confirming
check, and report the conclusion and remaining risk.

Use the full path when the failure is intermittent, concurrent, damaging,
cross-layer, or the first bad boundary is unknown.

## Full path

1. Pin the actual binary/commit, configuration, topology, input, and relevant
   persistent or initial state. Record the failure count only when frequency
   is part of the question.
2. Trace the real execution/data path, including queues, retries, persistence,
   caches, background work, and read-back where relevant.
3. Keep a boundary ledger. For each hand-off, record the invariant, the
   evidence, and whether the state is good, bad, or unknown. Identify the last
   known-good boundary and the first known-bad boundary; target the earliest
   unknown boundary between them. The first observed anomaly is not
   automatically the first corruption point.
4. State each candidate as a concrete mechanism, not a label such as
   “race” or “timing”. For each mechanism, state what must be observable if it
   is true and what experiment would distinguish it from the alternatives.
5. When an experiment is needed, hold the build, configuration, topology,
   input, and initial state fixed and change one meaningful condition. Use
   repetition to estimate a failure rate; use controlled comparisons to test
   causality. Treat an absence as negative evidence only when the probe would
   have observed the mechanism.
6. Treat a root cause as established only when it maps to a concrete code
   mechanism, explains the observed details, predicts a new observable
   consequence, and is supported by a controlled trigger or elimination. Keep
   trigger condition, root defect, amplifier, and discovery point separate.

Temporary probes are acceptable when they improve observability; remove them
and restore the environment after the investigation.

## Report

Report the shortest evidence-backed account that lets another engineer
reproduce or challenge the conclusion:

- minimal symptom and invariant;
- reproduction conditions and, if relevant, observed frequency;
- last known-good and first known-bad boundaries;
- decisive evidence and eliminated alternatives;
- confirmed mechanism, or explicitly bounded candidate mechanisms;
- validation performed and unresolved uncertainty.

Do not claim that the first observation is the origin, that correlation is
causation, or that a passing rerun disproves an intermittent failure.
