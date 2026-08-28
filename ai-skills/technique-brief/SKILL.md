---
name: technique-brief
description: Use when writing or rewriting internal technical design/implementation documentation that should establish a subsystem mental model, spell out invariants and tradeoffs, and read like PostgreSQL or MatrixDB backend design notes rather than API reference.
---

# Technique Brief

Write technical docs in the style used by `src/backend/*/README` files in PostgreSQL/MatrixDB.

This style is for subsystem explanation, not marketing copy, tutorials, changelogs, or API docs. The goal is to give future maintainers a working mental model of how a mechanism behaves, why it is structured that way, and what assumptions must remain true.

## When to use

Use this skill when the target document should resemble files like:

- `src/backend/storage/smgr/README`
- `src/backend/storage/buffer/README`
- `src/backend/access/transam/README`
- `src/backend/optimizer/README`
- `src/backend/utils/resowner/README`

Use it for:

- subsystem implementation notes
- architecture overviews tied to real code
- invariants, phases, lifecycles, ownership, and layering docs
- docs for internal maintainers of storage, executor, parser, planner, transaction, memory, lock, or similar backend code

Do not use it for:

- user-facing product docs
- step-by-step tutorials
- function-by-function API reference
- PR descriptions or release notes

## Core pattern

Start from the mechanism, not the file list.

The usual shape is:

1. Name the subsystem plainly.
2. State the core model in 1-3 paragraphs.
3. Explain the major mechanisms in sections with informative headings.
4. Spell out invariants, boundaries, ordering rules, or lifecycle rules.
5. Use examples only when they clarify a subtle point.
6. End naturally after the model is complete; no mandatory summary section.

The reader should finish with answers to:

- What problem does this subsystem solve?
- What are its main moving parts?
- What assumptions and invariants does the rest of the system rely on?
- What cases are special, surprising, or easy to misuse?

## Style rules

- Prefer a neutral, technical tone.
- Open with architecture or purpose, not motivation fluff.
- Explain mechanisms before edge cases, unless the edge case defines the mechanism.
- Use short section titles with underline-style headings when matching an existing README.
- Prefer prose over bullets unless listing phases, rules, or examples.
- Use bullets for precise rules, phases, or call sequences.
- Use examples sparingly and only to illuminate a non-obvious behavior.
- Use concrete internal names when they matter: struct names, function names, flags, phases, locks, or files.
- Mention file names to orient the reader, but do not turn the document into a file-by-file tour unless the subsystem is tiny.
- State limits and non-goals directly.

## What this style optimizes for

- Mental model over completeness
- Invariants over surface syntax
- Mechanism over chronology
- Accurate caveats over aspirational design

Good docs in this style often answer "why is it built this way?" and "what must not be broken?" before they answer "what functions exist?"

## Recommended document structure

Use the lightest structure that fits the material. A common pattern is:

```text
Title
=====

1-3 paragraphs of subsystem overview

Section A
---------

Core mechanism

Section B
---------

Important phases / state transitions / ownership model

Section C
---------

Special cases, restrictions, or implementation consequences
```

Good section types:

- architecture
- layering
- lifecycle
- ownership
- locking
- phases
- state transitions
- special cases
- correctness rules
- performance consequences

## Do and don't

Do:

- define the subsystem in the first paragraph
- make the main abstraction explicit
- explain why one mechanism is separate from another
- call out where semantics depend on current implementation choices
- describe correctness constraints in imperative terms when needed

Don't:

- begin with a long historical digression unless it matters to current structure
- enumerate files before explaining the subsystem
- pad with generic software-engineering advice
- write "overview", "background", "summary" headings unless they add real structure
- pretend unstable or arbitrary behavior is deterministic
- hide limitations behind vague wording

## Writing workflow

1. Read the implementation enough to identify the main abstraction, boundaries, and special cases.
2. Skim 2-4 nearby `src/backend` READMEs for local style matching.
3. Draft the opening paragraphs first. If these are weak, the whole doc will drift into a code tour.
4. Add sections for the mechanisms the reader must hold in their head.
5. Add explicit caveats, invariants, and unsupported cases.
6. Remove low-signal repetition and file-by-file narration.

## Quality checklist

Before finishing, check:

- The first 2 paragraphs explain the subsystem, not just its files.
- The main abstraction is named explicitly.
- The document explains at least one important tradeoff or design choice.
- Invariants or ordering rules are written down, not implied.
- Limitations and non-goals are explicit.
- If examples exist, they clarify a tricky behavior rather than pad the text.
- The doc reads like internal design notes, not a blog post or API manual.

## Reference map

Read `references/technique-brief-style.md` when you need the concrete patterns distilled from:

- `src/backend/storage/smgr/README`
- `src/backend/storage/buffer/README`
- `src/backend/access/transam/README`
- `src/backend/optimizer/README`
- `src/backend/parser/README`
- `src/backend/utils/resowner/README`
