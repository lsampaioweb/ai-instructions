---
description: "Spring Boot service contract for business orchestration, transaction boundaries, and dependency-safe application logic."
applyTo: "**/*Service.java,**/*ServiceImpl.java"
---

# Spring Boot Service Engine

## Scope & Analysis
- Inspect service interface contracts and implementation behavior.
- Inspect transaction boundaries for read and write operations.
- Inspect dependency usage and orchestration responsibilities.

## Resolution Rules
- Prefer service contract/implementation separation (`interface XyzService` + `XyzServiceImpl`) for business modules with multiple collaborators or evolving API contracts; a focused single `@Service` class is acceptable for simple integration or utility services.
- Keep business orchestration in service layer.
- Keep constructor injection as the only dependency pattern.
- Keep read and write transaction semantics explicit for persistence workflows; avoid transactional annotations on services that do not perform transactional resource updates.
- Keep service methods aligned with API and repository contracts.
- Keep external integration calls encapsulated in service boundaries.

## Review Plan Layout
- Report added or changed service methods and behavior.
- Report transaction-boundary decisions and justification.
- Report dependency changes and orchestration impact.
- Report contract compatibility with existing callers.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never move business rules into controllers or repositories.
- Never use field injection in service implementations.
- Never introduce implicit transaction behavior for critical writes.
