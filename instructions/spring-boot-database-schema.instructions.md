---
description: "Database schema conventions: type sizing, naming standards, constraints, and nullability defaults for SQL artifacts."
applyTo: "**/src/main/resources/sql/**/*.xml, **/src/main/resources/sql/**/*.sql"
---

# Spring Boot Database-Schema Engine

## Scope & Analysis
- Inspect SQL DDL files for table, constraint, and index definitions.
- Inspect foreign key relations and delete/update strategies in SQL DDL.
- Inspect SQL/XML naming conventions and data-type consistency.

## Resolution Rules
- Use PostgreSQL as the default relational system-of-record for CRUD modules unless request constraints require a different store.
- Allow in-memory relational storage only for explicit local or demo scope.
- For new CRUD resources with unspecified entity attributes, treat schema contract as unresolved and ask blocking clarification for table name, required columns, uniqueness, nullability, and key strategy before implementation planning.
- Keep table and column naming consistent and predictable.
- Keep SQL types aligned with Java model semantics.
- Keep nullable-by-default decisions explicit: mark required fields with `NOT NULL` and leave optional fields nullable by design.
- Keep SQL DDL idempotent for repeatable local setup where applicable.
- Keep seed-data statements idempotent when committed in schema/bootstrap scripts.
- Keep primary, unique, and foreign key constraints explicit in SQL DDL.
- Keep foreign key behavior explicit for delete and update actions in SQL DDL.
- Keep index strategy aligned with query access patterns.
- Add a `CREATE INDEX IF NOT EXISTS` for every foreign key column in SQL DDL; FK columns are always candidates for JOIN and filter queries.
- Keep SQL XML query keys and statement intent stable and resource-scoped (for example `sql.users.find-by-id`).

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
- Never add a FK constraint without a corresponding index on the FK column.
