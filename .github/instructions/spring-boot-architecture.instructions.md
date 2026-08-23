---
description: "Global architecture baseline for Spring Boot generation and review. Apply before component-specific instruction files."
applyTo: "**/pom.xml, **/src/**"
---

# Architecture Governance Baseline

## Dependencies

- Treat this section as the component instruction registry for Spring Boot application work.
- Read each linked instruction file when planning or reviewing application components:
  - `.github/instructions/spring-boot-actuator.instructions.md` — Spring Boot actuator and observability contract: endpoint exposure, health probes, metrics, tracing, sampling, and sensitive-data boundaries (`**/src/main/resources/application*.yml, **/src/test/java/**/*.java`)
  - `.github/instructions/spring-boot-api-versioning.instructions.md` — API versioning rules: coexistence strategy, deprecation headers, and DTO evolution across versions (`**/*Controller.java`)
  - `.github/instructions/spring-boot-application.instructions.md` — Spring Boot main application entry-point contract for bootstrap class placement, annotation discipline, and startup configuration safety (`**/*Application.java`)
  - `.github/instructions/spring-boot-async-events.instructions.md` — Spring Boot async-events contract for deterministic event publication, consumer processing, and resilient delivery semantics (`**/src/main/java/**/*Event*.java, **/src/main/java/**/*Publisher*.java, **/src/main/java/**/*Consumer*.java, **/src/main/java/**/*Listener*.java, **/src/main/java/**/*AsyncConfiguration*.java`)
  - `.github/instructions/spring-boot-config.instructions.md` — Spring Boot configuration contract for externalized, profile-aware, and safe configuration management (`**/src/main/resources/application*.yml, **/*ConfigurationProperties.java`)
  - `.github/instructions/spring-boot-container.instructions.md` — Compose and Dockerfile container rules: image structure, naming, profile activation, volume mounts, healthcheck, and log directory ownership (`**/Dockerfile, **/docker-compose.yml, **/docker-compose.yaml, **/compose.yml`)
  - `.github/instructions/spring-boot-controller.instructions.md` — Spring Boot controller contract for request mapping, HTTP semantics, validation boundaries, and response consistency (`**/*Controller.java`)
  - `.github/instructions/spring-boot-database-schema.instructions.md` — Database schema and referential-integrity contract: types, naming, constraints, FK actions, and SQL artifact layout (`**/src/main/resources/sql/**/*.xml, **/src/main/resources/sql/**/*.sql`)
  - `.github/instructions/spring-boot-dto-mapper.instructions.md` — Spring Boot DTO-mapper contract for deterministic model mapping and boundary-safe transformations (`**/*Request.java, **/*Response.java, **/*DtoMapper.java`)
  - `.github/instructions/spring-boot-enum.instructions.md` — Spring Boot enum contract for deterministic closed-set domain values in API, domain, and persistence boundaries (`**/src/main/java/**/*Enum.java`)
  - `.github/instructions/spring-boot-error-code.instructions.md` — Spring Boot error-code contract for deterministic machine-readable API error semantics and stable message-key mapping (`**/src/main/java/**/*ErrorCode.java`)
  - `.github/instructions/spring-boot-exception.instructions.md` — Spring Boot exception-handling contract for centralized response mapping, stable error payloads, and controlled failure semantics (`**/*Exception*.java, **/*ExceptionHandler*.java, **/*Advice*.java`)
  - `.github/instructions/spring-boot-gitignore.instructions.md` — Spring Boot .gitignore contract for safe, complete exclusion of build output, IDE artifacts, OS files, secrets, and logs (`**/.gitignore`)
  - `.github/instructions/spring-boot-http-client.instructions.md` — Spring Boot HTTP client contract for deterministic outbound calls, bounded resilience behavior, and secure integration boundaries (`**/src/main/java/**/*HttpClient*.java, **/src/main/java/**/*HttpAdapter*.java, **/src/main/java/**/*HttpConfiguration*.java, **/src/main/java/**/*HttpProperties*.java`)
  - `.github/instructions/spring-boot-i18n.instructions.md` — Spring Boot i18n contract for message-key governance, locale behavior, and translation-safe output (`**/messages*.properties, **/application*.yml, **/*Messages.java, **/*LogMessages.java, **/i18n/**/*.java`)
  - `.github/instructions/spring-boot-java-style.instructions.md` — Java coding style contract for import ordering, visibility discipline, string constants, blank-line rules, and helper extraction across all Java source files (`**/src/**/*.java`)
  - `.github/instructions/spring-boot-logging.instructions.md` — Spring Boot logging contract for application log events, Logback appenders, rotation, and profile-level log routing (`**/*Controller.java, **/*Service.java, **/*ServiceImpl.java, **/*Repository.java, **/*RepositoryImpl.java, **/*Filter.java, **/*Interceptor.java, **/*Advice.java, **/src/main/resources/**/logback-spring.xml`)
  - `.github/instructions/spring-boot-model.instructions.md` — Spring Boot domain model contract for JDBC-first internal model types, boundary isolation, and persistence-free field declarations (`**/*Model.java`)
  - `.github/instructions/spring-boot-openapi.instructions.md` — Spring Boot OpenAPI contract for documented API metadata, discoverable endpoints, and stable specification output (`**/OpenApiConfig.java, **/openapi/**/*.java, **/src/main/resources/application*.yml, **/*Controller.java`)
  - `.github/instructions/spring-boot-pagination.instructions.md` — Spring Boot pagination contract for pageable queries, deterministic ordering, and consistent paged response metadata (`**/*Controller.java, **/*Pagination*.java, **/src/main/resources/application*.yml`)
  - `.github/instructions/spring-boot-pom.instructions.md` — Spring Boot Maven contract for dependency, plugin, and build-governance decisions (`**/pom.xml`)
  - `.github/instructions/spring-boot-readme.instructions.md` — README structure rules for required sections, actionable content, fenced code blocks, and no-filler-prose policy (`README.md, **/README.md`)
  - `.github/instructions/spring-boot-repository.instructions.md` — Spring Boot repository contract for JDBC-first data access, interface-implementation separation, and SQL safety (`**/*Repository.java, **/*RepositoryImpl.java, **/*SqlConfigurationProperties.java, **/*SqlColumns.java`)
  - `.github/instructions/spring-boot-security.instructions.md` — Spring Boot security contract for authentication, authorization, service-level checks, and endpoint protection boundaries (`**/*SecurityConfig.java, **/security/**/*.java`)
  - `.github/instructions/spring-boot-service.instructions.md` — Spring Boot service contract for business orchestration, transaction boundaries, and dependency-safe application logic (`**/*Service.java, **/*ServiceImpl.java`)
  - `.github/instructions/spring-boot-test.instructions.md` — Spring Boot testing contract for layer-focused tests, API-contract assertions, and cross-cutting governance checks (`**/src/test/java/**/*.java`)
  - `.github/instructions/spring-boot-thymeleaf.instructions.md` — Thymeleaf rules: controller conventions, template layout, model attributes, form binding, and static resource references (`**/*PageController.java, **/*Routes.java, **/templates/**/*.html`)
  - `.github/instructions/spring-boot-websocket.instructions.md` — WebSocket/STOMP rules: endpoint topology, message flow contract, lifecycle handling, and client resilience (`**/*Socket*.java, **/*Stomp*.java`)

## Rules

### Clarification gates
- When the user asks for defaults, apply governed defaults from activated instruction files without re-asking; before blocking questions, suppress any question already answered by an activated rule or default.

### Packaging
- Use feature-first packages as the default.
- Do not use layer packages such as `controller`, `service`, `repository`, or `exception`.
- Place every new production class under its owning feature root package; block generation when a class is proposed outside a feature root without explicit approval.
- Use `br.com.<organization>.<module-name>` as the root Java package; derive the module segment from `artifactId`.
- Name feature sub-packages with the bounded-context term.
- Do not repeat the module segment as the immediate child package (invalid: `com.org.module.module`).
- When the feature name matches the module segment, choose a distinct bounded-context name and document it.
- Keep feature-scoped `*Impl`, feature-scoped `@Component`/`@Configuration`/`@ConfigurationProperties`, and internal mappers package-private.
- Keep feature-internal controllers and domain models package-private unless a component-specific instruction file requires public visibility.
- Expose only public interfaces, DTOs (`*Request`, `*Response`, other DTO types), and explicit cross-feature contracts from a feature package.

### Shared types
- Place types with no single feature owner (e.g., `Pagination`, `ApiResponse`, `SortOrder`) in `shared`, organized by concept, not by technical layer (no `shared/service`, `shared/repository`).
- Treat a type as `shared` only when two or more distinct features depend on it.
- Keep feature-specific exception classes, error codes, and feature-scoped exception handlers in the owning feature package.
- Place module-global `@RestControllerAdvice` / `@ControllerAdvice` and shared error-envelope DTOs in `shared` (not under `shared.exception`); place other exception-related types in `shared` only when two or more features share the same semantic contract and that dependency is recorded in the plan.

### Precedence and deferrals
- Component-specific instruction files override this baseline only for their scoped target files.

### Completion
- Every modified Spring artifact must satisfy activated instruction files for its scope and intent.
- Each modified area needs at least one objective verification (build, test, lint, or deterministic static check) with a pass result.
- Mark every temporary exception with an inline code comment stating: the exception condition, its expiration criterion, and the instruction file rule being waived.
- State what passed, what failed, and what remains blocked when reporting completion; do not describe partial completion as done.

## Safety Guards
- Never use JPA, Jakarta Persistence, Hibernate, or any ORM framework in any application layer.
- Never generate datasource, database driver, or connection pool configuration without an active persistence-specific instruction file.
