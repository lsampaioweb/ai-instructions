---
description: "Global architecture baseline for Spring Boot generation and review. This baseline is intentionally global and must be applied before component-specific instruction files."
applyTo: "**"
---

# Architecture Governance Baseline

## Scope & Analysis
- Analyze repository evidence before proposing changes.
- Classify findings into: environment state, boundary encapsulation, state mutation and persistence, failure processing, diagnostics, external integration.
- Classify component status as mandatory, conditional, or not-applicable.
- Preserve the existing package and module boundaries of the target project.
- Keep API boundary separation: controller, service, repository, DTO mapper, exception handling.

## Resolution Rules
- Prioritize explicit repository evidence over conventions.
- Use `com.learning` as the default top-level Java package namespace unless the user explicitly requests another namespace.
- Keep route versioning additive inside v1.
- Create a new API version for breaking changes.
- Use per-module error-code catalogs with strict prefixes.
- Allow only actuator health and info by default.
- Require explicit opt-in for any other actuator endpoint.
- Enforce one canonical local container run flow across Docker, Compose, and Traefik.
- Prohibit JPA, Hibernate, and Spring Data repository patterns.
- Use JDBC or JdbcClient patterns for persistence guidance.
- Always use constructor injection for application components.
- Keep feature-scoped application classes package-private by default and use public visibility only for cross-module contracts.
- Keep API models separated from persistence internals.
- Keep configuration externalized and profile-aware.
- Activate conditional components when request scope, existing implementation, active dependencies, or architecture contract requires them.
- Defer topics with insufficient evidence instead of inventing rules.

## Cross-Reference Guidance
- For actuator endpoint exposure and health access rules, read `spring-boot-actuator.instructions.md`.
- For controller routing, HTTP semantics, and validation boundaries, read `spring-boot-controller.instructions.md`.
- For API version coexistence and DTO evolution, read `spring-boot-api-versioning.instructions.md`.
- For async publication, consumers, and RabbitMQ delivery semantics, read `spring-boot-async-events.instructions.md`.
- For application properties, profiles, and externalized configuration, read `spring-boot-config.instructions.md`.
- For Dockerfile and Compose runtime rules, read `spring-boot-container.instructions.md`.
- For SQL DDL conventions, read `spring-boot-database-schema.instructions.md`.
- For DTO mapping contracts and MapStruct expectations, read `spring-boot-dto-mapper.instructions.md`.
- For enum governance and security role enums, read `spring-boot-enum.instructions.md`.
- For machine-readable API error codes and message-key mapping, read `spring-boot-error-code.instructions.md`.
- For centralized exception handling and error response mapping, read `spring-boot-exception.instructions.md`.
- For outbound HTTP clients and integration configuration, read `spring-boot-http-client.instructions.md`.
- For locale behavior and message bundle governance, read `spring-boot-i18n.instructions.md`.
- For Logback appenders, levels, and sink routing, read `spring-boot-logback.instructions.md`.
- For application logging behavior and safe diagnostics, read `spring-boot-logging.instructions.md`.
- For OpenAPI metadata and documentation structure, read `spring-boot-openapi.instructions.md`.
- For pageable endpoints, sorting, and paged response rules, read `spring-boot-pagination.instructions.md`.
- For Maven dependencies, plugins, and build governance, read `spring-boot-pom.instructions.md`.
- For README structure and project documentation rules, read `spring-boot-readme.instructions.md`.
- For foreign-key delete and update semantics, read `spring-boot-referential-integrity.instructions.md`.
- For repository boundaries, JdbcClient usage, and SQL safety, read `spring-boot-repository.instructions.md`.
- For authentication, authorization, and endpoint protection, read `spring-boot-security.instructions.md`.
- For service orchestration and transaction boundaries, read `spring-boot-service.instructions.md`.
- For test-layer scope and contract assertions, read `spring-boot-test.instructions.md`.
- For Thymeleaf controllers, templates, and form binding, read `spring-boot-thymeleaf.instructions.md`.
- For WebSocket/STOMP endpoint topology and lifecycle rules, read `spring-boot-websocket.instructions.md`.

## Review Plan Layout
- Review file targets before writing guidance.
- Keep one enforceable rule per bullet.
- Keep rule text short and directive.
- Reuse canonical statements from global governance files instead of duplicating long text.
- Mark each planned action as create, update, retain, delete, or defer.
- Report component status as applied, blocked, excluded, or deferred with reason.
- Report scope assumptions used in decisions.
- Report resolved high-impact decisions.
- Report cross-cutting checks for i18n, logging, observability, security, exception, error-code, and tests.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never assume unverified frameworks or tools.
- Never generate migration-framework rules without direct evidence.
- Never introduce destructive commands without explicit user confirmation.
- Never silently introduce optional components when intent is ambiguous.
- Require explicit user approval for controlled architecture deviations.
- Escalate findings only when a rule is applicable to the current scope.
- If instructions conflict, apply this precedence:
- 1. User explicit directive in current session.
- 2. This file for Spring Boot architecture constraints.
- 3. `copilot-instructions.md` for global behavior baseline.
- 4. Component-specific instruction files for local detail.
- Report conflicts explicitly and state which higher-priority rule was applied.
