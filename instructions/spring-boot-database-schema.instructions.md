---
description: "Database schema conventions: type sizing, naming standards, constraints, and nullability defaults for SQL artifacts."
applyTo: "**/src/main/resources/sql/**/*.xml, **/src/main/resources/sql/**/*.sql"
---

# Spring Boot Database-Schema Engine

## Scope & Analysis
- Inspect schema files for table, constraint, and index definitions.
- Inspect foreign key relations and delete/update strategies.
- Inspect naming conventions and data-type consistency.

## Resolution Rules
- Keep DDL idempotent for repeatable local setup where applicable.
- Keep table and column naming consistent and predictable.
- Keep primary, unique, and foreign key constraints explicit.
- Keep foreign key behavior explicit for delete and update actions.
- Keep index strategy aligned with query access patterns.
- Keep SQL types aligned with Java model semantics.

## Review Plan Layout
- Report table and column changes.
- Report constraint and relation changes.
- Report index additions or removals with query rationale.
- Report backward-compatibility risks for schema updates.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never remove integrity constraints without explicit approval.
- Never introduce destructive DDL without migration strategy.
- Never apply schema changes that violate referential integrity rules.
