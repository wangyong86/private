---
name: multi-agent-code-review-quality
description: Use when running a quality-focused local multi-agent PR review with specialist reviewers, an independent validator, evidence gates, and a structured Chinese review report.
---

# Multi-Agent Code Review Quality

## Scope

This skill contains the review core extracted from the standalone code-review
service. It preserves review knowledge, reviewer roles, evidence rules, output
contracts, and deterministic location/fix validation.

It does not provide Docker packaging, CLI credential selection, Gitee comments,
PostgreSQL storage, web UI, webhook/queue handling, token accounting, or the
original service test suite. Those are adapters around this skill, not part of
the local review capability.

## Required Inputs

Build a review manifest before dispatching agents. It may be supplied by the
caller or created locally from `repo_path`, `head_ref`, and `base_ref`.

```text
repo_path
head_ref                 # source branch, commit, or HEAD SHA
base_ref                 # target branch or commit
head_sha
changed_files
full_diff
code_diff
test_diff
pr_context               # optional: title, description, commit messages
checklist                # optional: mandatory review rules
custom_prompt            # optional: additional review rules
review_history           # optional explicit file; no database lookup
```

When constructing the manifest, compare `base_ref...head_ref`, use the exact
changed-file paths, and keep full/code/test diffs separate. A PR description
explains intent only; it cannot create or suppress a finding.

For a local repository, the minimum preparation is equivalent to:

```bash
export GIT_OPTIONAL_LOCKS=0
git -C "$repo_path" diff --unified=5 "$base_ref...$head_ref" -- > pr.diff
git -C "$repo_path" diff --unified=5 "$base_ref...$head_ref" -- <code-files> > pr.code.diff
git -C "$repo_path" diff --unified=5 "$base_ref...$head_ref" -- <test-files> > pr.test.diff
```

Do not use an empty path list with `git diff --`; an empty path list means the
full diff, not an empty diff.

## Review Workflow

### 1. Route the review

Use the smallest profile that covers the change:

| Profile | Reviewers | Use |
| --- | --- | --- |
| `full` | architecture, code-quality, performance, test-coverage, independent | normal PR |
| `light` | independent | small, low-risk, or explicitly fast review |
| `diverse` | `full` plus cross-model when another model is configured | high-risk or disagreement-prone PR |

Role input scope is part of the contract:

| Reviewer | Input |
| --- | --- |
| architecture | `code_diff` |
| code-quality | `code_diff` |
| performance | `code_diff` |
| test-coverage | `full_diff` and `test_diff` |
| independent | `full_diff` |
| cross-model | `full_diff` |
| validator | manifest, `full_diff`, and all candidates |

Route cross-cutting checks into the relevant reviewer and validator instead of
creating generic reviewers for every PR:

- metadata, serialization, versions, or configuration limits: persisted-format
  and baseline checks;
- new producer state, projection, callbacks, or late materialization:
  consumer/materialization checks;
- DSM, shared cursors, worker state, or rescan: parallel ownership checks;
- accelerator, fallback, or boundary tests: activation and test-artifact checks;
- external comments or suspected master defects: baseline attribution checks.

### 2. Dispatch specialists

When the multi-agent facility is available, spawn the selected reviewers in
parallel. In Codex, use the available `spawn_agent`/`wait_agent` facility
(`multi_agent_v1` in the current runtime). Pass each reviewer:

1. the manifest and its assigned diff;
2. only the reference guides selected by file type and risk;
3. the role prompt under `prompts/`;
4. the JSON output contract in `references/reviewer-prompts.md`.

A reviewer returns candidate findings, never final conclusions. Zero candidates
is valid, but candidate generation is a discovery pass rather than the final
publication gate. A concrete changed-line concern with a reproducible trigger
and code evidence should reach the validator even when runtime confirmation is
missing or the safe repair is cross-cutting. Mark that uncertainty explicitly
and use an empty `fix_code_blocks` array instead of silently dropping it. A
failed or timed-out specialist contributes an empty candidate list; the
validator still runs. If subagents are unavailable, execute the same roles
serially in the main agent and keep the same evidence gates.

### 3. Normalize candidate findings

Normalize every specialist response to the candidate schema:

```text
schemas/candidate.schema.json
```

Reject malformed candidates before semantic validation. Do not silently repair
missing evidence by inventing it. Preserve the reviewer name and
`coverage_notes`, including files and risk areas actually checked.

Every candidate must include:

- a changed-hunk anchor;
- a concrete trigger and bad outcome;
- base/head evidence and attribution;
- an actionable repair or verification direction; include a structured local
  fix only when it can be stated safely and exactly;
- complete performance evidence fields when performance is involved;
- consumer paths, authority, or activation proof when the concern requires it.

### 4. Run an independent validation pass

The validator is a separate pass from candidate generation. It may be a
dedicated validator subagent or the main agent operating under
`prompts/validator.md`, but it must not merely concatenate specialist prose.

For every `blocking` or `important` candidate, inspect the changed code,
callers, consumers, tests, and the target-base version. Then:

1. keep it if the failure is real and attributable to the PR;
2. downgrade it if the issue is real but severity is too high;
3. move it to `dismissed_findings` if it is not real, not actionable, not
   attributable to the PR, or lacks a credible local fix.

For `suggestion` candidates and credible but unverified risks, distinguish
"not proven" from "not real". Keep a downgraded active finding or an explicit
open question when the changed path, trigger, and potential outcome are
concrete. Missing a benchmark, runtime reproduction, or exact local patch is
not by itself a dismissal reason. Do not use this rule to retain vague pattern
matches, style preferences, or risks with no PR effect.

Always apply these gates:

- `file:line` is an added/modified line in the review diff;
- the failure is `input/state -> bad outcome`;
- existing guards, callers, tests, or framework behavior do not prevent it;
- the severity and fix are defensible;
- pre-existing issues without a PR effect are follow-ups, not active findings;
- optimized-path claims have activation evidence;
- a test that proves only an outer provider or final result does not count as
  coverage when the changed internal scanner, consumer, fallback, or rescan
  path is demonstrably different; wrong-path activation is itself reportable;
- performance claims distinguish measured from inferred and state benchmark
  status;
- persistence, materialization, parallel, and history claims follow
  `references/review-gates.md`.

Merge duplicates by root cause, not just wording. Keep the clearest evidence
and all source reviewer names. For open-ended reviews, keep at most 15 active
findings. For a fixed external comment set, retain a disposition for every
comment before deduplicating independent findings.

The deterministic checker also removes exact duplicates with the same
`(file, line, subcategory)` key; semantic duplicates remain the validator's
responsibility.

### 5. Validate and return the final report

Write the validator result using:

```text
schemas/review.schema.json
```

Then run the deterministic checker against the reviewed head and diff:

```bash
python3 scripts/validate_review.py \
  --review review.json \
  --diff pr.diff \
  --repo-path "$repo_path" \
  --head-sha "$head_sha" \
  --rewrite
```

`--rewrite` moves invalid active findings to `dismissed_findings`, records a
Chinese dismissal reason, and recomputes `decision`. Without `--rewrite`, the
script is a read-only check and exits nonzero on violations.

The final report must:

- lead with `REQUEST_CHANGES`, `APPROVE_WITH_COMMENTS`, or `APPROVE`;
- use Simplified Chinese for all human-readable text;
- group active findings by severity;
- include file, line, trigger, evidence, source reviewer, and fix;
- include a coverage note and meaningful uncertainty;
- preserve explicit historical follow-up when `review_history` was supplied.

Decision is computed only from active findings:

```text
blocking  -> REQUEST_CHANGES
important -> APPROVE_WITH_COMMENTS
otherwise -> APPROVE
```

## Reference Routing

Read the smallest relevant set of guides from `references/guides/`:

| Change | Guides |
| --- | --- |
| all code | `code-review-best-practices.md`, `code-quality-universal.md`, `common-bugs-checklist.md` |
| architecture | `architecture-review-guide.md` |
| performance/runtime | `performance-review-guide.md` |
| security-sensitive | `security-review-guide.md` |
| C/C++ | `c.md` or `cpp.md` |
| C# | `csharp.md` |
| Go | `go.md` |
| Java/Kotlin | `java.md`, `kotlin.md` |
| Python/Django | `python.md`, `django.md` |
| Rust | `rust.md` |
| TypeScript/JavaScript | `typescript.md` |
| React/Vue/Angular/Svelte | the matching framework guide plus `typescript.md` |
| NestJS/Qt/CSS | the matching guide |

Do not replace these guides with a short summary. The routing table is the
token-control mechanism; the guides preserve language- and framework-specific
review capability.

## Explicit Local Inputs

The local skill accepts optional files instead of service integrations:

- `CHECKLIST_FILE`: mandatory project-specific review rules;
- `CUSTOM_PROMPT` or `CUSTOM_SKILL_FILE`: additional review criteria;
- `REVIEW_HISTORY_FILE`: prior review findings and human feedback;
- `PR_CONTEXT_FILE`: title, description, and commit messages.

If an optional file is absent, continue and state the coverage limit. Never
invent a Gitee comment, database history item, benchmark, or runtime plan.

## Failure Policy

- specialist failure: empty candidate list, continue;
- malformed specialist output: reject that candidate, continue;
- validator failure: perform the validator pass in the main agent; do not
  return an unvalidated finding set;
- deterministic location/fix failure: move the item to
  `dismissed_findings` or fail the run when read-only checking is requested;
  an intentionally empty fix block is allowed when the finding has an
  actionable prose fix or verification direction;
- no findings: return a valid `APPROVE` report with empty arrays.

## Out Of Scope

Do not recreate the standalone service in this skill. Docker images, CLI
wrappers, Gitee/DB/Web integrations, queues, deployment, token accounting, and
the original repository test suite belong in separate adapters or the source
service.
