---
description: "Spring Boot i18n contract for message-key governance, locale behavior, and translation-safe output."
applyTo: "**/*Service.java, **/*Controller.java, **/application*.yml, **/messages*.properties"
---

# Spring Boot I18N Engine

## Scope & Analysis
- Inspect message bundles, locale coverage, and key consistency.
- Detect missing keys, orphan keys, and inconsistent placeholders.
- Detect hardcoded user-facing strings in code touched by the task.

## Naming Conventions
- Name message-source component classes (when used) with the `*Messages` or `*LogMessages` suffix (e.g., `ApplicationMessages`, `UserLogMessages`).
- For log-event resolution components, use the `*LogMessages` suffix explicitly (e.g., `PaymentLogMessages`, `OrderLogMessages`).
- Use domain-specific message component names (never `Messages`, `AppMessages`, or generic names without context).

## Resolution Rules
- Use message keys for user-facing text.
- Place message bundles under `src/main/resources/i18n/messages*.properties` with locale-specific variants named `messages_en.properties`, `messages_pt_BR.properties`, etc.; set `spring.messages.basename=i18n/messages` in `application.yml`.
- Set `spring.messages.encoding=UTF-8` in `application.yml`; always save `.properties` files in UTF-8 encoding.
- Keep `spring.messages.use-code-as-default-message=false` (the default) in all profiles; never set it to `true` in production as it silently hides missing translation keys.
- Keep key naming stable and domain-oriented.
- Use message-key namespaces that reflect the message category: `validation.*` for request validation errors, `error.*` for domain/application errors, `openapi.*` for API documentation strings, `log.*` for log-event messages resolved through `LogMessages`.
- Keep placeholders indexed and consistent across locales.
- Keep error messages aligned with error-code policy.
- Use `Accept-Language` as the default locale negotiation strategy for API and web flows.
- Use `en` and `pt-BR` as baseline defaults unless the project or user explicitly defines a different supported locale set.
- Add fallback behavior for unsupported locales.
- Use UTF-8-safe content and avoid encoding regressions.
- Use a dedicated `LogMessages` component backed by `MessageSource` with `Locale.ENGLISH` for log events; never resolve log messages using the request locale.
- Add `log.*` keys only when the same change set wires those keys through a `LogMessages` component used by application code.
- For logger declaration patterns and log-level semantics, defer to `spring-boot-logging.instructions.md`.

## Safety Guards
- Never remove keys that are still referenced.
- Never change placeholder order without updating all locale variants.
- Never hardcode user-facing text where message keys are required.
- Never resolve log-level messages using the request locale; always use `Locale.ENGLISH` for application log output.
- Never write inline hardcoded log strings in classes where `LogMessages` is available; always resolve log output via the `LogMessages` component.

## Review Plan Layout
- Report added keys and owning feature.
- Report changed keys and compatibility impact.
- Report locale coverage gaps and planned follow-up.
- Report fallback behavior used for missing translations.

