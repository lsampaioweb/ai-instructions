# application-production.yml
# Profile-specific configuration for production environment
# Only override values that differ from application.yml

server:
  port: 8080
  error:
    # Hide stack traces in error responses (security)
    include-stacktrace: "never"

management:
  endpoint:
    health:
      # Hide health details unless user is authorized (security)
      show-details: "never"

# OpenAPI documentation: disable Swagger UI in production
springdoc:
  swagger-ui:
    enabled: false
  api-docs:
    enabled: false

