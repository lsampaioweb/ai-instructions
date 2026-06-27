---
description: "Actuator and health check rules: dependency setup, endpoint exposure, security, and custom health indicators."
applyTo: "**/*ActuatorConfig*.java, **/*HealthIndicator.java, **/management/**/*.java, **/application*.yml"
---

# Actuator and Health Check Rules

## Dependency
Include `spring-boot-starter-actuator` in every project.

## Endpoint Exposure
- Expose only `/actuator/health` (including health subpaths such as `/actuator/health/liveness` and `/actuator/health/readiness`) and `/actuator/info` on the default management port
- Keep all other actuator endpoints disabled by default; enable specific ones in `application.yml` only when operationally required
- For container probes, prefer Spring Boot built-in probe groups (`/actuator/health/liveness` and `/actuator/health/readiness`) instead of a custom `ping` group
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

## Custom Health Indicators
- Implement a `HealthIndicator` for each external dependency (database, message broker, external API)
- Return `Health.down()` with a stable detail key (for example `reason`) and a descriptive value when the dependency is unavailable; avoid exposing raw internal error text in details unless it is explicitly safe for operators
- Keep health indicator classes package-private; register them as `@Component`
- Custom dependency indicators should influence readiness semantics; avoid coupling external dependency state to liveness

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
