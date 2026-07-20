---
description: "Spring Boot referential-integrity contract for deterministic foreign-key relationships, delete/update semantics, and data consistency in production-grade relational systems."
applyTo: "**/src/main/resources/sql/**/*.sql, **/src/main/resources/sql/**/*.xml"
---

# Spring Boot Referential-Integrity Engine

## Scope & Analysis
- Inspect foreign keys, unique constraints, and check constraints in SQL files.
- Inspect delete and update flows in service and repository implementations.
- Inspect relationship assumptions between parent and child entities.

## Resolution Rules
- Keep foreign-key constraints explicit for relational links.
- Keep delete behavior explicit for constrained relationships.
- Keep update behavior explicit where key relations can be impacted.
- Keep domain invariants enforced by constraints and service checks.
- Keep service-level guard checks aligned with schema constraints.
- Keep relation naming and constraint naming predictable.

## Review Plan Layout
- Report added or changed constraints and affected entities.
- Report delete and update behavior changes across relation boundaries.
- Report service-level guard logic added for integrity protection.
- Report risks of orphan records or invalid relations.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never remove referential constraints without explicit approval.
- Never introduce delete flows that bypass relation safeguards.
- Never accept integrity-breaking updates without controlled migration.
