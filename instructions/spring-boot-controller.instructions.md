---
description: "Spring Boot controller contract for request mapping, HTTP semantics, validation boundaries, and response consistency."
applyTo: "**/*Controller.java"
---

# Spring Boot Controller Engine

## Scope & Analysis
- Inspect controller class routing structure and endpoint design.
- Inspect request and response models used at API boundaries.
- Inspect validation and error-handling integration at controller layer.

## Resolution Rules
- Use class-level request mapping for every controller.
- Use `/api/v1` as the default base prefix for REST API controllers unless the user explicitly requests a different version root.
- Use view-flow route roots for page controllers (for example `/`, `/tasks`, `/ops`) instead of API version prefixes.
- When CRUD entity fields are not provided, propose a minimal baseline contract for the resource and ask for confirmation or edits.
- Use `@RestController` for JSON API endpoints and `@Controller` for server-rendered page flows.
- Use method-level HTTP verb mappings for each operation.
- Use constructor injection for controller dependencies.
- Keep controller logic thin and delegate business rules to services.
- Extract repeated technical string literals (for example route fragments, query parameter names, message-key constants) into named constants within the controller class.
- Use `@Valid` on all `@RequestBody` parameters to enforce request validation at the API boundary.
- Apply `@Positive` (or `@Min(1)`) to numeric `@PathVariable` resource-identifier parameters in REST endpoints.
- Do not apply numeric-positive constraints to non-numeric identifiers (for example `String` IDs).
- Validate incoming payloads at boundary when applicable.
- Return explicit `ResponseEntity` HTTP responses with stable payload contracts for REST endpoints.
- Return explicit view names for page controllers.

## Review Plan Layout
- Report endpoint additions, removals, and path changes.
- Report request and response contract changes.
- Report validation boundary behavior for each endpoint.
- Report controller-to-service delegation compliance.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never place business orchestration logic in controllers.
- Never mix `@RestController` and page-rendering responsibilities in the same controller class.
- Never mix unrelated resource routes in one controller.
- Never expose internal exception details in controller responses.
- Never leave a numeric `@PathVariable` resource identifier without a positive-value constraint.
