---
description: "Spring Boot README contract for accurate runbook, API usage, environment setup, and operational guidance in production-grade projects."
applyTo: "**/README.md"
---

# Spring Boot README Contract
Use this file to enforce executable and production-safe project documentation.

## Scope
1. Apply to repository root README and deployable module README files.
2. Keep README content aligned with active profiles and runtime configuration.

## Required Sections
1. Provide overview with capability and boundary summary.
2. Provide prerequisites with explicit Java, Maven, and infrastructure versions.
3. Provide local run steps with profile-aware commands.
4. Provide environment variable table with required and optional markers.
5. Provide API usage section when HTTP endpoints exist.
6. Provide security/auth section when security is enabled.
7. Provide observability section when actuator/metrics are enabled.
8. Provide production section with TLS and operational constraints when production profile exists.

## Command and Config Accuracy
1. Keep commands copy-pastable and profile-explicit.
2. Keep documented ports, paths, and endpoint URLs aligned with application*.yml.
3. Keep variable names in README identical to configuration keys and placeholders.
4. Keep profile names in README identical to declared Spring profiles.
5. Keep API version paths aligned with controller mappings.

## API and Security Documentation
1. Document pagination defaults and limits when pagination is enabled.
2. Document request and response examples for create and update operations.
3. Document authentication mechanism and authorization matrix by operation type.
4. Document machine-readable error behavior and expected status codes.

## Operability Requirements
1. Document health, info, and metrics endpoints only when exposed.
2. Document Swagger/OpenAPI availability by profile when openapi is enabled.
3. Document startup dependencies and failure troubleshooting steps.
4. Do not publish secrets, real credentials, or internal-only endpoints.

## Quality Gates
1. Forbid stale commands or endpoints that do not match current code and config.
2. Forbid placeholder sections without actionable runbook content.
3. Keep troubleshooting steps deterministic and bounded.
