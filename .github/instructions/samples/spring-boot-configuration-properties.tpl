package com.example.demo.feature;

import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.feature")
public record FeatureConfigurationProperties(
    String displayName,
    Endpoint endpoint,
    List<String> enabledRegions) {

  public record Endpoint(String baseUrl, int connectTimeoutSeconds) {
  }
}