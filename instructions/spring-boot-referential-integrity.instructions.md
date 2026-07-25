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
- When CRUD scope implies parent-child or lookup relationships but relation definitions are missing, ask blocking clarification for cardinality and delete/update behavior before planning schema changes.
- Keep delete behavior explicit for constrained relationships.
- Keep update behavior explicit where key relations can be impacted.
- Always declare both `ON DELETE` and `ON UPDATE` actions on every FK constraint; never declare one without the other.
- Keep foreign-key indexing governed by schema rules so FK constraints and FK indexes remain coordinated without duplicating indexing policy here.
- Keep domain invariants enforced by explicit SQL constraints and relation actions.
- Keep constraint semantics explicit enough to avoid hidden dependence on undocumented service-side safeguards.
- Keep relation naming and constraint naming predictable.

## Review Plan Layout
- Report added or changed constraints and affected entities.
- Report delete and update behavior changes across relation boundaries.
- Report constraint-level mechanisms added for integrity protection.
- Report risks of orphan records or invalid relations.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never remove referential constraints without explicit approval.
- Never introduce delete flows that bypass relation safeguards.
- Never accept integrity-breaking updates without controlled migration.
- Never write a FK constraint that specifies `ON DELETE` behavior but omits `ON UPDATE` behavior, or vice versa.
