package com.example.demo.integration;

import java.time.Duration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestClient;

@Configuration
class ExternalApiConfiguration {

  @Bean
  RestClient externalApiRestClient(ExternalApiProperties properties) {
    SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
    requestFactory.setConnectTimeout(Duration.ofMillis(properties.connectTimeoutMs()));
    requestFactory.setReadTimeout(Duration.ofMillis(properties.readTimeoutMs()));

    return RestClient.builder()
        .requestFactory(requestFactory)
        .baseUrl(properties.baseUrl())
        .build();
  }
}

// In the owning service:
// User user = externalApiRestClient.get().uri("/{id}", id).retrieve().body(User.class);
