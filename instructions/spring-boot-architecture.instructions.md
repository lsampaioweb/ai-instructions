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

### Instruction Reference
- Sync this list whenever a file is added, removed, or its `applyTo` scope changes.
- Read `spring-boot-java-style.instructions.md` for Java coding style, blank-line discipline, and method structure before creating or modifying any **/*.java files in src/.
- Read `spring-boot-pom.instructions.md` for Maven project identity, dependencies, plugins, and build governance when pom.xml needs to be modified, dependencies added or removed, or plugins configured.
- Read `spring-boot-config.instructions.md` for application properties, profiles, and externalized configuration when application*.yml files need to be created or modified.
- Read `spring-boot-i18n.instructions.md` for locale behavior and message bundle governance when introducing user-facing text, message keys, or locale configuration.
- Read `spring-boot-logging.instructions.md` for logging behavior and safe diagnostics before adding or modifying log statements in **/*.java application or test code.
- Read `spring-boot-logback.instructions.md` for logback configuration and safe logging when logback-spring.xml or logging dependencies in pom.xml need changes.
- Read `spring-boot-observability.instructions.md` for observability behavior and configuration governance when actuator endpoints, metrics, or health configuration in application*.yml are introduced or modified.
- Read `spring-boot-enum.instructions.md` for closed-set domain values and role-enum governance before creating or modifying enum types in **/*Enum.java.
- Read `spring-boot-error-code.instructions.md` for machine-readable API error-code mapping when error handling, exception mapping, or error messages in properties are introduced.
- Read `spring-boot-exception.instructions.md` for centralized exception handling and error response mapping when creating or modifying **/*Exception*.java, **/*ExceptionHandler*.java, or **/*Advice*.java.
- Read `spring-boot-test.instructions.md` for test-layer scope and contract assertions before creating or modifying any test files in **/src/test/java/**/ or **/*Test.java.
- Read `spring-boot-readme.instructions.md` for user-facing behavior and setup documentation rules when README or project documentation (*.md) files need to be created or updated.
- Read `spring-boot-gitignore.instructions.md` for source-control hygiene and safe artifact exclusion when .gitignore needs to be created or maintained.
- Read `spring-boot-controller.instructions.md` when creating or modifying **/*Controller.java files for REST or MVC endpoints.
- Read `spring-boot-openapi.instructions.md` when creating or modifying OpenAPI configuration, API endpoint classes, or controller classes that need API documentation.
- Read `spring-boot-security.instructions.md` when creating or modifying **/*SecurityConfig.java, **/*Service.java, **/*ServiceImpl.java, or endpoint protection for HTTP, REST, MVC, actuator, or websocket surfaces.
- Read `spring-boot-service.instructions.md` when creating or modifying **/*Service.java or **/*ServiceImpl.java for business orchestration and transaction management.
- Read `spring-boot-thymeleaf.instructions.md` when creating or modifying server-rendered page controllers (**/*PageController.java), routes, or templates/**/*.html.
- Read `spring-boot-http-client.instructions.md` when creating or configuring outbound HTTP client classes, adapters, or HTTP integration configuration.
- Read `spring-boot-websocket.instructions.md` when creating or modifying WebSocket or STOMP messaging endpoints (**/*Socket*.java, **/*Stomp*.java).
- Read `spring-boot-async-events.instructions.md` when implementing asynchronous event publication, consumption, or listener processing (**/*Event*.java, **/*Publisher*.java, **/*Consumer*.java, **/*Listener*.java).
- Read `spring-boot-container.instructions.md` when creating or modifying Dockerfile or docker-compose.yml for container runtime configuration.
- Read `spring-boot-repository.instructions.md` when creating or modifying repository classes or data access layer (**/*Repository.java, **/*RepositoryImpl.java, **/*SqlColumns.java, **/*SqlConfigurationProperties.java).
- Read `spring-boot-database-schema.instructions.md` when creating or modifying SQL DDL files (**/*.xml, **/*.sql) in src/main/resources/sql/.
- Read `spring-boot-referential-integrity.instructions.md` when defining foreign keys, constraints, or relational integrity rules in SQL schema files.
- Read `spring-boot-dto-mapper.instructions.md` when creating or modifying DTO mapper classes (**/*DtoMapper.java) for model transformations.
- Read `spring-boot-api-versioning.instructions.md` when creating or modifying REST API endpoints (**/*Controller.java, **/*Api.java) or related request/response DTOs to manage versioning strategy.
- Read `spring-boot-pagination.instructions.md` when implementing paginated collection endpoints in **/*Controller.java or pagination logic in **/*Service.java, **/*ServiceImpl.java.
- Read `spring-boot-actuator.instructions.md` when configuring actuator endpoint exposure in **/*SecurityConfig.java or application*.yml, or when security rules for health checks need to be defined.

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
