---
description: "Project profile and architecture contract for all Spring Boot projects: technology stack, cross-cutting rules, and component catalogue."
---

# Spring Boot Architecture Conventions

## Code and Style Rules
- 2 spaces for indentation; never use tabs
- All Java identifiers follow standard naming: `camelCase` for variables and methods, `UPPER_SNAKE_CASE` for constants, `PascalCase` for class and interface names; never use underscores or hyphens in identifiers; map external formats (e.g., JSON `snake_case`) via `@JsonProperty` or `@JsonNaming`
- Import order: `java.*` → `jakarta.*` → third-party (`org.*`, `com.*`) → project-internal; blank line between groups; never use wildcard imports
- Stack annotations one per line; class-level annotations before method-level and field-level
- Use modern Java features where the project's Java version supports them: records, sealed classes
- Keep signatures on one line unless line length exceeds 160 characters
- Separate logically distinct blocks within a method with a blank line; do not add a blank line after every single statement
- Keep assignment order consistent with field declaration and parameter order
- Extract complex boolean predicates into well-named private methods; avoid inline multi-part logic in `if`, `while`, or ternary expressions
- Never introduce deprecated APIs when a supported alternative exists
- Never call date/time `now()` methods without explicit `ZoneId` or `Clock`; default to UTC when no domain-specific timezone is required
- Prefer `Instant` or `OffsetDateTime` for cross-service/API timestamps; use `LocalDateTime` only when timezone-free local business time is intentional
- Never trust user input; validate format, length, and content explicitly at every API boundary; reject or sanitize by default
- Ensure every edited file ends with a blank newline character
- After creating or editing a file, format it using the project's configured formatter; if none is configured, preserve existing style; never claim a file was formatted unless formatting ran successfully
- Prefer clear names over comments; add comments only for intent, trade-offs, invariants, and non-obvious behavior; never comment obvious assignments or control flow; add short Javadoc to public methods only when behavior is not obvious

## Class Structure
- Use the narrowest visibility: `private` for internal helpers, package-private for intra-feature classes, `public` only when accessible from outside the package
- Order members to reflect the logical flow a reader would follow: static constants (i18n key constants first) → instance fields → constructor(s) → public API methods → package-private/protected methods → private helpers (in call order, not alphabetically)
- Define interfaces for any component that may have multiple implementations or needs to be mocked in tests; skip interfaces for one-off utilities and configuration classes never tested in isolation

## Packaging and Project Layout
- Organize code by feature or domain: `user`, `product`, `order`, `config`, `integration`; never create generic root packages named `controller`, `service`, or `repository`
- Keep all classes for a feature in one package (e.g. `UserController`, `UserService`, `UserMapper`, `User`, `CreateUserRequest`, and `UserNotFoundException` all belong in `com.example.user`)
- Non-Java project files belong at the project root, never inside `src/`

## Architecture Rules
- Use constructor injection for all Spring-managed dependencies; never use `@Autowired` on fields
- Enforce one-way dependency: `controller → service → repository` or `service → integration client`; skip-layer calls are not allowed
- Controllers call only services; services call mappers, repositories, and integration clients; mappers have no web-layer knowledge
- The controller receives DTOs only (never domain objects); the service calls `mapper.toResponse(domain)` before returning to the controller
- When an entity is not found, the service throws the domain-specific exception (e.g. `UserNotFoundException`); never throw a generic `RuntimeException` or Spring exception directly
- REST handlers use `@RestController` and return DTOs or `ResponseEntity`; MVC view handlers use `@Controller` and return template names; never mix both in the same class
- Name REST handlers `*Controller`/`*Api`; name MVC view handlers `*Routes`/`*PageController`
- If a class returns template names, Thymeleaf rules win; if a class exposes JSON API endpoints, REST rules win
- Do not introduce new layers, patterns, dependencies, or frameworks unless explicitly requested; if a change cannot fit the existing structure, state why and propose the minimum change needed

## Domain and Persistence Rules
- Domain objects are plain Java records or classes with no persistence annotations; use records for immutable objects
- Field names and types map to SQL result sets via MyBatis result maps in XML; no annotations required on the domain class
- Never expose domain objects in controller responses or request parameters; always pass DTOs across API boundaries
- Never use JPA, Hibernate, or any ORM framework; never annotate domain objects with `@Entity`, `@Table`, or `@Column`; never add ORM dependencies; use MyBatis or Spring JDBC Templates for all data access

## AI Behavior Rules
- Never claim success for build, test, lint, or runtime validation unless a command was actually executed and completed successfully; if diagnostics still report errors, say so explicitly
- Never invent or assume API signatures, configuration keys, framework behavior, or codebase conventions not visible in the current context or official documentation; when uncertain, say so
- When a user requirement conflicts with a style convention: state the conflict explicitly, state the default convention, and ask one targeted clarifying question only if the ambiguity materially changes architecture or generated artifacts; the user requirement always wins

## Scope Control
- Only generate files for the specific feature or change requested; never add optional infrastructure or endpoints unless explicitly requested
- When starting a new project, ensure mandatory shared infrastructure is present before generating feature-specific code; do not hardcode project-structure checklists here
- When editing existing projects, apply only sections relevant to touched files; do not over-apply

## Ambiguity and Clarification Protocol
- If context is sufficient, infer required components and proceed
- If context is insufficient and different interpretations would change generated files, architecture, security, persistence, transport, deployment, or test scope, ask one targeted clarifying question before generating; prioritize the highest-impact unknown first: transport type (REST API, MVC pages, CLI/batch, event-driven) or relational database requirement
- Do not hardcode fixed question lists in this file; clarification must be contextual
- Do not hardcode keyword trigger lists in this file; component inclusion decisions must be semantic and contextual
- If ambiguity is low-impact and does not change architecture or generated artifact boundaries, proceed with the safest minimal assumption and state it briefly

## Delegation Rules
- This architecture file defines global constraints, component catalogue, and decision protocol only
- Component-specific implementation details belong exclusively to their referenced instruction files
- Do not duplicate component internals in this file
- If a rule in this file conflicts with a component-specific rule for a touched artifact, follow the component-specific file unless the user explicitly overrides it

---

## Mandatory Components
Mandatory components are required for applicable Spring Boot project profiles and should be applied by default when they fit the project type and transport model.
If a mandatory component is architecturally inapplicable, do not include it.
In existing projects, enforce mandatory components only when creating a new project slice or when the requested change touches that concern; do not add unrelated components.

- **Actuator** — health and info endpoints exposed; no sensitive endpoints exposed without security → [spring-boot-actuator.instructions.md](./spring-boot-actuator.instructions.md)
- **Configuration** — multi-profile setup: `application.yml`, `application-development.yml`, `application-production.yml`; no hardcoded secrets → [spring-boot-config.instructions.md](./spring-boot-config.instructions.md)
- **Exception handling** — single `@RestControllerAdvice`; domain-specific exceptions extend a base `AppException` → [spring-boot-exception.instructions.md](./spring-boot-exception.instructions.md)
- **i18n** — English (`messages.properties`) and pt_BR (`messages_pt_BR.properties`) required; locale resolved via `Accept-Language` header only → [spring-boot-i18n.instructions.md](./spring-boot-i18n.instructions.md)
- **Logging** — `@Slf4j` (Lombok); all log messages use i18n keys, never hardcoded strings → [spring-boot-logging.instructions.md](./spring-boot-logging.instructions.md)
- **Maven build** — `spring-boot-starter-parent`; no hardcoded managed versions → [spring-boot-pom.instructions.md](./spring-boot-pom.instructions.md)
- **README** — required sections, no filler prose → [spring-boot-readme.instructions.md](./spring-boot-readme.instructions.md)

## Conditional Components

Include conditional components only when required by requested feature scope and project type. Infer inclusion semantically from the request context, not fixed keywords.

- **Async / event-driven** — when background processing or cross-feature event propagation is needed → [spring-boot-async-events.instructions.md](./spring-boot-async-events.instructions.md)
- **Container / Compose** — when packaging the application with Docker, Podman or Kubernetes → [spring-boot-container.instructions.md](./spring-boot-container.instructions.md)
- **Data persistence (SQL, no ORM)** — include only when the requested feature requires persisting to or querying from a relational database; use MyBatis or Spring JDBC Templates, never JPA → [spring-boot-repository.instructions.md](./spring-boot-repository.instructions.md)
- **DTO and mapping** — when crossing layer boundaries (controller ↔ service ↔ repository), enforce a mapper boundary (`toEntity`, `toResponse`, etc.); use MapStruct when already present or explicitly requested, otherwise use a lightweight Spring mapper component → [spring-boot-dto-mapper.instructions.md](./spring-boot-dto-mapper.instructions.md)
- **HTTP client** — when calling external APIs; use `RestClient` → [spring-boot-http-client.instructions.md](./spring-boot-http-client.instructions.md)
- **REST API controller** — include when exposing HTTP JSON endpoints; DTOs in/out, no business logic in the controller. Dependency: if REST API controller is included, OpenAPI is required → [spring-boot-controller.instructions.md](./spring-boot-controller.instructions.md)
- **OpenAPI** — include when the application exposes REST API endpoints; all REST endpoints documented with springdoc-openapi; UI toggled by profile → [spring-boot-openapi.instructions.md](./spring-boot-openapi.instructions.md)
- **Security** — when authentication or authorization is required; deny-by-default, `@PreAuthorize` → [spring-boot-security.instructions.md](./spring-boot-security.instructions.md)
- **Service layer** — when business logic, transactions, or orchestration is needed → [spring-boot-service.instructions.md](./spring-boot-service.instructions.md)
- **Tests** — always include when creating or modifying controllers or services → [spring-boot-test.instructions.md](./spring-boot-test.instructions.md)
- **Thymeleaf (server-side UI)** — when rendering server-side HTML views → [spring-boot-thymeleaf.instructions.md](./spring-boot-thymeleaf.instructions.md)
- **WebSocket / STOMP** — when real-time bidirectional communication is needed → [spring-boot-websocket.instructions.md](./spring-boot-websocket.instructions.md)
