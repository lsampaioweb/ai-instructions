---
description: "Spring DTO mappers for explicit request, response, query, and message transformations using MapStruct."
applyTo: "**/src/main/java/**/*Mapper.java, **/src/main/java/**/*DtoMapper.java, **/*Request.java, **/*Response.java, **/*Query.java, **/*Message.java"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` and the model contract in `spring-boot-model.instructions.md`.
- Configure MapStruct dependencies and annotation processors according to `spring-boot-pom.instructions.md` when using a MapStruct mapper.

## Naming Conventions
- Name inbound DTO types with the `*Request` suffix (e.g., `CreateHolidayRequest`, `UpdateHolidayRequest`).
- Name outbound DTO types with the `*Response` suffix (e.g., `HolidayResponse`).
- Name grouped HTTP query parameter records with the `*Query` suffix (e.g., `PageQuery`).
- Name broker payload records with the `*Message` suffix.
- Name mappers with the `*Mapper` or `*DtoMapper` suffix, keeping each mapper in the same package as the domain type it transforms.
- Use domain-prefixed mapper names (never `Mapper`, `DomainMapper`, or `EntityMapper` without a domain-entity prefix).
- Name mapping methods by direction: `toResponse(...)`, `toEntity(...)`, and `updateEntity(...)` when applicable.

## Rules

### Request, response, query, and message models
- Declare request, response, query, and message DTO types as Java records.
- Declare all request, response, query, and message DTO records as `public`.
- Use request records only for inbound API contracts; keep them separate from domain and persistence types.
- Apply Bean Validation constraints (`@NotBlank`, `@NotNull`, `@Email`, `@Positive`) on all required request DTO fields.
- Use i18n message keys as the `message` attribute value on all Bean Validation constraints on request DTO fields.
- Annotate nested object or collection components with `@Valid` when their elements require cascading validation.
- Use response records only for outbound API contracts; keep them free of input-validation constraints and include only the data required by the client contract.
- Use operation-specific request DTOs (`CreateXRequest`, `UpdateXRequest`) when create and update validation diverges.
- Use query records only for grouped inbound query parameters; normalize query defaults and bounds in the query record constructor; keep them separate from domain and persistence types.
- Use message records only for broker transport contracts; keep them free of service, persistence, and workflow behavior.

### Mapper responsibilities
- Keep mappers limited to transformations between request, domain, and response carriers.
- Map domain types to response carriers through the mapper when a mapped response carrier exists.
- Keep business validation, identifier generation, persistence, transactions, and HTTP concerns outside the mapper.
- Make identifier handling explicit whenever an input request does not contain the domain identifier.
- Register the mapper as a Spring bean and inject it into the consuming service.
- Declare a mapper interface as public only when it is shared across two or more distinct feature packages.

### MapStruct mappers
- Use MapStruct for all mapper implementations when the module adopts generated mapping.
- Use a MapStruct interface annotated with `@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)`.
- Declare `@Mapping` for every managed identifier absent from the input contract.
- Use `ignore = true` for identifiers generated or assigned outside the mapper.
- Use a constant mapping only when the receiving system requires that fixed value.
- Annotate partial-update mapping methods with `@BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)`.
- Annotate full-replacement mapping methods with `@BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.SET_TO_NULL)`.
- Define explicit collection mapping methods (e.g., `List<HolidayResponse> toResponseList(List<Holiday> items)`) in the mapper interface when collection mapping is needed.
- Suppress an unmapped field only with an explicit `@Mapping(target = "field", ignore = true)` annotation.
- Map all public API responses to dedicated `*Response` DTO types.

## Safety Guards
- Never bypass the mapper layer by copying fields directly in controller or service classes.

## Reference
- Use [samples/spring-boot-mapstruct-dto-mapper.tpl](samples/spring-boot-mapstruct-dto-mapper.tpl) for MapStruct mapper interfaces.
- Use [samples/spring-boot-request.tpl](samples/spring-boot-request.tpl) for request records.
- Use [samples/spring-boot-response.tpl](samples/spring-boot-response.tpl) for response records.
- Use [samples/spring-boot-page-query.tpl](samples/spring-boot-page-query.tpl) for query records.
