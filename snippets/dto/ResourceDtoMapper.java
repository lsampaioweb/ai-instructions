// MapStruct variant — use when MapStruct is already present or explicitly requested.
// Rename to ResourceDtoMapper to avoid collision with MyBatis mapper naming.
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
interface ResourceDtoMapper {

  Resource toEntity(CreateResourceRequest request);

  ResourceResponse toResponse(Resource entity);

  void updateEntity(UpdateResourceRequest request, @MappingTarget Resource entity);
}
