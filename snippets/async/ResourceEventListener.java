@Slf4j
@Component
class ResourceCreatedListener {

  private static final String LOG_RESOURCE_CREATED = "resource.created.log";

  private final LogMessages logMessages;

  ResourceCreatedListener(LogMessages logMessages) {
    this.logMessages = logMessages;
  }

  @Async
  @TransactionalEventListener
  public void onResourceCreated(ResourceCreatedEvent event) {
    // ...
  }
}
