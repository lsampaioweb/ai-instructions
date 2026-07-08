@Slf4j
@Service
class ResourceServiceImpl implements ResourceService {

  private final ResourceRepository resourceRepository;
  private final ResourceMapper resourceMapper;

  ResourceServiceImpl(ResourceRepository resourceRepository, ResourceMapper resourceMapper) {
    this.resourceRepository = resourceRepository;
    this.resourceMapper = resourceMapper;
  }

  @Override
  @Transactional(readOnly = true)
  public List<ResourceResponse> findAll() {
    // ...
  }

  @Override
  @Transactional(readOnly = true)
  public ResourceResponse findById(Long id) {
    // ...
  }

  @Override
  @Transactional
  public ResourceResponse create(CreateResourceRequest request) {
    // ...
  }

  @Override
  @Transactional
  public ResourceResponse update(Long id, UpdateResourceRequest request) {
    // ...
  }

  @Override
  @Transactional
  public int delete(Long id) {
    // ...
  }
}
