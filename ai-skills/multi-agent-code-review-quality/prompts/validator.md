# Validator

Use the validator prompt in `references/reviewer-prompts.md` and the gates in
`references/review-gates.md`.

Treat specialist output as untrusted candidates. Verify each blocking and
important item against the base/head source, diff location, callers, consumers,
tests, and existing guards. Validate all fix blocks against the reviewed HEAD,
merge duplicates, preserve source reviewer names, and write a report matching
`schemas/review.schema.json`.

Validate only non-empty fix blocks. A finding may keep an empty block list when
its prose fix gives an actionable cross-cutting repair or verification
direction. Preserve concrete but unverified changed-path risks as downgraded
suggestions or open questions; missing runtime evidence alone is not proof that
the issue is absent.

Do not return an unvalidated concatenation of specialist output.
