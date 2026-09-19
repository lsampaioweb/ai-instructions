---
description: "Spring Boot Actuator dependency, endpoint exposure, health details, security, container probes, tracing, and verification."
applyTo: "**/application*.yml, **/*Actuator*.java, **/*Actuator*Test.java"
---

## Dependencies
- Add `org.springframework.boot:spring-boot-starter-actuator` when Actuator endpoints are required.

## Rules

### Canonical ownership
- Treat this file as the canonical owner for Actuator endpoint exposure, health-check visibility, and public health-route policy.
- When another instruction file mentions Actuator exposure or health-check behavior, defer to this file instead of restating the rule.

### Endpoint exposure
- Configure web endpoint exposure explicitly with `management.endpoints.web.exposure.include`.
- Expose only `health` and `info` by default.
- Allow `metrics`, `prometheus`, or any additional actuator endpoint only with explicit module-level opt-in.
- Record the reason for any non-default actuator exposure in configuration comments or documentation.
- Do not use `include: "*"` unless every exposed endpoint has been reviewed and explicitly approved.
- Configure the `info` endpoint to expose at most application name and version.
- Set `management.endpoints.web.base-path` to `/actuator` explicitly in `application.yml`; override it in a profile file only when that profile uses a different base path.
- Configure the management server on a dedicated port (`8081` by default) to isolate actuator endpoints from application traffic.

### Health details and probes
- Keep base health details set to `when-authorized` unless a stricter policy is required.
- Set `management.endpoint.health.show-details` to `always` only in a development profile.
- Set `management.endpoint.health.show-details` to `when-authorized` or `never` outside development.
- Allow profile-specific health detail overrides when justified by environment needs.
- Set `management.endpoint.health.probes.enabled: true` in `application.yml` for container-aware deployments to activate `/actuator/health/liveness` and `/actuator/health/readiness`.
- Configure explicit liveness (`/actuator/health/liveness`) and readiness (`/actuator/health/readiness`) probe groups for container deployments.

### Security
- Permit unauthenticated access to `/actuator/health` and `/actuator/health/**` when health checks are used by load balancers or container orchestration.
- Keep non-health actuator endpoints authenticated when Spring Security is active.
- Obtain Actuator credentials from external configuration.

### Metrics and tracing
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

### Verification
- Test anonymous access to the public health endpoint when Actuator security is configured.
- Test that protected exposed endpoints reject anonymous requests and accept authenticated requests.
- Test the configured health-detail visibility for each profile that changes it.

## Approved Exception Handling
- If non-health actuator endpoints are exposed without Spring Security, document that exception explicitly.

## Safety Guards
- Never weaken production actuator controls silently.
- Never include PII, credentials, or sensitive request data as span tags or baggage items.
- Never commit a local-development fallback exporter endpoint in `application.yml`.

## Reference
- Use [samples/spring-boot-application.tpl](samples/spring-boot-application.tpl) for the canonical `management` configuration.
