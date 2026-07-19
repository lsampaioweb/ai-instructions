---
description: "Spring Boot persistence contract for deterministic data-access boundaries using MyBatis XML mappers or Spring JDBC in production-grade projects."
applyTo: "**/src/main/java/**/*Repository.java, **/src/main/java/**/*RepositoryImpl.java, **/src/main/java/**/*Jdbc*.java, **/src/main/java/**/*Mapper.java, **/src/main/resources/sql/**/*.xml"
---

# Spring Boot Repository Contract
Use this file to enforce deterministic persistence-layer behavior.

## Scope
1. Apply to feature-local repository classes, mapper interfaces, and persistence adapters.
2. Keep persistence logic within feature package boundaries.
3. Do not apply repository mapper rules to DTO mapper classes named *DtoMapper.java; apply [spring-boot-dto-mapper.instructions.md](./spring-boot-dto-mapper.instructions.md) for those files.

## Access Pattern Rules
1. Restrict data access to MyBatis mapper XML or Spring JDBC abstractions.
2. Keep SQL statement ownership explicit in XML mapper files or SQL configuration properties.
3. Keep repository methods deterministic and side-effect scoped to persistence operations.
4. Keep repository classes package-private unless an explicit boundary requires broader visibility.

## Query Safety Rules
1. Use named parameters only for query binding.
2. Forbid positional parameter binding and unsafe string concatenation for query values.
3. Keep paging queries explicit with limit and offset derived from validated inputs.
4. Keep count queries explicit for paginated reads.

## Transaction and Error Rules
1. Keep transactional boundaries at service layer entry points, not inside repository interfaces.
2. Keep persistence exceptions translated to deterministic application exceptions at feature boundary.
3. Keep generated key behavior explicit and validated for insert operations that return identifiers.

## Forbidden Stack Rules
1. Forbid jakarta.persistence.*, org.hibernate.*, and org.springframework.data.* usage.
2. Forbid Spring Data Repository patterns and JPA entity manager access.
3. Forbid persistence logic in controller methods.

## Quality Gates
1. Keep tests covering success and failure paths for repository operations.
2. Keep SQL and mapper contracts aligned with current schema migrations.
3. Keep README and service assumptions aligned with repository method semantics.
