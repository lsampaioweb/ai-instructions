---
description: "Security rules: Spring Security 6 Lambda DSL, deny-by-default, @PreAuthorize, CSRF/CORS policy, secrets, and error message hygiene."
applyTo: "**/*SecurityConfig.java, **/security/**/*.java"
---

# Security Rules

## Configuration
- Use Spring Security 6+ Lambda DSL for `HttpSecurity`; never use chained `.and()` style
- Deny by default; explicitly permit only required public endpoints
- The public endpoint list must be minimal and documented in the security config class

## Authorization
- Use `@PreAuthorize` for method-level authorization on business-sensitive operations
- Never disable CSRF globally unless the service is strictly stateless and uses non-cookie authentication (e.g., token-based authentication)

## CORS
Configure CORS with explicit allowed origins, methods, and headers. Never use wildcard origins in production.

## Secrets
- Inject signing keys, credentials, and secrets from environment variables or an external secret store
- Never hardcode any secret in code or YAML files

## Logging and Errors
- Do not log credentials, tokens, raw authorization headers, or full security exceptions with sensitive payloads
- Return generic messages for auth failures; never expose internal details
- Never include user input, request parameters, or any dynamic values in exception message text; use i18n keys with parameterized placeholders instead
- For shared operator-facing message-key and HTTP error rendering conventions, follow `spring-boot-logging.instructions.md` and `spring-boot-exception.instructions.md`

## Cryptography
Never implement custom cryptography. Use approved Spring Security password encoders and providers.

## SSL/TLS
- Enable HTTPS in production via `server.ssl.*` in `application-production.yml`
- **Never commit certificate files to the repository.** Store the keystore file outside the codebase (e.g., on the runtime host, in a secrets vault, or mounted as a volume). Reference the keystore path and credentials exclusively from environment variables; do not embed paths or filenames in YAML
- Use `TLSv1.3` exclusively; do not permit older TLS versions
- Enable HTTP/2 alongside HTTPS: `server.http2.enabled: true`
- Do not configure SSL in `application-development.yml` unless specifically required for local testing

When local SSL testing is required:
1. Inject certificate path and password through environment variables
1. Keep local SSL settings isolated to development profile values only
1. Never promote self-signed development certificates to production

## Templates

**SecurityFilterChain using Lambda DSL.** Replace public paths, CORS origins, and the auth mechanism with actual project values.

```java
@Configuration
@EnableMethodSecurity
class SecurityConfig {

  @Bean
  SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
      .authorizeHttpRequests(auth -> auth
        // Public endpoints — keep this list minimal; document each entry
        .requestMatchers("/actuator/health", "/actuator/info").permitAll()
        .anyRequest().authenticated()
      )
      .sessionManagement(session -> session
        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
      )
      .csrf(AbstractHttpConfigurer::disable) // stateless API — no session cookie, no CSRF needed
      .httpBasic(Customizer.withDefaults());

    return http.build();
  }

  @Bean
  CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration config = new CorsConfiguration();
    config.setAllowedOrigins(List.of("https://{allowed-origin}")); // replace with actual origin
    config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    config.setAllowedHeaders(List.of("Authorization", "Content-Type", "Accept-Language"));

    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", config);

    return source;
  }
}
```

**Method-level authorization.** Apply `@PreAuthorize` on service methods that require role or permission checks. Use `ROLE_USER` for read operations and `ROLE_ADMIN` for write operations as the baseline; adjust roles to actual project requirements.

```java
// Read — accessible by any authenticated user
@PreAuthorize("hasRole('USER')")
List<UserResponse> findAll() { ... }

@PreAuthorize("hasRole('USER')")
UserResponse findById(Long id) { ... }

// Write — restricted to admins
@PreAuthorize("hasRole('ADMIN')")
UserResponse create(CreateUserRequest request) { ... }

@PreAuthorize("hasRole('ADMIN')")
UserResponse update(Long id, UpdateUserRequest request) { ... }

@PreAuthorize("hasRole('ADMIN')")
void delete(Long id) { ... }
```
