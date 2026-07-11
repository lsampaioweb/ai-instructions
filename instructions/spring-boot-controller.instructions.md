---
description: "REST controller rules: no business logic, @Valid inputs, DTO responses, API versioning, and HTTP status conventions."
applyTo: "**/*Controller.java, **/*Api.java"
---

# Controller Rules

For pagination request/response contracts, parameter limits, and `Link` headers, follow `spring-boot-pagination.instructions.md`.
For soft-delete endpoint semantics and hard-delete exception paths, follow `spring-boot-soft-delete.instructions.md`.
For API version evolution, coexistence, and deprecation signaling, follow `spring-boot-api-versioning.instructions.md`.

## Rules

- Scope boundary: applies to REST HTTP handlers only (JSON/API responses)
- It does not apply to Thymeleaf MVC handlers returning template names
- Annotate with `@RestController`
- Declare the full versioned base path at class level: `@RequestMapping("/api/v1/resource-name")` using lowercase plural resource names
- Method annotations use only the path suffix relative to the class mapping (e.g., `@GetMapping`, `@GetMapping("/{id}")`, `@PostMapping`) and never repeat the base path in method annotations
- No business logic; delegate all processing to the service layer
- **No logging of business operations** — state transitions (create/update/delete), operation results, and business events belong in the service layer only
- Allow only protocol adaptation required by HTTP semantics (e.g., status code, headers, content-type); keep all branching, orchestration, transformations, and domain decisions in the service layer
- Do not call mapper classes or integration clients directly
- Accept input via explicit Spring binding annotations (`@RequestBody`, `@PathVariable`, `@RequestParam`, `@RequestHeader`, or `@ModelAttribute`) as required by the endpoint contract
- For `@RequestBody` or `@ModelAttribute` record DTOs, explicitly annotate the parameter with `@Valid` to trigger DTO-level validation constraints (`@NotNull`, `@NotBlank`, etc.)
- Do not apply `@Valid` to scalar `@PathVariable` or `@RequestParam` values; when scalar validation is required, use class-level `@Validated` with parameter constraints such as `@NotNull`, `@Min`, `@Max`, and `@Pattern`
- Return DTOs only; never return domain objects directly
- For raw opaque passthrough responses (e.g. file bytes, TOML), return `ResponseEntity<String>` or `ResponseEntity<byte[]>` as defined in the Raw Passthrough Exception section
- Never return `Map<String, Object>` or `Object`; every JSON response must be a typed Java record
- When returning a non-JSON response, set the `produces` attribute explicitly on the mapping annotation (e.g. `@PostMapping(value = "/", produces = "application/toml")`); the `produces` attribute sets the HTTP response `Content-Type` header
- Use specific mapping annotations: `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`, `@PatchMapping`
- HTTP status discipline: use 200 (successful read), 201 (resource creation), 204 (no-content, especially for successful DELETE), 400 (validation errors), 404 (not found), 500 (unexpected errors)
- Keep handler methods `public`; keep helper methods `private`

## HTTP 201 Created Pattern
- For POST endpoints that create resources, use `ResponseEntity.created(location).body(responseDto)` whenever a stable resource URI is available
- Build `location` from the newly created resource identifier using `UriComponentsBuilder`
- Use `ResponseEntity.status(HttpStatus.CREATED).body(responseDto)` only when a stable resource URI is not available

## API Versioning
- Use URL path versioning: `/api/v1/...`
- The version segment belongs on the class-level `@RequestMapping`, never on individual method annotations
- When introducing a new incompatible version, create a new controller class (e.g. `UserV2Controller`) with `@RequestMapping("/api/v2/users")`; do not modify the existing controller

## External Protocol Exception
When the endpoint URL is mandated by an external protocol, hardware system, or vendor integration (e.g., a device installer that calls a fixed path such as `/answer`), **the external mandate takes absolute precedence over API versioning rules**. Use the exact path specified by the external system; never force it into the `/api/v1/` pattern.
- Place the mandated path on the class-level `@RequestMapping`
- Add a comment on `@RequestMapping` that names the external system and documents the external constraint
- Only ask a clarifying question if the external mandate AND the user's stated requirement are themselves contradictory or ambiguous; if the external protocol is clear, apply it directly

## Raw Passthrough Exception
When the response body is raw opaque content passed through unchanged (e.g. a file read as text or bytes, with a non-JSON content type such as `application/toml`, `text/plain`, or `application/octet-stream`), skip the response DTO and mapper entirely. The service returns the raw content (`String` or `byte[]`) directly; the controller returns `ResponseEntity<String>` or `ResponseEntity<byte[]>` with an explicit `Content-Type`. Do not create a wrapper DTO with a single `content` field just to satisfy the DTO rule.

