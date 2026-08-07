---
name: spring-review-i18n
description: >-
  i18n/l10n-focused, read-only review of Spring Boot code — message-key
  governance, locale behavior, translation safety, and fallback consistency. Use
  when the user asks for an i18n/localization review of Spring Boot code, or
  invokes /spring-review-i18n. Optional input: files, a diff, or a scope to review.
disable-model-invocation: true
---

# Spring Review: i18n

- Obey `AGENTS.md` (project root) and applicable project rules under `.cursor/rules/` (packaging sources may live under `cursor/rules/`).
- Read-only review. Never edit code; only report findings.

## Scope & analysis

- Review only i18n/l10n concerns: message-key governance, locale behavior, translation safety, and fallback consistency.
- Ignore other domains unless needed to explain an i18n finding.
- Limit the review to the user-provided files, diff, or scope. If none is given, inspect uncommitted changes (`git status`, `git diff`).
- Before reporting locale-based findings, verify the active locale source: request header (`Accept-Language`), session attributes, and `LocaleResolver` beans. Check `spring.mvc.locale` and `spring.mvc.locale-resolver` to confirm runtime behavior.

## Resolution rules

- Base every finding on code you actually read. Never assume behavior that is not verifiable.
- Report hard-coded strings, missing message keys, and locale-sensitive logic.
- Assign severity by evidence:
  - At most `Medium` when an i18n gap is inferred.
  - `High` when evidence shows missing keys for an active locale, a broken placeholder contract, or log output using the request locale.

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
