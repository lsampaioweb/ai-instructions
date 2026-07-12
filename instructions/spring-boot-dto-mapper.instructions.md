---
description: "Spring Boot DTO mapper contract for deterministic boundary mapping, explicit field coverage, and compile-time safety in production-grade projects."
applyTo: "**/src/main/java/**/*DtoMapper.java, **/pom.xml"
---

# Spring Boot DTO Mapper Contract
Use this file to enforce deterministic DTO and domain mapping boundaries.

## Scope
1. Apply to DTO mapper interfaces and classes named *DtoMapper that convert between transport DTOs and domain models.
2. Keep mapping behavior isolated from service orchestration and repository concerns.
3. For pom.xml, apply this contract only when MapStruct dependency or MapStruct annotation processing is declared.
4. For generic *Mapper.java persistence artifacts, apply [spring-boot-repository.instructions.md](./spring-boot-repository.instructions.md) instead of this file.

## Mapper Design Rules
1. Use MapStruct mapper interfaces with Spring component model for DTO boundary mapping.
2. Keep mapper methods explicit for create, read, and update mapping paths.
3. Keep update mapping methods explicit about immutable or protected target fields.
4. Keep mapper names aligned with feature aggregate terminology.

## Field Coverage Rules
1. Forbid unmapped target fields in MapStruct DTO mappers.
2. Keep id and system-managed fields explicitly ignored or explicitly sourced.
3. Keep null handling and default values deterministic and explicit.
4. Keep transport-only fields out of persistence or domain models.
5. Forbid leaking persistence internals into response DTOs.

## Build and Tooling Rules
1. Keep MapStruct dependency and annotation processor configured in pom.xml when mapper interfaces are present.
2. Keep lombok-mapstruct-binding configured when Lombok and MapStruct coexist.
3. Keep annotation processor versions aligned with declared dependency versions.
4. Keep generated mapper behavior deterministic across profiles and environments.

## Boundary and Safety Rules
1. Keep business rules out of mapper methods.
2. Keep repositories and SQL concerns out of mapper implementations.
3. Keep mapper usage in service or adapter boundaries, not in configuration bootstrap logic.
4. Keep tests covering create, update, and response mapping for each feature mapper.

## Quality Gates
1. Forbid reflection-based or dynamic mapping for core request and response boundaries.
2. Forbid wildcard or ambiguous field mapping behavior.
3. Keep mapping contracts backward-compatible for published API DTO fields.
