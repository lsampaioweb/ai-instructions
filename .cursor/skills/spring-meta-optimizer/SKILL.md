---
name: spring-meta-optimizer
description: >-
  Post-pass optimization of AI customization overlays: analyze iteration
  friction and propose generic, framework-level rule updates only. Use after
  multi-iteration coding loops, when the user asks to meta-optimize
  instructions/rules/skills, or when an orchestrator invokes spring-meta-optimizer.
disable-model-invocation: true
---

# Spring Meta-Optimizer

Read-only meta-optimizer for AI customization overlays. Propose patches only; never apply them.

- Obey `AGENTS.md` (project root) and applicable project rules under `.cursor/rules/` (packaging sources may live under `cursor/rules/`).
- Obey `.cursor/rules/ai-customization.mdc` when present (packaging sources may live under `cursor/rules/ai-customization.mdc`).
- Prefer architecture guidance from `.cursor/rules/spring-boot-architecture.mdc` when present (packaging sources may live under `cursor/rules/`).

## Scope

- Analyze recent execution history and review findings for repeat failure patterns.
- Propose changes only for AI customization overlays under `.cursor/` (or packaging sources under `cursor/`).
- Optional: analyze Copilot-source trees `vscode/instructions/`, `vscode/agents/`, `vscode/prompts/` as evidence; prefer proposing Cursor targets under `.cursor/rules/` or `.cursor/skills/` (packaging sources may live under `cursor/rules/` or `cursor/skills/`).
- When the user names another overlay path in this repo, include it in scope.
- Never edit application runtime code, tests, or infrastructure files.

## Generic rule boundary

- Enforce generic, framework-level guidance only.
- Prohibit project-specific business rules in shared overlay files.
- Preserve technical literals unless they are incorrect.

## Analysis protocol

1. Ingest iteration evidence from chat/task logs, diagnostics, and reviewer findings.
2. Isolate recurring friction points that caused rework or repeated findings.
3. Trace each friction point to a missing, ambiguous, duplicated, or contradictory rule.
4. Select the minimal target file that can prevent recurrence.

## Change protocol

- Add one enforceable rule per bullet using imperative language.
- Split compound requirements into separate bullets.
- Resolve contradictions by defining precedence explicitly.
- Keep existing file structure and section intent intact.

## Output format

For each proposed optimization:

- **Target File:** path
- **Iteration Friction Identified:** what repeated and why
- **Rule Action:** `add` | `rewrite` | `remove` | `reference`
- **Proposed Rule Text:** exact bullet text
- **Proposed Patch Sketch:** minimal markdown diff-style snippet
- **Generic Boundary Check:** `pass` | `fail` with reason

If no optimization is justified: `No optimization needed.`
