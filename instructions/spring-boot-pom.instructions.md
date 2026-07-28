---
description: "Spring Boot Maven contract for dependency, plugin, and build-governance decisions."
applyTo: "**/pom.xml"
---

# Spring Boot POM Engine

## Scope & Analysis
- Inspect parent, dependency management, dependencies, plugins, and build profiles.
- Detect version overrides and duplicate dependency declarations.
- Detect dependencies that conflict with architecture constraints.

## Resolution Rules
- Keep Spring Boot parent and plugin versions coherent.
- Use Java 25 and Spring Boot 4.0.0 as the default baselines unless the user explicitly requests different versions.
- Use the project-owner's standard `groupId` namespace unless the user explicitly requests a different organization namespace.
- Keep project identity deterministic: set `<artifactId>` and `<name>` to the same module identifier in kebab-case.
- Add only dependencies required by explicit scope.
- Add a `<!-- reason -->` comment on the line immediately above every `<dependency>` block explaining why the dependency is needed (one concise sentence). This makes the dependency list self-documenting and prevents silent accumulation of unused libraries.
- When MapStruct is used, configure both `org.mapstruct:mapstruct` and compiler annotation processing via `org.mapstruct:mapstruct-processor`.
- When Lombok is used, declare `org.projectlombok:lombok` with `<scope>provided</scope>`.
- Always add an explicit `annotationProcessorPaths` entry for `org.projectlombok:lombok` in `maven-compiler-plugin`.
- Java 23 deprecated and Java 25 removed implicit annotation processor discovery.
- Omitting explicit Lombok annotation processor configuration causes `@Slf4j`, `@Data`, and other Lombok annotations to fail with "cannot be resolved" errors on Java 23+.
- Do not pin a Lombok version when Spring Boot parent BOM already manages it.
- Pin versions only when the parent BOM does not manage them.
- Remove duplicate dependencies and redundant exclusions.
- Prohibit JPA, Hibernate, and Spring Data repository dependencies.
- Prefer stable, maintained libraries over niche alternatives.
- Include `spring-boot-starter-webmvc-test` when using `@WebMvcTest`.
- Include `spring-boot-jdbc-test` when using `@JdbcTest`.
- Do not assume these starters are bundled in `spring-boot-starter-test`.

## Safety Guards
- Never upgrade unrelated dependencies in the same change.
- Never change Java version without explicit user approval.
- Never use placeholder project identity values such as `demo`, `app`, or `example` when a real module name is available.
- Never add milestone, beta, or snapshot versions without explicit approval.
- Never rely on MapStruct code generation without explicit compiler annotation-processor configuration.
- Never rely on Lombok annotations (`@Slf4j`, `@Data`, etc.) without an explicit `annotationProcessorPaths` entry in `maven-compiler-plugin`; implicit annotation processor discovery was removed in Java 25.
- Never add a dependency without a `<!-- reason -->` comment on the line immediately above it.
- Never introduce plugin behavior changes without stating build impact.

## Review Plan Layout
- Report added dependencies with purpose.
- Report removed or replaced dependencies with reason.
- Report version pin decisions and justification.
- Report blocked dependency requests and architecture reason.

