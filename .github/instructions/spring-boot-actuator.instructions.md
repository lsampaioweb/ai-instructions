---
description: "Spring Boot actuator and observability contract: endpoint exposure, health probes, metrics, tracing, sampling, and sensitive-data boundaries."
applyTo: "**/src/main/resources/application*.yml, **/src/test/java/**/*.java"
---

# Spring Boot Actuator Engine

## Rules
- Keep actuator endpoint exposure allowlist-based.
- Expose only `health` and `info` by default.
- Allow `metrics`, `prometheus`, or any additional actuator endpoint only with explicit module-level opt-in.
- Record the reason for any non-default actuator exposure in configuration comments or documentation.
- Configure the `info` endpoint to expose at most application name and version.
- Keep base health details set to `when-authorized` unless a stricter policy is required.
- Allow profile-specific health detail overrides when justified by environment needs.
- Prefer `always` only for local or development profiles.
- Prefer `never` for production profiles unless an authenticated operational requirement is documented.
- Keep `/actuator/health` publicly accessible for liveness and readiness probes.
- Set `management.endpoint.health.probes.enabled: true` in `application.yml` for container-aware deployments to activate `/actuator/health/liveness` and `/actuator/health/readiness`.
- Configure explicit liveness (`/actuator/health/liveness`) and readiness (`/actuator/health/readiness`) probe groups for container deployments.
- Keep non-health actuator endpoints authenticated when Spring Security is active.
- Configure the management server on a dedicated port (`8081` by default) to isolate actuator endpoints from application traffic.
- Set `management.endpoints.web.base-path` to `/actuator` explicitly in `application.yml`.
- Override `management.endpoints.web.base-path` in a profile file only when that profile uses a different base path.
- Include metrics exposure only when runtime monitoring requires it.
- Keep metrics visibility consistent across active profiles.
- Use Micrometer Tracing as the tracing abstraction layer.
- Set `spring.application.name` as the service name for all trace spans.
- Use W3C TraceContext (`traceparent`) as the trace context propagation format.
- Set sampling rate to `1.0` for local and development profiles.
- Set sampling rate to `0.1` or lower for production profiles unless a higher rate is operationally justified and documented.
- Configure the exporter endpoint explicitly in every profile that enables tracing.
- Keep a shared exporter endpoint definition in `application.yml` when all environments use the same externalized property key.
- Override the exporter endpoint in a profile file only when that profile requires a different effective value or a local-development fallback.
- Disable tracing in test classes by setting `management.tracing.sampling.probability=0.0` via environment variable override or inline `@TestPropertySource` in test configuration.
- Use `@Observed` on service methods to create automatic spans via AOP when custom span boundaries are needed.
- Use Micrometer `Baggage` API to propagate contextual key-value pairs (e.g., `user.id`, `tenant.id`) alongside trace context across service boundaries.
- Externalize exporter endpoint URLs as configuration properties.

## Approved Exception Handling
- If non-health actuator endpoints are exposed without Spring Security, document that exception explicitly.

## Safety Guards
- Never expose all actuator endpoints with wildcard include settings.
- Never weaken production actuator controls silently.
- Never include PII, credentials, or sensitive request data as span tags or baggage items.
- Never commit a local-development fallback exporter endpoint in `application.yml`.
