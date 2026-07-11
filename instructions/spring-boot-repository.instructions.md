---
description: "Repository rules: MyBatis and Spring JDBC Templates, SQL in XML files, no ORM, and no business logic."
applyTo: "**/*Repository.java, **/*RepositoryImpl.java, **/*Mapper.java, **/mapper/**/*.xml, **/sql/**/*.xml"
---

# Repository Rules

For pagination SQL strategy (`LIMIT`/`OFFSET`, count query parity, deterministic ordering), follow `spring-boot-pagination.instructions.md`.
For enum persistence conventions (string-based storage and migration safety), follow `spring-boot-enum.instructions.md`.
For SQL schema naming, type sizing, and constraint defaults, follow `spring-boot-database-schema.instructions.md`.
For versioned schema evolution with Flyway or Liquibase, follow `spring-boot-migrations.instructions.md`.
For soft-delete schema and query behavior, follow `spring-boot-soft-delete.instructions.md`.
For foreign-key integrity policy and delete-conflict behavior, follow `spring-boot-referential-integrity.instructions.md`.

## Scope
- Applies only to persistence repositories and SQL/MyBatis mappers
- Does not apply to feature mappers for domain ↔ DTO conversion (e.g., Spring `@Component` mapper); for those, follow `spring-boot-dto-mapper.instructions.md`

## No ORM
Never use JPA, Hibernate, Spring Data JPA, or any ORM abstraction. Do not extend `JpaRepository`, `CrudRepository`, or any Spring Data interface. Do not use JPQL or any ORM query language.

## MyBatis
- Define repositories as interfaces annotated with `@Mapper`
- SQL statements live in XML mapper files under `src/main/resources/mapper/`; never inline SQL as string literals
- Reference statements by their XML ID; the mapper interface method name must match the XML `id`
- Use MyBatis result maps in XML to map SQL result sets to domain objects; no annotations on domain classes
- Use package-private visibility by default for mapper interfaces; elevate to `public` only when external callers require it

## Spring JDBC (JdbcClient)
- Use `JdbcClient` for JDBC access; keep named parameters and never use positional `?` parameters
- SQL statements live in external XML files referenced by key; never inline SQL as string literals in Java
- Map result sets with explicit row mapping (`RowMapper`) or mapped classes; keep mapping helpers package-private
- For batch operations, use `NamedParameterJdbcTemplate.batchUpdate()` alongside `JdbcClient`; `JdbcClient` does not have a batch API

## General
- No business logic in repositories; data access only
- **No logging in repositories** — all operation tracking and state-transition logging belongs in the service layer
- Use package-private visibility by default for repository and mapper classes; elevate to `public` only when external callers require it
- Place schema and seed SQL files under `src/main/resources/sql/`; do not place them in the root of `src/main/resources/`
- Do not introduce migration dependencies by default; add Flyway or Liquibase only when migrations are in scope and follow `spring-boot-migrations.instructions.md`

## Repository Interface and Implementation
- Apply this section to Spring JDBC repositories and filesystem repositories.
- Do not apply this section to MyBatis mapper interfaces; MyBatis rules in `## MyBatis` take precedence.
- Use a repository interface plus implementation only when at least one condition is true:
  - The repository is injected into a service and must be mocked in unit tests
  - Multiple persistence backends are expected (for example: JDBC, MyBatis, in-memory)
  - The repository is consumed across package boundaries
- Keep a single concrete repository class when none of the conditions above apply
- Name the interface `XxxRepository` and the implementation `XxxRepositoryImpl`
- Services depend only on the `XxxRepository` interface; never depend directly on `XxxRepositoryImpl`
- Keep the implementation class package-private by default; elevate to `public` only when required by external callers

## Schema Initialization
- Development: keep DDL in `src/main/resources/sql/schema.sql` and optional seed data in `src/main/resources/sql/data.sql`
- Development startup: when automatic initialization is required, configure `spring.sql.init` in profile-specific YAML files
- Production: apply DDL before deployment using deployment tooling; do not rely on implicit runtime schema creation
- Keep SQL files as the source of truth for schema shape; do not store database state snapshots in the repository

## Filesystem Repositories
Use when the feature has no database and data is stored as files on disk identified by a key.

- Define a plain Java interface (no `@Mapper`, no Spring Data annotations)
- Implement the interface as a package-private class; inject the base directory as a `Path` from a `@ConfigurationProperties` class — never hardcode the path
- **Security: Validate and normalize the lookup key** — treat all keys as untrusted input:
  - Validate the key format against an allowlist (e.g., regex pattern for MAC addresses: `^[0-9A-Fa-f]{2}(:[0-9A-Fa-f]{2}){5}$`); reject invalid formats immediately with a domain bad-request exception
  - Normalize to a canonical form (e.g., lowercase, colon-separated)
  - Construct the file path by resolving the normalized key against the base directory
- **Security: Prevent path traversal**:
  - Enforce that the resolved path is within the base directory: `filePath.normalize().startsWith(baseDir.normalize())`
  - If the check fails, throw a domain bad-request exception and do not attempt file access; see `snippets/repository/filesystem/ResourceFilesystemRepository.java` for the guard pattern
- Use `Files.readString(path, StandardCharsets.UTF_8)` to read file contents; catch `NoSuchFileException` and rethrow as the domain `NotFoundException`
- Keep the implementation class package-private when used only within the same feature package

