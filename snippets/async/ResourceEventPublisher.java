@Slf4j
@Service
class ResourceServiceImpl implements ResourceService {

  private final ApplicationEventPublisher eventPublisher;

  ResourceServiceImpl(ApplicationEventPublisher eventPublisher) {
    this.eventPublisher = eventPublisher;
  }

  @Override
  @Transactional
  public ResourceResponse create(CreateResourceRequest request) {
    // ... save entity ...
    eventPublisher.publishEvent(new ResourceCreatedEvent(entity.getId(), entity.getName()));
    // ...
  }
}
