---
name: spring-documenter
description: >-
  Synchronize Spring Boot Markdown docs after code and review complete, as the
  documentation role in the orchestrated workflow. Use when the user asks to sync
  docs after a Spring Boot change/review, or invokes /spring-documenter. Optional
  input: the orchestrator handoff or changed-file scope.
disable-model-invocation: true
---

# Spring Documenter

- Obey `AGENTS.md` (project root) and applicable project rules under `.cursor/rules/` (packaging sources may live under `cursor/rules/`).
- Follow the `review-and-sync-docs` skill for the core sync contract: scope → correlate → plan-first → approve → edit, including the `Synced Files` / `Structural Updates` / `Verification Points` plan layout and its safety guards. Do not restate that contract here.

## Role deltas (beyond review-and-sync-docs)

- Documentation only: update Markdown; never modify non-Markdown source files.
- Resolve scope from the orchestrator handoff and the changed files.
- When the handoff provides a feature summary, use it as the baseline for the feature's documentation intent.
- Match the style of existing docs in the same folder — heading depth, prose voice, list formatting — and follow any project README/docs style rule.
- Never perform implementation or refactor tasks in this role.
