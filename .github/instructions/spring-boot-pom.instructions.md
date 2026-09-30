---
description: "Spring Boot Maven pom.xml contract for dependency, plugin, and coordinate governance."
applyTo: "**/pom.xml"
---

# Spring Boot pom.xml Contract

## Rules

### Project coordinates
- `groupId` is always `br.com.lsampaioweb`.
- `version` keeps the `-SNAPSHOT` suffix during active development (e.g. `0.0.1-SNAPSHOT`).
  Only drop `-SNAPSHOT` when an actual release is being cut via `mvn release:prepare`.
- Never leave `<url />` or `<licenses><license /></licenses>` as empty stub tags. If no
  real project URL or license has been decided, omit the tags entirely - ask the user
  rather than fabricating a license.

### Source control metadata
- Always include the `<scm>` block when the project has a git repository, added from
  project creation (not deferred to release time):
  ```xml
  <scm>
    <developerConnection>scm:git:<repository-url></developerConnection>
    <tag>HEAD</tag>
  </scm>
  ```

### Dependency documentation
- Every `<dependency>` has a one-line `<!-- purpose -->` comment placed directly above
  the `<dependency>` tag (not inside it) explaining why it is there.

### Dependency ordering
- Group and order dependencies as:
  1. Spring Boot / Spring Cloud / Spring Security starters (framework-provided). Within
     this group, `spring-boot-devtools` goes last since it is a dev-only convenience,
     not a feature starter.
  2. Third-party libraries (non-Spring groupIds: e.g. `org.projectlombok`, `org.mapstruct`,
     `org.springdoc`, `org.postgresql`, `com.zaxxer`), ordered alphabetically by
     artifactId.
  3. Internal/project-owned dependencies (for multi-module projects).
  4. Test-scoped dependencies, always last, regardless of groupId.

## Forbidden

- Never add `spring-boot-starter-data-jpa`, `hibernate-core`, or any `@Entity`/JPA-based
  persistence dependency unless the user explicitly asks for JPA. Default persistence is
  plain JDBC: `spring-boot-starter-jdbc` + the matching JDBC driver (e.g.
  `org.postgresql:postgresql`), plus `com.zaxxer:HikariCP` for connection pooling.
- `spring-data-commons` is allowed when the API uses Spring `Pageable`/`Page`. Do not
  pull JPA or HATEOAS solely to obtain pagination types.
- Never leave dependencies without a purpose comment.
- Never leave `<url />` / `<licenses><license /></licenses>` as empty placeholders.
- Never use a `groupId` other than `br.com.lsampaioweb` for project modules.
- Never place test-scoped dependencies anywhere but last in the `<dependencies>` block.
