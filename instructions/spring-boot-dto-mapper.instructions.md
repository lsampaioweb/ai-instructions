---
description: "DTO and MapStruct mapper rules: immutable records, validation placement, and @Mapper conventions."
applyTo: "**/*DTO.java, **/*Dto.java, **/*Mapper.java, **/*Request.java, **/*Response.java"
---

# DTO and Mapper Rules

## DTOs
- Use Java records for DTOs; use a class only when the framework requires mutability
- Name request DTOs with suffix `Request` (e.g. `CreateUserRequest`), response DTOs with suffix `Response` (e.g. `UserResponse`)
- Place all validation annotations (`@NotNull`, `@NotBlank`, `@Size`, etc.) on request DTOs, never on entities
- For collection fields, use `@Valid` (to recursively validate nested objects) and `@NotEmpty` (to reject empty collections) as needed; e.g., `@Valid @NotEmpty List<ItemRequest> items`
- For external identifiers used in lookups or I/O operations (MAC addresses, filenames, user IDs, URLs), apply explicit format constraints: `@Pattern` for regex-based validation, `@Size` for length bounds, or custom validators. Document the allowed format in the annotation's message parameter. Example: `@Pattern(regexp = "^([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})$", message = "MAC address must be in format HH:HH:HH:HH:HH:HH") String macAddress`

## MapStruct
- Define mappers as interfaces annotated with `@Mapper(componentModel = "spring")`
- Use consistent method names: `toEntity`, `toResponse`, `toCreateResponse`
- Keep mapper interfaces package-private when used only within the same feature package
- Configure `unmappedTargetPolicy = ReportingPolicy.ERROR` in the `@Mapper` annotation to catch unmapped fields at compile time and prevent silent data loss.
- If partial mapping is intentional (e.g., computed fields in the entity not present in the DTO, or differing inheritance hierarchies), explicitly set the policy to `WARN` or `IGNORE` for that specific mapper and add a one-line inline comment explaining why. Consider adding a unit test to document and verify the intentional unmapped fields.

## Raw Passthrough Exception
See [spring-boot-controller.instructions.md](./spring-boot-controller.instructions.md) for the Raw Passthrough Exception rule. When the response body is raw opaque content (e.g. TOML, binary files), skip the response DTO and mapper entirely.

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

**MapStruct mapper interface.** Replace `{Resource}` with the domain concept name. Add `@Mapping` annotations when source and target field names differ.

```java
@Mapper(componentModel = "spring")
interface {Resource}Mapper {
  {Resource} toEntity(Create{Resource}Request request);
  {Resource}Response toResponse({Resource} entity);
  void updateEntity(Update{Resource}Request request, @MappingTarget {Resource} entity);
  // @Mapping(source = "entityField", target = "responseField")
}
```
