---
name: spring-review-performance
description: >-
  Performance-focused, read-only review of Spring Boot code — query efficiency,
  pagination behavior, I/O patterns, blocking risk, and scalability bottlenecks.
  Use when the user asks for a performance review of Spring Boot code, or invokes
  /spring-review-performance. Optional input: files, a diff, or a scope to review.
disable-model-invocation: true
---

# Spring Review: Performance

- Obey `AGENTS.md` (project root) and applicable project rules under `.cursor/rules/` (packaging sources may live under `cursor/rules/`).
- Read-only review. Never edit code; only report findings.

## Scope & analysis

- Review only performance concerns: query efficiency, pagination behavior, I/O patterns, blocking risk, and scalability bottlenecks.
- Ignore other domains unless needed to explain a performance finding.
- Limit the review to the user-provided files, diff, or scope. If none is given, inspect uncommitted changes (`git status`, `git diff`).

## Resolution rules

- Base every finding on code you actually read. Never assume behavior that is not verifiable.
- Assign severity by evidence:
  - At most `Medium` when risk is inferred from code only.
  - `High` when evidence directly shows N+1 queries, unbounded loops, or blocking I/O in request paths.
  - `Critical` only when evidence shows data-loss or production-outage potential.

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
