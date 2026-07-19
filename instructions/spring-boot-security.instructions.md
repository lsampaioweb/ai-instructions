---
description: "Spring Boot security contract for deterministic authentication, authorization, and least-privilege endpoint protection in production-grade projects."
applyTo: "**/src/main/java/**/security/**/*.java, **/src/main/resources/application*.yml, **/pom.xml"
---

# Spring Boot Security Contract
Use this file to enforce deterministic security behavior.

## Scope
1. Apply to security configuration, identity providers, method authorization, and security-related runtime properties.
2. Keep security policy centralized and explicit per feature.

## Coordination Order
1. Apply [spring-boot-service.instructions.md](./spring-boot-service.instructions.md) first for generic service orchestration and transaction baseline rules.
2. Apply [spring-boot-config.instructions.md](./spring-boot-config.instructions.md) first for generic YAML configuration baseline rules.
3. Apply [spring-boot-pom.instructions.md](./spring-boot-pom.instructions.md) first for generic dependency and plugin baseline rules.
4. Apply this file for security-specific constraints that supplement those baselines.

## Authentication Rules
1. Keep authentication mechanism explicit in security configuration.
2. Keep password storage encoded using a strong PasswordEncoder implementation.
3. Keep credentials externalized through environment variables or secret stores.
4. Keep identity provider wiring behind UserDetailsService or equivalent abstraction.

## Authorization Rules
1. Keep authorization least-privilege with explicit allowlist matchers.
2. Keep a deny-by-default fallback for unmatched routes.
3. Keep role and authority names centralized in enum or constants.
4. Keep permission decisions centralized in dedicated policy components used by @PreAuthorize.

## Endpoint Protection Rules
1. Keep actuator health probes explicitly separated from broader actuator access.
2. Keep OpenAPI and Swagger exposure profile-aware and disabled in production by default.
3. Keep write operations authenticated and authorized with explicit policy checks.
4. Keep public read endpoints explicitly declared and bounded by path and method.

## Session and CSRF Rules
1. Keep REST APIs stateless when session cookies are not used.
2. Disable CSRF only with explicit stateless API rationale.
3. Keep session creation policy explicit.
4. Keep CORS policy explicit when browser cross-origin clients are supported.

## Service and Controller Alignment Rules
1. Keep method-level authorization aligned with controller route protection.
2. Keep security decisions out of controller business orchestration.
3. Keep service capabilities annotated with deterministic permission contracts when method security is enabled.
4. Keep error semantics aligned with centralized exception and error-code contracts.

## Quality Gates
1. Forbid hardcoded credentials, tokens, or private keys in source-controlled files.
2. Forbid broad permit-all matchers for protected API surfaces.
3. Forbid role literals scattered across controllers and services when role constants exist.
4. Keep tests covering authenticated success paths, unauthenticated paths, and forbidden paths.
