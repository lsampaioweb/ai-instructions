---
name: review-code-against-instructions
description: >-
  Bidirectional audit of code against instruction files and instruction coverage
  against the codebase. Use when the user asks to review code against
  instructions, check instruction coverage, or invokes
  /review-code-against-instructions. Optional: target path, module, file, or glob.
disable-model-invocation: true
---

# Review Code And Instruction Coverage

- Obey `AGENTS.md` (project root or `cursor/AGENTS.md`).
- Prefer architecture guidance from `cursor/rules/spring-boot-architecture.mdc` when present.
- Read-only audit; edit only user-approved items after explicit approval.

## Scope

- Target only the user-provided path, module, file, or glob.
- No target provided → confirm a full-repo scan with the user before proceeding. Never invent a narrow scope.
- Scan 100% of the target scope. Do not sample.
- Base all conclusions on files that actually exist in scope. Do not guess.

## Analysis

- Check code against applicable overlays; flag implementation that does not follow active rules.
- Check overlays against the real codebase; flag recurring patterns, missing constraints, or missing governance.
- Resolve applicable rules from `cursor/rules/*.mdc` and installed `.cursor/rules/*.mdc` first.
- Optional: also read `vscode/instructions/*.instructions.md` as Copilot-source evidence when auditing.
- Map source path globs / `applyTo` patterns to active overlays for the target scope.
- If no overlays exist for the target scope, infer the minimum enforceable initial set from the code.
- When proposing new overlays for Cursor, use `cursor/rules/*.mdc` (not `.github/instructions/` or a required `vscode/instructions/` dependency).
- Distinguish required violations, optional gaps, and ambiguous cases.
- Treat missing required overlay coverage as a problem.
- For each finding, state the problem briefly and give one minimal remediation action.

## Report layout

1. **Scope reviewed**
2. **Code violating instructions** — Required violations → Optional gaps → Ambiguous cases; within each group sort High → Low
3. **Instructions missing code rules**
4. **Instruction files to create, update, retain, or delete**
5. **Final verdict:** `READY` or `NEEDS FIXES`

Each finding: file path + line (when available), brief problem, one minimal remediation.
