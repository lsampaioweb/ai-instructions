---
description: "Actuator and health check rules: dependency setup, endpoint exposure, security, and custom health indicators."
applyTo: "**/*ActuatorConfig*.java, **/*HealthIndicator.java, **/management/**/*.java, **/application*.yml, **/pom.xml"
---

# Actuator and Health Check Rules

## Dependency
Include `spring-boot-starter-actuator` in every project.

## Endpoint Exposure
- Expose only `health`, `info`, and `metrics` via `management.endpoints.web.exposure.include: "health,info,metrics"`
- Serve exposed actuator endpoints on the default management port unless a dedicated management port is explicitly required
- Keep all other actuator endpoints disabled by default
- Never use `management.endpoints.web.exposure.include: "*"`
- Enable additional endpoints in `application.yml` only when operationally required and documented in the same file
- For container probes, use Spring Boot built-in probe groups (`/actuator/health/liveness` and `/actuator/health/readiness`) instead of a custom `ping` group
- Enable `management.endpoint.health.probes.enabled: true` when the service runs in containers or behind an orchestrator/load balancer health check
- Allow probes to be omitted for local-only or non-containerized runtimes
- Keep liveness independent from external dependencies; include external checks in readiness only when the dependency is truly required to serve traffic
- Use `management.endpoint.health.show-details: "when-authorized"` in base `application.yml`
- Use `management.endpoint.health.show-details: "always"` only in `application-development.yml`
- Use `management.endpoint.health.show-details: "never"` in `application-production.yml` unless operator-approved diagnostics require otherwise
- See `snippets/config/application.yml` for the required management endpoint YAML structure

## Security
- Secure actuator endpoints in production; allow unauthenticated access only to internal probe endpoints when required by platform health checks
- Use a dedicated management port (`management.server.port`) only when one of these conditions applies: compliance boundary separation, network-plane isolation, or restricted operator-only ingress
- Do not route actuator endpoints through a public API gateway
- For authentication and authorization rules, follow `spring-boot-security.instructions.md`

## Custom Health Indicators
- Implement a custom `HealthIndicator` for each critical external dependency that affects traffic readiness (database, message broker, external API)
- Return `Health.down()` with a stable detail key (e.g., `reason`) and descriptive value when the dependency is unavailable
- Do not expose raw internal error text in health details unless the value is explicitly reviewed and documented as operator-safe
- Keep health indicator classes package-private; register them as `@Component`
- Custom dependency indicators must influence readiness semantics; do not couple external dependency state to liveness

