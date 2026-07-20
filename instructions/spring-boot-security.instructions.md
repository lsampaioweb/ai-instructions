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
- Keep security defaults deny-oriented for mutating operations.
- Keep authentication and authorization concerns separated from business logic.
- Keep security decisions traceable through permission components.

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
