---
description: "Spring Boot controller contract for request mapping, HTTP semantics, validation boundaries, and response consistency."
applyTo: "**/*Controller.java"
---

# Spring Boot Controller Engine

## Scope & Analysis
- Inspect controller class routing structure and endpoint design.
- Inspect request and response models used at API boundaries.
- Inspect validation and error-handling integration at controller layer.

## Naming Conventions
- Controller classes must be named with the `*Controller` suffix (e.g., `UserController`, `AccountController`).
- REST API controllers use `@RestController`; page-flow controllers use `@Controller`.
- Use descriptive resource names in class identifiers (never `ApiController`, `WebController`, or generic names).

## Resolution Rules
- Use class-level request mapping for every controller.
- REST API version prefix: governed by spring-boot-api-versioning.instructions.md.
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

## Safety Guards
- Never place business orchestration logic in controllers.
- Never mix `@RestController` and page-rendering responsibilities in the same controller class.
- Never mix unrelated resource routes in one controller.
- Never expose internal exception details in controller responses.
- Never leave a numeric `@PathVariable` resource identifier without a positive-value constraint.

## Review Plan Layout
- Report endpoint additions, removals, and path changes.
- Report request and response contract changes.
- Report validation boundary behavior for each endpoint.
- Report controller-to-service delegation compliance.

