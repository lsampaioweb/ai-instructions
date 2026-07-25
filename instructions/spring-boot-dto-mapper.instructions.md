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
- Use MapStruct for generated mapper implementations when the module adopts generated mapping.
- Keep generated mappers strict with `unmappedTargetPolicy = ReportingPolicy.ERROR`.
- Keep DTO and entity model boundaries explicit in mapper methods.
- Keep request DTO strategy explicit: use operation-specific request DTOs when create/update validation diverges, or a shared request DTO when validation and semantics are identical.
- Keep public API responses mapped to dedicated `*Response` DTO types.
- Keep update mapping explicit for mutable entity fields.
- Keep mapper visibility aligned with feature encapsulation.

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
