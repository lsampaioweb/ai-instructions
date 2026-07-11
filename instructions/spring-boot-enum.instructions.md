---
description: "Enum conventions: naming, DB storage, API serialization, validation, OpenAPI docs, and migration safety."
applyTo: "**/*.java, **/mapper/**/*.xml, **/sql/**/*.xml"
---

# Enum Rules

## Scope
- Use this file as the canonical source for enum conventions across API, service, and persistence layers.

## Naming
- Use `UPPER_SNAKE_CASE` for enum constants.
- Use singular enum type names that describe one domain concept (for example: `CountryStatus`).
- Do not encode transport or storage concerns in enum type names.

## Database Storage
- Prefer storing enum values as `VARCHAR` names.
- Keep SQL columns and mapper configuration aligned to string-based enum values.
- Accept ordinal storage only when the user explicitly requests it and provides a clear reason.
- When ordinal storage is accepted, document the reason and migration risks in the change summary.

## API Serialization
- Keep API enum serialization stable and explicit.
- Use `@JsonValue` only when API wire values must differ from enum constant names.
- Use `@JsonCreator` or explicit conversion logic when accepting custom wire values.
- Do not expose ordinal values in JSON payloads.

## Input Validation
- Validate incoming enum text at the request boundary.
- Return HTTP 400 for unknown enum values.
- Keep validation error responses aligned with `spring-boot-exception.instructions.md`.

## OpenAPI Contract
- Document enum fields with OpenAPI schema metadata.
- Use `@Schema(enumAsRef = true)` for reusable enum schema components.
- Keep enum value documentation synchronized with runtime accepted values.

## Migration Safety
- Treat enum value renames and removals as breaking changes.
- Add new enum values in backward-compatible order and keep old values accepted during migration windows when required.
- For persisted enums, plan data migration scripts before removing or renaming values.
- Document enum lifecycle changes in release notes and API versioning notes when they affect clients.
