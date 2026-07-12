---
description: "Spring Boot enum contract for deterministic closed-set domain values and security role mappings in production-grade projects."
applyTo: "**/src/main/java/**/*Enum.java, **/src/main/java/**/security/Role.java"
---

# Spring Boot Enum Contract
Use this file to enforce stable enum usage and role authority mapping.

## Scope
1. Apply to domain enums and security role enums.
2. Use enums only for closed and stable value sets.

## Determinism Rules
1. Keep one enum type per file.
2. Keep enum constant names immutable after release.
3. Forbid ordinal-based persistence, serialization, or API contracts.
4. Keep external representations string-based and explicitly controlled.
5. Forbid silently accepting unknown enum values and throw IllegalArgumentException including enum type and offending value.

## Security Role Rules
1. Keep role names centralized in security Role enum as single source of truth.
2. Keep authority conversion deterministic by deriving from enum constant name.
3. Forbid hardcoded ROLE_* strings outside role or permission utilities.
4. Keep authorization checks bound to role constants, not duplicated literals.

## Boundary Rules
1. Keep user-facing localized labels outside enum constants.
2. Keep transport and persistence mapping logic outside enum declarations.
3. Keep enum evolution backward-compatible for published API payloads.

## Quality Gates
1. Forbid introducing enum values without verifying security and API impact.
2. Forbid duplicate semantic values split across multiple enum types.
3. Keep tests covering authority mapping and unknown-value handling.
