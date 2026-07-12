---
description: "Spring Boot i18n contract for locale-aware messages, deterministic fallback behavior, and maintainable message catalogs in production-grade projects."
applyTo: "**/src/main/resources/i18n/messages*.properties, **/src/main/java/**/*.java"
---

# Spring Boot i18n Contract
Use this file to enforce internationalization behavior across APIs, logs, and validation messages.

## Message Source Baseline
1. Keep message bundles under src/main/resources/i18n.
2. Keep the base bundle file named messages.properties.
3. Keep locale bundles named messages_<language>.properties or messages_<language>_<COUNTRY>.properties.
4. Keep message keys stable and namespace them by concern.
5. Keep placeholder usage consistent across locales.

## Scope and Coordination
1. For Java files, apply this contract only when code resolves locale-aware message keys or MessageSource-backed text.
2. Apply [spring-boot-error-code.instructions.md](./spring-boot-error-code.instructions.md) first for machine-readable error-code taxonomy and mapping behavior.
3. Apply [spring-boot-logging.instructions.md](./spring-boot-logging.instructions.md) first for generic log event and privacy baseline rules.
4. Apply this file for locale-aware message resolution and message-bundle consistency behavior.

## Encoding and Configuration
1. Store all message bundle files as UTF-8.
2. Use spring.messages.basename=i18n/messages in application configuration when i18n is enabled.
3. Use spring.messages.encoding=UTF-8 when overriding default MessageSource settings.
4. Do not mix encodings across locale bundles.

## Locale Resolution
1. Resolve locale from request context for user-facing responses.
2. Keep supported locales explicit and deterministic.
3. Keep fallback locale behavior explicit when requested locale is unsupported.

## DI and Access Pattern
1. Use dependency injection for MessageSource access.
2. Keep message resolution inside dedicated i18n components or service boundaries.
3. Do not use static global MessageSource holders as primary access pattern.
4. Keep transport-specific locale handling outside domain core.

## API and Error Semantics
1. Return localized user-facing error messages.
2. Keep machine-readable error codes stable and independent from localized text.
3. Keep validation message keys mapped to message bundles.

## Logging and Operations
1. Keep operational log keys centralized when i18n logging is enabled.
2. Keep default operational locale deterministic for cross-environment analysis.
3. Avoid mixing hardcoded and localized text for the same event class.

## Quality and Maintenance
1. Keep key sets synchronized across supported locale bundles.
2. Detect missing keys before release through validation or tests.
3. Keep translation updates backward-compatible for existing keys.

## Security and Reliability
1. Do not expose raw internal keys to API consumers.
2. Keep message resolution failures from breaking core request flow.
3. Externalize locale and i18n runtime settings when environment-specific.
