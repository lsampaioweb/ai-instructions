# application-development.yml
# Profile-specific configuration for local development environment
# Only override values that differ from application.yml

server:
  # Local development port (matches the container and production templates)
  port: 8080
  error:
    # Show full stack traces in error responses for debugging
    include-stacktrace: "always"

management:
  endpoint:
    health:
      # Show all health details during development (before authorized check)
      show-details: "always"

# SQL initialization: include only when this profile must create and seed the database
spring:
  sql:
    init:
      mode: "always"
      schema-locations: "classpath:sql/db/schema.sql"
      data-locations: "classpath:sql/db/insert.sql"

# OpenAPI documentation: expose Swagger UI only in development
springdoc:
  swagger-ui:
    enabled: true

