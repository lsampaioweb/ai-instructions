---
description: "Spring Boot soft-delete contract for deterministic lifecycle state management, retention windows, and archive-safe data handling in production-grade systems."
applyTo: "**/src/main/resources/sql/**/*.sql, **/src/main/resources/sql/**/*.xml"
---

# Spring Boot Soft Delete Contract
Use this file to enforce deterministic soft-delete and data lifecycle behavior.

## Scope
1. Apply to tables and queries that retain records beyond active operational usage.
2. Keep lifecycle policy explicit for each dataset: active, history, and archive or purge.
3. Treat this file as lifecycle policy source of truth, then align with referential-integrity and migrations contracts for implementation.

## Coordination Order
1. Define lifecycle policy in this file.
2. Validate constraints and foreign-key behavior with spring-boot-referential-integrity.instructions.md.
3. Implement SQL execution steps with spring-boot-migrations.instructions.md.

## Lifecycle Policy Rules
1. Define lifecycle stages explicitly for aging data: active window, history window, and archive or purge window.
2. Keep retention windows externalized in configuration, not hardcoded in SQL or Java.
3. Keep retention execution deterministic with explicit schedule and cutoff timestamp source.
4. Keep lifecycle policy documented per table or aggregate.

## Soft Delete State Rules
1. Keep soft-delete state explicit with deterministic marker columns.
2. Keep delete timestamp and delete actor fields explicit when auditability is required.
3. Keep default reads excluding soft-deleted rows unless endpoint purpose is recovery or audit.
4. Reject updates to soft-deleted rows with deterministic not-found or lifecycle-state semantics.

## History and Archive Rules
1. Move expired active data to history storage before purge when configured history window is greater than zero.
2. Keep history retention bounded by configured duration.
3. Purge or archive history records only after retention window is reached.
4. Keep archive and purge operations idempotent and resumable.

## Exception Class Rules
1. Classify immutable identity data and compliance-required records as lifecycle exceptions.
2. Forbid automatic purge for lifecycle-exception data classes.
3. Keep exception list explicit in policy configuration and documentation.

## Query and Integrity Rules
1. Keep repository and mapper queries lifecycle-aware with explicit active-state filters.
2. Keep foreign key and referential rules compatible with soft-delete and archive flow.
3. Keep unique constraints designed to avoid collisions across active and archived records.

## Quality Gates
1. Forbid lifecycle jobs without dry-run validation and deterministic cutoff criteria.
2. Keep tests covering active-to-history transition, history-to-purge transition, and exception-class protection.
3. Keep audit logs for lifecycle transitions and purge actions.
