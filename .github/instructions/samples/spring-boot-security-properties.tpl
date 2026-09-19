package com.example.demo.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.security.integration")
record SecurityConfigurationProperties(String username, String password) {

  @Override
  public String toString() {
    return "SecurityConfigurationProperties[username=" + username + ", password=[REDACTED]]";
  }
}