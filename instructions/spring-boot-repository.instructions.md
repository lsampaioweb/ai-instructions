---
description: "Repository rules: MyBatis and Spring JDBC Templates, SQL in XML files, no ORM, and no business logic."
applyTo: "**/*Repository.java, **/*Mapper.java, **/mapper/**/*.xml, **/sql/**/*.xml"
---

# Repository Rules

## No ORM
Never use JPA, Hibernate, Spring Data JPA, or any ORM abstraction. Do not extend `JpaRepository`, `CrudRepository`, or any Spring Data interface. Do not use JPQL or any ORM query language.

## MyBatis
- Define repositories as interfaces annotated with `@Mapper`
- SQL statements live in XML mapper files under `src/main/resources/mapper/`; never inline SQL as Java string literals
- Reference statements by their XML ID; the mapper interface method name must match the XML `id`
- Use MyBatis result maps in XML to map SQL result sets to domain objects; no annotations on domain classes
- Keep mapper interfaces package-private when used only within the same feature package

## Spring JDBC Templates
- Use `NamedParameterJdbcTemplate` for all JDBC access; never use positional `?` parameters
- SQL statements live in external XML files referenced by key; never inline SQL as string literals in Java
- Map result sets with a `RowMapper` implementation; keep `RowMapper` classes package-private

## General
- No business logic in repositories; data access only
- Keep repository and mapper classes package-private when used only within the same feature package
- Place schema and seed SQL files under `src/main/resources/sql/`; do not place them in the root of `src/main/resources/`
- Never add Flyway or Liquibase dependencies unless explicitly requested; assume SQL files are executed manually or via `spring.sql.init` properties

## Filesystem Repositories
Use when the feature has no database and data is stored as files on disk identified by a key.

- Define a plain Java interface (no `@Mapper`, no Spring Data annotations)
- Implement the interface as a package-private class; inject the base directory as a `Path` from a `@ConfigurationProperties` class — never hardcode the path
- Use `Files.readString(path, StandardCharsets.UTF_8)` to read file contents; catch `NoSuchFileException` and rethrow as the domain `NotFoundException`
- No business logic; I/O only
- Keep the implementation class package-private when used only within the same feature package
