---
description: "Actuator and health check rules: dependency setup, endpoint exposure, security, and custom health indicators."
applyTo: "**/*ActuatorConfig*.java, **/*HealthIndicator.java, **/management/**/*.java, **/application*.yml, **/pom.xml"
---

# Actuator and Health Check Rules

## Scope
- Applies to health endpoints, probe exposure, and custom dependency health indicators

## Dependency
Include `spring-boot-starter-actuator` in every project.

## Endpoint Exposure
- Expose only `/actuator/health` (including health subpaths such as `/actuator/health/liveness` and `/actuator/health/readiness`) and `/actuator/info`
- Serve exposed actuator endpoints on the default management port unless a dedicated management port is explicitly required
- Keep all other actuator endpoints disabled by default; enable specific ones in `application.yml` only when operationally required
- For container probes, use Spring Boot built-in probe groups (`/actuator/health/liveness` and `/actuator/health/readiness`) instead of a custom `ping` group
- Enable probes explicitly outside Kubernetes with `management.endpoint.health.probes.enabled: true`
- Keep liveness independent from external dependencies; include external checks in readiness only when the dependency is truly required to serve traffic

```yaml
management:
  endpoints:
    web:
      exposure:
        include: "health,info"
  endpoint:
    health:
      show-details: "when-authorized"
      probes:
        enabled: true
```

## Security
- Secure actuator endpoints; never expose them unauthenticated in production
- Use a dedicated management port (`management.server.port`) to isolate actuator traffic from the application API
- Do not route actuator endpoints through a public API gateway
- For authentication and authorization rules, follow `spring-boot-security.instructions.md`

## Custom Health Indicators
- Implement a `HealthIndicator` for each external dependency (database, message broker, external API)
- Return `Health.down()` with a stable detail key (e.g., `reason`) and descriptive value when the dependency is unavailable
- Do not expose raw internal error text in health details unless the value is explicitly reviewed and documented as operator-safe
- Keep health indicator classes package-private; register them as `@Component`
- Custom dependency indicators must influence readiness semantics; do not couple external dependency state to liveness

## Templates

Custom `HealthIndicator`. Replace `{Dependency}` with the external system name (e.g. `PaymentGateway`, `Cache`, `MessagingBroker`).

```java
@Slf4j
@Component
class {Dependency}HealthIndicator implements HealthIndicator {

  private static final String LOG_HEALTH_{DEPENDENCY}_DOWN = "health.{dependency}.down";

  private final {Dependency}Client {dependency}Client;
  private final LogMessages logMessages;

  {Dependency}HealthIndicator({Dependency}Client {dependency}Client, LogMessages logMessages) {
    this.{dependency}Client = {dependency}Client;
    this.logMessages = logMessages;
  }

  @Override
  public Health health() {
    try {
      {dependency}Client.ping();

      return Health.up().build();
    } catch (Exception ex) {
      log.warn(logMessages.get(LOG_HEALTH_{DEPENDENCY}_DOWN), ex.getMessage());

      return Health.down()
        .withDetail("reason", ex.getMessage())
        .build();
    }
  }
}
```
