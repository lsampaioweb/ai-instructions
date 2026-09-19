---
description: "Springdoc OpenAPI configuration, API metadata, localized documentation, stable spec paths, and OpenAPI availability tests."
applyTo: "**/OpenApiConfig.java, **/*OpenApi*Test.java, **/openapi/**/*.java, **/application*.yml, **/*Controller.java"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for formatting, imports, visibility, injection, constants, and JavaDoc.
- Follow `spring-boot-pom.instructions.md` for the Springdoc dependency from the approved palette.
- Follow `spring-boot-config.instructions.md` for `springdoc.*` property placement rules in `application*.yml`.

## Naming Conventions
- Name the configuration class `OpenApiConfig`.
- Name the OpenAPI bean method `customOpenAPI()`.
- Place `OpenApiConfig` at the module root or in an `openapi` sub-package of the feature.
- Use `openapi.info.title` and `openapi.info.description` for localized OpenAPI metadata keys.

## Rules

### OpenAPI configuration
- Declare exactly one OpenAPI configuration class per runnable module, annotated with `@Configuration` and declared `public`.
- Expose one `OpenAPI` bean through `customOpenAPI()`.
- Set `info.title` to a concise, human-readable module name, and `info.version` to the current API version in semantic version format (e.g., `1.0.0`); keep `info.version` synchronized with the active route version prefix.
- Set `info.description` to a one-paragraph summary covering the module's purpose, base URL, and authentication requirements.
- Keep OpenAPI configuration focused on API metadata; do not add unrelated application configuration to `OpenApiConfig`.
- Use localized title and description messages only when the API documentation itself must be localized.
- When OpenAPI metadata is localized, resolve `info.title` and `info.description` from `openapi.*` message keys via `MessageSource` injection, using the locale available while the `OpenAPI` bean is configured.
- When OpenAPI metadata is localized, support English and `pt-BR` and fall back to the default English bundle for unsupported locales.
- When an `OpenApiConfig` component is created or modified, add matching `openapi.*` keys in all active locale bundles (`messages.properties` and locale variants) in the same change.

### Stable discoverable paths
- Configure `springdoc.swagger-ui.path=/swagger-ui.html` in `application.yml` for a stable, discoverable Swagger UI URL.
- Configure `springdoc.api-docs.path=/api-docs` in `application.yml` for a stable, discoverable OpenAPI spec URL.
- Define `springdoc.swagger-ui.path` and `springdoc.api-docs.path` together in the same change.
- Keep the configured `springdoc.swagger-ui.path` and `springdoc.api-docs.path` values consistent across base and profile-specific `application*.yml` files unless a profile-specific override is explicitly required and documented.

### Endpoint documentation and schema stability
- Apply `@Tag` and `@Operation(summary = "...")` consistently across all touched endpoints when the module adopts per-endpoint documentation.
- Keep public schema names and semantics stable.
- Document any schema-name or semantics change with a versioning decision in the same change.

### Verification
- When OpenAPI metadata is localized, test English, `pt-BR`, and unsupported-locale fallback values.
- Test that `/v3/api-docs` and `/swagger-ui/index.html` are available in the development profile.
- Test that `/v3/api-docs` and `/swagger-ui/index.html` are unavailable in the production profile when production disables API documentation.

## Reference
- Use [samples/spring-boot-openapi.tpl](samples/spring-boot-openapi.tpl) for the canonical OpenAPI configuration.
- Use [samples/spring-boot-application-development.tpl](samples/spring-boot-application-development.tpl) and [samples/spring-boot-application-production.tpl](samples/spring-boot-application-production.tpl) for Springdoc profile configuration.
