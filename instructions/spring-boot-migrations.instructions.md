---
description: "Spring Boot migrations contract for deterministic versioned SQL changes, safe roll-forward strategy, and environment-consistent schema evolution in production-grade projects."
applyTo: "**/src/main/resources/db/migration/*.sql, **/src/main/resources/sql/**/*.sql, **/src/main/resources/application*.yml, **/src/main/resources/application*.yaml, **/pom.xml"
---

# Spring Boot Migrations Contract
Use this file to enforce deterministic schema evolution and retention transition execution.

## Scope
1. Apply to SQL schema scripts, migration scripts, and migration-related runtime configuration.
2. Keep migration behavior aligned across development, test, and production profiles.

## Coordination Order
1. Apply [spring-boot-database-schema.instructions.md](./spring-boot-database-schema.instructions.md) first for table, key, and constraint design rules.
2. Apply this file second for migration versioning, sequencing, roll-forward strategy, and runtime execution behavior.

## Script Design Rules
1. Keep migration and schema scripts idempotent where repeated execution is possible.
2. Keep table and index creation guarded to avoid duplicate-object failures.
3. Keep seed and baseline data inserts idempotent.
4. Keep migration steps ordered deterministically by dependency and foreign key constraints.

## Evolution Rules
1. Keep schema evolution backward-compatible before destructive transitions.
2. Keep destructive changes isolated behind explicit compatibility windows.
3. Keep rollback strategy explicit through forward-fix migrations when direct rollback is unsafe.
4. Keep migration changes aligned with repository and mapper SQL contracts.

## Runtime Configuration Rules
1. Keep migration or schema-init mode explicit per profile.
2. Keep test profile schema initialization deterministic for isolated test execution.
3. Keep production initialization mode least-privilege and operationally controlled.
4. Keep migration execution source paths explicit and version-controlled.

## Data Lifecycle Transition Rules
1. Keep lifecycle transitions from active to history and history to archive or purge executed by explicit migration or batch routines.
2. Keep lifecycle cutoff windows externalized in configuration.
3. Keep lifecycle migration jobs idempotent and resumable across failures.
4. Keep lifecycle exception data classes excluded from automated purge routines.

## Quality Gates
1. Forbid editing previously released migration scripts without explicit repair strategy.
2. Forbid non-deterministic migration scripts that depend on environment-local side effects.
3. Keep verification tests for schema initialization, migration ordering, and lifecycle transitions.
