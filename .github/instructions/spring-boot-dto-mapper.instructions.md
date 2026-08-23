---
description: "Spring Boot DTO-mapper contract for deterministic model mapping and boundary-safe transformations."
applyTo: "**/*Request.java, **/*Response.java, **/*DtoMapper.java"
---

# Spring Boot DTO-Mapper Engine

## Naming Conventions
- Name inbound DTO types with the `*Request` suffix (e.g., `CreateHolidayRequest`, `UpdateHolidayRequest`).
- Name outbound DTO types with the `*Response` suffix (e.g., `HolidayResponse`).
- Name DTO mapper interfaces with the `*DtoMapper` suffix (e.g., `HolidayDtoMapper`).
- Use domain-prefixed mapper names (never `Mapper`, `DomainMapper`, or `EntityMapper` without a domain-entity prefix).

## Rules
- For MapStruct dependency and annotation processor configuration, follow `spring-boot-pom.instructions.md`.
- For domain/persistence model annotation bans, defer to `spring-boot-model.instructions.md`.
- Declare request and response DTO types as Java records.
- Declare all request and response DTO records as `public`.
- Apply Bean Validation constraints (`@NotBlank`, `@NotNull`, `@Email`, `@Positive`) on all required request DTO fields.
- Use i18n message keys as the `message` attribute value on all Bean Validation constraints on request DTO fields.
- Keep mapping logic isolated in dedicated mapper types.
- Declare a mapper interface as public only when it is shared across two or more distinct feature packages.
- Use MapStruct for all mapper implementations when the module adopts generated mapping.
- Set `componentModel = "spring"` on every `@Mapper` interface.
- Set `unmappedTargetPolicy = ReportingPolicy.ERROR` on every `@Mapper` interface.
- Use operation-specific request DTOs (`CreateXRequest`, `UpdateXRequest`) when create and update validation diverges.
- Map all public API responses to dedicated `*Response` DTO types.
- Annotate partial-update mapping methods with `@BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)`.
- Annotate full-replacement mapping methods with `@BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.SET_TO_NULL)`.
- Define explicit collection mapping methods (e.g., `List<HolidayResponse> toResponseList(List<Holiday> items)`) in the mapper interface when collection mapping is needed.
- Suppress an unmapped field only with an explicit `@Mapping(target = "field", ignore = true)` annotation.

## Safety Guards
- Never add business logic inside a mapper method.
- Never bypass the mapper layer by copying fields directly in controller or service classes.
- Never mix MapStruct and ad-hoc manual mapping styles inside the same feature module.
