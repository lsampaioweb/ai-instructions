---
description: "Spring Boot security contract for authentication, authorization, service-level checks, and endpoint protection boundaries."
applyTo: "**/*SecurityConfig.java,**/*Service.java,**/*ServiceImpl.java,**/security/*Permissions.java,**/security/Role.java,**/security/*Role.java"
---

# Spring Boot Security Engine

## Scope & Analysis
- Inspect security configuration, permission components, and role modeling.
- Inspect authorization boundaries for endpoints and service methods.
- Inspect session, CSRF, and request-matcher behavior.

## Naming Conventions
- Role enums must be named with the `*Role` suffix when used as a dedicated component (e.g., `UserRole`, `AccountRole`); plain enum names like `Role`, `Authority` are acceptable only when the enum is self-contained within a security context.
- Permission or authority component classes must be named with the `*Permissions` or `*Permission` suffix (e.g., `UserPermissions`, `AccountPermissions`, `AdminPermission`).
- Security configuration classes must be named with the `*SecurityConfig` suffix (e.g., `ApiSecurityConfig`, `WebSecurityConfig`).
- Use domain-specific security component names (never `SecurityPermission`, `CommonRole`, or overly generic names).

## Resolution Rules
- Keep security defaults deny-oriented for mutating operations.
- Use JWT stateless authentication (Bearer token) by default for REST APIs; use session-cookie authentication for server-rendered MVC applications.
- Set access token expiry to 24 hours by default; never issue non-expiring tokens.
- Keep authorization policy explicit at route or service boundary.
- Keep coarse-grained and fine-grained authorization rules consistent.
- Keep role and authority mapping centralized in security model.
- Use `ADMIN` and `USER` as the default role set unless the user explicitly defines a different set.
- Provision users in-module via `UserDetailsService` by default; document explicitly when an external identity provider manages roles instead.
- Use `BCryptPasswordEncoder` with default strength (10) for password hashing; never store plain-text or weakly hashed passwords.
- When the module provisions users in-process (for example via `UserDetailsService`), every `Role` enum value must map to at least one provisioned principal in an active profile; for externally managed identity providers, document where role assignment is enforced.
- Disable CSRF protection for stateless JWT REST APIs; enable CSRF protection for session-based MVC applications.
- Retain Spring Security's default HTTP security headers (HSTS, X-Frame-Options, X-Content-Type-Options); never disable them without explicit justification.
- Configure CORS with explicit allowed-origin lists in production profiles; never allow wildcard origins (`*`) in production.
- Keep authentication and authorization concerns separated from business logic.
- Keep security decisions traceable through permission components.
- Document temporary authentication deferrals with explicit metadata: scope, closure condition, and release checkpoint.
- For service orchestration, transaction boundaries, and collaborator structure, defer to `spring-boot-service.instructions.md`.

## Approved Exception Handling
- Identify features or endpoints explicitly approved by user for temporary open access.
- Distinguish between temporary exceptions and architectural security violations.
- When a user explicitly approves temporary open access for a feature or module, document the exception with an expiration condition (e.g., "open until authentication is implemented" or "open for prototype phase").
- Suppress authorization findings for endpoints within the approved exception scope until the condition is resolved.
- Never silence security findings that fall outside the user's explicit approval.
- Always keep the exception documented in code comments, configuration, or test annotations so reviewers know the decision is intentional, not missed.
- Never treat temporary open access as permanent; require explicit re-approval or closure before production release.
- Never apply an exception to a wider scope than the user explicitly approved.

## Safety Guards
- Never expose mutating endpoints without explicit authorization checks.
- Never duplicate conflicting authorization logic across layers.
- Never weaken security defaults without explicit approval.
- Never leave role-assignment ownership ambiguous: assign roles in-module for local identity setups or explicitly document the external authority that assigns them.
- Never leave unresolved `TODO` or `FIXME` markers inside active security route rules.
- Never hardcode JWT signing keys; always externalize them through environment variables or a secrets manager.

## Review Plan Layout
- Report protected routes and authorization rules changed.
- Report permission logic updates and affected roles.
- Report session and CSRF policy decisions.
- Report unresolved security gaps in touched scope.

