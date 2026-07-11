---
description: "Database migration rules: Flyway/Liquibase selection, versioned scripts, profile behavior, and test integration."
applyTo: "**/pom.xml, **/application*.yml, **/src/main/resources/db/migration/**/*.sql, **/*Test.java, **/*IT.java, **/test/**/*.java"
---

# Database Migration Rules

## Scope
- Use this file when schema changes must be versioned and tracked across environments.
- Keep this file as the canonical source for migration-tool behavior.

## Tool Selection
- Prefer Flyway as the default migration tool.
- Use Liquibase only when the user explicitly requests it or existing project standards require it.
- Do not enable Flyway and Liquibase in the same application unless the user explicitly requests a dual-tool strategy.

## Script Location and Naming
- Store Flyway SQL migrations under `src/main/resources/db/migration/`.
- Use Flyway naming format `V<version>__<description>.sql`.
- Keep migration descriptions lowercase with underscores.
- Never edit an already applied migration in shared environments; add a new migration instead.

## Environment Behavior
- Keep migrations enabled for development and production when migration tooling is in scope.
- Avoid relying on `spring.sql.init` DDL execution when Flyway or Liquibase is active.
- Keep schema evolution in migration scripts, not in ad-hoc startup SQL execution.

## Rollback and Safety
- Treat rollback as forward-fix by default: create a new migration that restores intended state.
- For destructive schema changes, require explicit user confirmation and clear impact notes.
- Keep data backfill and schema changes in ordered, reviewable steps.

## Test Profile
- Ensure tests execute migrations against an isolated test database profile when persistence behavior is under test.
- Keep test schema creation aligned with migration scripts to prevent drift.
- Do not depend on production databases for migration-related tests.

## Documentation and Review
- Record migration intent and impact in change summaries.
- When introducing migrations into a project that previously used `schema.sql`, document the transition plan.
