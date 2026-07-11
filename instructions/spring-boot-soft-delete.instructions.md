---
description: "Soft-delete rules: schema columns, query filtering, endpoint semantics, and restore behavior."
applyTo: "**/*Controller.java, **/*Api.java, **/*Repository.java, **/*RepositoryImpl.java, **/*Service.java, **/*ServiceImpl.java, **/*Exception.java, **/*ControllerAdvice.java, **/src/main/resources/sql/**/*.sql, **/mapper/**/*.xml, **/sql/**/*.xml"
---

# Soft Delete Rules

## Scope
- Use this file as the canonical source for soft-delete behavior in reference-data and relationally linked aggregates.

## Data Model
- Prefer soft delete for entities referenced by foreign keys.
- Use `deleted_at TIMESTAMP WITH TIME ZONE NULL` to record deletion time.
- Use `is_active BOOLEAN NOT NULL DEFAULT TRUE` for active-state filtering.
- Keep hard delete only for entities explicitly approved for physical removal.

## Repository and SQL Behavior
- Replace physical delete operations with updates that set `is_active = FALSE` and `deleted_at` to the current UTC timestamp.
- Add `is_active = TRUE` filter predicates to list and lookup queries by default.
- Keep dedicated admin or restore queries explicit when including inactive rows.
- Keep uniqueness checks aligned with soft-delete policy so inactive rows do not create false conflicts unless intended.

## Service Behavior
- Treat delete operations as deactivation unless the endpoint is explicitly defined as hard delete.
- Keep delete operations idempotent: deleting an already inactive entity should not fail unexpectedly.
- Provide restore operations only when business scope requires reactivation.

## API Semantics
- Keep `DELETE` endpoints documented as soft delete when this policy is active.
- Return `204 No Content` for successful soft delete operations.
- Use explicit endpoint naming for hard delete operations when they exist (for example: `DELETE /resource/{id}/hard`).

## Exception Handling
- Return `404` for missing entities.
- For inactive entities hidden by default filters, return `404` unless business requirements mandate `409` or explicit inactive-state errors.
- Keep violation handling consistent with foreign-key and delete-policy rules.

## Auditing and Recovery
- Keep `deleted_at` immutable once set, except during explicit restore flows.
- On restore, set `is_active = TRUE` and clear `deleted_at`.
- Log delete and restore actions at `INFO` with entity identifier and correlation context.
