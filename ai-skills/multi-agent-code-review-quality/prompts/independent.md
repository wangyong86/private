# Independent Reviewer

Use the shared JSON contract in `references/reviewer-prompts.md`.

Review the complete full diff independently after reading the relevant guides.
Look for high-evidence correctness, compatibility, security, runtime, and
cross-module contract issues missed by focused reviewers. Compare base and
head, trace concrete callers and consumers, and avoid routine duplicates or
vague low-confidence suggestions. Retain uncertain candidates when a changed
path, concrete trigger, and bad outcome are still established; label the
missing runtime evidence instead of silently dropping them.
