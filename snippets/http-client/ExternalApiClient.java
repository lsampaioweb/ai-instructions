@Service
class ExternalApiClient {

  private final RestClient.Builder restClientBuilder;
  private final ExternalApiProperties apiProperties;
  private RestClient restClient;

  ExternalApiClient(RestClient.Builder restClientBuilder, ExternalApiProperties apiProperties) {
    this.restClientBuilder = restClientBuilder;
    this.apiProperties = apiProperties;
  }

  @PostConstruct
  private void init() {
    this.restClient = restClientBuilder.baseUrl(apiProperties.baseUrl()).build();
  }

  ResourceResponse findById(Long id) {
    // ...
  }
}
