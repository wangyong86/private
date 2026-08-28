# Verification and Recovery

This reference is for a rewrite that has already been authorized and whose
mapping is explicit. Replace placeholders with fixed values; do not paste
unreviewed shell expansion into a production repository.

## Freeze the identities

```bash
feature=$(git symbolic-ref --quiet --short HEAD) || exit 1
old_tip=$(git rev-parse HEAD) || exit 1
base="KNOWN_BASE_SHA"
git rev-parse "$base" "$old_tip" "$old_tip^{tree}" || exit 1
```

Use an existing, agreed base ref. If `git fetch` advances a tracking ref, keep
the previously agreed base or stop for confirmation; do not silently rebase a
larger range. Verify the topology and mapping before editing:

```bash
git merge-base --is-ancestor "$base" "$old_tip" || exit 1
test "$(git rev-list --count --merges "$base..$old_tip")" -eq 0 || exit 1
target_1="TARGET_1_SHA"
fix_1="FIX_1_SHA"
target_2="TARGET_2_SHA"
fix_2="FIX_2_SHA"
git rev-parse "$target_1" "$fix_1" "$target_2" "$fix_2" || exit 1
for commit in "$target_1" "$fix_1" "$target_2" "$fix_2"; do
    git merge-base --is-ancestor "$base" "$commit" || exit 1
    git merge-base --is-ancestor "$commit" "$old_tip" || exit 1
done
git merge-base --is-ancestor "$target_1" "$fix_1" || exit 1
git merge-base --is-ancestor "$target_2" "$fix_2" || exit 1
```

Record the expected number of commits and the full ordered list with
`git log --reverse --format='%H%x09%s' "$base..$old_tip"`. A target or fix that
is outside this range, duplicated, already absorbed, or ordered unexpectedly
is a stop condition. Record signature status as well:

```bash
git log --format='%H%x09%G?%x09%s' "$base..$old_tip"
```

Any signature status other than `N` needs explicit confirmation because a
rewritten commit cannot retain its old signature. Review anchors, Change-Ids,
attestations, and systems keyed by commit OID need the same decision.

## Preserve a dirty checkout

The safest preservation mechanism is never to operate in the checkout. Before
creating a worktree, save evidence outside the repository:

```bash
set -euo pipefail
snapshot_dir=$(mktemp -d /tmp/cross-commit-absorption.XXXXXX) || exit 1
git status --porcelain=v2 -z >"$snapshot_dir/status.before"
git diff --binary --full-index >"$snapshot_dir/unstaged.patch"
git diff --cached --binary --full-index >"$snapshot_dir/staged.patch"
git ls-files --others --exclude-standard -z >"$snapshot_dir/untracked.list"

record_untracked() {
    git ls-files --others --exclude-standard -z |
    while IFS= read -r -d '' path; do
        mode=$(stat -c '%f' -- "$path") || return 1
        if test -L "$path"; then
            link_target=$(readlink -- "$path") || return 1
            printf 'symlink\0%s\0%s\0%s\0' "$path" "$mode" "$link_target" || return 1
        elif test -f "$path"; then
            digest=$(git hash-object --no-filters -- "$path") || return 1
            printf 'file\0%s\0%s\0%s\0' "$path" "$mode" "$digest" || return 1
        else
            printf 'special\0%s\0%s\0' "$path" "$mode" || return 1
        fi
    done
}
record_untracked >"$snapshot_dir/untracked.digest" || exit 1
```

If ignored files or dirty submodules matter, record and protect those exact
paths separately. A path manifest is not a recovery copy: for explicitly
protected untracked or ignored paths, make an outside-the-repository copy that
preserves mode and symlink targets. For dirty submodules, record each nested
repository's HEAD, status, tracked diff, and protected untracked/ignored paths
separately; stop if that cannot be done.

Create a non-colliding recovery ref and a separate worktree:

```bash
set -euo pipefail
utc_stamp="20260827T000000Z"  # replace with a fresh, unique UTC value
backup_ref="refs/absorb-backups/${feature}-before-${utc_stamp}"
zero_oid=$(printf '' | git hash-object --stdin | sed 's/./0/g')
git update-ref "$backup_ref" "$old_tip" "$zero_oid" || exit 1
worktree_dir=$(mktemp -d /tmp/cross-commit-worktree.XXXXXX) || exit 1
git worktree add "$worktree_dir" "$old_tip" || exit 1
```

Do not initialize or modify submodules in this worktree unless that is part of
the authorized task.

## Rewrite and inspect

Inside the temporary worktree, require support for all safety flags, then run
the following in one shell session:

```bash
set -euo pipefail
rebase_help=$(git rebase -h 2>&1 || :)
for spec in \
    'update-refs|--(\[no-\])?update-refs' \
    'empty|--empty' \
    'reapply-cherry-picks|--(\[no-\])?reapply-cherry-picks'; do
    option=${spec%%|*}
    pattern=${spec#*|}
    printf '%s\n' "$rebase_help" | grep -Eq -- "$pattern" || {
        printf 'required rebase option is unavailable: %s\n' "$option" >&2
        exit 1
    }
done
git -c rebase.missingCommitsCheck=error \
    rebase -i --no-autosquash --no-update-refs \
    --empty=stop --reapply-cherry-picks "$base"
```

Move each named fix directly below its target and change only that line to
`fixup` (or intentionally `squash`). Keep all unrelated todo lines exactly
once and in order. Resolve todo entries against full SHAs first: interactive
rebase commonly abbreviates them. Re-open the todo after editing and count each
target/fix pair. If the history contains merges, stop; do not treat
`--rebase-merges` as a simple substitution for this linear algorithm. Continue
only under a separate topology-specific plan that records and matches old/new
parents. For the stop report, preserve the old parent list with:

```bash
git rev-list --parents --topo-order "$base..$old_tip"
```

When a conflict occurs, collect evidence before editing:

```bash
git status
git diff --name-only --diff-filter=U
git show :1:path/to/file  # merge base
git show :2:path/to/file  # current target-time side
git show :3:path/to/file  # fix side
git diff "$target_1^" "$target_1" -- path/to/file
git diff "$fix_1^" "$fix_1" -- path/to/file
```

Resolve the target-plus-fix meaning at that historical point, not the final
tip. Stage the resolved path and run `git rebase --continue`. If a fix becomes
empty, a commit disappears, or the rebase reports an unexpected drop, stop and
inspect whether it was redundant or incorrectly replayed. Use
`git rebase --abort` when the meaning cannot be established. If a commit that
was non-empty before replay becomes empty, stop and classify it as redundant
only after comparing its patch; preserve intentional-empty commits explicitly.

`git-absorb` is useful only as an optional dry-run mapping hint for staged
working-tree changes. It is not authoritative for an existing correction
commit, especially when later refactors changed blame lines, when one fix
touches several owners, or when many fine-grained fixups would be generated.

## Proof gates

After the worktree reaches `new_tip`, run all applicable checks before moving
the feature ref:

```bash
old_tree=$(git rev-parse "$old_tip^{tree}") || exit 1
new_tip=$(git -C "$worktree_dir" rev-parse HEAD) || exit 1
new_tree=$(git -C "$worktree_dir" rev-parse "$new_tip^{tree}") || exit 1
test "$old_tree" = "$new_tree" || exit 1
git diff --exit-code "$old_tip" "$new_tip" -- || exit 1
git diff --exit-code "$new_tip" "$old_tip" -- || exit 1
git range-diff --no-color "$base..$old_tip" "$base..$new_tip"
old_count=$(git rev-list --count "$base..$old_tip") || exit 1
absorbed_count=2  # replace with the number of explicitly absorbed fix commits
expected_count=$((old_count - absorbed_count))
test "$(git rev-list --count "$base..$new_tip")" -eq "$expected_count" || exit 1
test "$(git rev-list --count --merges "$base..$new_tip")" -eq 0 || exit 1
if git log --format=%s "$base..$new_tip" | grep -Eq '^(fixup!|squash!)'; then
    printf '%s\n' 'unexpected independent fixup/squash subject remains' >&2
    exit 1
fi
while IFS= read -r commit; do
    git diff-tree --check --no-commit-id -r "$commit" || exit 1
done < <(git log --format=%H "$base..$new_tip")
```

`range-diff` is a review aid: unchanged unrelated patches should compare as
equal, while target patches should explain the absorbed content. Also check the
expected commit count, merge count, parent list, author/message policy, and that
no subject begins with `fixup!` or `squash!` unless intentionally retained.
Net patch-ID is redundant once tree IDs and diffs match; if a reviewer requests
it as a summary, label it as secondary because it ignores metadata and some
whitespace differences.

Repository-wide `git fsck --connectivity-only --no-reflogs --full` is an optional
health check. It can be slow or report unrelated repository damage; if policy
requires it, treat a non-zero result as a stop condition and report whether it
actually completed. It is not evidence that the rewrite itself changed or did
not change content.

Tree equality covers tracked paths, modes, and symlink targets only. It does
not cover untracked or ignored files, submodule working trees, signatures,
review anchors, CI artifacts, or functional behavior. Run the repository's
appropriate build/regression tests when required and report exactly what was
not run.

## Atomic publication and rollback

Only after every gate passes, update a checked-out branch by compare-and-swap:

```bash
set -euo pipefail
git update-ref -m "absorb named fixes" "refs/heads/$feature" "$new_tip" "$old_tip" || exit 1
```

If this fails, assume another process moved the ref and stop. Keep the shell
session that defined `record_untracked` (or redefine it before this block),
then recheck the checkout snapshots after the update:

```bash
set -euo pipefail
verify_checkout_snapshot() {
    git status --porcelain=v2 -z >"$snapshot_dir/status.after" || return 1
    git diff --binary --full-index >"$snapshot_dir/unstaged.after.patch" || return 1
    git diff --cached --binary --full-index >"$snapshot_dir/staged.after.patch" || return 1
    record_untracked >"$snapshot_dir/untracked.after.digest" || return 1
    cmp "$snapshot_dir/status.before" "$snapshot_dir/status.after" || return 1
    cmp "$snapshot_dir/unstaged.patch" "$snapshot_dir/unstaged.after.patch" || return 1
    cmp "$snapshot_dir/staged.patch" "$snapshot_dir/staged.after.patch" || return 1
    git ls-files --others --exclude-standard -z >"$snapshot_dir/untracked.after.list" || return 1
    cmp "$snapshot_dir/untracked.list" "$snapshot_dir/untracked.after.list" || return 1
    cmp "$snapshot_dir/untracked.digest" "$snapshot_dir/untracked.after.digest" || return 1
}

if ! verify_checkout_snapshot; then
    git update-ref -m "rollback failed absorption validation" \
        "refs/heads/$feature" "$old_tip" "$new_tip" || {
        printf '%s\n' 'snapshot mismatch and CAS rollback failed; stop immediately' >&2
        exit 1
    }
    printf '%s\n' 'snapshot mismatch; local ref rolled back to old_tip' >&2
    exit 1
fi
```

Before publication, abort the rebase and remove the temporary worktree if
needed; the original branch still points at `old_tip`. After a successful local
update, the backup ref is the recovery point. If remote publication was
explicitly authorized and the remote still equals the captured old OID, use
an exact lease and verify the result:

```bash
remote=origin
remote_ref="refs/heads/FEATURE"
remote_old=$(git ls-remote --exit-code --refs "$remote" "$remote_ref" |
    awk 'NR == 1 { print $1 }') || exit 1
test -n "$remote_old" || exit 1
git push --force-with-lease="$remote_ref:$remote_old" \
    "$remote" "$new_tip:$remote_ref" || exit 1
remote_now=$(git ls-remote --exit-code --refs "$remote" "$remote_ref" |
    awk 'NR == 1 { print $1 }') || exit 1
test "$remote_now" = "$new_tip" || exit 1
```

Never use bare `--force`. If the remote has moved, stop rather than
overwriting it. A post-push rollback, if explicitly authorized, uses the same
lease form with `new_tip` as the expected remote OID and the backup ref as the
pushed value:

```bash
git push --force-with-lease="$remote_ref:$new_tip" \
    "$remote" "$backup_ref:$remote_ref" || exit 1
```

Do not delete the backup ref or run `git gc` until the new history is accepted.
