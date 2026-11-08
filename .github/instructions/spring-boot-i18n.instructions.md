---
description: "Spring Boot i18n contract for message bundles, locale resolution, MessageSource usage, and key-parity tests."
applyTo: "**/src/main/resources/application*.yml, **/src/main/resources/application*.yaml, **/src/main/resources/i18n/**, **/src/**/*.java"
---

# Spring Boot i18n Contract

These rules apply to application modules that expose user-facing or log-facing
message text. Projects must meet the full contract once i18n is in use.

## Message bundles

- Store bundles under `src/main/resources/i18n/`.
- A deployable application ships at least:
  - `messages.properties` as the English default bundle
  - `messages_pt_BR.properties` for Brazilian Portuguese
- A reusable library exposes stable message keys but does not package its own
  locale bundles. The consuming application owns translations for those keys in
  its standard `messages.properties` and `messages_pt_BR.properties` bundles.
- Every key present in one locale file must exist in every other locale file.
- Placeholder arity must match across locales for the same key (for example `{0}`
  and `{1}` counts must be identical).
- Never hardcode user-facing API, UI, validation, or error text in Java. Resolve it
  through `MessageSource` (or a thin helper that wraps it) and a message key.
- Developer-facing log text uses the dedicated logging message helper defined by the
  logging contract. Resolve request-scoped log messages with the request locale and
  messages without a request locale with the configured default locale.

## Spring messages configuration

Declare all four settings in `application.yml` whenever the project uses message
bundles:

```yml
spring:
  messages:
    basename: "i18n/messages"
    encoding: "UTF-8"
    default-locale: "en"
    fallback-to-system-locale: false
```

- Quote string values consistently (configuration contract).
- Have the application read `default-locale` for its own default-locale consumers;
  do not assume Spring Boot applies that key to the auto-configured `MessageSource`.
- Keep `fallback-to-system-locale: false`. With `true`, an English request can pick
  the JVM/OS locale bundle (for example `messages_pt_BR`) before the base bundle.
- Keep exactly two bundles: `messages.properties` (English, base) and
  `messages_pt_BR.properties`. Never add `messages_en.properties`.
- A missing key in an existing locale bundle follows its ResourceBundle parent
  chain, ultimately reaching the base bundle; `fallback-to-system-locale` is not
  a per-key translation fallback.

## Locale resolution

- Supported locales for real projects are English and `pt-BR`.
- Default locale is English.
- REST/API applications resolve locale from the `Accept-Language` header. A stock
  `AcceptHeaderLocaleResolver` configured with that default and supported list is
  enough.
- MVC/page applications may also honor an explicit `lang` query parameter when the
  UI needs a language switcher. Keep the application locale resolver's default
  as English.
- Keep user-facing resolution separate from log-message resolution by using the
  dedicated logging helper. Both use the applicable locale: request locale for
  request-scoped messages and configured default locale for messages without a request.

## Consistency tests

- Every module with message bundles must include an automated test that:
  - loads every locale file under `i18n/`
  - asserts the key sets are exactly equal
  - asserts placeholder arity matches per key
- Prefer a dedicated `I18nConsistencyTest` (or equivalent) that fails the build when
  a translation key is added to one file and omitted from another.
- Verify that each supported request locale resolves correctly when the JVM default
  is a different supported locale.
- Translate `log.` values in each locale bundle; do not require their text to be identical
  across locales.
- Optional stronger checks (keys used in code vs keys defined in bundles) are
  encouraged when the module can enumerate used keys reliably.

## Forbidden

- Never hardcode user-facing strings in controllers, services, exception handlers,
  templates, or OpenAPI annotations when a message key can be used instead.
- Never ship only one locale file when the project claims i18n support.
- Never omit `encoding`, `default-locale`, or `fallback-to-system-locale` once
  `spring.messages.basename` is declared.
- Never set `fallback-to-system-locale` to `true` or add `messages_en.properties`.
- Never treat English and `pt-BR` key sets as best-effort; they must stay identical.
