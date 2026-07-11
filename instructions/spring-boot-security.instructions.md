---
description: "Security rules: Spring Security 6 Lambda DSL, deny-by-default, @PreAuthorize, CSRF/CORS policy, secrets, and error message hygiene."
applyTo: "**/*SecurityConfig.java, **/security/**/*.java, **/pom.xml, **/application*.yml"
---

# Security Rules

## Configuration
- Include `spring-boot-starter-security` in `pom.xml` whenever Security is selected by architecture scope
- Use Spring Security 6+ Lambda DSL for `HttpSecurity`; never use chained `.and()` style
- Deny by default; explicitly permit only required public endpoints
- The public endpoint list must be minimal and documented in the security config class

## Authorization
- Use `@PreAuthorize` for method-level authorization on business-sensitive operations
- Disable CSRF globally only when both conditions are true: (1) the service is strictly stateless and (2) authentication is non-cookie-based (for example, token-based authentication). Otherwise, do not disable CSRF globally.

## Actuator Endpoints
- Protect `/actuator/**` with authentication and authorization in non-development profiles by default
- Permit unauthenticated access only to probe endpoints required by internal health checks (`/actuator/health`, `/actuator/health/liveness`, `/actuator/health/readiness`)
- Never expose actuator endpoints through public ingress without access controls

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
- HTTPS is mandatory in `application-production.yml`; configure `server.ssl.*` with environment-backed values only
- **Never commit certificate files to the repository.** Store the keystore file outside the codebase (e.g., on the runtime host, in a secrets vault, or mounted as a volume). Reference the keystore path and credentials exclusively from environment variables; do not embed paths or filenames in YAML
- Use `TLSv1.3` exclusively; do not permit older TLS versions
- Enable HTTP/2 alongside HTTPS: `server.http2.enabled: true`
- Use `server.port: ${SERVER_PORT:9443}` in production profile unless an explicit deployment requirement overrides it
- Do not configure SSL in `application-development.yml` unless specifically required for local testing

When local SSL testing is required:
1. Inject certificate path and password through environment variables
1. Keep local SSL settings isolated to development profile values only
1. Never promote self-signed development certificates to production

