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

## Proactive Instruction Loading Directive
1. This file has `applyTo: "**"` and is always loaded.
2. For each activated component, explicitly read and apply its instruction file before generating any artifact.
3. Do not rely on `applyTo` auto-loading for new code generation.
4. Apply this directive to all required components and to conditional components only when they are included for the current task.

## Required Component Families
Treat these families as required production concerns. Read each linked instruction file before generating any artifact for that component.

- architecture — this file
- pom — [spring-boot-pom.instructions.md](./spring-boot-pom.instructions.md)
- config — [spring-boot-config.instructions.md](./spring-boot-config.instructions.md)
- i18n — [spring-boot-i18n.instructions.md](./spring-boot-i18n.instructions.md)
- logging — [spring-boot-logging.instructions.md](./spring-boot-logging.instructions.md)
- logback — [spring-boot-logback.instructions.md](./spring-boot-logback.instructions.md)
- observability — [spring-boot-observability.instructions.md](./spring-boot-observability.instructions.md)
- exception — [spring-boot-exception.instructions.md](./spring-boot-exception.instructions.md)
- error-code — [spring-boot-error-code.instructions.md](./spring-boot-error-code.instructions.md)
- test — [spring-boot-test.instructions.md](./spring-boot-test.instructions.md)
- readme — [spring-boot-readme.instructions.md](./spring-boot-readme.instructions.md)

## Optional Component Families
Treat these as conditional and activate only when feature scope requires them. When activated, read the linked instruction file before generating any artifact for that component.

- actuator — [spring-boot-actuator.instructions.md](./spring-boot-actuator.instructions.md)
- controller — [spring-boot-controller.instructions.md](./spring-boot-controller.instructions.md)
- api-versioning — [spring-boot-api-versioning.instructions.md](./spring-boot-api-versioning.instructions.md)
- pagination — [spring-boot-pagination.instructions.md](./spring-boot-pagination.instructions.md)
- caching — [spring-boot-caching.instructions.md](./spring-boot-caching.instructions.md)
- dto-mapper — [spring-boot-dto-mapper.instructions.md](./spring-boot-dto-mapper.instructions.md)
- openapi — [spring-boot-openapi.instructions.md](./spring-boot-openapi.instructions.md)
- enum — [spring-boot-enum.instructions.md](./spring-boot-enum.instructions.md)
- repository — [spring-boot-repository.instructions.md](./spring-boot-repository.instructions.md)
- database-schema — [spring-boot-database-schema.instructions.md](./spring-boot-database-schema.instructions.md)
- referential-integrity — [spring-boot-referential-integrity.instructions.md](./spring-boot-referential-integrity.instructions.md)
- soft-delete — [spring-boot-soft-delete.instructions.md](./spring-boot-soft-delete.instructions.md)
- migrations — [spring-boot-migrations.instructions.md](./spring-boot-migrations.instructions.md)
- service — [spring-boot-service.instructions.md](./spring-boot-service.instructions.md)
- security — [spring-boot-security.instructions.md](./spring-boot-security.instructions.md)
- http-client — [spring-boot-http-client.instructions.md](./spring-boot-http-client.instructions.md)
- async-events — [spring-boot-async-events.instructions.md](./spring-boot-async-events.instructions.md)
- thymeleaf — [spring-boot-thymeleaf.instructions.md](./spring-boot-thymeleaf.instructions.md)
- websocket — [spring-boot-websocket.instructions.md](./spring-boot-websocket.instructions.md)
- container — [spring-boot-container.instructions.md](./spring-boot-container.instructions.md)

## Activation Rules for Conditional Components
Mark a conditional component mandatory for the current task when at least one condition is true:
1. The request explicitly asks for that capability.
2. Existing project or touched artifacts already implement that capability.
3. A dependency or configuration for that capability is present and active.
4. The architecture or API contract explicitly requires that capability.

If none of the conditions are true, mark the component as excluded with reason.

## Context-Driven Dependency Inference Rules
Apply these rules as deterministic dependency inference. Do not treat this section as an exhaustive feature checklist.

### Cross-Cutting Concern Inference (Always Evaluate)
1. For every task, evaluate applicability of `i18n`, `logging`, `observability` (including metrics and tracing), `security`, `performance and scalability`, `exception handling`, `error-code mapping`, and `test coverage`.
2. If any cross-cutting concern is marked not-applicable, record explicit rationale tied to concrete scope boundaries.
3. If observability is active for runtime services, record one explicit tracing decision: enabled now, deferred with reason, or out-of-scope by contract.
4. If performance or scalability risks exist (for example large collections, blocking I/O, external network calls, or high concurrency), record at least one explicit mitigation or accepted risk.
5. If security exposure exists (for example external inputs, authentication, authorization, secrets, or sensitive data), record explicit controls or an approved exception.
6. If a cross-cutting decision conflicts with explicit user intent or project evidence, ask focused clarification instead of guessing.
7. Record all cross-cutting evaluations and resulting activations or exclusions in compliance output under scope and assumptions.

## Component Discovery and Decision Workflow
1. If a project exists, detect required and optional component presence before generation.
2. If a detected component is present, validate it against its corresponding instruction contract before adding new code.
3. If an optional component is not present, decide inclusion from explicit user intent and task scope.
4. If optional-component intent is ambiguous, ask the user explicitly before implementation.
5. Use this explicit prompt: "Component <name> is optional. Do you want me to add it to this project?".
6. Do not silently introduce optional components when user intent is unclear.
7. Default Decision Policy applies only when step 4 confirms user intent is silent.

## Default Decision Policy (When User Is Silent)
1. Apply defaults only to optional components and only when user intent is silent.
2. Do not apply defaults to high-impact assumptions; ask the user explicitly.
3. Treat persistence strategy, data model constraints, API contract boundaries, authentication/authorization model, and external integration semantics as high-impact assumptions.
4. Record every applied default in compliance output under scope and assumptions.
5. When a component-specific instruction file defines an explicit default, that file takes precedence over this section.
6. If no component-specific default exists, exclude the optional component by default and record the exclusion reason.
7. For data-access strategy when user intent is silent and both patterns are allowed, default to MyBatis mapper interface + XML.
8. If existing code already uses NamedParameterJdbcTemplate for the same feature, preserve that strategy and record the reason.

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
4. Restrict data access to MyBatis mapper interfaces plus XML under src/main/resources/sql or NamedParameterJdbcTemplate.
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
5. resolved decisions for all high-impact assumptions
6. cross-cutting evaluation matrix covering i18n, logging, observability or tracing, security, performance, exception, error-code, and test

## Safety Guards
1. Forbidden: generate or approve code using jakarta.persistence.*, org.hibernate.*, or org.springframework.data.*.
2. Hard stop: reject any task that splits one feature into separate top-level technical packages.
