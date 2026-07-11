---
description: "Referential integrity rules: foreign-key delete policy, API behavior, and FK violation exception mapping."
applyTo: "**/src/main/resources/sql/**/*.sql, **/mapper/**/*.xml, **/sql/**/*.xml, **/*Repository.java, **/*RepositoryImpl.java, **/*Exception.java, **/*ControllerAdvice.java, **/*Controller.java, **/*Api.java"
---

# Referential Integrity Rules

## Scope
- Use this file as the canonical source for parent-child delete behavior and foreign-key violation handling.

## Foreign Key Delete Policy
- Explicitly define `ON DELETE` behavior for every foreign key.
- Prefer `ON DELETE RESTRICT` for reference-data hierarchies unless cascade delete is explicitly required by business rules.
- Use `ON DELETE CASCADE` only when automatic child removal is a confirmed business requirement.
- Use `ON DELETE SET NULL` only when nullable relationships are intentional and validated at the domain level.

## API Delete Semantics
- Keep API delete behavior consistent with the selected foreign-key policy.
- If delete is blocked by referential integrity (`RESTRICT`), return `409 Conflict` with a domain-safe message.
- Do not expose raw database constraint names in API responses.

## Exception Translation
- Translate Spring `DataIntegrityViolationException` and equivalent FK constraint exceptions to `409 Conflict` when caused by parent-child delete restrictions.
- Keep non-constraint integrity errors mapped according to existing exception policy.
- Resolve response messages through `MessageSource` and existing i18n conventions.

## Service and Repository Boundaries
- Keep referential-integrity decisions in schema design and service behavior; repository methods remain data-access only.
- Do not catch-and-swallow foreign-key exceptions in repositories.
- Service methods may pre-check domain relationships when required for clearer business errors, but database constraints remain the final safeguard.

## Soft Delete Interaction
- When soft delete is active, ensure FK behavior and soft-delete filters do not contradict each other.
- If hard delete endpoints exist alongside soft delete, document which endpoints can trigger FK conflict responses.
