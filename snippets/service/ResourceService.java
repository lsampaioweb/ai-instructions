interface ResourceService {

  List<ResourceResponse> findAll();

  ResourceResponse findById(Long id);

  ResourceResponse create(CreateResourceRequest request);

  ResourceResponse update(Long id, UpdateResourceRequest request);

  int delete(Long id);
}
