---
description: "REST controller rules: no business logic, @Valid inputs, DTO responses, API versioning, and HTTP status conventions."
applyTo: "**/*Controller.java"
---

# Controller Rules

- Annotate with `@RestController`
- Declare the full versioned base path at class level: `@RequestMapping("/api/v1/resource-name")` using lowercase plural resource names
- Method annotations use only the path suffix relative to the class mapping: `@GetMapping("/")`, `@GetMapping("/{id}")`, `@PostMapping("/")` — never repeat the base path in method annotations
- No business logic; delegate all processing to the service layer
- Do not call mapper classes or integration clients directly
- Accept input via `@RequestBody` or `@PathVariable`; always annotate request body objects with `@Valid`
- Return DTOs only; never return domain objects directly; exception: when the response is raw opaque content (e.g. file bytes, TOML passthrough), return `ResponseEntity<String>` or `ResponseEntity<byte[]>` — see the Raw Passthrough Exception rule below
- Never return `Map<String, Object>` or `Object`; every JSON response must be a strictly typed Java record
- When returning a non-JSON response, set the `produces` attribute explicitly on the mapping annotation (e.g. `@PostMapping(value = "/", produces = "application/toml")`); the `produces` attribute sets the HTTP response `Content-Type` header
- Use specific mapping annotations: `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`, `@PatchMapping`
- HTTP status discipline: 200 for successful reads, 201 for creation via `ResponseEntity`, 204 for no-content, 400 for validation errors, 404 for not found, 500 for unexpected errors
- Keep handler methods `public`; keep helper methods `private`

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
