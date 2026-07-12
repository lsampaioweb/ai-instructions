---
description: "Spring Boot Maven contract for dependency, plugin, and build configuration decisions in production-grade projects."
applyTo: "**/pom.xml"
---

# Spring Boot POM Contract
Use this file to enforce Maven build consistency for Spring Boot projects.

## Scope
1. Apply to every Maven project descriptor in scope.
2. Keep rules generic and technology-focused, not domain-specific.
3. Apply this file as the canonical baseline for pom.xml governance.
4. Apply feature-specific pom rules only when their feature scope is active.
5. Treat feature-specific pom rules as supplements to this baseline unless explicit precedence is declared.

## Mandatory Structure
1. Set modelVersion to 4.0.0.
2. Use spring-boot-starter-parent unless an explicit platform BOM strategy is required.
3. Keep groupId, artifactId, version, name, and description present and coherent.
4. Define Java version in properties and align compiler/runtime target to that value.
5. Include spring-boot-maven-plugin in build plugins.

## Dependency Governance
1. Include only dependencies required by active architecture components.
2. Use Spring Boot starters as default entry points for framework capabilities.
3. Keep non-starter library versions centralized in properties.
4. Avoid duplicate capabilities across conflicting stacks unless explicitly required.
5. Pin versions only when dependency is not managed by Spring Boot BOM.
6. Keep optional development tools out of production runtime.

## Scope Rules
1. Use test scope for test-only libraries.
2. Use runtime scope for drivers and production runtime-only components.
3. Use provided scope for compile-time only tooling dependencies.
4. Mark local developer helpers as optional when they are not required in production artifacts.

## Plugin Rules
1. Configure maven-compiler-plugin when annotation processors are used.
2. Declare annotation processors explicitly in annotationProcessorPaths.
3. Include processor bindings required to prevent generation-order conflicts.
4. Keep plugin configuration minimal and deterministic.
5. Apply [spring-boot-dto-mapper.instructions.md](./spring-boot-dto-mapper.instructions.md) for MapStruct and lombok-mapstruct-binding specifics when DTO mappers are in scope.

## Security and Supply Chain
1. Prefer dependencies with active maintenance and known update cadence.
2. Remove unused dependencies and plugins.
3. Avoid snapshots for release builds.
4. Keep SCM metadata present for release traceability when repository workflow requires it.

## Performance and Build Stability
1. Keep dependency graph minimal to reduce startup and build time.
2. Avoid redundant transitive pulls by choosing one stack per capability.
3. Keep build plugins limited to required behavior.

## Testability and Operability
1. Ensure test dependencies support unit, integration, and security tests for enabled features.
2. Keep actuator and observability dependencies aligned with monitoring requirements.
3. Ensure packaging and plugin setup can run via standard lifecycle commands.
