---
name: technical-issue-response
description: Use when drafting or revising a technical issue reply that must explain a failure mechanism, separate evidence from inference, define a bounded fix, or provide conditional effort estimates.
---

# Technical Issue Response

Write an issue reply that a maintainer can review and act on. The reply must establish the core
mechanism before discussing alternatives, and must keep verified behavior, interpretation, proposal,
and estimate visibly separate.

## Scope and sources

Before drafting, identify the target version or commit, the affected path, the trigger, and the
requested decision. Read the issue, comments, relevant code, tests, configuration, and available
measurements. Prefer executable code and focused tests over prose. If a source is unavailable, say
so rather than filling the gap with a likely explanation.

Do not silently broaden a single failing scenario into a general compatibility claim. State which
input shape, transaction/state boundary, and deployment configuration the reply covers. Keep
unrelated defects, such as a separate result-returning or protocol issue, separate unless evidence
shows they share the same mechanism.

## Explain the mechanism first

Use this causal order:

1. Define the operation and its correctness invariant.
2. Describe the normal mechanism that preserves the invariant, including ordering, ownership,
   visibility, locking, or failure behavior as applicable.
3. Show the smallest execution sequence that violates the invariant.
4. Identify the first point where the observed implementation diverges from the normal mechanism.
5. State the observable consequence in user terms.

When comparing systems, explain each system's mechanism before naming a difference. For concurrency,
cover at least read visibility, write conflict behavior, lock duration, transaction boundary, and
what happens after a conflict. Do not call two mechanisms equivalent merely because both prevent one
example. Explain the tradeoff that caused the difference, such as snapshot reads reducing blocking
or optimistic conflict detection turning waits into transaction aborts.

## Evidence labels

Use explicit language matching the evidence:

- **Observed/validated:** reported by the issue or reproduced by a focused test; include version,
  configuration, and workload when material.
- **Current source behavior:** established from code, tests, or configuration in the inspected
  revision.
- **Historical intent:** supported by commit history or accepted design documentation.
- **Inference:** a technical explanation derived by comparing the evidence; label it as a
  hypothesis when upstream rationale is unknown.
- **Proposed:** a change that is not implemented.
- **Unknown:** evidence is insufficient; name the smallest experiment needed to resolve it.

If no upstream rationale is found, write “未找到明确的上游设计说明” and then state the technical
inference separately. Do not turn parser acceptance into execution support, a single successful run
into a correctness proof, or a plausible motivation into an upstream fact.

## Bounded solution

Present the smallest solution that addresses the reported scenario. Specify:

- supported statement/input shape and required preconditions;
- state or transaction boundary that owns the invariant;
- success and conflict paths, including affected-row checks, retry, rollback, and error handling;
- expected behavior after the fix;
- cases deliberately left unsupported and their diagnostic behavior.

Keep an existing application workaround separate from a platform fix. Do not repeat a workaround the
issue author is already implementing as if it were a new recommendation. If no transparent
substitute exists, give a short repair direction that preserves the invariant and explain its main
semantic cost. For concurrency fixes, define an acceptance trace and test the invariant, not only
the final stored value.

For a staged platform implementation, make the first stage narrow and explicit. For example, a
single-table lookup of an existing row may be supportable before joins, range predicates, missing-row
creation, or full lock-hint compatibility. Unsupported forms should remain explicit errors until
their semantics are designed; silent ignore is unacceptable for a correctness-sensitive feature.

## Effort estimates

Only include effort when the user or issue asks for it. If requested with AI assistance, label it as
an estimate rather than a commitment and state assumptions: target revision, build/test readiness,
scope, concurrency test availability, and review requirements. Split investigation, implementation,
focused regression tests, and integration/validation. Use ranges and list the factors that can move
them. AI may reduce code search, scaffolding, and repetitive test authoring; it does not replace
mechanism design, version-specific reproduction, full builds, concurrency validation, or human review.

## Reply shape

Use only the sections needed, normally in this order:

1. **结论/影响** — one short paragraph, without greetings or advocacy language.
2. **核心机制** — the invariant and the normal versus failing execution trace.
3. **证据与边界** — source, test, version, configuration, and unknowns.
4. **处理方向** — the bounded fix, semantic tradeoffs, and explicitly unsupported cases.
5. **验收条件** — observable correctness and failure cases.
6. **工作量** — only when requested, with assumptions and ranges.

Avoid greetings, “我们认为/我们建议” as substitutes for reasoning, generic conclusions, repeated
issue background, and unsupported completion dates. Write concrete subject-oriented sentences:
“当前解析路径会移除该提示，未发现执行器锁定转换” is preferable to “我们认为上游还不支持”。

## Final checks

- The first paragraph states the actual impact and scope.
- The core invariant and mechanism appear before solution options.
- Facts, inferences, proposals, and unknowns are labeled by wording.
- The proposed fix has a bounded acceptance trace and does not imply broader compatibility.
- Independent symptoms are not merged without evidence.
- Unsupported forms fail explicitly when silent success could hide a correctness error.
- Estimates, if present, include assumptions and are not promises.
