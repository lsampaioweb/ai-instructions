---
description: "Spring Boot actuator contract for minimal, secure, and operationally useful management endpoint exposure in production-grade projects."
applyTo: "**/src/main/resources/application*.yml, **/src/main/resources/application*.yaml, **/pom.xml"
---

# Spring Boot Actuator Contract
Use this file to enforce deterministic management endpoint behavior.

## Scope
1. Apply when spring-boot-starter-actuator dependency is present or management.endpoints.web.exposure.include is configured.
2. Keep actuator settings profile-aware across development and production.

## Dependency and Exposure Rules
1. Include spring-boot-starter-actuator when project requirements explicitly include health, metrics, or info operational endpoints.
2. Keep management endpoint exposure allowlisted.
3. Forbid wildcard exposure in production profiles.
4. Keep exposed endpoint set minimal and explicit.
5. Keep health, info, and metrics exposure aligned with documented operational needs.

## Health Endpoint Rules
1. Keep health endpoint enabled for platform and load balancer checks.
2. Keep health detail visibility restricted in production.
3. Keep development diagnostics stricter than production diagnostics.
4. Keep liveness and readiness paths available when container orchestration healthchecks are in scope.

## Security Rules
1. Keep non-health actuator endpoints authenticated or network-restricted.
2. Keep health detail access restricted to authorized principals when details are enabled.
3. Forbid exposing sensitive runtime metadata to unauthenticated callers.

## Configuration Accuracy Rules
1. Keep management endpoint configuration consistent between pom dependency set and application profiles.
2. Keep README actuator endpoint documentation aligned with actual exposure configuration.
3. Keep stacktrace and error detail behavior profile-aware and least-privilege in production.

## Quality Gates
1. Forbid actuator enablement without explicit endpoint exposure policy.
2. Forbid production profiles that expose broad management surfaces.
3. Keep container healthcheck paths aligned with configured actuator health routes.
