---
name: matrixdb-code-development
description: >-
  Write and change MatrixDB / PostgreSQL backend code while matching nearby
  conventions, reusing existing helpers, and self-checking before commit. Use
  when implementing, fixing, or extending pg core, mars2x/Mars3, or mxvector
  code, or when the user asks to follow MatrixDB coding conventions.
---

# MatrixDB Code Development

Use this skill for implementation and local edits. It does not replace
debugging, design-confirmation, or review skills.

## Non-negotiable rules

1. 代码是遵循周边代码的规范，pg/mars2x/mxvector都有自己的代码规范，后两者有clang-format要求。
2. 写代码的时候严禁自造轮子，要尽量复用，如果一定要抽utils，要有一定的抽象和复用。
3. 变量命名要遵循周边代码风格，并尽量使用良好的命名风格，复用原有代码里好的命名。
4. 写完代码要自查。
5. 代码提交要按相应skill提交commit message。

## Choose the local convention

Read the nearest callers, headers, and tests before writing. Match that
subtree; do not import another subtree's style.

| Area | Authority | Format | Comments / braces |
|---|---|---|---|
| PostgreSQL core (`src/`) | Nearby `.c` / `.h` in the same file | No clang-format unless that file already uses it | `/* ... */` only. Omit braces when an `if` / `while` body is a single statement. |
| mars2x / Mars3 (`contrib/matrixts/mars2x`) | `contrib/matrixts/mars2x/AGENTS.md` and nearest `.clang-format` | clang-format **changed lines only** | `//` in mars2x, except file headers and inline parameter comments. Core files touched by a Mars3 task still follow PostgreSQL comment/brace rules. |
| mxvector (`contrib/mxvector`, `contrib/matrixts/mxvector`) | Nearby `.cc` / `.h` and `contrib/mxvector/.clang-format` | clang-format **changed lines only** | Follow the surrounding C++ file. |

Do not reformat unrelated lines. Do not mix a PostgreSQL patch and an
mxvector rename in the same opportunistic sweep.

## Reuse before inventing

- Search the same subsystem for the helper, walker, GUC, type gate, or
  naming already used by callers. Prefer adapting that function to a
  documented extra case over adding a parallel copy.
- Extract a new util only when a second caller already exists or is in
  the same change, and the name states a real abstraction (for example
  `RuntimeFilterGetVar`, not `helper1`). One-off wrappers stay local.
- Do not add a compatibility shim, second metadata path, or extra
  validation layer unless it removes a concrete duplication or invariant
  hole visible in the current callers.

## Naming

- Copy identifiers from the surrounding function: `varno`, `varattno`,
  `hashclauses`, `prefetch_inner`, `inner_datatype`, and similar PG/MxV
  names stay as they are.
- New names should say the invariant (`RuntimeFilterTextType`,
  `FastDDLocalRuntimeFilterHashPath`), not the ticket or a nickname.
- Keep PG C names `snake_case`; keep existing MxV C++ names
  (`need_init`, `FilterInsert`) unless the file already uses another
  pattern for that kind of symbol.

## Self-check before claiming done

Walk the changed functions as a reviewer:

- Every new branch has a conservative fallback to the previous
  authoritative path (no filter, no prune, original scan).
- Type, NULL, collation, TOAST, FastDD, and parallel/Motion cases that
  the neighboring code already special-cases are handled or explicitly
  rejected.
- No unused helper, dead `#include`, or invented GUC.
- mars2x / mxvector edits were formatted with the nearest
  `.clang-format` on the changed lines only.
- A compile or the existing test for that subsystem was actually run
  when the change is in those trees. Report only commands that ran.

## Commit messages

When the user asks to commit, follow
[`write-commit-message`](../write-commit-message/SKILL.md) and
[`write-commit-message/references/commit-message-rules.md`](../write-commit-message/references/commit-message-rules.md).
Read nearby commits in the same subsystem before choosing the subject
prefix. Do not invent Conventional Commit prefixes if the history uses
`runtimefilter:`, `mxv:`, or `fix(mxvector):`.
