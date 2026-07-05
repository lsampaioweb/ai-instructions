---
description: "DTO and mapper rules: immutable records, validation placement, and mapper conventions."
applyTo: "**/*DTO.java, **/*Dto.java, **/*DtoMapper.java, **/*Mapper.java, **/*Request.java, **/*Response.java"
---

# DTO and Mapper Rules

## Scope
- Applies to DTO classes and non-SQL feature mappers (e.g., Spring `@Component` mappers used for domain ↔ DTO conversion)
- SQL/MyBatis persistence mappers follow `spring-boot-repository.instructions.md`

## DTOs
- Use Java records for DTOs; use a class only when the framework requires mutability
- Name request DTOs with suffix `Request` (e.g. `CreateUserRequest`), response DTOs with suffix `Response` (e.g. `UserResponse`)
- Place all validation annotations (`@NotNull`, `@NotBlank`, `@Size`, etc.) on request DTOs, never on entities
- For collection fields, use `@Valid` (to recursively validate nested objects) and `@NotEmpty` (to reject empty collections) as needed; e.g., `@Valid @NotEmpty List<ItemRequest> items`
- For external identifiers used in lookups or I/O operations (MAC addresses, filenames, user IDs, URLs), apply explicit format constraints: `@Pattern` for regex-based validation, `@Size` for length bounds, or custom validators. Document the allowed format in the annotation's message parameter. Example: `@Pattern(regexp = "^([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})$", message = "MAC address must be in format HH:HH:HH:HH:HH:HH") String macAddress`

## Mapper Boundary
- Always map at layer boundaries: controller returns response DTOs, service maps domain objects to DTOs before returning
- Use consistent method names: `toEntity`, `toResponse`, `toCreateResponse`
- Default mapper style: package-private Spring component class (e.g., `{Resource}Mapper`) when mapping is simple and MapStruct is not already required

## MapStruct (Optional)
- Use MapStruct when it is already present in the module or explicitly requested
- Define mappers as interfaces annotated with `@Mapper(componentModel = "spring")`
- Name MapStruct mapper interfaces with suffix `DtoMapper` to avoid overlap with SQL/MyBatis mapper conventions
- Use package-private visibility by default for mapper interfaces; elevate to `public` only when external callers require it
- Default to `unmappedTargetPolicy = ReportingPolicy.ERROR` to catch unmapped fields at compile time. For intentional partial mapping (e.g., computed fields not in DTO, differing hierarchies), explicitly set policy to `WARN` or `IGNORE`, add a one-line inline comment, and consider a unit test documenting the unmapped fields.

## Raw Passthrough Exception
See [spring-boot-controller.instructions.md](./spring-boot-controller.instructions.md) for the canonical Raw Passthrough Exception rule.

## Templates

**Request DTO record.** Replace `{Resource}` with the domain concept name. Add or remove fields and validation annotations as needed.

```java
public record Create{Resource}Request(
  @NotBlank String name,
  @NotBlank @Size(max = 255) String description) {}
```

**Response DTO record.** Replace `{Resource}` with the domain concept name. Add or remove fields as needed.

```java
public record {Resource}Response(
  Long id,
  String name,
  String description) {}
```

**Spring component mapper (default).** Replace `{Resource}` with the domain concept name. Keep package-private when used only in the same feature package.

```java
@Component
class {Resource}Mapper {
  {Resource}Response toResponse({Resource} entity) {
    return new {Resource}Response(entity.id(), entity.name(), entity.description());
  }
}
```

**MapStruct mapper interface (optional).** Replace `{Resource}` with the domain concept name. Use `ReportingPolicy.ERROR` by default. Add `@Mapping` annotations when source and target field names differ.

```java
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
interface {Resource}Mapper {
  {Resource} toEntity(Create{Resource}Request request);
  {Resource}Response toResponse({Resource} entity);
  void updateEntity(Update{Resource}Request request, @MappingTarget {Resource} entity);
  // If partial mapping is intentional, switch to WARN/IGNORE and add a one-line reason comment.
  // @Mapping(source = "entityField", target = "responseField")
}
```
