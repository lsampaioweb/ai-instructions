---
description: "Spring Boot security contract for authentication, authorization, service-level checks, and endpoint protection boundaries."
applyTo: "**/*SecurityConfig.java, **/security/**/*.java"
---

# Spring Boot Security

## Naming Conventions
- Role enums dedicated as a component must use the `*Role` suffix (e.g., `UserRole`, `AccountRole`).
- Plain enum names like `Role` or `Authority` are acceptable only when the enum is self-contained within a security context.
- Permission or authority component classes must use the `*Permissions` or `*Permission` suffix (e.g., `UserPermissions`, `AccountPermissions`, `AdminPermission`).
- Security configuration classes must use the `*SecurityConfig` suffix (e.g., `ApiSecurityConfig`, `WebSecurityConfig`).
- Use domain-specific security component names (never `SecurityPermission` or `CommonRole`).

## Rules
- Keep security defaults deny-oriented for mutating operations.
- Declare security configuration using a `@Bean SecurityFilterChain` method.
- End every `SecurityFilterChain` with `anyRequest().denyAll()` to reject all unmatched routes by default.
- Apply `@Order` to every `SecurityFilterChain` bean when more than one filter chain is declared in the same module.
- Use JWT stateless authentication (Bearer token) by default for REST APIs.
- Use session-cookie authentication for server-rendered MVC applications.
- Set access token expiry to 24 hours by default.
- Keep authorization policy explicit at route or service boundary.
- Use `ADMIN` and `USER` as the default role set unless the user explicitly defines a different set.
- Provision users in-module via `UserDetailsService` by default.
- When an external identity provider manages roles, document that decision explicitly.
- Use `BCryptPasswordEncoder` with default strength (10) for password hashing.
- Externalize JWT signing keys through environment variables or a secrets manager.
- When the module provisions users in-process via `UserDetailsService`, every `Role` enum value must map to at least one provisioned principal in an active profile.
- When an external identity provider manages identity, document where role assignment is enforced.
- Disable CSRF protection for stateless JWT REST APIs.
- Disable CSRF protection when using HTTP Basic authentication.
- Enable CSRF protection for session-based MVC applications.
- Retain Spring Security's default HTTP security headers (HSTS, X-Frame-Options, X-Content-Type-Options).
- Configure CORS with explicit allowed-origin lists in production profiles.
- Keep authentication and authorization concerns separated from business logic.
- Document temporary authentication deferrals per Approved Exception Handling.

## Approved Exception Handling
- When temporary open access is approved for a feature or module, document the exception with an expiration condition (e.g., "open until authentication is implemented").
- Keep the exception documented in code comments, configuration, or test annotations so reviewers can identify it as intentional.

## Safety Guards
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
- Never treat temporary open access as permanent.
- Never apply a security exception to a wider scope than explicitly approved.
