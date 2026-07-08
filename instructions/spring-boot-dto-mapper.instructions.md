---
description: "DTO and mapper rules: immutable records, validation placement, and mapper conventions."
applyTo: "**/*DTO.java, **/*Dto.java, **/*DtoMapper.java, **/*Mapper.java, **/*Request.java, **/*Response.java, **/pom.xml"
---

# DTO and Mapper Rules

## Scope
- Applies to DTO classes and non-SQL feature mappers (e.g., Spring `@Component` mappers used for domain ↔ DTO conversion)
- SQL/MyBatis persistence mappers follow `spring-boot-repository.instructions.md`

## DTOs
- Use Java records for DTOs; use a mutable class only when the framework explicitly requires it (e.g., Thymeleaf form-backing objects)
- Name request DTOs with suffix `Request` (e.g. `CreateUserRequest`), response DTOs with suffix `Response` (e.g. `UserResponse`)
- Place all validation annotations (`@NotNull`, `@NotBlank`, `@Size`, etc.) on request DTOs, never on entities
- For collection fields, use `@Valid` (to recursively validate nested objects) and `@NotEmpty` (to reject empty collections) as needed; e.g., `@Valid @NotEmpty List<ItemRequest> items`
- For external identifiers used in lookups or I/O operations (MAC addresses, filenames, user IDs, URLs), apply explicit format constraints: `@Pattern` for regex-based validation, `@Size` for length bounds, or custom validators. Document the allowed format in the annotation's message parameter. Example: `@Pattern(regexp = "^([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})$", message = "MAC address must be in format HH:HH:HH:HH:HH:HH") String macAddress`

## Mapper Boundary
- Always map at layer boundaries: controller returns response DTOs, service maps domain objects to DTOs before returning
- Use consistent method names: `toEntity`, `toResponse`, `toCreateResponse`

## MapStruct
- MapStruct is mandatory for all domain ↔ DTO mapping; never write manual conversion boilerplate
- Define mappers as interfaces annotated with `@Mapper(componentModel = "spring")`
- Name MapStruct mapper interfaces with suffix `DtoMapper` to avoid overlap with SQL/MyBatis mapper conventions
- Use package-private visibility by default for mapper interfaces; elevate to `public` only when external callers require it
- Default to `unmappedTargetPolicy = ReportingPolicy.ERROR` to catch unmapped fields at compile time. For intentional partial mapping (e.g., computed fields not in DTO, differing hierarchies), explicitly set policy to `WARN` or `IGNORE`, add a one-line inline comment, and consider a unit test documenting the unmapped fields.

## MapStruct Build Requirements
- When DTO mapping exists in scope, `pom.xml` must include `org.mapstruct:mapstruct`
- `maven-compiler-plugin` must include `org.mapstruct:mapstruct-processor` under `annotationProcessorPaths`
- If Lombok and MapStruct are both used, `annotationProcessorPaths` must include `org.projectlombok:lombok-mapstruct-binding`
- Do not finalize generation if mapper interfaces exist but MapStruct dependencies/processors are missing

## Raw Passthrough Exception
See [spring-boot-controller.instructions.md](./spring-boot-controller.instructions.md) for the canonical Raw Passthrough Exception rule.

