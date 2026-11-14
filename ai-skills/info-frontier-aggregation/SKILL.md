---
name: info-frontier-aggregation
description: Collect and synthesize high-signal data-processing frontier trends since a checkpoint, using topic, system, mechanism, adoption, and research signals; use for periodic information refreshes and trend briefs, not generic news summaries.
---

# Info Frontier Aggregation

Collect incremental, evidence-backed signals about AI-era data infrastructure. The target is a
small but broad set of signals that explains where systems, architectures, and engineering
tradeoffs are moving, rather than a large list of product announcements.

## Scope

- Start from the user's configured topics, products, people, and last-refresh checkpoint.
- Treat the checkpoint as a hard deduplication boundary. Track the collection window, publication
  time, first-seen time, canonical URL, and stable deduplication key internally, but do not expose
  those implementation fields in the user-facing log.
- Prefer primary sources: official engineering blogs, release notes with mechanism detail,
  design documents, conference talks, papers plus artifact/reproduction notes, standards,
  repositories/releases, and credible operator case studies.
- Search by topic and mechanism before searching by product name. Product pages are inputs, not
  the coverage plan.
- Do not include generic model launches, funding/news, ordinary patch releases, tutorials without
  system novelty, or benchmark claims with no workload/configuration context.

## Coverage contract

Every `week` or `month` refresh must build a coverage table before selecting items. The table is
internal working state; the final document only needs to report checked and deferred sources.

- Cover every top-level topic that has a plausible signal in the window. At minimum, rotate across
  system shape, storage/formats, execution/indexing, streaming/incremental processing,
  inference/application data planes, interoperability, and research/viewpoints.
- Check all tracked products at least once per month, or explicitly list each product that was
  deferred and why. Do not let `high_priority_daily` become a whitelist.
- Use at least three source classes in a weekly/monthly pass: primary product or project sources,
  open-source repositories/standards, and research, operator, or community sources. If a source
  class is inaccessible, record the fallback and the resulting evidence limitation.
- Search at least once using mechanism terms without a vendor name. Rotate discovery terms from
  `references/trend-angles.md` so new projects can enter the corpus.
- Keep one organization or product family to at most two main items per monthly document unless
  it is the only source with qualifying evidence for that topic. Prefer breadth across at least
  four organizations and three subtopics; if the window genuinely lacks that breadth, say so
  instead of inventing weak items.
- A product or topic skipped in one pass should be prioritized in the next pass. “No qualifying
  signal found” and “not checked” are different statuses and must not be conflated.

For `day` refreshes, check high-priority products plus one rotating low-coverage topic/product
group. Two consecutive day refreshes must not contain only one product family.

## Trend angles

For every refresh, deliberately sample multiple angles instead of searching only product names.
Read [references/trend-angles.md](references/trend-angles.md) for the angle matrix and search
prompts. At minimum cover:

1. **System shape**: new boundaries between lakehouse, OLTP, vector/search, stream, and inference
   data planes.
2. **Mechanisms**: storage layout, metadata/catalog, indexing, retrieval, execution, caching,
   incremental maintenance, and multimodal I/O.
3. **Workload pressure**: agent memory, RAG quality, real-time serving, training/feature data,
   multimodal and robotics workloads.
4. **Economics and operations**: memory/disk/object-store tradeoffs, tail latency, autoscaling,
   isolation, observability, governance, and failure recovery.
5. **Adoption and ecosystem**: open formats, interoperability, APIs/protocols, integrations,
   community artifacts, and credible production migrations.
6. **Research direction**: papers, keynotes, benchmarks with artifacts, and explicit positions by
   tracked researchers; distinguish research evidence from shipped capability.
7. **Negative space**: important tracked sources checked but not included, with the reason (old
   discussion, marketing, no technical delta, inaccessible evidence, or outside the window).

## Evidence and scoring

For each candidate, capture the concrete mechanism, the affected workload, and the source's
evidence level:

- `primary_shipped`: documented and available capability;
- `primary_prototype`: official prototype/design or preview;
- `operator_case`: production case study, useful for direction but not independent benchmarking;
- `research_artifact`: paper/talk plus code/data/benchmark artifact;
- `secondary_signal`: discovery only, never sufficient by itself for a strong conclusion.

Use a compact score (0-2 each) for `technical_delta`, `topic_fit`, `evidence_quality`, and
`independent_corroboration`. Include a candidate in the main log when it has a clear mechanism,
topic fit, and total score of at least 5; retain notable rejected candidates in the source-status
notes when they explain a trend or a gap. Never turn a vendor number into an independently
validated measurement.

## Summary standard

Each accepted item must explain more than the feature name. Write 3-5 natural-language sentences
that cover, in order where practical:

1. **Background**: what workload or old system boundary created the need;
2. **Method**: the concrete storage, metadata, index, execution, protocol, caching, incremental,
   or control-plane mechanism;
3. **Impact**: what changes for the affected workload and what cost or complexity is removed;
4. **Tradeoff and evidence**: when the mechanism is useful, what it costs or assumes, and whether
   performance numbers are vendor/operator claims or independently corroborated.

Explain a specialized term the first time it appears. Do not merely paraphrase a release title or
list API names. Keep the prose compact, but include enough background that a reader can understand
why the mechanism matters without opening the source.

## Deliverable

Update a calendar-month Markdown document at `logs/YYYY-MM.md`, using the publication month of the
signal. A refresh spanning two calendar months must update both documents; do not mix August and
September entries in one monthly file. Keep each accepted item compact and readable:

- retain the title;
- show one short natural-language **category** line that combines the signal/evidence type and
  relevant topic (for example, `类别：官方工程信号；系统 / 技术`);
- show one **address** line containing the canonical URL (for example, `地址：<https://...>`);
- add the 3-5 sentence background/method/impact/tradeoff summary described above, plus an evidence
  limitation when needed.

Do not emit metadata blocks or field names such as `signal_type:`, `topic:`, `subtopics:`,
`canonical_url:`, `published_at:`, `first_seen_at:`, `dedupe_key:`, `window_start:`, or
`window_end:` in the user-facing log. Publication dates and deduplication keys remain internal
collection data; if a date is materially important, mention it in ordinary prose rather than as a
metadata field. Each monthly document should finish with sources checked/deferred, coverage gaps,
and a short synthesis of 2-4 cross-source trends. Merge duplicate announcements and do not inflate
the count with variants of the same signal.

## Operating modes

- `since_last` / `day` / `week`: incremental collection only; write accepted signals into the
  corresponding calendar-month document and preserve earlier monthly documents.
- `month`: recheck the full target month, fill coverage gaps, and include ranking/ecosystem sources
  when their cadence applies.
- `trend brief`: do not modify logs unless requested; synthesize the current window by angle,
  evidence level, and convergence/divergence.

Before claiming completion, verify URL reachability where possible, deduplication, timestamp
consistency, and `git diff --check` for edited Markdown. Report inaccessible sources and unverified
claims explicitly.
