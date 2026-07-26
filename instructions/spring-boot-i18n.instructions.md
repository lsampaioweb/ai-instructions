---
description: "Spring Boot i18n contract for message-key governance, locale behavior, and translation-safe output."
applyTo: "**/*.java, **/application*.yml, **/messages*.properties"
---

# Spring Boot I18N Engine

## Scope & Analysis
- Inspect message bundles, locale coverage, and key consistency.
- Detect missing keys, orphan keys, and inconsistent placeholders.
- Detect hardcoded user-facing strings in code touched by the task.

## Resolution Rules
- Use message keys for user-facing text.
- Keep key naming stable and domain-oriented.
- Use message-key namespaces that reflect the message category: `validation.*` for request validation errors, `error.*` for domain/application errors, `openapi.*` for API documentation strings.
- Keep placeholders indexed and consistent across locales.
- Use `Accept-Language` as the default locale negotiation strategy for API and web flows.
- Use `en` and `pt-BR` as baseline defaults unless the project or user explicitly defines a different supported locale set.
- Add fallback behavior for unsupported locales.
- Use UTF-8-safe content and avoid encoding regressions.
- Keep error messages aligned with error-code policy.
- Use a dedicated `LogMessages` component backed by `MessageSource` with `Locale.ENGLISH` for log events; never resolve log messages using the request locale.
- Add `log.*` keys only when the same change set wires those keys through a `LogMessages` component used by application code.

## Review Plan Layout
- Report added keys and owning feature.
- Report changed keys and compatibility impact.
- Report locale coverage gaps and planned follow-up.
- Report fallback behavior used for missing translations.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never remove keys that are still referenced.
- Never change placeholder order without updating all locale variants.
- Never hardcode user-facing text where message keys are required.
- Never resolve log-level messages using the request locale; always use `Locale.ENGLISH` for application log output.
- Never write inline hardcoded log strings in classes where `LogMessages` is available; always resolve log output via the `LogMessages` component.
