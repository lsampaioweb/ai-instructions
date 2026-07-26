---
description: "Spring Boot observability contract for health, metrics, and operational visibility with secure production defaults."
applyTo: "**/src/main/resources/application*.yml"
---

# Spring Boot Observability Engine

## Scope & Analysis
- Inspect management and actuator configuration for each active profile.
- Inspect health endpoint detail visibility and authorization behavior.
- Inspect runtime metrics exposure and endpoint access boundaries.
- Treat `spring-boot-actuator.instructions.md` as the canonical authority for endpoint-exposure and health-detail policy decisions when both contracts apply.

## Resolution Rules
- Keep observability settings profile-aware.
- Include metrics exposure only when runtime monitoring requires it.
- Keep health-detail and endpoint-exposure decisions aligned with `spring-boot-actuator.instructions.md`.
- Keep profile-level observability posture explicit (for example development visibility versus production restriction).
- Document each non-default observability posture decision and operational reason.
- Keep this contract focused on operational visibility scope (metrics intent, profile posture, and access boundaries), while endpoint-exposure policy remains canonical in `spring-boot-actuator.instructions.md`.

## Review Plan Layout
- Report exposed actuator endpoints per profile.
- Report any new endpoint exposure and operational purpose.
- Report health-detail policy and access model.
- Report deferred observability requirements with reason.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never expose all actuator endpoints with wildcard settings.
- Never expose sensitive operational endpoints without explicit approval.
- Never weaken production observability controls silently.
