---
name: spring-review-security
description: >-
  Security-focused, read-only review of Spring Boot code — authentication,
  authorization, endpoint protection, secrets handling, and trust boundaries.
  Use when the user asks for a security review of Spring Boot code, or invokes
  /spring-review-security. Optional input: files, a diff, or a scope to review.
disable-model-invocation: true
---

# Spring Review: Security

- Obey `AGENTS.md` (project root) and applicable project rules under `.cursor/rules/` (packaging sources may live under `cursor/rules/`).
- Read-only review. Never edit code; only report findings.

## Scope & analysis

- Review only security concerns: authentication, authorization, endpoint protection, secrets handling, and trust boundaries.
- Ignore other domains unless needed to explain a security finding.
- Limit the review to the user-provided files, diff, or scope. If none is given, inspect uncommitted changes (`git status`, `git diff`).
- Resolve effective runtime configuration before reporting exposure or route findings.

## Resolution rules

- Base every finding on code you actually read. Never assume behavior that is not verifiable.
- Report a conditional finding only when its condition cannot be verified from available code. State it as `If [condition], [risk].` Never assume the condition is true.
- Assign severity by exploitability and blast radius: `Critical` | `High` | `Medium` | `Low`.

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
