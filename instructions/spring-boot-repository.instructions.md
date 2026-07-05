---
description: "Repository rules: MyBatis and Spring JDBC Templates, SQL in XML files, no ORM, and no business logic."
applyTo: "**/*Repository.java, **/*Mapper.java, **/mapper/**/*.xml, **/sql/**/*.xml"
---

# Repository Rules

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
- Use package-private visibility by default for repository and mapper classes; elevate to `public` only when external callers require it
- Place schema and seed SQL files under `src/main/resources/sql/`; do not place them in the root of `src/main/resources/`
- Never add Flyway or Liquibase dependencies unless explicitly requested; assume SQL files are executed manually or via `spring.sql.init` properties

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
  - If the check fails, throw a domain bad-request exception and do not attempt file access
  - Use this guard before any read operation:

```java
if (!filePath.normalize().startsWith(baseDir.normalize())) {
  throw new BadRequestException("error.invalid.path");
}
```
- Use `Files.readString(path, StandardCharsets.UTF_8)` to read file contents; catch `NoSuchFileException` and rethrow as the domain `NotFoundException`
- No business logic; I/O only
- Keep the implementation class package-private when used only within the same feature package

## Templates

**MyBatis — mapper interface.** Replace `{Resource}`, `{resource}`, and `{feature}` with actual names.

```java
@Mapper
interface {Resource}Mapper {
  List<{Resource}> findAll();
  Optional<{Resource}> findById(Long id);
  int insert({Resource} entity);
  int update({Resource} entity);
  int deleteById(Long id);
  boolean existsById(Long id);
}
```

**MyBatis — XML mapper file** (`src/main/resources/mapper/{Resource}Mapper.xml`). Replace namespace, table, and column names with actual values. The `namespace` attribute must exactly match the fully qualified name of the Java mapper interface. Example: if the mapper interface is `com.example.user.UserMapper`, the namespace must be `com.example.user.UserMapper`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.example.{feature}.{Resource}Mapper">

    <resultMap id="{resource}Map" type="com.example.{feature}.{Resource}">
        <id property="id" column="id"/>
        <result property="name" column="name"/>
        <result property="description" column="description"/>
    </resultMap>

    <select id="findAll" resultMap="{resource}Map">
        SELECT id, name, description FROM {resources}
    </select>

    <select id="findById" parameterType="long" resultMap="{resource}Map">
        SELECT id, name, description FROM {resources} WHERE id = #{id}
    </select>

    <insert id="insert" useGeneratedKeys="true" keyProperty="id">
        INSERT INTO {resources} (name, description) VALUES (#{name}, #{description})
    </insert>

    <update id="update">
        UPDATE {resources} SET name = #{name}, description = #{description} WHERE id = #{id}
    </update>

    <delete id="deleteById" parameterType="long">
        DELETE FROM {resources} WHERE id = #{id}
    </delete>

</mapper>
```

**JdbcClient repository.** Replace `{Resource}`, `{resource}`, `{resources}`, and column names with actual values. SQL strings must be stored in external XML files and loaded by key — never hardcoded inline.

```java
@Slf4j
@Repository
class {Resource}Repository {

  private final JdbcClient jdbcClient;

  {Resource}Repository(JdbcClient jdbcClient) {
    this.jdbcClient = jdbcClient;
  }

  @Transactional(readOnly = true)
  List<{Resource}> findAll() {
    return jdbcClient.sql(SQL_FIND_ALL)
      .query({Resource}.class)
      .list();
  }

  @Transactional(readOnly = true)
  Optional<{Resource}> findById(Long id) {
    return jdbcClient.sql(SQL_FIND_BY_ID)
      .param("id", id)
      .query({Resource}.class)
      .optional();
  }

  @Transactional
  int insert({Resource} entity) {
    return jdbcClient.sql(SQL_INSERT)
      .param("name", entity.getName())
      .param("description", entity.getDescription())
      .update();
  }

  @Transactional
  int update({Resource} entity) {
    return jdbcClient.sql(SQL_UPDATE)
      .param("id", entity.getId())
      .param("name", entity.getName())
      .param("description", entity.getDescription())
      .update();
  }

  @Transactional
  int deleteById(Long id) {
    return jdbcClient.sql(SQL_DELETE_BY_ID)
      .param("id", id)
      .update();
  }

  @Transactional(readOnly = true)
  boolean existsById(Long id) {
    return jdbcClient.sql(SQL_EXISTS_BY_ID)
      .param("id", id)
      .query(Boolean.class)
      .single();
  }
}
```
