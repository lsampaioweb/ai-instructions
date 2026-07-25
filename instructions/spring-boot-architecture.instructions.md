---
description: "Global architecture baseline for Spring Boot generation and review. This baseline is intentionally global and must be applied before component-specific instruction files."
applyTo: "**/pom.xml, **/src/**"
---

# Architecture Governance Baseline

## Cross-Reference Guidance

### Clarification Triggers
- Ask for application type when request text does not identify `rest-web`, `mvc-web`, `console-cli`, `batch-worker`, or `integration-adapter`.
- Ask for data-store strategy when data ownership is requested but persistence details are absent.
- Ask for access policy when endpoint exposure is requested without authentication and authorization boundaries.
- Ask for runtime expectations when profiles, ports, TLS, or container runtime are not explicit.
- Ask for domain fields and validation rules when CRUD entities are requested without attribute definitions.

### Exclusion Signals
- Exclude web-controller guidance for console-only or worker-only requests.
- Exclude security guidance unless access boundaries are requested or already implemented.
- Exclude container guidance unless local or deployment runtime requires it.
- Exclude pagination guidance unless list behavior requires page and sort controls.
- Exclude async-events and websocket guidance unless messaging behavior is explicitly requested.

### Always Active
- Read `spring-boot-pom.instructions.md` for Maven dependencies, plugins, and build governance.
- Read `spring-boot-config.instructions.md` for application properties, profiles, and externalized configuration.
- Read `spring-boot-i18n.instructions.md` for locale behavior and message bundle governance.
- Read `spring-boot-logging.instructions.md` for logging behavior and safe diagnostics.
- Read `spring-boot-observability.instructions.md` for observability behavior and configuration governance.
- Read `spring-boot-enum.instructions.md` for closed-set domain values and role-enum governance.
- Read `spring-boot-error-code.instructions.md` for machine-readable API error-code mapping.
- Read `spring-boot-exception.instructions.md` for centralized exception handling and error response mapping.
- Read `spring-boot-test.instructions.md` for test-layer scope and contract assertions.
- Read `spring-boot-readme.instructions.md` for user-facing behavior and setup documentation rules.

### Intent-Driven Activation
- Read `spring-boot-controller.instructions.md` when REST or MVC endpoints are requested.
- Read `spring-boot-openapi.instructions.md` when API contract documentation is requested.
- Read `spring-boot-security.instructions.md` when authentication or authorization is requested.
- Read `spring-boot-thymeleaf.instructions.md` when server-rendered pages are requested.
- Read `spring-boot-http-client.instructions.md` when outbound HTTP integration is requested.
- Read `spring-boot-websocket.instructions.md` when realtime messaging is requested.
- Read `spring-boot-async-events.instructions.md` when asynchronous event workflows are requested.
- Read `spring-boot-container.instructions.md` when Docker, Compose, or Traefik runtime is requested.

### Evidence-Driven Activation
- Read `spring-boot-repository.instructions.md` when persistence is present or requested.
- Read `spring-boot-database-schema.instructions.md` when SQL schema files are created or modified.
- Read `spring-boot-referential-integrity.instructions.md` when foreign-key behavior is introduced.
- Read `spring-boot-dto-mapper.instructions.md` when DTO-to-domain mapping is introduced.
- Read `spring-boot-api-versioning.instructions.md` when API version coexistence is required.
- Read `spring-boot-pagination.instructions.md` when pageable list behavior is required.
- Read `spring-boot-actuator.instructions.md` when actuator exposure policy is changed.
