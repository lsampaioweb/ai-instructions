---
description: "Feature-based packaging, dependency flow, visibility, domain object rules, interface conventions, and code style for all Java and Spring Boot files."
applyTo: "**/*.java, **/pom.xml, **/application*.yml"
---

# Spring Boot Architecture Conventions

## Code Style
- 2 spaces for indentation; never use tabs
- Use modern Java features where the project's Java version supports them: records, pattern matching, sealed classes, text blocks
- Add a blank line before every `return` statement unless the method body is a single expression
- Separate logically distinct blocks within a method body with a blank line (e.g. between validation, data retrieval, transformation, and return)
- Do not add a blank line after every single statement; use spacing to group related lines, not to isolate them

## Versions
Target the latest stable Spring Boot and Java versions for new projects. For existing projects, detect the version from `pom.xml` and apply rules compatible with that version without suggesting upgrades unless asked.

## Build Tool
Use Maven. See `spring-boot-pom.instructions.md` for dependency rules.

## Project Layout
Non-Java project files belong at the project root, never inside `src/`:

```text
project-root/
├── .dockerignore
├── .env
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── pom.xml
├── README.md
├── logs/
│   └── container/
│       └── .keep
├── ssl/
│   └── .keep
└── src/
    ├── main/
    │   ├── java/
    │   └── resources/
    │       ├── application.yml
    │       ├── application-development.yml
    │       ├── application-production.yml
    │       ├── i18n/
    │       │   └── messages.properties
    │       │   └── messages_pt_BR.properties
    │       └── log/
    │           └── logback-spring.xml
    └── test/
        └── java/
```

## Packaging
Organize code by feature or domain. Use packages like `user`, `product`, `order`, `config`, `integration`. Do not create generic root packages named `controller`, `service`, or `repository`.

Keep all classes for a feature together in one package. Example: `UserController`, `UserService`, `UserMapper`, `User`, `CreateUserRequest`, and `UserNotFoundException` all belong in `com.example.user`.

## Dependency Flow
One-way only: `controller → service → repository` or `service → integration client`. Skip-layer calls are not allowed.

Specific rules:
- `UserController` calls `UserService`; it does not call `UserMapper` or integration clients directly
- `UserService` calls `UserMapper`, repositories, and integration clients
- `UserMapper` has no knowledge of web concerns; it does not use `ResponseEntity` or any web-layer class
- Integration clients do not call controllers and do not depend on web-layer classes

## Domain Objects
- Domain objects are plain Java records or classes with no persistence annotations
- Field names and types map to SQL result sets via MyBatis result maps defined in XML; no annotations are required on the domain class itself
- Use Java records for immutable domain objects; use a class only when mutation is genuinely necessary

## API Boundaries
Never expose domain objects in controller responses or request parameters. Pass DTOs across all API boundaries.

## Object Mapping
Use MapStruct for all object mapping between layers. See `spring-boot-dto-mapper.instructions.md` for mapper conventions.

## No ORM
Never use JPA, Hibernate, or any ORM framework. Do not annotate domain objects with `@Entity`, `@Table`, `@Column`, or any ORM annotation. Do not add ORM dependencies to the project. Use MyBatis or Spring JDBC Templates for all data access. See `spring-boot-repository.instructions.md` for data access rules.

## Dependency Injection
Use constructor injection for all Spring-managed dependencies. Never use `@Autowired` on fields.

## Exception Handling
Centralize all exception handling in a single `@RestControllerAdvice` class. See `spring-boot-exception.instructions.md` for the full pattern.

## Logging
Use `@Slf4j` (Lombok) for all logging. See `spring-boot-logging.instructions.md` for level and content rules.

## Hardcoded Text
Never hardcode human-readable text (messages, labels, error descriptions) as string literals in Java code. All text must be defined in `messages.properties` and referenced by its i18n key. See `spring-boot-logging.instructions.md` for how this applies to log statements.

## Constants
- Declare i18n key strings as `private static final String` constants at the top of the class; never pass key literals inline
- Name constants in `UPPER_SNAKE_CASE` that describes the message, not the key string value

Bad:
```java
log.debug(logMessages.get("log.user.find.all"));
```

Good:
```java
private static final String LOG_USER_FIND_ALL = "log.user.find.all";

log.debug(logMessages.get(LOG_USER_FIND_ALL));
```

## Visibility
Use the narrowest visibility that works:
- `private` for helpers not used outside the class
- Package-private (no modifier) for classes and methods used only within the same feature package
- `public` only for types and methods that must be accessible from outside the package

Do not make every class or method `public` by default.

## Interfaces
Define interfaces for services and any component that may have multiple implementations or needs to be mocked in tests. A dedicated interface is not required for one-off utilities or configuration classes that are never tested in isolation.
