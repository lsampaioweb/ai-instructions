@Slf4j
@Component
class FeatureRegistry {

  private static final String LOG_LOADING = "log.feature.loading";
  private static final String LOG_INITIALIZATION_COMPLETE = "log.feature.initialization.complete";
  private static final String ERROR_LOAD_FAILED = "error.feature.load.failed";

  private final AppConfigurationProperties properties;
  private final LogMessages logMessages;

  FeatureRegistry(AppConfigurationProperties properties, LogMessages logMessages) {
    this.properties = properties;
    this.logMessages = logMessages;
  }

  @PostConstruct
  void initialize() {
    // ...
  }
}
