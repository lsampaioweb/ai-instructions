---
description: "Spring MVC and REST HTTP controllers: routes, request binding, validation, responses, views, and API documentation."
applyTo: "**/*Controller.java, **/*Api.java, **/*PageRoutes.java"
---

## Dependencies
- Follow `spring-boot-java-style.instructions.md` for Java-wide formatting, visibility, injection, constants, JavaDoc, and helper rules.
- Follow `spring-boot-pagination.instructions.md` when an endpoint exposes a paginated collection.
- Follow `spring-boot-api-versioning.instructions.md` for REST route versioning.

## Naming Conventions
- Name REST resource controllers `{Resource}Controller` (e.g., `HolidayController`, `AccountController`).
- Use descriptive resource names in controller class identifiers (never `ApiController` or `WebController`).
- Name server-rendered page controllers `{Feature}PageController` or `{Feature}PageRoutes`.
- Name asynchronous HTTP command endpoints `{Feature}Api` when the endpoint represents an API command rather than a resource controller.
- Name endpoint methods by their HTTP and domain intent, such as `findById(...)`, `create(...)`, `transfer(...)`, or `submitOrder(...)`.

## Rules

### Controller type and routes
- Use `@RestController` for HTTP endpoints that return response bodies.
- Use `@Controller` for endpoints that return rendered views, view fragments, or WebSocket message mappings.
- Declare the shared route with class-level `@RequestMapping`.
- Use plural nouns for collection resource paths.
- Use HTTP method annotations that match the operation: `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`, `@PatchMapping`.
- Keep command-style subpaths explicit when the endpoint represents an operation rather than CRUD, such as `/transfer`.

### Request binding and validation
- Bind JSON payloads with `@RequestBody`.
- Apply `@Valid` to request bodies and validated MVC model attributes.
- Validate numeric path identifiers with `@Positive` when the identifier domain is numeric and positive.
- Use `@RequestParam` for query parameters and command-style scalar inputs.
- Use `@ModelAttribute` for a grouped query contract such as `PageQuery`.
- Declare optional request parameters with `required = false`.
- Place `BindingResult` immediately after its associated validated MVC model attribute.

### REST responses
- Keep controllers thin by delegating business operations to services.
- Return `ResponseEntity` with a typed `*Response` DTO for all REST endpoints when the HTTP status, headers, or body must be explicit.
- Return `200 OK` for successful reads and updates.
- Return `200 OK` with an empty collection for GET collection endpoints that produce no results.
- Return `201 Created` with the created resource body for successful resource creation.
- Return `202 Accepted` when an asynchronous command, such as message publication, has been accepted.
- Return `204 No Content` for successful deletion without a response body.
- Return `404` when a DELETE operation targets a non-existent resource.
- Return `404` when a single-resource GET finds no matching resource.
- Include a `Location` response header on `201` responses pointing to the created resource URL.
- Build the `Location` URI using `UriComponentsBuilder` injected as a method parameter in the POST handler.
- Map `Optional<T>` service returns via `.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build())`.
- Use `ResponseEntity.notFound()` only when the service contract represents absence as an optional result; otherwise defer domain-error translation to dedicated exception handling.
- Keep HTTP status selection and `ResponseEntity` construction in controllers, not services.

### MVC views and form handling
- Return the view name or view fragment from server-rendered MVC endpoints, without the `.html` extension.
- Populate all attributes required to re-render an invalid form before returning its view.
- Return the same view when `BindingResult` contains errors.
- Redirect after a successful MVC form mutation when the next response is a full page.
- Return only the relevant fragment when the endpoint serves an AJAX page update.

### API documentation and logging
- Add `@Tag` to documented REST resources when SpringDoc is used.
- Add `@Operation(summary = "...")` to documented REST operations when SpringDoc is used.
- Use the project message-key pattern for controller logs when logging is required.
- Log operational identifiers and outcome-relevant values without logging credentials, tokens, or secrets.

### Scope boundaries
- Keep validation, route binding, HTTP response construction, and view selection in controllers.
- Keep business decisions, persistence orchestration, and remote integration logic in services.
- Keep `@MessageMapping` and `@SendTo` handling in dedicated WebSocket endpoint classes, not HTTP controllers.

## Safety Guards
- Never call `Optional.get()` directly on a service-returned `Optional<T>`.
- Never mix `@RestController` and page-rendering responsibilities in the same controller class.
- Never mix unrelated resource routes in one controller class.
- Never expose internal exception details in controller responses.
- Never use `@RequestBody` on GET or DELETE methods.

## Reference
- Use [samples/spring-boot-controller.tpl](samples/spring-boot-controller.tpl) for the canonical REST controller structure.
