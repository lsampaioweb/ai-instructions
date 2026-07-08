@Configuration
@EnableMethodSecurity
class SecurityConfig {

  @Bean
  SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    // ...
  }

  @Bean
  CorsConfigurationSource corsConfigurationSource() {
    // ...
  }
}
