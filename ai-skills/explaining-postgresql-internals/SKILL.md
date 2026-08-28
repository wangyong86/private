---
name: explaining-postgresql-internals
description: Use when explaining PostgreSQL internals, reading PostgreSQL backend source, answering why a PostgreSQL mechanism exists, or writing concise PostgreSQL learning and design notes. Start with authoritative public PostgreSQL material to establish the mechanism and version framework, then validate it against local source and clearly separate core, version-specific, extension, and downstream-fork behavior.
---

# Explaining PostgreSQL Internals

## Core Principle

Explain concepts before symbols. Answer: problem, design, key implementation, and reusable lesson.
Depth comes from causality and invariants; adjacent concepts belong only when they close that chain.

## Workflow

1. **Define the question and version boundary.** State which behavior is being explained, which
   PostgreSQL release or local fork is in scope, and whether the user wants current upstream or
   local behavior. Do not let a current upstream symbol or a fork patch silently redefine the task.
2. **Research the public baseline first.** Search authoritative public sources before deep local
   exploration: current and versioned PostgreSQL documentation, official source/README files,
   release notes, git history, and pgsql-hackers discussions. Prefer primary sources; use search
   results to build a framework, not as proof. Record the source URL, version/commit, and the claim
   it supports. If network access fails, say so and proceed with local evidence rather than inventing
   a public baseline.
3. **Build a framework before reading every symbol.** Organize the investigation around:
   - the concrete failure or constraint;
   - ownership/lifetime and state transitions;
   - normal success versus error/abort control flow;
   - ordering, concurrency, and failure invariants;
   - data-structure or performance tradeoffs;
   - version evolution and extension/fork boundaries.
   Mark framework items as hypotheses until source evidence confirms them.
4. **Establish the implementation boundary.** Determine whether each claim belongs to PostgreSQL
   core, a particular release, an extension API, or a downstream fork. When local and upstream
   source differ, report both facts and label any inference from the diff.
5. **Read the minimum local evidence path.** Locate the definition, lifecycle entry points, one
   decisive producer/consumer path, cleanup/error path, and tests or comments that encode the
   invariant. Prefer exact symbols and line anchors over file-by-file tours.
6. **Build one mental model.** Name the state, data flow, or invariant that connects the evidence.
7. **Write four required layers:**
   - **Problem:** the concrete constraint or failure being addressed.
   - **Design:** the central idea, invariant, and important tradeoff.
   - **Key implementation:** only the source details that realize the design.
   - **Lessons:** the reusable pattern, its boundary, and what breaks if the invariant changes.
8. **Add related concepts selectively.** Keep only design dependencies, optimizations, slow-path
   boundaries, or failure modes. Insert them after the key implementation.
9. **Compress.** Remove every detail that strengthens none of the layers above.

## Evidence Labels

Use explicit labels when the scope can drift:

- **Public baseline:** current or versioned official documentation, source, release history, or
  pgsql-hackers rationale.
- **Local source fact:** behavior verified in the requested checkout.
- **Fork fact:** downstream-only code or behavior, including vendor additions.
- **Inference:** a conclusion derived by comparing evidence; do not present it as a source fact.

For version-sensitive mechanisms, provide a short matrix or timeline when the implementation shape
changed materially. Explain the stable invariant first, then show what changed in data structures,
APIs, ordering, or extension ergonomics.

## Related Concepts

Choose at most three. Give each causal link in one or two short paragraphs; name adjacency alone is
insufficient.

Example: `attcacheoff` belongs with `att_align_*` because it shows when offsets become stable enough
to cache and why NULL or varlena ends that fast path; do not turn it into a relcache tutorial.

## Information Density

- Lead with the answer, then prove it.
- Prefer one model, one comparison or flow, and one decisive example.
- Use source references as evidence; do not reproduce the source as documentation.
- State the non-obvious boundary or failure mode; that is usually where the depth is.
- Match scope to the question. A narrow macro question must not become a subsystem tutorial.

## Quality Gate

Before finishing, verify:

- A public baseline and its version/date are recorded for non-local or current-version claims.
- The framework was established before the local file tour, and each framework item is resolved or
  explicitly left as an open question.
- Every implementation detail proves a prior conceptual claim.
- At least one invariant, tradeoff, or “what breaks” consequence is explicit.
- Each related concept closes a causal gap and remains subordinate to the main topic.
- PostgreSQL facts are not contaminated by extension or fork-specific behavior.
- Version-specific APIs and data structures are labeled; stable semantics are not confused with
  implementation history.
- No conclusion, example, or caveat is repeated in another form.

## Common Failures

| Failure | Correction |
| --- | --- |
| Broad but shallow API inventory | Center one mechanism and its invariant |
| Related concepts become mini-tutorials | Keep only their causal link to the main topic |
| Many examples prove the same point | Keep the smallest decisive example |
| Brevity removes the causal implementation detail | Keep the detail that closes the chain |
| Fork code is treated as PostgreSQL behavior | Label the boundary or omit it from PG notes |
| Current upstream is assumed to describe an old local branch | Build a public/version matrix before local validation |
| Search snippets are treated as evidence | Open the primary page, source, commit, or discussion and cite the exact claim |
| Public research becomes an unstructured link dump | Use it only to establish the framework and version deltas |
