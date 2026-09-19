---
description: "Spring service contracts and implementations: business orchestration, transactions, persistence, mapping, and domain errors."
applyTo: "**/*Service.java, **/*ServiceImpl.java"
---

## Dependencies
- Follow `spring-boot-java-style.instructions.md` for Java-wide formatting, visibility, injection, constants, JavaDoc, and helper rules.
- Follow `spring-boot-exception.instructions.md` when throwing or translating domain and infrastructure failures.
- Follow `spring-boot-pagination.instructions.md` when a service exposes a paginated collection.
- For authorization annotations and role enforcement, defer to `spring-boot-security.instructions.md`.

## Naming Conventions
- Name a service interface after its domain capability, such as `UserService` or `AccountService`.
- Name a concrete implementation `{ServiceName}Impl` when an interface exists.
- Use descriptive, domain-specific names for all service types (never `BusinessService`, `OperationService`, or `AppService`).
- Name persistence lookup helpers by the resolved domain type, such as `findUserById(...)` or `findDomainById(...)`.
- Name business operations by their domain intent, such as `transfer(...)`, `batchCreate(...)`, or `findAllPaged(...)`.

## Rules

### Service contract and ownership
- Keep the service interface and implementation in the same domain package.
- Place `@Service` on the implementation class, not on the interface.
- Use a service interface paired with a `*ServiceImpl` implementation for business modules that have multiple collaborators or evolving API contracts.
- Use a single `@Service` class without a separate interface for simple integration or utility services.
- Make service implementations implement their matching service interface when callers depend on a business contract.
- Own business decisions, persistence orchestration, and response mapping; implement all cross-feature orchestration and business decision logic in service classes.
- Route all outbound integration calls through service methods.

### Transactions and persistence
- Apply `@Transactional(readOnly = true)` to service methods that only read data.
- Apply `@Transactional` to service methods that perform write operations.
- Apply `@Transactional` annotations at the method level.
- Use `REQUIRED` transaction propagation for service methods that participate in or start a transaction.
- Use `REQUIRES_NEW` propagation only when the operation must commit independently of the outer transaction.
- Place the transaction boundary on the service method that owns the complete business operation.
- Retrieve an existing domain entity before an update or delete when its existence is part of the operation contract.
- Map request types to domain entities before persistence and map persisted domain entities to response types before returning them when those types exist.
- Return the repository result after a create or update when persistence can assign or modify state.
- Return domain model objects or response DTOs from service methods.
- Accept a query contract such as `PageQuery` instead of separate paging and sorting parameters when a service exposes a paginated collection.

### Domain behavior and errors
- Validate business preconditions before performing a state-changing operation.
- Throw a domain-specific exception when a required domain entity does not exist or a business rule is violated.
- Catch unwrapped persistence-layer exceptions at the service boundary and rethrow as domain exceptions (e.g., `ResourceNotFoundException`, `DuplicateResourceException`).
- When a repository lookup returns empty `Optional<T>` for a required resource, throw the appropriate domain exception at the service boundary.
- Keep transport annotations such as `@RequestBody`, `@PathVariable`, and mapping annotations out of services.
- Defer HTTP status selection and `ResponseEntity` construction to controllers per `spring-boot-controller.instructions.md`.
- Keep remote client error handling inside the service that owns that integration.

### Logging
- Log meaningful state-changing operations using the project message-key pattern when logging is required.
- Log business identifiers or relevant operation values without logging secrets or credentials.

## Safety Guards
- Never re-wrap a feature-scoped exception already thrown by the repository for the same SQL failure.

## Reference
- Use [samples/spring-boot-service-interface.tpl](samples/spring-boot-service-interface.tpl) for service contracts.
- Use [samples/spring-boot-service.tpl](samples/spring-boot-service.tpl) for service implementations.
