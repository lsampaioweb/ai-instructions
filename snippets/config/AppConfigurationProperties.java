@ConfigurationProperties(prefix = "app.feature")
public record AppConfigurationProperties(String baseUrl, Duration timeout, int maxRetries) {
}
