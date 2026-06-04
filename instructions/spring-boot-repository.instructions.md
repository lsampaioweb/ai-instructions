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
- **Security: Validate and normalize the lookup key** — treat all keys as untrusted input:
  1. Validate the key format against an allowlist (e.g., regex pattern for MAC addresses: `^[0-9A-Fa-f]{2}(:[0-9A-Fa-f]{2}){5}$`); reject invalid formats immediately with a domain bad-request exception
  2. Normalize to a canonical form (e.g., lowercase, colon-separated)
  3. Construct the file path by resolving the normalized key against the base directory
  4. Enforce that the resolved path is within the base directory (path traversal check): `filePath.normalize().startsWith(baseDir.normalize())`
  5. If the check fails, throw a domain bad-request exception; do not attempt access
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

**MyBatis — XML mapper file** (`src/main/resources/mapper/{Resource}Mapper.xml`). Replace namespace, table, and column names with actual values.

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
  public List<{Resource}> findAll() {
    return jdbcClient.sql(SQL_FIND_ALL)
      .query({Resource}.class)
      .list();
  }

  @Transactional(readOnly = true)
  public Optional<{Resource}> findById(Long id) {
    return jdbcClient.sql(SQL_FIND_BY_ID)
      .param("id", id)
      .query({Resource}.class)
      .optional();
  }

  @Transactional
  public void save({Resource} entity) {
    jdbcClient.sql(SQL_INSERT)
      .param("name", entity.getName())
      .param("description", entity.getDescription())
      .update();
  }

  @Transactional
  public void deleteById(Long id) {
    jdbcClient.sql(SQL_DELETE_BY_ID)
      .param("id", id)
      .update();
  }
}
```
