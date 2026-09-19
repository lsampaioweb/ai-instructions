---
name: spring-boot-feature
description: >-
  Implement a Spring Boot feature by copying the good examples in project
  rules. Use when adding or changing Spring Boot APIs, JDBC persistence,
  controllers, DTOs, or feature packages, or when the user asks to implement
  a Spring feature.
---

# Spring Boot Feature

Implement only the files the user requested. Match the good examples in the activated glob rules. Do not run an ADR or reviewer pipeline.

## Steps

1. Read `AGENTS.md` and the glob-matching rules under `.cursor/rules/` for the files you will touch (`spring-boot-architecture`, `spring-boot-pom`, `spring-boot-persistence`, `spring-boot-web`, `spring-boot-java-style`).
2. Copy the **GOOD** snippets in those rules (package layout, `JdbcClient`, XML SQL, constructor-injected controller, record DTOs).
3. Create or edit only paths required by the request.
4. Fill unspecified details from Spring knowledge only when they do not contradict `AGENTS.md` or an activated rule.

## Constraints

- Do not add JPA, Hibernate, `@Entity`, `JpaRepository`, layer packages, field `@Autowired`, Lombok `@Data`, or concatenated SQL.
- Do not add MapStruct or Lombok unless the user asked.
- Do not create files outside the requested feature.
