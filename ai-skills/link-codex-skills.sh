#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
codex_home="${CODEX_HOME:-$HOME/.codex}"
skills_dir="$codex_home/skills"

mkdir -p "$skills_dir"

find "$source_dir" -mindepth 2 -maxdepth 2 -name SKILL.md -print0 |
while IFS= read -r -d '' skill_file; do
    skill_dir="$(dirname "$skill_file")"
    skill_name="$(basename "$skill_dir")"
    link_path="$skills_dir/$skill_name"

    if [ -L "$link_path" ]; then
        current_target="$(readlink "$link_path")"
        if [ "$current_target" = "$skill_dir" ]; then
            printf 'already linked: %s -> %s\n' "$link_path" "$skill_dir"
            continue
        fi

        printf 'skip conflicting symlink: %s -> %s\n' "$link_path" "$current_target" >&2
        continue
    fi

    if [ -e "$link_path" ]; then
        printf 'skip existing path: %s\n' "$link_path" >&2
        continue
    fi

    ln -s "$skill_dir" "$link_path"
    printf 'linked: %s -> %s\n' "$link_path" "$skill_dir"
done
