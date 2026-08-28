# Backend README Style Notes

This reference distills the style used by several `src/backend` README files, with `storage/smgr/README` as the anchor sample.

## Shared traits

### 1. Start with the subsystem, not the edit

These READMEs open by defining the subsystem and its role in the backend. They do not start with "this document explains" or "the following files".

Typical opening moves:

- define the subsystem in one sentence
- give just enough history if it explains current structure
- explain why the layering still exists

From `smgr/README`, the opening does three things quickly:

- says what storage managers are
- notes why the name is historically odd
- explains why the switch layer still exists

That is a strong pattern: explain the current abstraction and why it remains, even if it looks old-fashioned.

### 2. Prefer mechanism over inventory

Good backend READMEs are not directory listings. When they list files, it is brief and only after the reader already has context.

Examples:

- `parser/README` is mostly a compact inventory because that subsystem is largely pipeline-shaped and directory-oriented
- `optimizer/README`, `buffer/README`, and `transam/README` mostly explain mechanisms, state, and algorithms

Use file lists only when they genuinely orient the reader.

### 3. Explain invariants and rules explicitly

These documents often exist to preserve correctness constraints that are easy to violate.

Common forms:

- access rules
- lock ordering
- release phases
- transaction state transitions
- parent/child ownership rules
- conditions under which a shortcut is valid

If the subsystem has invariants, write them as rules. Do not make the reader infer them from prose alone.

### 4. Separate layers cleanly

A recurring style choice is to describe the subsystem in layers:

- conceptual layer
- control layer
- low-level execution layer

`transam/README` is especially clear about this. It describes top-level traffic-cop functions separately from low-level transaction functions, then explains how they interact.

When the code has multiple layers, mirror that separation in the doc.

### 5. Use examples to resolve subtlety, not to teach basics

Examples appear when they clarify a sequence or prove why a distinction matters.

Strong uses:

- call sequences
- multi-step state changes
- release ordering
- join construction examples

Weak uses:

- toy examples that restate obvious prose
- "hello world" style demonstrations

### 6. Name the current limitations honestly

These READMEs do not hide awkwardness. They say things like:

- this is not well-supported
- this path is only enough for one waiter
- this operation must not fail
- this rule is subtle but important

That directness is part of the style. Internal docs should reduce false confidence.

## What `smgr/README` does especially well

`smgr/README` is short, but it demonstrates several useful writing choices:

- It opens from system concept, not implementation detail.
- It uses a small historical note only to explain current naming and layering.
- It briefly inventories the two key source files after the abstraction is clear.
- It adds one focused section for relation forks, because that is the key semantic extension readers need to know.

This is a good model for a small subsystem document:

1. Define subsystem and why it exists.
2. Briefly point to the key files.
3. Explain the one or two non-obvious semantics that matter to the rest of the backend.

## Practical template

For a new backend README, a strong starting template is:

```text
<Subsystem Name>
================

Define the subsystem and its role in the backend. If the structure is
historical, explain only the part of the history that justifies today's
shape.

If useful, briefly identify the key files and what responsibilities they
own.

<Key Mechanism or Abstraction>
------------------------------

Explain the main abstraction and how callers are expected to think about it.

<Rules / Phases / Ownership / State>
------------------------------------

Document the invariants or ordering constraints that preserve correctness.

<Special Cases / Caveats>
-------------------------

Call out the cases where semantics differ from the naive model.
```

## Anti-patterns

Avoid these if you want the `src/backend` README style:

- Long motivational introductions
- File-by-file tours before the architecture is clear
- User-facing tutorial tone
- Bullets where prose would better explain a mechanism
- API reference masquerading as design notes
- Generic conclusions that add no design information
