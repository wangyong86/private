# Commit Message Rules

Use these rules for implementation, bug-fix, refactor, compatibility, and
backport commits. Adapt their depth to the change; a narrow fix does not need a
design essay.

## Evidence And Scope

1. Describe only the exact target boundary. Do not absorb staged, unstaged, or
   later changes unless the user explicitly includes them.
2. Read implementation before prose. Treat the target diff, callers, tests,
   and persisted behavior as facts; use design documents to understand intent,
   not to claim unfinished work.
3. Inspect nearby commits from the affected subsystem before selecting a title
   convention, terminology, body depth, or trailers.
4. Keep unrelated changes visible. Do not invent a single rationale that makes
   an incoherent commit appear cohesive; flag a material boundary mismatch.

## Subject

5. State the primary behavioral change in imperative or present tense. Avoid
   subjects such as `update code`, `fix issue`, `improve logic`, or a feature
   nickname that requires reading the diff.
6. Keep one center of gravity. Leave implementation steps, tests, file names,
   and secondary edge cases to the body. Prefer a subject around 72 characters
   or shorter when the local history permits it.
6a. Keep every subject and body line at 80 columns or fewer. Wrap prose at
    word boundaries and preserve paragraph separation; do not trade away a
    material compatibility or fallback statement merely to shorten the text.
7. Match the repository rather than forcing Conventional Commits. MatrixDB
   subsystem history commonly uses `mars3: ...`, `planner: ...`, or
   `fix(mars3): ...`; PostgreSQL upstream commonly uses a plain imperative
   sentence. Follow the relevant neighboring history, including its treatment
   of capitalization and terminal periods.

## Body

8. Start with the previous limitation or root cause and its concrete impact.
   For a bug fix, explain why the failure occurred, not only its symptom.
9. Explain the core mechanism next. Describe the meaningful data flow,
   ownership, state transition, format, planner, or executor decision; do not
   narrate the diff file by file.
10. Name the authoritative correctness path and the important invariants when
    relevant: for example MVCC, SQL qualification, LEAF/data, WAL, catalog,
    locks, memory contexts, shared cursors, or executor ownership.
11. State what remains unchanged when compatibility matters. Cover applicable
    old versions, explicit and implicit paths, serial and parallel modes,
    persisted formats, fallback behavior, and user-visible semantics.
12. Distinguish optimization success from conservative fallback. Say what is
    skipped, what proof permits it, and how unsupported input, absent optional
    state, resource limits, or unavailable ownership return to the authoritative
    path.
13. For persisted or shared-state changes, cover the applicable lifecycle:
    writer, reader, validation, publication, copy or compaction, recovery,
    rescan, invalidation, and compatibility. Mention only stages the target
    actually affects.
14. Do not claim the complete design when the target implements only a phase.
    Name material exclusions or follow-up work when omission would otherwise
    mislead a maintainer.

## Verification And Attribution

15. Describe test coverage by behavior and boundary, not as a command log.
    Claim that a test passes only when it was actually run for the relevant
    source state. Do not infer unrun regression, benchmark, or platform results.
16. Omit routine build commands, temporary probes, Build IDs, and debugging
    chronology unless they are part of the change's reproducibility or release
    contract.
17. Preserve project-standard attribution for upstream, backpatch, security,
    or externally reported fixes. Use applicable trailers such as `Backport of
    upstream ...`, `Reported-by:`, `Author:`, `Security:`, and
    `Backpatch-through:`; never invent them for a local implementation.

## Style And Final Check

18. Prefer two to five short prose paragraphs in this natural order when each
    part applies: problem, mechanism, invariants and compatibility, validation.
    Use bullets only for genuinely parallel changes or a test matrix that prose
    would obscure.
19. Use neutral, concrete language. Avoid promotional claims such as `fully`,
    `perfectly`, or `massively` unless the target and evidence define and prove
    them.
20. Before returning the message, verify every sentence against the target,
    remove duplicated details and file inventories, and confirm that the
    subject still describes the commit's main behavior.

## Lightweight Shape

Use the lightest subset that tells the truth:

```text
<subsystem-aware subject>

<previous limitation or root cause and impact>

<implementation mechanism and important ownership or data-flow decisions>

<preserved invariants, compatibility, fallback, and verified coverage when relevant>
```

Do not emit empty template sections. A small, obvious change may need only a
subject and one explanatory paragraph.
