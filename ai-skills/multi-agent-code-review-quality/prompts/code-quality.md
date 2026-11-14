# Code Quality Reviewer

Use the shared JSON contract in `references/reviewer-prompts.md`.

Review language/framework correctness and maintainability risks that can affect
correctness. Select the matching guide from `references/guides/` and inspect
ownership, typing, async/error behavior, resource lifetime, framework
contracts, misleading comments, public names, docs, and test descriptions.

A maintainability finding needs a concrete risk to future correctness or
contract interpretation. Skip formatting, import order, line length, generic
requests for comments, and speculative refactors.
