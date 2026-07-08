@Configuration
@EnableWebSocketMessageBroker
@EnableConfigurationProperties(WebSocketConfigurationProperties.class)
class WebSocketConfiguration implements WebSocketMessageBrokerConfigurer {

  private static final String APP_PREFIX = "/app";
  private static final String TOPIC_PREFIX = "/topic";
  private static final String QUEUE_PREFIX = "/queue";
  private static final String STOMP_ENDPOINT = "/ws";

  private final WebSocketConfigurationProperties properties;

  WebSocketConfiguration(WebSocketConfigurationProperties properties) {
    this.properties = properties;
  }

  @Override
  public void configureMessageBroker(MessageBrokerRegistry registry) {
    // ...
  }

  @Override
  public void registerStompEndpoints(StompEndpointRegistry registry) {
    // ...
  }
}

@Controller
class ResourceSocketEndpoint {

  @MessageMapping("/resource.send")
  @SendTo("/topic/resources")
  public ResourceSocketMessage publish(ResourceSocketMessage message) {
    // ...
  }
}
