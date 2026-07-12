---
description: "Spring Boot API versioning contract for deterministic path-based versioning and controlled evolution of breaking changes in production-grade projects."
applyTo: "**/src/main/java/**/*Controller.java"
---

# Spring Boot API Versioning Contract
Use this file to enforce deterministic API version path governance.

## Scope
1. Apply to REST API controllers under /api/* paths.
2. Apply these rules only to controller methods mapped under /api/*.
3. Mark page-rendering routes and non-API UI routes as not-applicable for this contract.
4. Treat API versioning scope as active when controller mappings contain /api/vN paths or project documentation explicitly requires versioned API routing.

## Coordination Order
1. Evaluate [spring-boot-controller.instructions.md](./spring-boot-controller.instructions.md) first for baseline controller behavior.
2. Apply this contract only when versioned API routing is in scope for the matched controller file.

## Versioning Rules
1. When API versioning is in scope, use path-based versioning with /api/vN prefix for every public API route.
2. Keep one API version per controller class.
3. Keep version token explicit in class-level request mapping constants.
4. Keep nested resource routes within the same version prefix.

## Evolution Rules
1. Introduce a new /api/vN controller for breaking contract changes.
2. Keep existing published versions backward-compatible during support window.
3. Keep request and response schema differences explicit by version.
4. Keep deprecation notices documented before version removal.

## Cross-Component Alignment
1. Keep security route matchers aligned with active /api/vN prefixes.
2. Keep OpenAPI endpoint documentation grouped by API version.
3. Keep README endpoint examples aligned with current versioned routes.
4. Keep tests asserting versioned paths for success and failure routing.

## Quality Gates
1. Forbid mixed v1 and v2 mappings in the same controller class.
2. Forbid unversioned public API mappings under /api/*.
3. Keep redirects between versions explicit and temporary only when migration policy requires them.
