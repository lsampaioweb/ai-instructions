---
description: "Spring Boot repository contract for JDBC-first data access, interface-implementation separation, and SQL safety."
applyTo: "**/*Repository.java,**/*RepositoryImpl.java,**/*SqlColumns.java,**/*SqlConfigurationProperties.java"
---

# Spring Boot Repository Engine

## Scope & Analysis
- Inspect repository interfaces, implementations, and SQL support types.
- Inspect data-access boundaries between service and repository layers.
- Inspect SQL execution paths and exception mapping behavior.

## Resolution Rules
- Require repository implementations to be separated from contract interfaces: define `interface XyzRepository`, then implement `@Repository class XyzRepositoryImpl implements XyzRepository`.
- Keep repositories JDBC or JdbcClient based.
- Keep JDBC or JdbcClient as the default for relational persistence modules.
- Allow non-relational repository implementations only when the module is explicitly scoped to an approved non-relational store; keep key design, serialization rules, and failure mapping explicit.
- Prohibit JPA, Hibernate, and Spring Data repository patterns.
- Keep SQL parameters explicit and safely bound.
- Keep repository exceptions mapped to domain-safe failures.
- Keep repository methods scoped to persistence concerns only.

## Review Plan Layout
- Report repository methods added, changed, or removed.
- Report SQL execution and parameter-binding decisions.
- Report exception mapping behavior for data-access failures.
- Report persistence-strategy compliance with architecture baseline.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never embed business orchestration logic in repository layer.
- Never execute unparameterized SQL with user-controlled input.
- Never mix ORM-based patterns into JDBC-first repository contracts.
- Never apply relational SQL rules to approved non-relational repositories; enforce equivalent store-specific safety controls instead.
