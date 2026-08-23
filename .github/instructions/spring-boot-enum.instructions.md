---
description: "Spring Boot enum contract for deterministic closed-set domain values in API, domain, and persistence boundaries."
applyTo: "**/src/main/java/**/*Enum.java"
---

# Spring Boot Enum

## Naming Conventions
- Use the `*Enum` suffix for all enum class names (e.g., `UserStatusEnum`, `OrderStateEnum`).
- Include the domain context as a prefix in every enum class name (e.g., `UserStatusEnum`, not `StatusEnum`).
- Use domain-specific enum names (never `TypeEnum`, `StatusEnum`, or other generic names without a domain prefix).

## Rules
- Keep enum values stable after public release.
- Treat adding a new enum value to a public API contract as a breaking change.
- Document new enum value additions in the API changelog.
- Keep enum names expressive and domain-specific.
- Keep enum-to-string behavior explicit when used in contracts.
- Serialize enums as their `name()` string value in all API and message contracts (not ordinal).
- Apply `@JsonValue` only when the serialized API value must differ from the Java constant name.
- Declare a `@JsonCreator` factory method on enums used in API request bodies to control string-to-enum deserialization.
- Add an `UNKNOWN` fallback constant annotated with `@JsonEnumDefaultValue` when the enum is sourced from an external API or message broker that may introduce new values.
- Store application-owned enum domains in relational persistence through a dedicated lookup/reference table plus a foreign-key column in the business table.
- Keep a stable code column in the lookup/reference table for mapping between the Java enum `name()` and the relational row.
- Store enum values as strings in relational persistence only when the enum is external-system-owned, transient, or the user explicitly rejects a lookup/reference table design.
- Declare enum constructor parameters as `private` and their backing fields as `final`.
- Keep helper methods deterministic and side-effect free.

## Safety Guards
- Never repurpose existing enum values for new semantics.
- Never introduce contract-breaking enum changes silently.
- Never duplicate enum meaning in string literals across code.
- Never use ordinal-style numeric persistence to represent enum meaning directly in a business table.
