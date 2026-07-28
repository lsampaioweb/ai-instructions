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
- Default primary keys and row identifiers to `INTEGER` for standard CRUD business tables; use `SMALLINT` only for clearly bounded low-cardinality domains expected to stay below 32767 rows for the full lifecycle, and use `BIGINT` only when stated scale expectations or lifetime cardinality can exceed `INTEGER` limits.
- When expected row count, identifier growth, or retention horizon is unclear enough to justify `SMALLINT` or `BIGINT` instead of the default `INTEGER`, ask blocking clarification for expected maximum rows and growth horizon before finalizing key or counter column types.
- Enforce deterministic SQL naming conventions across table, column, index, and constraint identifiers; do not allow per-task naming drift.
- Treat deterministic naming-rule violations as blocking for schema approval.
- Use singular snake_case for table names and avoid generic table tokens such as `tbl`, `data`, or `obj`; allow `_tmp` only for explicit temporary-table intent documented with a short DDL comment describing lifecycle and cleanup trigger.
- Name primary key columns as `<table_name>_id`; do not use generic standalone names such as `id`.
- Name foreign key columns as `<referenced_table_name>_id` and keep the referenced table token explicit.
- Name non-key columns with domain-qualified semantics; do not use ambiguous standalone names such as `name`, `value`, `type`, `status`, or `date` without a domain qualifier.
- Use `pk_<table_name>` for primary key constraints.
- Use `fk_<source_table>_<target_table>` for foreign key constraints.
- Use `uq_<table_name>_<column_name>` for unique constraints.
- Use `ck_<table_name>_<rule_name>` for check constraints.
- Use `ix_<table_name>_<column_name>` for non-unique indexes and `ux_<table_name>_<column_name>` for unique indexes.
- For composite unique constraints or composite indexes, append column tokens in declaration order using underscores.
- When business terminology is insufficient to produce deterministic, domain-qualified names, ask blocking clarification before schema finalization.
- Apply naming examples for consistency checks: good `customer_account.customer_account_id`, `customer_account.account_display_name`, `order_item.product_id`, `fk_order_item_product`, and `ix_order_item_order_id`; avoid `customer_account.id`, `customer_account.name`, `order_item.product`, `fk_order_item_prod_tbl`, and `idx1`.
- Keep SQL types aligned with Java model semantics by choosing numeric, temporal, and text types from domain range, precision, and persistence behavior rather than convenience defaults.
- Keep nullable-by-default decisions explicit: mark required fields with `NOT NULL` and leave optional fields nullable by design.
- Keep SQL DDL idempotent for repeatable local setup where applicable.
- Place SQL DDL schema files under `src/main/resources/sql/db/`; place SQL query files (XML property sources) directly under `src/main/resources/sql/`; never mix DDL and query files in the same directory.
- Keep seed-data statements idempotent when committed in schema/bootstrap scripts.
- Keep primary, unique, and foreign key constraints explicit in SQL DDL.
- Keep foreign key behavior explicit for delete and update actions in SQL DDL.
- Keep index strategy aligned with query access patterns.
- Add a `CREATE INDEX IF NOT EXISTS` for every foreign key column in SQL DDL; FK columns are always candidates for JOIN and filter queries.

## Safety Guards
- Never remove integrity constraints without explicit approval.
- Never introduce destructive DDL without migration strategy.
- Never apply schema changes that violate referential integrity rules.
- Never add a FK constraint without a corresponding index on the FK column.

## Review Plan Layout
- Report table and column changes.
- Report constraint and relation changes.
- Report index additions or removals with query rationale.
- Report backward-compatibility risks for schema updates.

