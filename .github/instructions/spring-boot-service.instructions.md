---
description: "Spring Boot service contract for business orchestration, transaction boundaries, and dependency-safe application logic."
applyTo: "**/*Service.java,**/*ServiceImpl.java"
---

# Spring Boot Service Engine

## Scope & Analysis
- Inspect service interface contracts and implementation behavior.
- Inspect transaction boundaries for read and write operations.
- Inspect dependency usage and orchestration responsibilities.

## Naming Conventions
- Service interfaces must be named with the `*Service` suffix (e.g., `UserService`, `PaymentService`).
- Service implementations must be named with the `*ServiceImpl` suffix (e.g., `UserServiceImpl`, `PaymentServiceImpl`).
- Use descriptive business domain names (never `BusinessService`, `OperationService`, or generic names).

## Resolution Rules
- Keep business orchestration in service layer.
- Prefer service contract/implementation separation (`interface XyzService` + `XyzServiceImpl`) for business modules with multiple collaborators or evolving API contracts; a focused single `@Service` class is acceptable for simple integration or utility services.
- Always apply `@Transactional(readOnly = true)` to service methods that only read data; apply `@Transactional` without `readOnly` for write operations; never omit transaction annotations for persistence workflows.
- Use `REQUIRED` (the default) transaction propagation for service methods that participate in or start a transaction; use `REQUIRES_NEW` only when the operation must commit independently of the outer transaction.
- Keep service methods aligned with API and repository contracts.
- Return domain-layer objects or DTOs from service methods; never return raw persistence entities from service methods called by controllers.
- Catch persistence-layer exceptions at the service boundary and rethrow as domain exceptions (e.g., `ResourceNotFoundException`, `DuplicateResourceException`); never let raw `DataAccessException` or SQL exceptions propagate to controllers.
- Keep external integration calls encapsulated in service boundaries.
- For authorization annotations, role checks, and permission enforcement, defer to `spring-boot-security.instructions.md`.

## Safety Guards
- Never move business rules into controllers or repositories.
- Never introduce implicit transaction behavior for critical writes.

## Review Plan Layout
- Report added or changed service methods and behavior.
- Report transaction-boundary decisions and justification.
- Report dependency changes and orchestration impact.
- Report contract compatibility with existing callers.

