---
description: "Spring Boot observability contract for health, metrics, and operational visibility with secure production defaults."
applyTo: "**/src/main/resources/application*.yml, **/README.md"
---

# Spring Boot Observability Engine

## Scope & Analysis
- Inspect management and actuator configuration for each active profile.
- Inspect health endpoint detail visibility and authorization behavior.
- Inspect runtime metrics exposure and endpoint access boundaries.

## Resolution Rules
- Expose only health and info by default.
- Require explicit opt-in for any additional actuator endpoint.
- Keep endpoint exposure allowlist-based.
- Keep health details restricted when unauthenticated.
- Keep observability settings profile-aware.
- Document every non-default exposed endpoint with reason.

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
