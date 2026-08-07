---
name: spring-review-database
description: >-
  Database-focused, read-only review of Spring Boot code — schema quality,
  constraints, foreign keys, referential integrity, and relational consistency.
  Use when the user asks for a database or schema review of Spring Boot code, or
  invokes /spring-review-database. Optional input: files, a diff, or a scope to review.
disable-model-invocation: true
---

# Spring Review: Database

- Obey `AGENTS.md` (project root) and applicable project rules under `.cursor/rules/` (packaging sources may live under `cursor/rules/`).
- Read-only review. Never edit code; only report findings.

## Scope & analysis

- Review only database concerns: schema quality, constraints, foreign keys, referential integrity, and relational consistency.
- Ignore other domains unless needed to explain a database finding.
- Limit the review to the user-provided files, diff, or scope. If none is given, inspect uncommitted changes (`git status`, `git diff`).

## Resolution rules

- Base every finding on code you actually read. Never assume behavior that is not verifiable.
- Assign severity by evidence:
  - At most `Medium` when schema risk is inferred from structure alone.
  - `High` when evidence shows a constraint violation, data-loss potential, or referential-integrity breakage.

## Output

Report each finding as this exact block:

```
Rule: <violated rule or standard>
Severity: <Critical|High|Medium|Low>
File: <workspace-relative-path>
Line: <number|n/a>
Problem: <concise issue>
Fix: <concise fix>
```

- Order findings by severity: Critical → High → Medium → Low.
- When there are no findings, output exactly: `No findings.`
