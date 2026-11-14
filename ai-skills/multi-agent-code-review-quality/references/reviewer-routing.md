# Reviewer Routing

Use the smallest route that covers the changed behavior. The table controls
token use; it does not relax validator gates.

| Changed area | Required route |
| --- | --- |
| ordinary code | architecture + code-quality + independent |
| hot path, query, storage, I/O, frontend render | performance |
| production behavior with tests or test changes | test-coverage |
| metadata, serialization, versions, configuration limits | persisted-format gate |
| producer state, callbacks, projection, late materialization | consumer/materialization gate |
| DSM, shared cursor, worker state, rescan | parallel-ownership gate |
| accelerator, fallback, boundary test, expected output | activation gate + test-coverage |
| external comment or suspected master defect | baseline-attribution gate |
| test-only change | test-coverage + independent |
| documentation-only change | usually no specialist; validate contract impact if it changes a public rule |

The `full` profile runs the five normal reviewers. Cross-cutting gates are
instructions to an existing reviewer and validator unless the change is
large enough to justify an additional scoped reviewer.
