---
description: "Global architecture baseline for Spring Boot generation and review. This baseline is intentionally global and must be applied before component-specific instruction files."
applyTo: "**/pom.xml, **/src/**"
---

# Architecture Governance Baseline

## Cross-Reference Guidance

### Clarification Triggers
- Treat application type as unresolved when the request does not identify `rest-web`, `mvc-web`, `console-cli`, `batch-worker`, or `integration-adapter`; do not generate implementation until the type is explicit.
- Allow a primary application type plus secondary capabilities when the module combines concerns such as REST, MVC, websocket, async events, or outbound integration.
- For persistence defaults and override behavior, defer to the active persistence-specific instruction files.
- Treat data-store strategy as unresolved only when active persistence instructions do not resolve the decision or request constraints conflict; do not generate persistence implementation until the strategy is explicit.
- Use feature-first package organization as the default; treat package structure as unresolved only when the user explicitly requests a conflicting structure.
- Gate feature-root packaging: place every new production class under its owning feature root package; treat placement as unresolved and block generation when a class is proposed outside a feature root without explicit approval.
- Use `com.<organization>.<module-name>` as the root Java package; derive it from the project `groupId` and `artifactId`; never use generic root packages like `com.example` or `com.demo`.
- Never create layer-based packages like common/api, common/exception, common/service, or common/repository; group all cross-cutting concerns and exceptions within their owning feature package.
- Keep feature-scoped implementation classes package-private to enforce feature boundaries: all classes ending in `Impl` (ServiceImpl, RepositoryImpl, etc.) must be package-private; all @Component or @Configuration classes scoped to a single feature (including those wiring domain-specific components like repositories or SQL configs) must be package-private and placed within the feature package; all internal mappers (whether manually written or generated) must be package-private.
- Expose only public interfaces, DTOs (Request, Response, DTO types), records, and public service contracts (interfaces and controllers) from a feature package.
- Treat access policy as unresolved when externally reachable HTTP endpoints, messaging endpoints, or websocket endpoints are requested without authentication and authorization boundaries; do not generate endpoint implementation until boundaries are explicit.
- Treat runtime expectations as unresolved when profiles, ports, TLS, or container runtime are not explicit; do not generate environment-specific configuration until these are stated.
- For entity field and validation baseline suggestions, defer to active API-contract instructions.
- For REST list pagination and sorting defaults, defer to active pagination instructions.
- When user text explicitly requests default options, apply defaults from active component instructions without re-asking covered decisions.
- Before generating blocking questions, scan all activated instruction files for governed defaults; suppress any question whose answer is already explicitly stated as a rule or default in an activated file.
- When configuration properties are introduced, defer registration and test-slice behavior to the active config and test instruction files.

### Instruction Reference

These references supplement `applyTo` routing for intent-based activation — cases where context or domain intent determines file applicability beyond file-path patterns.

- Read `spring-boot-java-style.instructions.md` for Java coding style, blank-line discipline, and method structure before creating or modifying any **/*.java files in src/.
- Read `spring-boot-pom.instructions.md` for Maven project identity, dependencies, plugins, and build governance when pom.xml needs to be modified, dependencies added or removed, or plugins configured.
- Read `spring-boot-config.instructions.md` for application properties, profiles, and externalized configuration when application*.yml files need to be created or modified.
- Read `spring-boot-i18n.instructions.md` for locale behavior and message bundle governance when introducing user-facing text, message keys, or locale configuration.
- Read `spring-boot-logging.instructions.md` for logging behavior and safe diagnostics before adding or modifying log statements in **/*.java application or test code.
- Read `spring-boot-logback.instructions.md` for logback configuration and safe logging when logback-spring.xml or logging dependencies in pom.xml need changes.
- Read `spring-boot-enum.instructions.md` for closed-set domain values and role-enum governance before creating or modifying enum types in **/*Enum.java.
- Read `spring-boot-error-code.instructions.md` for machine-readable API error-code mapping when error handling, exception mapping, or error messages in properties are introduced.
- Read `spring-boot-exception.instructions.md` for centralized exception handling and error response mapping when creating or modifying **/*Exception*.java, **/*ExceptionHandler*.java, or **/*Advice*.java.
- Read `spring-boot-test.instructions.md` for test-layer scope and contract assertions before creating or modifying any test files in **/src/test/java/**/ or **/*Test.java.
- Read `spring-boot-readme.instructions.md` for user-facing behavior and setup documentation rules when README or project documentation (*.md) files need to be created or updated.
- Read `spring-boot-controller.instructions.md` when creating or modifying **/*Controller.java files for REST or MVC endpoints.
- Read `spring-boot-openapi.instructions.md` when creating or modifying OpenAPI configuration, API endpoint classes, or controller classes that need API documentation.
- Read `spring-boot-security.instructions.md` when creating or modifying **/*SecurityConfig.java, **/*Service.java, **/*ServiceImpl.java, or endpoint protection for HTTP, REST, MVC, actuator, or websocket surfaces.
- Read `spring-boot-service.instructions.md` when creating or modifying **/*Service.java or **/*ServiceImpl.java for business orchestration and transaction management.
- Read `spring-boot-thymeleaf.instructions.md` when creating or modifying server-rendered page controllers (**/*PageController.java), routes, or templates/**/*.html.
- Read `spring-boot-http-client.instructions.md` when creating or configuring outbound HTTP client classes, adapters, or HTTP integration configuration.
- Read `spring-boot-websocket.instructions.md` when creating or modifying WebSocket or STOMP messaging endpoints (**/*Socket*.java, **/*Stomp*.java).
- Read `spring-boot-async-events.instructions.md` when implementing asynchronous event publication, consumption, or listener processing (**/*Event*.java, **/*Publisher*.java, **/*Consumer*.java, **/*Listener*.java).
- Read `spring-boot-repository.instructions.md` when creating or modifying repository classes or data access layer (**/*Repository.java, **/*RepositoryImpl.java, **/*SqlColumns.java, **/*SqlConfigurationProperties.java).
- Read `spring-boot-database-schema.instructions.md` when creating or modifying SQL DDL files (**/*.xml, **/*.sql) in src/main/resources/sql/.
- Read `spring-boot-referential-integrity.instructions.md` when defining foreign keys, constraints, or relational integrity rules in SQL schema files.
- Read `spring-boot-dto-mapper.instructions.md` when creating or modifying DTO mapper classes (**/*DtoMapper.java) for model transformations.
- Read `spring-boot-api-versioning.instructions.md` when creating or modifying REST API endpoints (**/*Controller.java, **/*Api.java) or related request/response DTOs to manage versioning strategy.
- Read `spring-boot-pagination.instructions.md` when implementing paginated collection endpoints in **/*Controller.java or pagination logic in **/*Service.java, **/*ServiceImpl.java.
- Read `spring-boot-actuator.instructions.md` when configuring actuator endpoint exposure, management server port, metrics visibility, profile-level observability posture, or health check security in **/*SecurityConfig.java or application*.yml.
- Read `spring-boot-gitignore.instructions.md` when the repository root .gitignore is missing, incomplete against baseline exclusions, or build artifacts appear in version-control changes.

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
