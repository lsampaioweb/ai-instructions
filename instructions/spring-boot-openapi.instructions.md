---
description: "Spring Boot OpenAPI contract for deterministic API documentation, accurate response semantics, and secure profile-aware exposure in production-grade projects."
applyTo: "**/src/main/java/**/*OpenApi*Config*.java, **/src/main/java/**/*ApiDoc*Config*.java, **/src/main/java/**/*Swagger*Config*.java, **/src/main/java/**/*Controller.java, **/src/main/resources/application*.yml, **/src/main/resources/application*.yaml, **/README.md, **/pom.xml"
---

# Spring Boot OpenAPI Contract
Use this file to enforce deterministic API documentation behavior.

## Scope
1. Apply when springdoc dependency or OpenApiConfig class is present.
2. Keep OpenAPI behavior aligned across pom, configuration, controllers, and README.

## Dependency and Configuration Rules
1. Keep springdoc-openapi dependency explicitly declared in pom.xml when OpenAPI UI or docs are required.
2. Keep OpenAPI metadata configured in OpenApiConfig with explicit title, version, and description.
3. Keep OpenAPI metadata version aligned with published API major version policy.
4. Keep springdoc profile-aware configuration explicit in application profiles.

## Exposure and Security Rules
1. Forbid Swagger UI in production profile and enable it only in development and test profiles.
2. Keep production profile disabling Swagger UI unless an explicit operational exception is documented.
3. Keep API docs endpoint access controls aligned with security configuration.
4. Forbid exposing internal-only endpoints in public OpenAPI definitions.

## Controller Documentation Rules
1. Keep controller operations and response semantics documented for externally exposed endpoints.
2. Keep status code documentation aligned with real controller and exception behavior.
3. Keep request and response schemas aligned with DTO validation and field constraints.
4. Keep pagination, error payload, and authorization requirements documented when applicable.

## README Alignment Rules
1. Keep Swagger UI URL documentation aligned with actual profile behavior.
2. Keep docs availability statements explicit by profile.
3. Keep README examples consistent with versioned /api/vN routes.

## Quality Gates
1. Forbid stale OpenAPI metadata after breaking API changes.
2. Forbid production profile enabling Swagger UI without explicit justification and access restrictions.
3. Keep tests validating docs endpoint availability expectations per profile.
