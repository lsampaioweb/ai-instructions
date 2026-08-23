---
description: "Spring Boot service contract for business orchestration, transaction boundaries, and dependency-safe application logic."
applyTo: "**/*Service.java, **/*ServiceImpl.java"
---

# Spring Boot Service Engine

## Naming Conventions
- Name service interfaces with the `*Service` suffix (e.g., `HolidayService`, `PaymentService`).
- Name service implementations with the `*ServiceImpl` suffix (e.g., `HolidayServiceImpl`, `PaymentServiceImpl`).
- Use descriptive, domain-specific names for all service types (never `BusinessService`, `OperationService`, or `AppService`).

## Rules
- For authorization annotations and role enforcement, defer to `spring-boot-security.instructions.md`.
- Place `@Service` on the implementation class, not on the interface.
- Implement all cross-feature orchestration and business decision logic in service classes.
- Use a service interface paired with a `*ServiceImpl` implementation for business modules that have multiple collaborators or evolving API contracts.
- Use a single `@Service` class without a separate interface for simple integration or utility services.
- Apply `@Transactional(readOnly = true)` to service methods that only read data.
- Apply `@Transactional` to service methods that perform write operations.
- Apply `@Transactional` annotations at the method level.
- Use `REQUIRED` transaction propagation for service methods that participate in or start a transaction.
- Use `REQUIRES_NEW` propagation only when the operation must commit independently of the outer transaction.
- Return domain model objects or response DTOs from service methods.
- Catch unwrapped persistence-layer exceptions at the service boundary and rethrow as domain exceptions (e.g., `ResourceNotFoundException`, `DuplicateResourceException`).
- When a repository lookup returns empty `Optional<T>` for a required resource, throw the appropriate domain exception at the service boundary.
- Route all outbound integration calls through service methods.

## Safety Guards
- Never re-wrap a feature-scoped exception already thrown by the repository for the same SQL failure.
