---
description: "Service layer rules: business logic ownership, @Transactional, domain exceptions, and interface+impl pattern."
applyTo: "**/*Service.java, **/*ServiceImpl.java"
---

# Service Rules

See `spring-boot-caching.instructions.md` for cache annotation strategy, key naming, and invalidation behavior.
See `spring-boot-logging.instructions.md` for logging scope, message i18n, and component-specific log levels.

## Rules

- All business logic lives in the service layer; never in controllers, repositories, or entities
- Service layer is the canonical owner of business-operation logs (state transitions, operation outcomes, business events)
- Follow `spring-boot-logging.instructions.md` for level selection, state-transition scope, and `LogMessages` usage
- Do not duplicate the same business-event log across controller, service, and repository layers; emit it once in the service flow
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

