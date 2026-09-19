---
description: "PostgreSQL database schema and seed SQL scripts: types, naming, constraints, FK actions, and idempotent DDL."
applyTo: "**/src/main/resources/**/*.sql, **/src/main/resources/sql/**/*.xml"
---

## Dependencies
- Follow `spring-boot-application.instructions.md` for base and profile-specific application configuration.
- Follow `spring-boot-repository.instructions.md` for JDBC repository behavior that uses the schema.
- Follow `spring-boot-architecture-defaults.instructions.md` for the default-datastore decision.

## Naming Conventions
- Name primary schema scripts `schema.sql`.
- Name optional seed-data scripts `insert.sql`.
- Use singular snake_case for table names; avoid generic tokens such as `tbl`, `data`, or `obj`.
- Name primary key columns as `<table_name>_id` (never standalone `id`).
- Name foreign key columns as `<referenced_table_name>_id`.
- Name non-key columns with domain-qualified semantics (never standalone `name`, `value`, `type`, `status`, or `date`).
- Name primary key constraints as `pk_<table_name>`.
- Name foreign key constraints as `fk_<source_table>_<target_table>`.
- Name unique constraints as `uq_<table_name>_<column_name>`.
- Name check constraints as `ck_<table_name>_<rule_name>`.
- Name non-unique indexes as `ix_<table_name>_<column_name>`.
- Name unique indexes as `ux_<table_name>_<column_name>`.
- For composite constraints or indexes, append column tokens in declaration order separated by underscores.

## Rules

### Clarification gates
- When the user prompt does not specify lifecycle, retention, archival, or delete semantics for a new table or column, treat the schema design as unresolved and ask the user before generating DDL.
- When a new relation introduces business-data deletion, retention, archival, or historical-movement consequences and the user prompt is silent, treat the delete behavior as unresolved and ask the user before finalizing the constraint action.

### Types and structure
- Default primary keys and row identifiers to `INTEGER`.
- Use `SMALLINT` only for clearly bounded low-cardinality domains expected to stay below 32,767 rows for the full lifecycle.
- Use `BIGINT` only when stated scale expectations or lifetime cardinality can exceed `INTEGER` limits.
- Declare integer primary keys using `GENERATED ALWAYS AS IDENTITY`.
- Use `TEXT` for variable-length string columns with no business-rule length limit.
- Use `VARCHAR(n)` only when the domain enforces a maximum character length.
- Use `NUMERIC(precision, scale)` for monetary or decimal columns.
- Use `DATE` for calendar-day business fields.
- Use `TIMESTAMPTZ` (timestamp with time zone) for event-time and audit fields.
- Model application-owned closed-set domains through lookup/reference tables plus foreign-key columns in business tables.
- Keep a stable domain code column in each lookup/reference table for idempotent seed data and application mapping.
- Mark required columns with `NOT NULL`.
- Leave optional columns nullable by design.
- Add `CHECK` constraints for database-enforceable domain invariants, such as a non-negative balance.
- Add `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` and `updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` to every business table.
- Omit `created_at` and `updated_at` audit columns only for pure lookup or reference tables with no lifecycle.
- Declare columns in this order within every table: primary key, required foreign keys, business columns, optional foreign keys, audit columns (`created_at`, `updated_at`) last.
- Keep delete mode, retention window, historical-table strategy, and archival behavior as explicit design decisions for every new business table.

### Constraints and indexes
- Use `CREATE TABLE IF NOT EXISTS` for idempotent table definitions.
- Keep primary, unique, and foreign key constraints explicit in SQL DDL.
- Declare unique and check constraints as named `CONSTRAINT` clauses (e.g., `CONSTRAINT uq_users_email UNIQUE (email)`) rather than inline column keywords.
- Declare both `ON DELETE` and `ON UPDATE` actions on every FK constraint.
- Use `ON DELETE RESTRICT` and `ON UPDATE CASCADE` as the default FK action pair.
- Use hard delete (physical `DELETE`) only when the user explicitly confirms there is no soft-delete, archival, or historical-retention requirement.
- Implement soft delete with a `deleted_at TIMESTAMPTZ` column only when explicitly requested; document the retention and cleanup strategy alongside the schema change.
- Use `ON DELETE CASCADE` only for child records with no independent existence.
- Use `ON DELETE SET NULL` only for optional associations; declare the FK column as nullable for these.
- Add a `CREATE INDEX IF NOT EXISTS` for every foreign key column in SQL DDL.
- Treat every non-foreign-key index as an explicit query-shape decision; when the user prompt does not justify that index, ask before generating it.
- When adding a FK constraint to a table with existing data, use `NOT VALID` to add the constraint without scanning existing rows, then run `VALIDATE CONSTRAINT` in a separate transaction.
- For hierarchical or tree-structured data, declare a self-referencing FK on the parent column (e.g., `parent_id REFERENCES same_table(id)`) with `ON DELETE CASCADE` when child nodes have no independent existence.
- Keep domain invariants enforced by explicit SQL constraints and relation actions.

### File organization
- Place SQL DDL schema files under `src/main/resources/sql/db/`.
- Place SQL query files (XML property sources) directly under `src/main/resources/sql/`.
- Keep schema comments focused on table purpose or non-obvious performance decisions; add succinct SQL comments before each business table, lookup/reference table, idempotent seed-data block, and non-obvious index.

### Seed data
- Keep development seed data in a separate SQL script from the schema.
- Keep seed-data statements idempotent and stable across reruns, including lookup/reference seeds.
- Use idempotent inserts with `ON CONFLICT ... DO NOTHING` when seed data can run repeatedly.
- Use seed values that make development and integration-test scenarios understandable.

## Safety Guards
- Never remove integrity or referential constraints without explicit approval.
- Never introduce destructive DDL without a migration strategy.
- Never introduce delete flows that bypass relation safeguards.
- Never accept integrity-breaking updates without controlled migration.

## Reference
- Use [samples/spring-boot-database-schema.tpl](samples/spring-boot-database-schema.tpl) for schema structures.
- Use [samples/spring-boot-database-seed.tpl](samples/spring-boot-database-seed.tpl) for seed-data structures.
- Use [samples/spring-boot-application-development.tpl](samples/spring-boot-application-development.tpl) for SQL-initialization configuration.
