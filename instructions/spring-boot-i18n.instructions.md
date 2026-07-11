---
description: "i18n rules: message file layout, English+pt_BR required, locale resolution via Accept-Language header only."
applyTo: "**/i18n/**, **/messages*.properties, **/*LocaleConfig.java"
---

# i18n Rules

## File Layout
- Store all message files under `src/main/resources/i18n/`
- `messages.properties` (English) and `messages_pt_BR.properties` (Portuguese) are required in every project; additional locales are optional
- All message files are UTF-8 encoded; write non-ASCII characters directly (e.g. `Usuário`, `não`) — never use Unicode escape sequences (e.g. `\u00e1`)
- **Why:** Spring Boot's `MessageSource` auto-configuration reads `.properties` files as UTF-8 by default (since Spring Boot 2.x). Unicode escapes (`\u00e1`) are a legacy workaround from Java 8's ISO-8859-1 default and are unnecessary and harmful here — they make files unreadable in editors and diff tools without a UTF-8 decoder.
- Message text must be linguistically correct for its locale (spelling, accents, grammar); for `pt_BR`, ensure proper Portuguese orthography (e.g. `Conexão`, `Configuração`, `Usuário`)

## Configuration
Configure the basename in `application.yml`: `spring.messages.basename: "i18n/messages"`. See `snippets/config/application.yml` for the full placement.

## Usage
- Inject `MessageSource` via constructor; never use field injection
- Resolve the current locale with `LocaleContextHolder.getLocale()` in a private helper method
- Resolve locale from the `Accept-Language` request header; this is the only supported locale detection mechanism
- For manual testing, use curl with `-H "Accept-Language: pt-BR"`
- Locale resolution policy is defined in this file; operator-facing message text policy is defined in `spring-boot-logging.instructions.md` and `spring-boot-exception.instructions.md`

## Locale Resolution
- Register `LocaleResolver` as a `@Bean` inside a dedicated `@Configuration` class configured to read the `Accept-Language` header
- Do not support `?lang=` query parameter — the header mechanism is sufficient for all environments including testing

