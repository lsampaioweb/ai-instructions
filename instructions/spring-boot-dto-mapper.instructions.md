---
description: "Spring Boot DTO-mapper contract for deterministic model mapping and boundary-safe transformations."
applyTo: "**/*DtoMapper.java,**/*Mapper.java"
---

# Spring Boot DTO-Mapper Engine

## Scope & Analysis
- Inspect mapper interfaces and mapper classes used by touched features.
- Inspect mapping coverage between request, entity, and response models.
- Inspect update-mapping behavior for partial and full updates.

## Resolution Rules
- Keep mapping logic isolated in dedicated mapper types.
- Keep mapper contracts deterministic and side-effect free.
- Name mapper classes with the DtoMapper suffix (e.g., CountriesDtoMapper) to signal DTO transformation; never use generic Mapper suffix for DTO-to-model or model-to-DTO conversions.
- Declare DTO mapper classes as package-private unless the mapper is explicitly shared across multiple feature packages; a feature-scoped mapper must not be public.
- Use MapStruct for generated mapper implementations when the module adopts generated mapping.
- Keep generated mappers strict with `unmappedTargetPolicy = ReportingPolicy.ERROR`.
- Keep DTO and entity model boundaries explicit in mapper methods.
- Keep request DTO strategy explicit: use operation-specific request DTOs when create/update validation diverges, or a shared request DTO when validation and semantics are identical.
- Keep public API responses mapped to dedicated `*Response` DTO types.
- Keep update mapping explicit for mutable entity fields.

## Review Plan Layout
- Report mapper methods added or changed.
- Report field mappings added, ignored, or transformed.
- Report unmapped-field decisions and justification.
- Report boundary-leak risks between API and persistence models.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never bypass mapper layer by copying fields in controllers.
- Never return domain or persistence entity objects directly from public API endpoints.
- Never mix MapStruct and ad-hoc manual mapper styles inside the same feature module without explicit approval.
- Never reuse one generic request DTO type across create and update operations when validation rules differ.
- Never hide unmapped fields without explicit reason.
- Never mix transport-model logic into persistence models.
