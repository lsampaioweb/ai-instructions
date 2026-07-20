---
description: "Spring Boot i18n contract for message-key governance, locale behavior, and translation-safe output."
applyTo: "**/messages*.properties,**/*Controller.java,**/*Service.java,**/*ServiceImpl.java,**/*Exception*.java"
---

# Spring Boot I18N Engine

## Scope & Analysis
- Inspect message bundles, locale coverage, and key consistency.
- Detect missing keys, orphan keys, and inconsistent placeholders.
- Detect hardcoded user-facing strings in code touched by the task.

## Resolution Rules
- Use message keys for user-facing text.
- Keep key naming stable and domain-oriented.
- Keep placeholders indexed and consistent across locales.
- Use `Accept-Language` as the default locale negotiation strategy for API and web flows.
- Use `en` and `pt-BR` as the default supported locale set unless the user explicitly requests additional locales.
- Add fallback behavior for unsupported locales.
- Use UTF-8-safe content and avoid encoding regressions.
- Keep error messages aligned with error-code policy.

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
