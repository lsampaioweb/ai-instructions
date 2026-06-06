---
description: "REST controller rules: no business logic, @Valid inputs, DTO responses, API versioning, and HTTP status conventions."
applyTo: "**/*Controller.java"
---

# Controller Rules

## Rules

- Annotate with `@RestController`
- Declare the full versioned base path at class level: `@RequestMapping("/api/v1/resource-name")` using lowercase plural resource names
- Method annotations use only the path suffix relative to the class mapping: `@GetMapping("/")`, `@GetMapping("/{id}")`, `@PostMapping("/")` — never repeat the base path in method annotations
- No business logic; delegate all processing to the service layer
- Do not call mapper classes or integration clients directly
- Accept input via `@RequestBody` or `@PathVariable`
- When accepting Java Records as `@RequestBody` or `@ModelAttribute`, explicitly annotate the parameter with `@Valid` to trigger DTO-level validation constraints (`@NotNull`, `@NotBlank`, etc.).
- Do NOT apply `@Valid` to scalar parameters like `@PathVariable Long id` or `@RequestParam String name`; they use framework-level type coercion and Spring's built-in constraints. If you need custom validation on scalars, use class-level `@Validated` on the controller combined with `@NotNull` / `@Pattern` on the method parameters.
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

## Templates

CRUD controller skeleton. Replace `{Resource}`, `{resource}`, `{resources}`, and all DTO names with actual project values.

```java
@Slf4j
@RestController
@RequestMapping("/api/v1/{resources}")
@Tag(name = "{Resource}s", description = "Manage {resources}")
class {Resource}Controller {

  private final {Resource}Service {resource}Service;

  {Resource}Controller({Resource}Service {resource}Service) {
    this.{resource}Service = {resource}Service;
  }

  @GetMapping("/")
  @Operation(summary = "List all {resources}")
  public PagedModel<EntityModel<{Resource}Response>> findAll(
      Pageable pageable, PagedResourcesAssembler<{Resource}Response> assembler) {

    return assembler.toModel({resource}Service.findAll(pageable));
  }

  @GetMapping("/{id}")
  @Operation(summary = "Find a {resource} by id")
  public ResponseEntity<{Resource}Response> findById(@PathVariable Long id) {
    return ResponseEntity.ok({resource}Service.findById(id));
  }

  @PostMapping("/")
  @Operation(summary = "Create a new {resource}")
  public ResponseEntity<{Resource}Response> create(
      @Valid @RequestBody Create{Resource}Request request, UriComponentsBuilder uriBuilder) {

    {Resource}Response response = {resource}Service.create(request);
    URI location = uriBuilder.path("/api/v1/{resources}/{id}").buildAndExpand(response.id()).toUri();

    return ResponseEntity.created(location).body(response);
  }

  @PutMapping("/{id}")
  @Operation(summary = "Update a {resource}")
  public ResponseEntity<{Resource}Response> update(
      @PathVariable Long id, @Valid @RequestBody Update{Resource}Request request) {

    return ResponseEntity.ok({resource}Service.update(id, request));
  }

  @DeleteMapping("/{id}")
  @Operation(summary = "Delete a {resource}")
  public ResponseEntity<Void> delete(@PathVariable Long id) {
    {resource}Service.delete(id);

    return ResponseEntity.noContent().build();
  }
}
```
