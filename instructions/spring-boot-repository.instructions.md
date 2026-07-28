---
description: "Spring Boot repository contract for JDBC-first data access, interface-implementation separation, and SQL safety."
applyTo: "**/*Repository.java,**/*RepositoryImpl.java,**/*SqlColumns.java,**/*SqlConfigurationProperties.java"
---

# Spring Boot Repository Engine

## Scope & Analysis
- Inspect repository interfaces, implementations, and SQL support types.
- Inspect data-access boundaries between service and repository layers.
- Inspect SQL execution paths and exception mapping behavior.

## Naming Conventions
- Repository interfaces must be named with the `*Repository` suffix (e.g., `UserRepository`, `OrderRepository`).
- Repository implementations must be named with the `*RepositoryImpl` suffix (e.g., `UserRepositoryImpl`, `OrderRepositoryImpl`).
- SQL configuration property records must be named with the `*SqlConfigurationProperties` suffix (e.g., `UserSqlConfigurationProperties`).
- Use resource entity names (never `DataRepository`, `PersistenceRepository`, or generic names).

## Resolution Rules
- Prefer repository contract/implementation separation (`interface XyzRepository` + `XyzRepositoryImpl`) for modules with multiple persistence adapters or higher domain complexity; a single `@Repository` class is acceptable for focused modules.
- Keep repositories JDBC or JdbcClient based.
- Keep JDBC or JdbcClient as the default for relational persistence modules.
- Allow non-relational repository implementations only when the module is explicitly scoped to an approved non-relational store; keep key design, serialization rules, and failure mapping explicit.
- Prohibit JPA, Hibernate, and Spring Data repository patterns.
- Keep SQL parameters explicit and safely bound.
- Extract repeated technical string literals (for example SQL parameter names, column names, table names, key names) into named constants within the repository implementation.
- Keep repository exceptions mapped to domain-safe failures.
- Keep repository methods scoped to persistence concerns only.
- Externalize SQL statements into `@PropertySource`-backed XML property files (one file per feature); access them through a `@ConfigurationProperties` record named `XyzSqlConfigurationProperties` within the feature package.
- Register `XyzSqlConfigurationProperties` using one explicit pattern: either `@Component` + `@ConfigurationProperties` on the record, or `@EnableConfigurationProperties` on the owning `@Configuration` class.
- Keep SQL XML query keys and statement intent stable and resource-scoped (for example `sql.users.find-by-id`).
- Fallback from `INSERT/UPDATE ... RETURNING` only when the exception evidence indicates unsupported `RETURNING`; rethrow unrelated SQL grammar errors.
- Validate generated-key fallback results explicitly and throw a deterministic data-retrieval exception when no key is returned.
- Use `Locale.ROOT` for case normalization in machine-parsed string comparisons (for example SQL error-message feature detection).

## Safety Guards
- Never embed business orchestration logic in repository layer.
- Never execute unparameterized SQL with user-controlled input.
- Never mix ORM-based patterns into JDBC-first repository contracts.
- Never duplicate the same technical identifier string literal across multiple repository statements when a constant can represent it.
- Never apply relational SQL rules to approved non-relational repositories; enforce equivalent store-specific safety controls instead.

## Review Plan Layout
- Report repository methods added, changed, or removed.
- Report SQL execution and parameter-binding decisions.
- Report exception mapping behavior for data-access failures.
- Report persistence-strategy compliance with architecture baseline.

