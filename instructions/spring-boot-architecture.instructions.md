---
description: "Global architecture baseline for Spring Boot generation and review. This baseline is intentionally global and must be applied before component-specific instruction files."
applyTo: "**/pom.xml, **/src/**"
---

# Architecture Governance Baseline

## Cross-Reference Guidance

### Clarification Triggers
- Ask for application type when request text does not identify `rest-web`, `mvc-web`, `console-cli`, `batch-worker`, or `integration-adapter`.
- Allow a primary application type plus secondary capabilities when the module combines concerns such as REST, MVC, websocket, async events, or outbound integration.
- For persistence defaults and override behavior, defer to the active persistence-specific instruction files.
- Ask for data-store strategy only when active persistence instructions do not resolve the decision or request constraints conflict.
- Use feature-first package organization as the default, and ask blocking clarification only when the user explicitly requests a conflicting structure.
- Never create layer-based packages like common/api, common/exception, common/service, or common/repository; group all cross-cutting concerns and exceptions within their owning feature package.
- Keep feature-scoped implementation classes package-private to enforce feature boundaries: all classes ending in `Impl` (ServiceImpl, RepositoryImpl, etc.) must be package-private; all @Component or @Configuration classes scoped to a single feature (including those wiring domain-specific components like repositories or SQL configs) must be package-private and placed within the feature package; all internal mappers (whether manually written or generated) must be package-private.
- Expose only public interfaces, DTOs (Request, Response, DTO types), records, and public service contracts (interfaces and controllers) from a feature package.
- Ask for access policy when externally reachable HTTP endpoints, messaging endpoints, or websocket endpoints are requested without authentication and authorization boundaries.
- Ask for runtime expectations when profiles, ports, TLS, or container runtime are not explicit.
- For entity field and validation baseline suggestions, defer to active API-contract instructions.
- For REST list pagination and sorting defaults, defer to active pagination instructions.
- When user text explicitly requests default options, apply defaults from active component instructions without re-asking covered decisions.
- When configuration properties are introduced, defer registration and test-slice behavior to the active config and test instruction files.

### Exclusion Signals
- Exclude web-controller guidance for console-only or worker-only requests.
- Exclude security guidance only when there is no externally reachable HTTP, messaging, or websocket surface and none is planned.
- Exclude container guidance unless local runtime, deployment runtime, or shared infrastructure assets require it.
- Exclude pagination guidance only when no collection endpoint is present or user explicitly requires unpaged responses.
- Exclude async-events and websocket guidance unless messaging behavior is explicitly requested or present in scope.

### Always Active
- Read `spring-boot-pom.instructions.md` for Maven project identity, dependencies, plugins, and build governance.
- Read `spring-boot-config.instructions.md` for application properties, profiles, and externalized configuration.
- Read `spring-boot-i18n.instructions.md` for locale behavior and message bundle governance.
- Read `spring-boot-logging.instructions.md` for logging behavior and safe diagnostics.
- Read `spring-boot-logback.instructions.md` for logback configuration and safe logging.
- Read `spring-boot-observability.instructions.md` for observability behavior and configuration governance.
- Read `spring-boot-enum.instructions.md` for closed-set domain values and role-enum governance.
- Read `spring-boot-error-code.instructions.md` for machine-readable API error-code mapping.
- Read `spring-boot-exception.instructions.md` for centralized exception handling and error response mapping.
- Read `spring-boot-test.instructions.md` for test-layer scope and contract assertions.
- Read `spring-boot-readme.instructions.md` for user-facing behavior and setup documentation rules.

### Intent-Driven Activation
- Read `spring-boot-controller.instructions.md` when REST or MVC endpoints are present or requested.
- Read `spring-boot-openapi.instructions.md` when REST API endpoints are present, created, or modified.
- Read `spring-boot-security.instructions.md` when externally reachable HTTP, REST, MVC, actuator, config-server, or websocket endpoints are present or requested.
- Read `spring-boot-service.instructions.md` when business use cases, orchestration flows, or service-layer methods are present or requested.
- Read `spring-boot-thymeleaf.instructions.md` when server-rendered pages are present or requested.
- Read `spring-boot-http-client.instructions.md` when outbound HTTP integration is present or requested.
- Read `spring-boot-websocket.instructions.md` when realtime messaging endpoints are present or requested.
- Read `spring-boot-async-events.instructions.md` when asynchronous event workflows are present or requested.
- Read `spring-boot-container.instructions.md` when Docker, Podman, container runtime, or shared infrastructure container assets are present or requested.

### Evidence-Driven Activation
- Read `spring-boot-repository.instructions.md` when persistence is present or requested.
- Read `spring-boot-database-schema.instructions.md` when relational persistence is present or requested.
- Read `spring-boot-referential-integrity.instructions.md` when relational persistence is present or requested.
- Read `spring-boot-dto-mapper.instructions.md` when DTO models and domain models coexist in controller or service flows.
- Read `spring-boot-api-versioning.instructions.md` when REST API endpoints are present, created, or modified.
- Read `spring-boot-pagination.instructions.md` for REST collection endpoints unless user explicitly requests unpaged responses.
- Read `spring-boot-actuator.instructions.md` when actuator dependency or endpoint exposure is present, created, or modified.

## Spring Completion Gates

### Acceptance Gates
- Gate A: All modified Spring artifacts must satisfy every activated instruction file mapped by scope and intent.
- Gate B: Each modified area must have at least one objective verification action (build, test, lint, or deterministic static check) with a pass result.
- Gate C: Any temporary exception must include complete exception metadata and an unexpired review window.
- Gate D: Completion evidence must state which gates passed or failed.

### Completion-Blocking Logic
- Block completion when any required gate fails.
- Block completion when verification for a modified area is missing.
- Block completion when a temporary exception is missing required metadata.
- Block completion when a temporary exception is expired or has no removal condition.
- Completion is allowed only when all required gates pass, or blocked items are explicitly marked as unresolved blockers with owner and next checkpoint.
