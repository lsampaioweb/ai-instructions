---
description: "Spring Boot enum contract for deterministic closed-set domain values in API, domain, and persistence boundaries."
applyTo: "**/src/main/java/**/*Enum.java"
---

## Naming Conventions
- Name enum types after the closed-set domain concept they represent, without a redundant `Enum` suffix in the type name itself unless the file-matched convention requires it (e.g., `HolidayType`, `AccountStatus`).
- Use UPPER_SNAKE_CASE for all enum constants.

## Rules
- Use an enum only for a truly closed, stable set of domain values known at compile time.
- Keep enum constants free of business logic beyond simple derived accessors (e.g., a display label or a stable code).
- Provide a stable, explicit string code for each enum constant when the value crosses an API, persistence, or message boundary; do not rely on `Enum#name()` or `Enum#ordinal()` for external representations.
- Map an enum to and from its external representation explicitly (e.g., via Jackson `@JsonValue`/`@JsonCreator` or a dedicated converter) rather than relying on default serialization when the codebase-external contract must remain stable across refactors.
- Keep enum-to-database mapping explicit and code-based, not ordinal-based.
- Reject unknown external values explicitly with a clear domain error instead of silently defaulting to a constant.

## Safety Guards
- Never persist or transmit an enum's ordinal value as its external representation.
- Never add mutable state to an enum constant.
