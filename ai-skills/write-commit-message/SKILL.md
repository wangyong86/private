---
name: write-commit-message
description: Draft or revise Git commit messages from an exact commit, staged diff, or revision range while matching nearby repository history and accurately describing implementation behavior, invariants, compatibility, fallback, and verified tests. Use when asked to write, improve, review, or apply a commit message; message generation alone does not authorize staging, committing, or rewriting history.
---

# Write Commit Message

Produce a commit message that will remain useful to maintainers after the
review context and working tree are gone.

## Required Reference

Read [Commit Message Rules](references/commit-message-rules.md) completely
before drafting or reviewing a message.

## Workflow

1. Establish the exact target: a named commit, `HEAD`, the index, a working-tree
   diff, or a revision range. Keep unstaged, staged, and committed changes
   distinct.
2. Inspect the target diff, affected behavior, relevant tests, and nearby
   commits from the same subsystem. Use implementation as current fact and
   design documents as intent unless the target implements them.
3. Draft the subject and body using the referenced rules. Match local history
   rather than imposing one repository-independent prefix convention.
4. Check every behavioral and verification claim against the target boundary.
   Remove file inventories, command narration, unverified claims, and design
   work that is not in the target.
5. Return the complete message in a form suitable for `git commit` unless the
   user requested a review, alternatives, or another output shape.

## Mutation Boundary

By default, generate text only. Do not stage files, create a commit, amend a
commit, rebase, or push unless the user explicitly requests that operation.

When an amend is explicitly requested:

- inspect the index and worktree before acting;
- preserve changes outside the authorized commit boundary;
- use a message-only amend when only the message should change;
- verify the resulting parent, tree, message, index, and worktree state.
