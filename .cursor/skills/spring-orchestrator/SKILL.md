---
name: spring-orchestrator
description: >-
  Coordinate the Spring Boot create-or-change and review-only workflows: drive
  architect → coder → parallel reviewers → documenter, with an iteration cap and
  a meta-optimizer exit. Use when the user asks to build or review a Spring Boot
  feature end to end, or invokes /spring-orchestrator. Optional input: the request or scope.
disable-model-invocation: true
---

# Spring Orchestrator

- Obey `AGENTS.md` (project root) and applicable project rules under `.cursor/rules/` (packaging sources may live under `cursor/rules/`).
- Coordinate only: never edit code directly. Delegate planning to `spring-architect`, edits to `spring-coder`, reviews to the `spring-review-*` skills, and doc sync to `spring-documenter`.
- Run each role by following its skill, launching the parallel reviewers as concurrent subagents.
- "Activated rules" = the project rules/instructions a task must obey (from the architect specification).

## Required reviewer output

Require this exact block from every reviewer:

```
Rule: <violated rule or standard>
Severity: <Critical|High|Medium|Low>
File: <workspace-relative-path>
Line: <number|n/a>
Problem: <concise issue>
Fix: <concise fix>
```

When a reviewer has no findings, require exactly: `No findings.`

## Phase policy

- Launch all five reviewers (`spring-review-security`, `-performance`, `-qa`, `-i18n`, `-database`) in one parallel fan-out, then wait for all results before merging.
- Enforce explicit user confirmation once, between the approved specification and the first coder pass.
- Treat that checkpoint as satisfying the stepwise-confirmation requirement for internal change orchestration.
- Require each delegated role to emit a phase marker within its first tool cycle (`Architect clarifying`, `Coder preflight`, `Review fan-out`, `Documenter planning`); treat >2 minutes of silence in a delegated phase as a process defect to surface to the user with current phase and next expected artifact.

## Workflow exit policy

- Always run `spring-meta-optimizer` at workflow end for both flows, including success and stop exits.
- Require `spring-meta-optimizer` to return propose-only, generic rule suggestions.

## Create-or-change flow

1. Have `spring-architect` clarify the request and produce a **Complete Feature Specification**.
2. Require these sections: Application type, Feature summary, Activated rules, Endpoints, Entity and schema, Security, Data strategy, Configuration, Deferred decisions, Constraints and assumptions.
3. Reject the specification if any required section is absent; route back to the architect.
4. Apply the Phase Policy gate after specification delivery.
5. Initialize iteration counter `N = 1` before the first coder pass.
6. Print `Iteration <N> out of 5` before each coder pass.
7. Send `spring-coder` the Complete Feature Specification plus any unresolved findings from previous passes.
8. Require from `spring-coder`:
   - Preflight checklist confirming all spec sections are present and all activated rules were read.
   - Post-implementation compliance report with one pass/fail line per activated rule.
   - Per-modified-area validation evidence with check command and pass/fail.
9. Reject completion when:
   - Any required spec section was neither implemented nor deferred.
   - Per-modified-area validation evidence is missing.
   - Unresolved blockers lack owner and next checkpoint.
   - Any constraint marked INFERRED in the spec was not satisfied and not flagged.
10. Block completion while any unresolved Critical or High finding remains.
11. After each review phase, merge duplicate findings, sort by severity, and summarize.
12. Re-run targeted reviewers tied to unresolved findings and for changed files.
13. Route unresolved findings to the narrowest next phase: coder pass for fixes, targeted review for verification, architect re-specification only when findings invalidate a spec decision.
14. Increment `N` by 1 before re-entering the coder phase when another coder pass is required.
15. If `N > 5`, stop and report unresolved blockers with owner and next checkpoint.
16. After review PASS, run `spring-documenter`; require a read-only doc sync plan before documentation edits.
17. Define one no-progress cycle as a coder pass plus review phase with unchanged unresolved-finding count and unchanged highest severity.
18. After one no-progress cycle, stop and report unresolved blockers with owner and next checkpoint.
19. Apply the Workflow Exit Policy.

## Review-only flow

1. Launch all five reviewers in one parallel fan-out, then wait for all results before merging.
2. Merge duplicates.
3. Remove findings invalidated by resolved assumptions.
4. Downgrade or rewrite findings dependent on unresolved assumptions.
5. Sort findings by Critical, High, Medium, Low.
6. Apply the Workflow Exit Policy.

Keep outputs concise.
