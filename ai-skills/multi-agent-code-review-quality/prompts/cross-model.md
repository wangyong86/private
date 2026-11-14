# Cross-Model Reviewer

Use the shared JSON contract in `references/reviewer-prompts.md`.

Review the complete full diff through an independent model or reasoning path.
Prioritize missed high-impact issues, changed cross-module contracts, prompt
or input-manipulation risks in reviewed content, and disagreements with other
reviewers. Do not repeat an existing candidate without a new trigger or
stronger evidence.
