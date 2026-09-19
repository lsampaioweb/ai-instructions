---
description: "Spring Security filter chains, route authorization, authentication defaults, CSRF decisions, and security tests."
applyTo: "**/*SecurityConfig.java, **/*SecurityConfiguration.java, **/*SecurityProperties.java, **/*SecurityConfigurationProperties.java, **/*Security*Test.java, **/security/**/*.java"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for security configuration and tests.
- Follow `spring-boot-actuator.instructions.md` for Actuator endpoint authorization.
- Follow `spring-boot-openapi.instructions.md` for Springdoc route allowlisting.
- Follow `spring-boot-config.instructions.md` for security-related YAML and profile settings.
- Follow `spring-boot-test.instructions.md` for test scope selection and Spring Boot 4.x test import paths; this file owns only the security-specific MockMvc setup.

## Naming Conventions
- Name Spring Security configuration classes with the `*SecurityConfig` or `*SecurityConfiguration` suffix (e.g., `ApiSecurityConfig`, `WebSecurityConfig`).
- Name a `SecurityFilterChain` bean after the protected integration when multiple filter chains exist.
- Role enums dedicated as a component must use the `*Role` suffix (e.g., `UserRole`, `AccountRole`); a plain `Role` or `Authority` name is acceptable only when self-contained within a security context.
- Permission or authority component classes must use the `*Permissions` or `*Permission` suffix (e.g., `UserPermissions`, `AdminPermission`).
- Use domain-specific security component names (never `SecurityPermission` or `CommonRole`).
- Name tests for security behavior with the `*Security*Test` pattern.

## Rules

### Canonical ownership
- Treat this file as the canonical owner for route authorization, security-chain ordering, authentication strategy, credentials, and profile-specific protection rules.
- When another instruction file discusses security allowlists, route protection, or credential sources, defer to this file instead of copying the rule.

### Security filter chains
- Declare security configuration using a `@Bean SecurityFilterChain` method around explicit route ownership.
- Give a constrained filter chain an explicit `securityMatcher`.
- Apply `@Order` to every `SecurityFilterChain` bean when more than one filter chain is declared in the same module; order multiple filter chains deliberately when their route scopes overlap.
- Order authorization matchers from specific public or protected routes to broader routes.
- End every `SecurityFilterChain` with `anyRequest().denyAll()` to reject all unmatched routes by default.
- Permit only routes with a defined public contract.
- Keep `/error` public only when the application error-dispatch behavior requires it.
- Follow `spring-boot-actuator.instructions.md` for which Actuator endpoints require authentication; enforce that policy through this filter chain's authorization matchers.
- Include Springdoc routes in the public allowlist only while those endpoints are enabled.

### Authentication defaults
- Use JWT stateless authentication (Bearer token) by default for REST APIs.
- Use session-cookie authentication for server-rendered MVC applications.
- Configure HTTP Basic only for machine or operational clients that require it.
- Do not enable form login unless the application requires an interactive browser sign-in flow.
- Set access token expiry to 24 hours by default.
- Externalize JWT signing keys through environment variables or a secrets manager.

### Credentials and roles
- Apply role-based authorization only when a route has a distinct client or operator role.
- Use `ADMIN` and `USER` as the default role set unless the user explicitly defines a different set.
- Use multiple filter chains only when routes require different authentication or session behavior.
- Provision users in-module via `UserDetailsService` by default; ensure the configured authentication source matches the configured credential properties.
- When the module provisions users in-process via `UserDetailsService`, every `Role` enum value must map to at least one provisioned principal in an active profile.
- When an external identity provider manages roles, document that decision explicitly, including where role assignment is enforced.
- Do not retain unused `spring.security.user.*` properties when a custom `UserDetailsService` owns authentication.
- Bind in-memory usernames and passwords from external configuration; assign in-memory users only the roles required by their protected routes.
- Use `BCryptPasswordEncoder` with default strength (10), or another adaptive password encoder, outside explicitly local or demo-only configurations.
- Do not use `{noop}` for deployed credentials.

### CSRF, CORS, and headers
- Disable CSRF protection for stateless JWT REST APIs and when using HTTP Basic authentication.
- Enable CSRF protection for session-based MVC applications.
- Document the reason when CSRF is disabled outside these defaults.
- Retain Spring Security's default HTTP security headers (HSTS, X-Frame-Options, X-Content-Type-Options).
- Configure CORS with explicit allowed-origin lists in production profiles.

### Security tests
- Test anonymous and authenticated outcomes for every public and protected route.
- Assert the expected status code for unavailable routes and protected resources.
- Test the matcher boundary and role requirement of every custom security chain.
- Use `spring-security-test` and apply Spring Security to MockMvc for MVC security tests.
- Test profile-specific authorization allowlist changes when endpoint availability varies by profile.

## Approved Exception Handling
- When temporary open access is approved for a feature or module, document the exception with an expiration condition (e.g., "open until authentication is implemented"), recorded in code comments, configuration, or test annotations so reviewers can identify it as intentional.

## Safety Guards
- Never commit credentials, passwords, or tokens to source control.
- Never use sensitive fallback values in environment placeholders for sensitive configuration.
- Never expose mutating endpoints without explicit authorization checks.
- Never extend `WebSecurityConfigurerAdapter`.
- Never duplicate conflicting authorization logic across layers.
- Never weaken security defaults without explicit approval.
- Never leave unresolved `TODO` or `FIXME` markers inside active security route rules.
- Never issue non-expiring tokens.
- Never store plain-text or weakly hashed passwords.
- Never disable Spring Security's default HTTP security headers without explicit justification.
- Never allow wildcard origins (`*`) in production CORS configuration.
- Never silence security findings that fall outside explicitly approved exceptions.
- Never apply an approved exception to a wider scope than approved.

## Reference
- Use [samples/spring-boot-security-properties.tpl](samples/spring-boot-security-properties.tpl) for externalized security credentials.
- Use [samples/spring-boot-integration-security-config.tpl](samples/spring-boot-integration-security-config.tpl) for a route-scoped integration security chain.
- Use [samples/spring-boot-actuator-security-config.tpl](samples/spring-boot-actuator-security-config.tpl) for an Actuator default-deny security chain.
- Use [samples/spring-boot-security-integration-test.tpl](samples/spring-boot-security-integration-test.tpl) for MockMvc security integration tests.
