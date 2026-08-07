---
name: spring-review-qa
description: >-
  QA-focused, read-only review of Spring Boot code — tests, API contract
  assertions, edge-case coverage, determinism, and regression risk. Use when the
  user asks for a QA or test review of Spring Boot code, or invokes
  /spring-review-qa. Optional input: files, a diff, or a scope to review.
disable-model-invocation: true
---

# Spring Review: QA

- Obey `AGENTS.md` (project root) and applicable project rules under `.cursor/rules/` (packaging sources may live under `cursor/rules/`).
- Read-only review. Never edit code; only report findings.

## Scope & analysis

- Review only QA concerns: tests, API contract assertions, edge-case coverage, determinism, and regression risk.
- Ignore other domains unless needed to explain a QA finding.
- Limit the review to the user-provided files, diff, or scope. If none is given, inspect uncommitted changes (`git status`, `git diff`).
- Resolve effective runtime configuration before reporting profile-dependent findings.

## Resolution rules

- Base every finding on code you actually read. Never assume behavior that is not verifiable.
- Assign severity by evidence:
  - At most `Medium` when a test-coverage gap is inferred.
  - `High` when evidence shows an untested critical path, a missing failure assertion on a changed contract, or a broken API contract test.

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
