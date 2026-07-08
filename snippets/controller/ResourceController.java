@Slf4j
@RestController
@RequestMapping("/api/v1/resources")
@Tag(name = "Resources", description = "Manage resources")
class ResourceController {

  private final ResourceService resourceService;

  ResourceController(ResourceService resourceService) {
    this.resourceService = resourceService;
  }

  @GetMapping("/")
  @Operation(summary = "List all resources")
  public ResponseEntity<List<ResourceResponse>> findAll() {
    // ...
  }

  @GetMapping("/{id}")
  @Operation(summary = "Find a resource by id")
  public ResponseEntity<ResourceResponse> findById(@PathVariable Long id) {
    // ...
  }

  @PostMapping("/")
  @Operation(summary = "Create a new resource")
  public ResponseEntity<ResourceResponse> create(
      @Valid @RequestBody CreateResourceRequest request, UriComponentsBuilder uriBuilder) {
    // ...
  }

  @PutMapping("/{id}")
  @Operation(summary = "Update a resource")
  public ResponseEntity<ResourceResponse> update(
      @PathVariable Long id, @Valid @RequestBody UpdateResourceRequest request) {
    // ...
  }

  @DeleteMapping("/{id}")
  @Operation(summary = "Delete a resource")
  public ResponseEntity<Void> delete(@PathVariable Long id) {
    // ...
  }
}
