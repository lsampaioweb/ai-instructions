@Slf4j
@Component
class DependencyHealthIndicator implements HealthIndicator {

  private static final String LOG_HEALTH_DOWN = "health.dependency.down";

  private final DependencyClient dependencyClient;
  private final LogMessages logMessages;

  DependencyHealthIndicator(DependencyClient dependencyClient, LogMessages logMessages) {
    this.dependencyClient = dependencyClient;
    this.logMessages = logMessages;
  }

  @Override
  public Health health() {
    // ...
  }
}
