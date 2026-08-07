---
description: "Spring Boot referential-integrity contract for deterministic foreign-key relationships, delete/update semantics, and data consistency in production-grade relational systems."
applyTo: "**/src/main/resources/sql/**/*.sql, **/src/main/resources/sql/**/*.xml"
---

# Spring Boot Referential-Integrity Engine

## Scope & Analysis
- Inspect foreign keys, unique constraints, and check constraints in SQL files.
- Inspect delete and update actions declared in SQL relation constraints.
- Inspect relationship assumptions expressed by schema definitions between parent and child entities.

## Resolution Rules
- Keep foreign-key constraints explicit for relational links.
- When CRUD scope implies parent-child or lookup relationships but relation definitions are missing, treat referential semantics as unresolved; do not generate schema until cardinality and delete/update behavior are explicit in the request.
- Keep relation naming and constraint naming predictable.
- Keep delete behavior explicit for constrained relationships.
- Specify update behavior explicitly using standard SQL mechanisms where key relations can be impacted.
- For FK action pair defaults (`ON DELETE RESTRICT / ON UPDATE CASCADE`) and syntax requirements, defer to `spring-boot-database-schema.instructions.md`.
- Declare the FK column as nullable for every optional association that uses `ON DELETE SET NULL`; a non-nullable FK column with `SET NULL` action produces a constraint violation at runtime.
- Keep domain invariants enforced by explicit SQL constraints and relation actions.
- Keep constraint semantics explicit enough to avoid hidden dependence on undocumented service-side safeguards.

## Safety Guards
- Never remove referential constraints without explicit approval.
- Never introduce delete flows that bypass relation safeguards.
- Never accept integrity-breaking updates without controlled migration.

## Review Plan Layout
- Report added or changed constraints and affected entities.
- Report delete and update behavior changes across relation boundaries.
- Report constraint-level mechanisms added for integrity protection.
- Report risks of orphan records or invalid relations.

