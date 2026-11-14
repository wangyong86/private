---
name: matrixdb-code-analysis
description: Systematically analyze, understand, and learn existing MatrixDB backend code, including its problem abstraction, call paths, state/data flow, invariants, and documented limitations. Use only for code analysis and learning or implementation-mechanism explanation. Do not use for design review, correctness or risk assessment, complexity or architecture decisions, code changes, testing, regression investigation, or benchmarking.
---

# MatrixDB Code Analysis

**强约束：本 skill 只用于系统性学习现有 MatrixDB 代码和解释既有实现机制。**
不得将其用于设计评审、正确性或风险评估、复杂度/架构决策、实现或代码修改、
review、测试方案或测试执行、回归调查、性能 benchmark；这些工作必须改用相应的
实现、调试、review、验证或规划流程。即使任务包含代码阅读，只要主要交付物是
上述任一项，也不得调用本 skill。

Produce a concise technical analysis for MatrixDB developers and maintainers. The analysis should
explain what problem the code solves, the important design choices, how the current implementation
connects its abstractions and control flow, and its established behavioral boundaries.

## Scope gate

This skill is exclusively for systematic analysis, understanding, and learning
of existing code. It explains what the code currently does and how its pieces
fit together; it does not decide whether the design is appropriate or propose
the implementation to use.

Do not use this skill for an active implementation task, feature completion,
bug fix, or change request merely because the work includes code reading. For
those tasks, inspect the relevant source directly and use the applicable
implementation, debugging, review, or verification workflow instead. This
skill may be used only when the user's primary deliverable is a read-only,
systematic explanation of an existing subsystem.

Use this skill only when the user's main question is descriptive, such as what a subsystem does,
how a mechanism is implemented, which abstractions participate, or how state moves through the
current code.

Do not invoke it merely because a request says "analyze" or concerns MatrixDB source. In
particular, do not use it for requests whose main goal is to:

- diagnose a failure, crash, regression, false assumption, or suspected defect;
- decide whether an implementation is correct, safe, complete, risky, complex, or "too optimistic";
- review a design, change, branch, commit, or pull request for findings;
- choose between architectures or implementation alternatives, or propose code changes;
- propose a validation strategy, test matrix, test cases, regression coverage, or benchmark;
- execute tests or measurements, interpret failures, or implement a fix.

Handle those requests with the applicable diagnostic, review, verification, planning, or editing
workflow. If a broader task contains a small mechanism-explanation component, use this skill only
when that component is independently requested and is the primary deliverable; otherwise inspect
the code directly as part of the broader workflow.

## Required deliverable

Adapt the depth to the feature. The result should cover, as applicable:

1. **Problem and mechanism**: the abstract problem, the current mechanism, its main entry points,
   and the established boundary or limitation.
2. **Design space**: the meaningful solution directions, the current choice, and its main tradeoffs
   and constraints.
3. **Current implementation**: key abstractions, constraints and invariants, the shortest useful
   call chain, and the core state and data flow. Include ownership, lifecycle, concurrency,
   persistence, or fallback only when they affect the conclusion.
4. **Known boundaries**: unsupported combinations, intentional fallbacks, and limitations already
   established by source, maintained documentation, or prior evidence. Do not turn this into defect
   discovery, risk assessment, or a test-coverage review.
5. **Reference comparison**: compare with an upstream, SOTA, or other reference implementation only
   when it clarifies the assessment, and state the comparison boundary.
6. **Evidence boundary**: identify the decisive source, test, history, runtime, or measurement
   evidence and distinguish current facts, historical facts, validated behavior, inference, and
   unresolved questions.

## Concision

- Lead with the mechanism summary and the causal explanation needed to support it.
- Explain the problem abstraction before listing classes, functions, or files.
- Include only code locations that establish a material claim; explain what each location proves.
- Do not turn the result into a file tour, commit timeline, or API inventory.
- Choose state, lifecycle, special paths, and limitations according to the feature rather than by
  applying a fixed checklist.
- Treat correctness as a prerequisite and mention only the checks needed to establish that premise;
  do not independently assess correctness or turn the explanation into a correctness report.
- For a small question, compress the output to the problem, conclusion, call chain, and key boundary.

## Evidence and boundaries

- Prefer current target code, direct callers/callees, and focused tests. Use history, old documents,
  comments, and benchmarks as supporting evidence with their time boundary stated.
- Do not present design intent, a function name, a configuration option, an `EXPLAIN` plan, or an
  unrun test as proof of runtime behavior.
- Separate MatrixDB fork behavior from PostgreSQL behavior when both are discussed.
- Mark uncertain claims as `待确认` or `需要验证`; do not fill evidence gaps with assumptions.
- Preserve existing worktree changes and follow repository and nearest-directory `AGENTS.md` rules.

Useful labels are: `当前实现`, `历史事实`, `已有证据`, `已知边界`, `推断`, and `待确认`.

## Work boundary

- Default to read-only analysis. Do not edit source, documentation, tests, or configuration.
- Do not build, install, restart a cluster, run regressions, or run benchmarks under this skill.
  Existing results may be read only to explain an implementation mechanism or established bound.
- Do not design validation combinations or test cases under this skill. A request to validate,
  diagnose, assess, review, benchmark, or modify behavior is outside its scope even when it also
  requires reading the same source files.
- When a request becomes a diagnosis, correctness/risk assessment, code change, refactor review,
  verification, benchmark, comment audit, or other specialized workflow, stop using this skill and
  use the corresponding workflow instead of silently expanding it.

Write like an internal maintainer note: mechanism before inventory, concrete symbols where they
matter, explicit tradeoffs and established boundaries, and no repeated conclusions.
