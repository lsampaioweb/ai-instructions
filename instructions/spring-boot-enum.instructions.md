---
description: "Spring Boot enum contract for deterministic closed-set domain values and security role mappings in production-grade projects."
applyTo: "**/src/main/java/**/*Enum.java"
---

# Spring Boot Enum Engine

## Scope & Analysis
- Inspect enum types used in API, domain, and security boundaries.
- Inspect enum serialization and persistence-facing usage.
- Inspect enum helper methods used by security or mapping logic.

## Resolution Rules
- Keep enum values stable after public release.
- Keep enum names expressive and domain-specific.
- Keep enum-to-string behavior explicit when used in contracts.
- Keep security enums aligned with authorization conventions.
- Keep helper methods deterministic and side-effect free.
- Keep hardcoded duplicate constants out of business logic.

## Review Plan Layout
- Report enum values added, removed, or renamed.
- Report serialization or contract impact for enum changes.
- Report security-impact changes for role or authority enums.
- Report migration notes when enum evolution is breaking.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never repurpose existing enum values for new semantics.
- Never introduce contract-breaking enum changes silently.
- Never duplicate enum meaning in string literals across code.
