#!/bin/bash
# Integration checks for the index scripts using real ctags/cscope in /tmp.
# Run from anywhere: bash test/bash/mytool_index.sh
set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
tags_tool=$repo/exec/make_ctags
scratch=$(mktemp -d /tmp/mytool-check.XXXXXX)
trap 'rm -rf -- "$scratch"' EXIT
for tool in ctags cscope flock; do
    command -v "$tool" >/dev/null
done

fail()
{
    echo "FAIL: $*" >&2
    exit 1
}

expect_failure()
{
    if "$@" > "$scratch/failure.log" 2>&1; then
        fail "command unexpectedly succeeded: $*"
    fi
}

mkdir -p "$scratch/tree with spaces"
cd "$scratch/tree with spaces"
mkdir -p src/nested src/test src/mock src/mars src/mars2x gpAux/gpdemo/data .git CVS
printf 'int alpha(void) { return 1; }\n' > 'src/a file.c'
printf '#define SAMPLE_VALUE 3\n' > src/nested/value.h
printf 'int scope_only(void) { return 2; }\n' > src/test_case.c
printf 'int excluded(void) { return 0; }\n' > src/test/excluded.c
printf 'int excluded_mock;\n' > src/mock/excluded.c
printf 'int excluded_mars;\n' > src/mars/excluded.c
printf 'int included_mars2x;\n' > src/mars2x/included.c

# Compare parallel output with a direct, serial ctags run over an independently
# specified file set. This also verifies the historical substring exclusions.
printf '%s\n' "$PWD/src/a file.c" "$PWD/src/nested/value.h" \
    "$PWD/src/mars2x/included.c" > "$scratch/expected.files"
ctags --kinds-C=+defgmstv --kinds-C++=+cdefgmstuv \
    -f "$scratch/expected.tags" -L "$scratch/expected.files"
MYTOOL_CTAGS_JOBS=2 "$tags_tool"
cmp tags "$scratch/expected.tags"
[[ -L src/nested/tags && src/nested/tags -ef tags ]] || fail 'nested link'
[[ ! -e .git/tags && ! -e CVS/tags ]] || fail 'metadata directory got a link'

# Rebuilding the root tags file must not recreate already-correct symlinks.
link_before=$(stat -c '%i:%y' src/nested/tags)
MYTOOL_CTAGS_JOBS=1 "$tags_tool"
[[ $(stat -c '%i:%y' src/nested/tags) == "$link_before" ]] || fail 'link rewritten'
cmp tags "$scratch/expected.tags"
ln -sfn missing src/nested/tags
MYTOOL_CTAGS_JOBS=2 "$tags_tool"
[[ src/nested/tags -ef tags ]] || fail 'broken link not repaired'

# No cache in this version: edits, additions and removals must be reflected.
printf 'int beta(void) { return 7; }\n' > 'src/a file.c'
printf 'int gamma(void) { return 8; }\n' > src/added.c
rm src/nested/value.h
"$tags_tool"
grep -q $'^beta\t' tags
grep -q $'^gamma\t' tags
if grep -qE '^(alpha|SAMPLE_VALUE)[[:space:]]' tags; then fail 'stale tags'; fi

# By default, remove only old demo links to our root tags, preserving data.
[[ ! -L gpAux/gpdemo/data/tags ]] || fail 'default demo link exclusion'
ln -s ../../../tags gpAux/gpdemo/data/tags
mkdir -p gpAux/gpdemo/private
printf 'keep me\n' > gpAux/gpdemo/private/tags
"$tags_tool"
[[ ! -L gpAux/gpdemo/data/tags ]] || fail 'demo link remains'
grep -qx 'keep me' gpAux/gpdemo/private/tags

# Publication must retain the previous file on a worker error or sort error.
cp tags "$scratch/previous.tags"
mkdir "$scratch/bin"
cat > "$scratch/bin/ctags" <<'SH'
#!/bin/bash
if [[ $1 == --version ]]; then
    echo 'Universal Ctags (failure fixture)'
    exit 0
fi
echo 'injected worker failure' >&2
exit 7
SH
chmod +x "$scratch/bin/ctags"
expect_failure env PATH="$scratch/bin:$PATH" "$tags_tool"
cmp tags "$scratch/previous.tags"
rm "$scratch/bin/ctags"
cat > "$scratch/bin/sort" <<'SH'
#!/bin/bash
if [[ $1 == --parallel=* ]]; then exit 8; fi
exec /usr/bin/sort "$@"
SH
chmod +x "$scratch/bin/sort"
expect_failure env PATH="$scratch/bin:$PATH" "$tags_tool"
cmp tags "$scratch/previous.tags"
rm "$scratch/bin/sort"

# Terminating the parent while it waits must stop its workers, release the
# lock and keep the old tags. A sleeping executable makes this deterministic.
cat > "$scratch/bin/ctags" <<'SH'
#!/bin/bash
if [[ $1 == --version ]]; then echo 'Universal Ctags (signal fixture)'; exit 0; fi
echo "$$" > "$MYTOOL_PID_DIR/worker-$$"
exec sleep 30
SH
chmod +x "$scratch/bin/ctags"
PATH="$scratch/bin:$PATH" MYTOOL_PID_DIR="$scratch" MYTOOL_CTAGS_JOBS=2 \
    "$tags_tool" > "$scratch/signal.log" 2>&1 &
parent=$!
for (( attempt=0; attempt<200; attempt++ )); do
    if compgen -G "$scratch/worker-*" >/dev/null; then break; fi
    sleep 0.02
done
if ! compgen -G "$scratch/worker-*" >/dev/null; then
    kill "$parent" || :
    wait "$parent" || :
    fail 'signal fixture did not start'
fi
kill -TERM "$parent"
status=0
wait "$parent" || status=$?
[[ $status == 143 ]] || fail "unexpected termination status: $status"
for pid_file in "$scratch"/worker-*; do
    if kill -0 "$(cat "$pid_file")" 2>/dev/null; then fail 'worker survived parent'; fi
done
cmp tags "$scratch/previous.tags"

expect_failure env MYTOOL_CTAGS_JOBS=0 "$tags_tool"
expect_failure flock cscope.ctags.lock "$tags_tool"
cmp tags "$scratch/previous.tags"
if find . -maxdepth 1 -type d -name 'cscope.ctags.*' | grep -q .; then
    fail 'temporary directory left behind'
fi

# Empty input still produces a usable empty tags file.
mkdir "$scratch/empty"
(cd "$scratch/empty" && "$tags_tool")
[[ -f $scratch/empty/tags ]] || fail 'empty input'

# Exercise the real wrapper, including quoted source paths, the separate
# cscope filters, and propagation of a failing ctags invocation. cscope 15.9
# cannot reopen its own database when its working directory contains spaces.
expect_failure "$repo/exec/buildidx" "$PWD"
grep -q 'without whitespace' "$scratch/failure.log"
mkdir "$scratch/wrapper"
cp -R src "$scratch/wrapper/"
cd "$scratch/wrapper"
"$repo/exec/buildidx" "$PWD"
cscope -dL -f cscope.out -1 scope_only > "$scratch/query"
grep -q scope_only "$scratch/query"
expect_failure env MYTOOL_CTAGS_JOBS=0 "$repo/exec/buildidx" "$PWD"
expect_failure flock cscope.build.lock "$repo/exec/buildidx" "$PWD"
expect_failure "$repo/exec/buildidx" "$scratch/missing"
# New entry point: default directory, jobs option, argument errors, and legacy
# wrapper delegation all work without the caller selecting the helper in PATH.
"$repo/exec/buildidx" -j 2
"$repo/exec/mytool" -i "$PWD"
expect_failure "$repo/exec/buildidx" -m .
expect_failure "$repo/exec/buildidx" -j
expect_failure "$repo/exec/buildidx" --jobs 17 .
expect_failure "$repo/exec/buildidx" . .
"$repo/exec/buildidx" --help > "$scratch/help"
grep -q -- '--jobs' "$scratch/help"
echo 'PASS: buildidx defaults, jobs, compatibility, output, edits, links, failures and locks'
