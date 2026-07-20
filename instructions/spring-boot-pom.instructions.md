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
- Use Java 25 as the default baseline by defining `<java.version>25</java.version>` unless the user explicitly requests a different version.
- Use `io.github.lsampaioweb` as the default `groupId` unless the user explicitly requests a different organization namespace.
- Keep project identity deterministic: set `<artifactId>` and `<name>` to the same module identifier in kebab-case.
- Add only dependencies required by explicit scope.
- Keep MapStruct modules configured with both `org.mapstruct:mapstruct` and compiler annotation processing via `org.mapstruct:mapstruct-processor`.
- Pin versions only when the parent BOM does not manage them.
- Remove duplicate dependencies and redundant exclusions.
- Prohibit JPA, Hibernate, and Spring Data repository dependencies.
- Prefer stable, maintained libraries over niche alternatives.

## Review Plan Layout
- Report added dependencies with purpose.
- Report removed or replaced dependencies with reason.
- Report version pin decisions and justification.
- Report blocked dependency requests and architecture reason.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never upgrade unrelated dependencies in the same change.
- Never change Java version without explicit user approval.
- Never use placeholder project identity values such as `demo`, `app`, or `example` when a real module name is available.
- Never add milestone, beta, or snapshot versions without explicit approval.
- Never rely on MapStruct code generation without explicit compiler annotation-processor configuration.
- Never introduce plugin behavior changes without stating build impact.
