---
description: "Spring Boot observability contract for health, metrics, and operational visibility with secure production defaults."
applyTo: "**/src/main/resources/application*.yml"
---

# Spring Boot Observability Engine

## Scope & Analysis
- Inspect management and actuator configuration for each active profile.
- Inspect health endpoint detail visibility and authorization behavior.
- Inspect runtime metrics exposure and endpoint access boundaries.

## Resolution Rules
- Keep observability settings profile-aware.
- Include metrics exposure only when runtime monitoring requires it.
- Keep metrics exposure, endpoint visibility, and health-detail posture consistent across active profiles.
- Keep profile-level observability posture explicit (for example development visibility versus production restriction).
- Document each non-default observability posture decision and operational reason.

## Safety Guards
- Never weaken production observability controls silently.

## Review Plan Layout
- Report exposed actuator endpoints per profile.
- Report any new endpoint exposure and operational purpose.
- Report health-detail policy and access model.
- Report deferred observability requirements with reason.

