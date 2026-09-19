package com.example.demo.config;

import java.util.List;
import java.util.Objects;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
@EnableConfigurationProperties(WebSocketConfigurationProperties.class)
class WebSocketConfiguration implements WebSocketMessageBrokerConfigurer {

  private final WebSocketConfigurationProperties properties;

  WebSocketConfiguration(WebSocketConfigurationProperties properties) {
    this.properties = Objects.requireNonNull(properties);
  }

  @Override
  public void configureMessageBroker(MessageBrokerRegistry registry) {
    registry.enableSimpleBroker("/topic", "/queue");
    registry.setApplicationDestinationPrefixes("/app");
  }

  @Override
  public void registerStompEndpoints(StompEndpointRegistry registry) {
    registry.addEndpoint("/ws")
        .setAllowedOriginPatterns(resolveAllowedOriginPatterns())
        .withSockJS();
  }

  private String[] resolveAllowedOriginPatterns() {
    List<String> allowedOrigins = properties.allowedOrigins();

    return allowedOrigins == null ? new String[0] : allowedOrigins.toArray(String[]::new);
  }
}