// Default: Spring component mapper. Use ResourceDtoMapper.java when MapStruct is in scope.
@Component
class ResourceMapper {

  ResourceResponse toResponse(Resource entity) {
    // ...
  }

  Resource toEntity(CreateResourceRequest request) {
    // ...
  }

  void updateEntity(UpdateResourceRequest request, Resource entity) {
    // ...
  }
}
