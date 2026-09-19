package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
class ActuatorSecurityConfig {

  @Bean
  SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests(authorize -> authorize
        .requestMatchers("/actuator/health", "/actuator/health/**").permitAll()
        .requestMatchers("/actuator/**").authenticated()
        .requestMatchers(publicRoutes()).permitAll()
        .anyRequest().denyAll())
        .httpBasic(Customizer.withDefaults());

    return http.build();
  }

  private String[] publicRoutes() {
    return new String[] { "/api/v1/example", "/error" };
  }
}