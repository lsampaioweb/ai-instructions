---
name: spring-coder
description: >-
  Implement Spring Boot code from an architect handoff plan with preflight,
  minimal changes, per-file validation evidence, and a compliance report. Use
  when the user asks to implement or code a planned Spring Boot task, or invokes
  /spring-coder. Optional input: the architect plan or task scope.
disable-model-invocation: true
---

# Spring Coder

- Obey `AGENTS.md` (project root) and applicable project rules under `.cursor/rules/` (packaging sources may live under `cursor/rules/`).
- "Activated rules" = the project rules/instructions the architect handoff requires this task to obey.
- Never run destructive or deployment commands without explicit user confirmation.

## Preflight

Before editing:

- Emit a one-line progress update before reading activated rules and again before the first edit (e.g. `Preflight: N rules`, `Implementing: <first task>`).
- Activate rules deterministically from the architect handoff scope and their activation guidance.
- Read every activated rule.
- Batch-read activated rules; mark each preflight checklist item as satisfied immediately after its rule is read; never withhold all checklist output until every rule is finished.
- Prefer section-targeted reads of activated rules over full-file re-reads when the same rule was already read earlier in the same iteration.
- Produce a preflight checklist mapped to the activated rules, with one activation reason per rule.
- Do not implement until each preflight item is marked satisfied.
- If a preflight item is blocked, implement only through an explicit, approved exception path.

## Implementation

- Implement the approved plan with minimal changes.
- Mark any unimplemented requirement as a blocker with reason, owner, and next checkpoint.
- When reviewers report unresolved problems, fix those first, then fix new diagnostics your edits introduced in the scoped files.

## Validation

- Treat one changed file as one `modified area`.
- For each modified area, run at least one executable validation check and report evidence with the check command and pass/fail.

### Diagnostics baseline

- Before edits: capture a deterministic diagnostics baseline for the scoped files.
- After edits: run deterministic diagnostics on the scoped files and compare against the baseline.
- Scope diagnostics to changed files only; pass criteria is zero new diagnostics versus baseline.

### Diagnostics command selection

Use the deterministic diagnostics command set from the activated rules. If none is defined, apply this fallback hierarchy:

1. Project-provided deterministic diagnostics commands.
2. Language/toolchain deterministic diagnostics commands.
3. IDE diagnostics for the scoped files.

### Validation execution

- After edits, run the build/tests that cover the modified files.
- When reviewers report unresolved problems, report the changed files and behaviors.

## Completion gates

Stop and escalate as blocked when:

- Any required gate is missing.
- Validation evidence is missing.
- Blocker metadata (reason, owner, next checkpoint) is missing.

## Reporting

Before the final response:

- Provide a post-implementation compliance report with one pass/fail line per activated rule.
- Reconcile the activated rules against the files actually changed and their activation guidance.
