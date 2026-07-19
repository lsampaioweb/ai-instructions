---
description: "Spring Boot observability contract for health, metrics, and operational visibility with secure production defaults."
applyTo: "**/src/main/resources/application*.yml, **/README.md"
---

# Spring Boot Observability Contract
Use this file to enforce runtime visibility and operational safety.

## Health and Endpoint Baseline
1. Apply [spring-boot-actuator.instructions.md](./spring-boot-actuator.instructions.md) as canonical source for health endpoint exposure and detail visibility behavior.
2. Keep observability-specific endpoint documentation aligned with actuator configuration.

## Metrics Baseline
1. Enable metrics exposure only for required operational consumers.
2. Keep metric export configuration explicit when external monitoring backends are enabled.
3. Keep metric naming and tags stable to preserve dashboard and alert compatibility.

## Security and Access Control
1. Protect management endpoints with network and/or application-level access controls.
2. Keep production settings aligned with least-privilege observability access.
3. Do not expose sensitive runtime metadata in unauthenticated endpoints.

## Configuration Discipline
1. Keep observability settings profile-aware.
2. Keep development diagnostics higher than production diagnostics.
3. Externalize environment-specific observability endpoints and credentials.

## Reliability and Performance
1. Keep observability overhead bounded and non-blocking for request handling.
2. Avoid unbounded cardinality in metric labels or dimensions.
3. Keep scrape/export intervals and payload size aligned with system capacity.

## Instrumentation (When Adopted)
1. Instrument critical business and integration paths with consistent metric conventions.
2. Ensure instrumentation failures do not break business operations.
3. Keep instrumentation libraries isolated from business logic.

## Operational Verification
1. Validate health endpoint behavior in development and production profiles.
2. Validate expected metrics availability for enabled monitoring integrations.
3. Validate observability behavior during dependency degradation and recovery.
