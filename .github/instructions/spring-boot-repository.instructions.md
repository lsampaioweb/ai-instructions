---
description: "Spring repository adapters for JDBC-first database access, interface-implementation separation, Redis repositories, and SQL safety."
applyTo: "**/*Repository.java, **/*RepositoryImpl.java, **/*SqlConfigurationProperties.java, **/*SqlColumns.java"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for formatting, imports, visibility, injection, constants, and JavaDoc.
- Follow `spring-boot-exception.instructions.md` when wrapping persistence failures or rethrowing domain exceptions.
- Follow `spring-boot-pagination.instructions.md` when the repository performs database-backed pagination.
- Defer the global ORM ban to `spring-boot-architecture.instructions.md` and ORM dependency bans to `spring-boot-pom.instructions.md`.

## Naming Conventions
- Name the adapter after the aggregate it persists, using the `*Repository` suffix (e.g., `HolidayRepository`).
- Name repository implementations with the `*RepositoryImpl` suffix (e.g., `HolidayRepositoryImpl`).
- Use resource entity names in repository identifiers (never `DataRepository` or `PersistenceRepository`).
- Name SQL configuration property records with the `*SqlConfigurationProperties` suffix; name SQL property keys with the pattern `sql.<resource>.<operation>` (e.g., `sql.holidays.find-by-id`).
- Name SQL column name constant classes with the `*SqlColumns` suffix (e.g., `UserSqlColumns`, `AccountSqlColumns`).
- Name repository methods after their data-access intent: `findById`, `findAll`, `findBy*`, `save`, `update`, `deleteById`; name persistence error keys after the aggregate and operation, such as `ERROR_USER_INSERT`.

## Rules

### Repository declaration and dependencies
- Annotate each persistence adapter with `@Repository`.
- Keep repository classes package-private unless an explicit cross-package contract requires wider visibility.
- Inject only the data-access dependencies needed by the repository through its constructor.
- Keep datastore conversion and serialization inside the repository that owns the datastore boundary.
- Keep JDBC or `JdbcClient` as the default for relational persistence modules.
- Use interface + implementation separation (`XyzRepository` interface + `XyzRepositoryImpl`) for modules with multiple persistence adapters or higher domain complexity.
- Use a single `@Repository` class without a separate interface for focused modules with a single persistence adapter.
- Allow non-relational repository implementations only when the module is explicitly scoped to an approved non-relational store.

### JDBC repositories
- Read SQL statements from aggregate-specific `*SqlConfigurationProperties`; do not embed SQL strings in repository methods.
- Externalize SQL statements into `@PropertySource`-backed XML property files, one file per feature, declared on the `@Configuration` class that owns the `JdbcClient` bean.
- Access SQL statements through a `@ConfigurationProperties` record named `XyzSqlConfigurationProperties` within the feature package.
- Register `XyzSqlConfigurationProperties` using one explicit pattern: either `@Component` + `@ConfigurationProperties` on the record, or `@EnableConfigurationProperties` on the owning `@Configuration` class.
- Annotate `*SqlConfigurationProperties` records with `@Validated` and annotate each SQL field with `@NotBlank`.
- Declare SQL column name constants in a `*SqlColumns` utility class within the feature package; use these constants as all named parameter keys in SQL method calls.
- Declare SQL result-set column-label constants in the repository implementation and reuse them for all `ResultSet` reads.
- Bind parameters using the query's named column constants when the aggregate defines them.
- Query directly into the aggregate type when the result matches its fields.
- Accept `PageQuery` only when the repository performs database-backed pagination; accept pagination parameters (offset, limit, sort column) as explicit method parameters for paginated queries.
- Return `Optional<T>` from all single-resource lookup methods (e.g., `findById`); return `null` only when the calling layer explicitly follows the null-on-missing contract.
- Return the affected-row count from a single JDBC write operation and an array of counts from a batch write operation.
- Raise the aggregate-specific not-found exception when an update or delete affects no rows and that operation requires an existing record.
- Validate generated-key fallback results explicitly and throw a deterministic data-retrieval exception when no key is returned.
- Fall back from `INSERT/UPDATE ... RETURNING` only when exception evidence indicates the database does not support `RETURNING`; rethrow unrelated SQL grammar errors.
- Use `Locale.ROOT` for case normalization in machine-parsed string comparisons (e.g., SQL error-message feature detection).
- Wrap unexpected persistence failures in the project database exception using the operation-specific error key; catch SQL exceptions at the repository boundary so services do not re-wrap the same SQL failure.
- Rethrow expected domain exceptions before wrapping unexpected persistence failures.
- Keep business orchestration out of repository methods.
- Build SQL parameter containers to be null-tolerant by omitting null entries or binding typed null values explicitly.
- Keep SQL statements straightforward and readable; prefer simple joins, predicates, and direct projections over expression-heavy control-flow in SQL.
- Implement sortable pagination in SQL only when the user explicitly requires database-side sorting or the expected data volume makes application-side sorting unsuitable; otherwise perform sorting in Java after retrieval using an allowlisted set of sortable fields.

### Redis repositories
- Store values under a named hash key declared as a `private static final String` constant.
- Return `Optional<T>` for a missing hash entry.
- Return the saved aggregate from `save(...)` after writing it to the datastore.
- Convert datastore values to and from JSON within the repository using the configured `ObjectMapper`.
- Raise `IllegalStateException` with the appropriate localized error message when JSON serialization or deserialization fails.

## Safety Guards
- Never build executable SQL statements at runtime with `String#formatted`, concatenation, or replacement from request-derived values.

## Reference
- Use [samples/spring-boot-repository.tpl](samples/spring-boot-repository.tpl) for the canonical JDBC repository structure.
