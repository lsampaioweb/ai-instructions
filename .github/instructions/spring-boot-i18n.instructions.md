---
description: "Spring internationalization message bundles, locale resolution, namespace governance, and localized log and user-facing messages."
applyTo: "**/messages*.properties, **/LogMessages.java, **/*LocaleResolver.java, **/*LocaleResolverConfig.java, **/application*.yml, **/*Messages.java, **/i18n/**/*.java"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for Java formatting, imports, visibility, constants, and JavaDoc.
- Follow `spring-boot-config.instructions.md` for `spring.messages.basename` placement.

## Naming Conventions
- Name the default bundle `messages.properties` and locale variants `messages_pt_BR.properties`, etc.
- Use lowercase dot-delimited keys that identify the message purpose, such as `log.user.fetching.all`, `error.user.not.found`, and `page.index.title`.
- Use the `log.*` namespace for developer-facing log messages.
- Use the `error.*` namespace for domain errors and the `error.validation.*` namespace for Bean Validation constraint messages.
- Use the `api.*` namespace for API response messages and the `openapi.*` namespace for API documentation strings.
- Use domain-prefixed keys for UI and API messages when the context needs qualification.
- Name message-source component classes with the `*Messages` or `*LogMessages` suffix; use domain-specific component names (never `Messages`, `AppMessages`, or `LogMessages` without a domain prefix).

## Rules

### Message bundles
- Set `spring.messages.basename=i18n/messages` and `spring.messages.encoding=UTF-8` in `application.yml`.
- Place standard bundles at `src/main/resources/i18n/messages.properties` and `src/main/resources/i18n/messages_pt_BR.properties`.
- Use UTF-8-safe content in all message bundle files.
- Keep the same keys in every locale bundle; add every new key to all locale files simultaneously.
- Keep the same indexed placeholder arity and meaning for each key across locale bundles.
- Use `{0}`, `{1}`, and subsequent indexed placeholders for dynamic message values.
- Keep message values in the language represented by their bundle; keep `messages_pt_BR.properties` entries written in natural Portuguese with correct orthography and diacritics.
- Group related keys together with `# Section Name` comments when they improve scanning of a larger bundle.
- Add a localized value for every newly introduced key before using it in application code.
- Remove keys that are no longer used by application code.
- Add `log.*` keys only when the same change wires those keys through a `*LogMessages` component used by application code.
- Add `error.validation.*` and `error.*` keys only when the same change includes the controller or service component that produces those validation errors or domain failures.
- For `openapi.*` key requirements, defer to `spring-boot-openapi.instructions.md`.

### Message resolution
- Resolve a user-facing HTTP message with `MessageSource` and `LocaleContextHolder.getLocale()`.
- Resolve developer-facing log messages in English.
- Use a `LogMessages` component for reusable developer-facing log messages.
- Declare each `*LogMessages` component as a `public class` annotated with `@Component`, backed by `MessageSource` with `Locale.ENGLISH` for log events.
- Place a module-root `*LogMessages` component (e.g., `AppLogMessages`) in `<root-package>.i18n` when the component is consumed by cross-cutting shared classes such as `@RestControllerAdvice`.
- Use feature-scoped `*LogMessages` components (e.g., `HolidayLogMessages` in `holiday.i18n`) only when the component is consumed exclusively within that feature.
- Implement `LogMessages#get(String key, Object... args)` with `Locale.ENGLISH` as its default locale, delegating to `get(Locale.ENGLISH, key, args)`.
- Expose a `get(Locale locale, String key, Object... args)` overload for caller-specified locale resolution.
- Delegate message lookup to `MessageSource#getMessage(...)`; do not embed translated text in Java code.
- Define reused message keys as named string constants in the owning class.

### Locale resolution
- Use `AcceptHeaderLocaleResolver` for HTTP locale selection when localized HTTP or rendered messages are exposed.
- Configure English as the default locale and English plus `pt-BR` as supported locales (`en` and `pt-BR` as baseline defaults unless the project explicitly defines a different set).
- Fall back to English when the request does not provide an `Accept-Language` value.
- Add session- or query-parameter-based locale selection only when the feature explicitly requires persisted user preference or direct language selection.

### Verification
- Add or update tests that locale bundles contain the same keys.
- Add or update tests that matching messages use the same placeholder arity in every locale bundle.
- Add or update tests that application keys referenced in code exist in the message bundles.
- Add or update tests that message-bundle keys unused by application code are removed.
- Keep the reference set of keys used in code current when a feature adds or removes an `i18n` key.

## Safety Guards
- Never set `spring.messages.use-code-as-default-message=true`.
- Never remove keys that are still referenced.
- Never concatenate string fragments to construct a user-facing message.

## Reference
- Use [samples/spring-boot-log-messages.tpl](samples/spring-boot-log-messages.tpl) for the `LogMessages` component.
- Use [samples/spring-boot-messages.properties.tpl](samples/spring-boot-messages.properties.tpl) for the default message bundle.
- Use [samples/spring-boot-messages_pt_BR.properties.tpl](samples/spring-boot-messages_pt_BR.properties.tpl) for the Brazilian Portuguese message bundle.
- Use [samples/spring-boot-application.tpl](samples/spring-boot-application.tpl) for the related `spring.messages` configuration.
- Use [samples/spring-boot-i18n-consistency-test.tpl](samples/spring-boot-i18n-consistency-test.tpl) for locale bundle key-parity and placeholder-arity tests.
