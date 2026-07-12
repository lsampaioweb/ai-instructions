---
description: "Spring Boot service contract for deterministic business orchestration, transaction boundaries, and feature-local application behavior in production-grade projects."
applyTo: "**/src/main/java/**/*Service.java, **/src/main/java/**/*ServiceImpl.java, **/src/main/java/**/service/**/*.java"
---

# Spring Boot Service Contract
Use this file to enforce deterministic service-layer behavior.

## Scope
1. Apply to feature service interfaces and service implementations.
2. Keep business orchestration and transactional intent in service layer boundaries.

## Boundary Rules
1. Keep controllers limited to transport concerns and delegate business orchestration to services.
2. Keep repository and mapper coordination in services, not in controllers.
3. Keep service contracts focused on application use cases, not persistence primitives.
4. Keep service classes package-private unless another feature package must invoke the service through a documented cross-feature contract.

## Transaction Rules
1. Keep transaction demarcation explicit on service operations.
2. Keep read operations marked read-only when no state mutation is expected.
3. Keep write operations transactional and bounded to one deterministic business outcome.
4. Keep retry-sensitive operations idempotent when external retries are expected.

## Business Rule Rules
1. Keep invariant checks explicit before state mutation.
2. Keep not-found and invalid-state handling mapped to deterministic application exceptions.
3. Keep monetary, inventory, and lifecycle transitions validated before persistence updates.
4. Keep time and randomness dependencies injectable for deterministic behavior.

## Integration Rules
1. Keep external HTTP, messaging, or cache calls behind feature-local abstractions.
2. Keep integration side effects ordered after mandatory local validation.
3. Keep outbound request and response mapping isolated from core business decisions.
4. When cross-system consistency is required, document recovery strategy at method boundary with trigger condition and expected terminal failure behavior.

## Quality Gates
1. Forbid persistence SQL orchestration directly in service methods.
2. Forbid transport concerns such as HTTP status construction in services.
3. Keep tests covering success paths, business failure paths, and transactional boundary behavior.
4. Keep logging aligned with operation boundary semantics without leaking sensitive data.
