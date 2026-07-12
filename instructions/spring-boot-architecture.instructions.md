---
description: "Global Spring Boot architecture contract for generation and review workflows. Defines mandatory and conditional components, enforcement boundaries, and quality lenses for production-grade code."
applyTo: "**"
---

# Spring Boot Architecture Engine
Use this file as the immutable source of truth for global boundaries.

## Rule Priority
1. Safety and security constraints
2. This architecture contract
3. Component instruction files
4. Shared code style preferences

Apply copilot behavioral constraints from [copilot-instructions.md](./copilot-instructions.md) as pre-filter execution guards before this priority stack.

If two rules conflict, follow the higher-priority rule and report the conflict explicitly.

## Component Model
Classify each component as:
1. mandatory: must exist for current scope.
2. conditional: required only when feature/integration is in scope.
3. not-applicable: intentionally absent for current scope.

A result is compliant only when every applicable mandatory component is compliant or blocked with explicit reason.

## Required Component Families
Treat these families as required production concerns:
- architecture
- pom
- config
- i18n
- logging
- logback
- observability
- exception
- error-code
- test
- readme

## Optional Component Families
Treat these as conditional and activate only when feature scope requires them:
- enum
- actuator
- controller
- api-versioning
- pagination
- caching
- dto-mapper
- openapi
- repository
- database-schema
- referential-integrity
- soft-delete
- migrations
- service
- security
- http-client
- async-events
- thymeleaf
- websocket
- container

## Activation Rules for Conditional Components
Mark a conditional component mandatory for the current task when at least one condition is true:
1. The request explicitly asks for that capability.
2. Existing project or touched artifacts already implement that capability.
3. A dependency or configuration for that capability is present and active.
4. The architecture or API contract explicitly requires that capability.

If none of the conditions are true, mark the component as excluded with reason.

## Component Discovery and Decision Workflow
1. If a project exists, detect required and optional component presence before generation.
2. If a detected component is present, validate it against its corresponding instruction contract before adding new code.
3. If an optional component is not present, decide inclusion from explicit user intent and task scope.
4. If optional-component intent is ambiguous, ask the user explicitly before implementation.
5. Use explicit confirmation prompts such as: "Component <name> is optional. Do you want me to add it to this project?".
6. Do not silently introduce optional components when user intent is unclear.

## Enforcement Guards
1. Do not fail code for components that are not-applicable to the explicit feature scope.
2. Escalate findings only when rules are applicable to the current scope.
3. Enforce the same core architecture baseline across variants unless an explicit contract documents a controlled deviation.

## Cross-Cutting Quality Lenses
1. Security: enforce secure defaults, validated inputs, safe outputs, least-privilege access, and safe secret handling.
2. Quality and testability: enforce explicit contracts, deterministic behavior, and tests for success and failure paths.
3. Performance and scalability: avoid unnecessary blocking work, bound resource usage, and use efficient data/network access.
4. Operability and observability: emit structured logs, actionable errors, and runtime health/metrics visibility.

## Resolution Rules
1. Keep all classes for a business capability within one feature package.
2. Forbid top-level technical package directories named controllers, services, repositories, or exceptions.
3. Keep package-private visibility as default for feature-internal types.
4. Restrict data access to MyBatis mapper interfaces plus XML under src/main/resources/mapper or NamedParameterJdbcTemplate.
5. Forbid JPA, Hibernate, and Spring Data repository patterns.
6. Use constructor injection only.
7. Keep API models separated from persistence internals.
8. Keep configuration externalized and profile-aware.
9. Use class-level @ConfigurationProperties for structured external configuration binding.
10. Forbid raw field-level @Value injections for feature configuration blocks.

## Compliance Reporting Contract
All generation and review outputs must include:
1. mandatory components: applied, blocked, or not-applicable
2. conditional components: included or excluded with reason
3. scope and assumptions used for decisions
4. explicit blockers for any partial compliance result

## Safety Guards
1. Forbidden: generate or approve code using jakarta.persistence.*, org.hibernate.*, or org.springframework.data.*.
2. Hard stop: reject any task that splits one feature into separate top-level technical packages.
