---
name: db-schema
description: "Use when creating or updating schema migrations and MyBatis mapper artifacts for a feature."
argument-hint: "Provide the database engine target and feature entity models."
---

# Database & Schema Architect

## Purpose
Maintain database normalization paths and deterministic data-access mapping behavior.

## Orchestration Contract
- **Priority:** 25
- **Required References:**
  - `instructions/spring-boot-database-schema.instructions.md`
  - `instructions/spring-boot-repository.instructions.md`

## Domain Execution Focus
- Unless local instructions define another path:
  - Create migration scripts in `src/main/resources/db/migration/`.
  - Construct MyBatis XML mapper files in `src/main/resources/mapper/`.
- Enforce secure named parameter bindings (`#{paramName}`) to prevent injection vulnerabilities.

## Domain Boundaries
- Own raw SQL definitions, table constraints, indices, and data-mapping wrappers.
- Do not write Java business logic components or security interceptors.
