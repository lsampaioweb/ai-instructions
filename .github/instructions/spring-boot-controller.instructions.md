---
description: "Spring Boot controller contract for request mapping, HTTP semantics, validation boundaries, and response consistency."
applyTo: "**/*Controller.java"
---

# Spring Boot Controller Engine

## Naming Conventions
- Name controller classes with the `*Controller` suffix (e.g., `HolidayController`, `AccountController`).
- Use descriptive resource names in controller class identifiers (never `ApiController` or `WebController`).

## Rules
- Annotate REST API controllers with `@RestController`.
- Annotate page-flow controllers with `@Controller`.
- Use class-level `@RequestMapping` for every controller.
- Use method-level HTTP verb annotations (`@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`, `@PatchMapping`) for each operation.
- Keep controller logic thin and delegate business rules to services.
- Return `ResponseEntity` with a typed `*Response` DTO for all REST endpoints.
- Include a `Location` response header on HTTP 201 responses pointing to the created resource URL.
- Build the `Location` URI using `UriComponentsBuilder` injected as a method parameter in the POST handler.
- Return HTTP 200 OK for GET and PUT operations.
- Return HTTP 200 with an empty collection for GET collection endpoints that produce no results.
- Return HTTP 201 Created with the created resource body for POST operations.
- Return HTTP 204 No Content for DELETE operations.
- Return HTTP 404 when a DELETE operation targets a non-existent resource.
- Return HTTP 404 when a single-resource GET finds no matching resource.
- Return explicit view names for page-flow controller methods.
- Apply `@Valid` to all `@RequestBody` parameters.
- Apply `@Positive` to numeric `@PathVariable` resource-identifier parameters.
- Map `Optional<T>` service returns via `.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build())`.

## Safety Guards
- Never call `Optional.get()` directly on a service-returned `Optional<T>`.
- Never mix `@RestController` and page-rendering responsibilities in the same controller class.
- Never mix unrelated resource routes in one controller class.
- Never expose internal exception details in controller responses.
- Never use `@RequestBody` on GET or DELETE methods.
