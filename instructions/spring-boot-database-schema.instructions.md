---
description: "Spring Boot database schema contract for deterministic table design, naming consistency, and production-safe evolution in relational persistence projects."
applyTo: "**/src/main/resources/db/migration/*.sql, **/src/main/resources/sql/**/schema.sql, **/src/main/resources/sql/**/*.sql"
---

# Spring Boot Database Schema Contract
Use this file to enforce deterministic relational schema design.

## Scope
1. Apply to SQL schema and migration scripts that define relational structures.
2. Keep schema rules aligned with repository SQL and mapper contracts.

## Naming and Structure Rules
1. Keep table, column, constraint, and index names explicit and stable.
2. Keep primary key constraints explicitly declared.
3. Keep unique constraints explicitly declared for business-unique fields.
4. Keep foreign key constraints explicitly named and scoped.
5. Keep column nullability explicit for every persisted field.

## Integrity and Type Rules
1. Keep data types aligned with domain cardinality and precision requirements.
2. Keep CHECK constraints explicit for bounded numeric and domain invariants.
3. Keep referential actions explicit for foreign keys when delete or update behavior matters.
4. Keep default values explicit only when domain semantics require defaults.

## Evolution Rules
1. Keep schema changes backward-compatible before destructive transitions.
2. Keep destructive changes isolated and sequenced after compatibility windows.
3. Keep seed data idempotent when included in schema scripts.
4. Keep indexes explicit for high-frequency lookup columns.

## Alignment Rules
1. Keep schema definitions aligned with repository query contracts.
2. Keep pagination and sorting columns indexed where endpoint usage requires it.
3. Keep README operational expectations aligned with schema initialization behavior.
4. Forbid assumptions that depend on JPA entity auto-generation.

## Quality Gates
1. Forbid unnamed constraints in production schema scripts.
2. Forbid nullable foreign keys when relation is mandatory by domain rules.
3. Keep tests or verification queries covering key constraints and index expectations.
