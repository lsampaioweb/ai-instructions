---
description: "Spring Boot security contract for authentication, authorization, and endpoint protection boundaries."
applyTo: "**/*SecurityConfig.java,**/security/*Permissions.java,**/security/Role.java,**/*Service.java"
---

# Spring Boot Security Engine

## Scope & Analysis
- Inspect security configuration, permission components, and role modeling.
- Inspect authorization boundaries for endpoints and service methods.
- Inspect session, CSRF, and request-matcher behavior.

## Resolution Rules
- Keep authorization policy explicit at route or service boundary.
- Keep coarse-grained and fine-grained authorization rules consistent.
- Keep role and authority mapping centralized in security model.
- When the module provisions users in-process (for example via `UserDetailsService`), every `Role` enum value must map to at least one provisioned principal in an active profile; for externally managed identity providers, document where role assignment is enforced.
- Keep security defaults deny-oriented for mutating operations.
- Keep authentication and authorization concerns separated from business logic.
- Keep security decisions traceable through permission components.
- Document temporary authentication deferrals with explicit metadata: scope, closure condition, and release checkpoint.

## Review Plan Layout
- Report protected routes and authorization rules changed.
- Report permission logic updates and affected roles.
- Report session and CSRF policy decisions.
- Report unresolved security gaps in touched scope.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never expose mutating endpoints without explicit authorization checks.
- Never duplicate conflicting authorization logic across layers.
- Never weaken security defaults without explicit approval.
- Never leave role-assignment ownership ambiguous: assign roles in-module for local identity setups or explicitly document the external authority that assigns them.
- Never leave unresolved `TODO` or `FIXME` markers inside active security route rules.

## Approved Exception Handling
- Identify features or endpoints explicitly approved by user for temporary open access.
- Distinguish between temporary exceptions and architectural security violations.
- When a user explicitly approves temporary open access for a feature or module, document the exception with an expiration condition (e.g., "open until authentication is implemented" or "open for prototype phase").
- Suppress authorization findings for endpoints within the approved exception scope until the condition is resolved.
- Never silence security findings that fall outside the user's explicit approval.
- Always keep the exception documented in code comments, configuration, or test annotations so reviewers know the decision is intentional, not missed.
- Never treat temporary open access as permanent; require explicit re-approval or closure before production release.
- Never apply an exception to a wider scope than the user explicitly approved.
