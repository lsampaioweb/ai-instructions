---
description: "Spring Boot actuator contract for endpoint exposure, health detail policy, and security boundary control."
applyTo: "**/*SecurityConfig.java, **/src/main/resources/application*.yml"
---

# Spring Boot Actuator Engine

## Scope & Analysis
- Inspect actuator endpoint exposure settings in base and profile files.
- Inspect health endpoint detail policy for authenticated and unauthenticated access.
- Inspect security rules for actuator route access control.

## Resolution Rules
- Keep actuator endpoint exposure allowlist-based.
- Expose only health and info by default.
- Require explicit opt-in for metrics, prometheus, or any additional actuator endpoint.
- Keep health details set to when-authorized unless a stricter policy is required.
- Keep /actuator/health publicly accessible for probes.
- Keep non-health actuator endpoints authenticated.
- Keep actuator policy consistent across configuration, security rules, and documentation.

## Review Plan Layout
- Report actuator endpoints exposed in each active profile.
- Report any endpoint exposure expansion and operational reason.
- Report health detail visibility policy and access model.
- Report security matcher rules for /actuator/**.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never expose all actuator endpoints with wildcard include settings.
- Never expose non-health actuator endpoints publicly without explicit approval.
- Never document actuator exposure that does not match runtime configuration.
