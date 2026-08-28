---
name: cross-commit-absorption
description: Use when later fix or correction commits must be folded into earlier commits on a Git branch while preserving the final tracked tree, especially with a dirty worktree, overlapping refactors, or history-rewrite risk.
metadata:
  short-description: Safely fold later fixes into earlier commits
---

# Cross-Commit Absorption

## Overview

Absorption rewrites commit ownership while preserving the old tip's tracked
tree. The user supplies the fix-to-target mapping; new commit IDs are expected,
but a changed final tree is a failure. This skill describes a technique and
proof gates, not permission to rewrite or publish history.

## When to Use

Use it for explicit mappings such as `F1 -> A` on a merge-free feature branch:
late review, regression-test, or hardening commits that belong with an earlier
feature commit. Stop for merge-heavy/shared/signed history, or when final
content is also meant to change; those require a separate topology or release
decision.

## Non-Negotiable Invariants

1. Freeze `base`, `old_tip`, branch, and all target/fix SHAs; never let fetch
   silently move the base.
2. Create a unique backup ref at `old_tip` atomically; reflogs are not enough.
3. Never rebase a dirty checkout. Use a temporary worktree and leave the user's
   index, worktree, untracked/ignored files, and submodules untouched.
4. Follow the user's mapping. Blame or `git-absorb` may suggest ownership only.
5. Resolve `target + fix` in historical context; never use global `-Xours` or
   `-Xtheirs` to conceal an unresolved meaning.
6. Require `--no-update-refs`, `--empty=stop`, and `--reapply-cherry-picks`;
   do not inherit safety-sensitive Git defaults.
7. Publish the local ref only after tree and commit-level proofs pass, using a
   compare-and-swap update.
8. Push, force-push, delete the backup ref, or run GC only when explicitly
   requested or authorized.
9. Tree equality is not a build or regression test; report tests not run.

## Procedure

1. **Preflight.** Check status and active sequencer state. Verify the linear
   range, target/fix ancestry and order, mapping uniqueness, signatures, and
   expected commit list.
2. **Protect.** Save status plus staged/unstaged binary patches outside the
   repository. Record untracked content/type/mode digests and make recovery
   copies only for explicitly protected paths. Create the atomic backup ref.
3. **Isolate.** Add a temporary worktree at `old_tip`; do not modify the dirty
   checkout or initialize its submodules.
4. **Rewrite.** In the worktree, run interactive rebase with autosquash disabled
   and all three required safety flags. Move each fix immediately after its
   target as `fixup`, preserving every other todo line exactly once. Match full
   SHAs, then re-read the abbreviated todo and verify every pair.
5. **Resolve.** Inspect stages and target/fix diffs for each conflict. Stage only
   an explained target-time result; abort on uncertainty, unexpected drops, or
   non-empty commits becoming empty without an explicit classification.
6. **Prove.** Require identical old/new tip tree IDs and bidirectional diffs.
   Review `range-diff`, expected counts/parents, whitespace checks, and absence
   of independent fixups. Patch-ID is optional summary evidence; repository-wide
   `fsck` is optional unless policy makes it a gate.
7. **Publish and retain.** Move the local branch with `update-ref` using the old
   tip as expected value, then compare dirty-state snapshots and CAS-roll back
   on mismatch. Keep the backup ref and recovery materials through review/CI;
   use an exact remote lease only for an explicitly authorized push.

Read [references/verification-and-recovery.md](references/verification-and-recovery.md)
for executable command templates, conflict evidence, empty/signature/submodule
handling, remote lease, and rollback details.

## Quick Reference

| Situation | Action | Stop when |
| --- | --- | --- |
| Explicit mapping | Manual interactive rebase | Mapping is ambiguous |
| Dirty checkout | Temporary worktree | Isolation cannot be guaranteed |
| Conflict | Inspect stages and replay target-time intent | Meaning is uncertain |
| Same result required | Compare tip trees and diffs | Any mismatch |
| Remote involved | Require explicit authorization and lease | Remote moved |

## Common Mistakes

| Rationalization | Correction |
| --- | --- |
| "`git-absorb` knows the owner." | Blame/hunks can misattribute after refactors; use it only as a clue. |
| "The tree is unchanged, so no backup is needed." | History, signatures, and dirty files still need recovery. |
| "I can rebase here and restore files later." | Stash/reset/reapply can lose ignored, untracked, or submodule state. |
| "Tree proof means tests passed." | It proves tracked content only; report functional-test status separately. |

## Red Flags

Moving base, active sequencer, missing backup, dirty checkout being rebased,
inferred mapping, deleted todo line, unexplained range-diff, tree mismatch,
changed snapshot, stale lease, or an unrun test reported as passing means stop
and preserve `old_tip`.
