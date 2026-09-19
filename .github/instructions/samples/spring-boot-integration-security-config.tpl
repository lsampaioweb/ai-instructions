package com.example.demo.config;

// Local or demo-only configuration. Use an adaptive password encoder in deployed environments.

import java.util.Objects;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableConfigurationProperties(SecurityConfigurationProperties.class)
class IntegrationSecurityConfig {

  private final SecurityConfigurationProperties securityProperties;

  IntegrationSecurityConfig(SecurityConfigurationProperties securityProperties) {
    this.securityProperties = Objects.requireNonNull(securityProperties);
  }

  @Bean
  SecurityFilterChain integrationSecurityFilterChain(HttpSecurity http) throws Exception {
    http
        .securityMatcher("/integration/**")
        .authorizeHttpRequests(authorize -> authorize
            .anyRequest().hasRole("integration-client"))
        .httpBasic(Customizer.withDefaults());

    return http.build();
  }

  @Bean
  UserDetailsService userDetailsService() {
    InMemoryUserDetailsManager manager = new InMemoryUserDetailsManager();

    manager.createUser(User.withUsername(securityProperties.username())
        .password(passwordEncoder().encode(securityProperties.password()))
        .roles("integration-client")
        .build());

    return manager;
  }

  @Bean
  PasswordEncoder passwordEncoder() {
    return PasswordEncoderFactories.createDelegatingPasswordEncoder();
  }
}