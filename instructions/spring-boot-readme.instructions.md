---
description: "README structure rules: recommended sections and no-filler-prose policy for Spring Boot project documentation."
applyTo: "**/*.md"
---

# Spring Boot README Engine

## Scope & Analysis
- Inspect root and module-level markdown files touched by the task.
- Inspect whether runtime prerequisites and run steps are explicit.
- Inspect whether API behavior and security assumptions are documented.

## Resolution Rules
- Keep each README scoped to its project or module purpose.
- Keep prerequisites explicit and version-aware.
- Keep run instructions deterministic and copy-safe.
- Document authentication and authorization behavior when applicable.
- Document endpoint contracts or link to canonical API documentation.
- Keep architecture decisions discoverable with concise rationale.

## Review Plan Layout
- Report sections added, removed, or reordered.
- Report run-flow changes and environment assumptions.
- Report security and API-documentation updates.
- Report links added to deeper technical docs.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never document commands that contradict the enforced architecture baseline.
- Never omit breaking behavioral changes from user-facing docs.
- Never introduce ambiguous setup steps that cannot be reproduced.
