---
description: "Service layer rules: business logic ownership, @Transactional, domain exceptions, and interface+impl pattern."
applyTo: "**/*Service.java, **/*ServiceImpl.java"
---

# Service Rules

For cache annotation strategy, key naming, and invalidation behavior, see `spring-boot-caching.instructions.md`.
For logging scope, message i18n, and component-specific log levels, see `spring-boot-logging.instructions.md`.

## Rules

- All business logic lives in the service layer; never in controllers, repositories, or entities
- **Log all state transitions here**: create/update/delete operations must log at `INFO` level with i18n message keys via `LogMessages` injection; controllers and repositories do NOT log business events
- Define a service interface; provide a single implementation class suffixed with `Impl` per interface
- Apply `@Transactional` at the method level, not on the class; read-only methods use `@Transactional(readOnly = true)`
- Throw domain-specific exceptions extending the project's base exception class; do not throw raw Spring infrastructure exceptions
- If throwing operational exceptions (e.g., `IllegalStateException` for startup/validation), use i18n message keys resolved via `LogMessages`, never hardcode message text
- Services call repositories, mappers, and integration clients; they do not call controllers
- Use package-private visibility by default for service classes and methods; elevate to `public` only when external callers require it

## Exception Handling
- Only catch an exception when you can meaningfully recover from it, translate it into a domain exception, or must release a resource
- Never catch and silently swallow an exception
- Do not wrap every method body in a `try/catch` as boilerplate; let unchecked exceptions propagate to `@RestControllerAdvice`
- When catching a checked exception from an external library, wrap it in the appropriate domain exception before rethrowing
- For API error-response shape and stacktrace exposure policy, see `spring-boot-exception.instructions.md`

