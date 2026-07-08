@ConfigurationProperties(prefix = "external.api.feature")
public record ExternalApiProperties(String baseUrl) {}
