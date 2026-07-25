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
- Expose only `health` and `info` by default.
- Allow `metrics`, `prometheus`, or any additional actuator endpoint only with explicit module-level opt-in.
- Record the reason for any non-default actuator exposure in configuration comments, documentation, or tests.
- Keep base health details set to `when-authorized` unless a stricter policy is required.
- Allow profile-specific health detail overrides when justified by environment needs.
- Prefer `always` only for local or development profiles.
- Prefer `never` for production profiles unless an authenticated operational requirement is documented.
- Keep /actuator/health publicly accessible for probes.
- Keep non-health actuator endpoints authenticated when Spring Security is active.
- If non-health actuator endpoints are exposed without Spring Security, document that exception explicitly.
- Keep actuator policy consistent across configuration, security rules, tests, and documentation.
- Add integration coverage for actuator access rules when a module defines actuator-specific security rules.

## Review Plan Layout
- Report actuator endpoints exposed in each active profile.
- Report any non-default actuator endpoint exposure and the recorded operational reason.
- Report base and profile-specific health detail policies.
- Report security matcher rules for `/actuator/health` and `/actuator/**`.
- Report whether actuator exposure is covered by configuration, security rules, tests, and documentation.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never expose all actuator endpoints with wildcard include settings.
- Never expose `metrics`, `prometheus`, or other non-default actuator endpoints without documented justification.
- Never expose non-health actuator endpoints publicly without explicit approval.
- Never document actuator exposure that does not match runtime configuration.
