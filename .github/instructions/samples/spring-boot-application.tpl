spring:
  application:
    # Name of the application (lowercase, matches pom.xml artifactId)
    name: "<feature>"

  # Enable virtual threads for Java 25+ (better concurrency without extra threads)
  threads:
    virtual:
      enabled: true

  # Internationalization: i18n message bundle location
  # Only include if using spring-boot-starter-web with message properties
  messages:
    basename: "i18n/messages"

  # Profile management: development or production
  profiles:
    active:
      # - "development"
      - "production"

  # Database configuration: uncomment only when using spring-boot-starter-jdbc
  # datasource:
  #   driver-class-name: "org.postgresql.Driver"
  #   # Use environment variables for connection details (never hardcoded)
  #   url: "jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:mydatabase}"
  #   username: "${DB_USER}"
  #   password: "${DB_PASSWORD}"
  #   hikari:
  #     # Maximum number of connections in the pool (default: 10)
  #     maximum-pool-size: 10
  #     # Minimum number of idle connections to maintain
  #     minimum-idle: 2
  #     # Idle connection timeout in milliseconds
  #     idle-timeout: 30000
  #     # Time to wait for a connection before failing
  #     connection-timeout: 20000

  # Exclude auto-configuration: ONLY if NOT using features you don't need
  # Example: exclude database autoconfiguration for REST APIs without persistence
  # autoconfigure:
  #   exclude: "org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration"

# Logging configuration: points to the custom Logback file
logging:
  config: "classpath:log/logback-spring.xml"
  file:
    # Maximum size of each log file before rotation (e.g., 10MB, 500MB, 1GB)
    max-size: 10MB
    # Number of days to keep archived log files (e.g., 7, 30, 90)
    max-history: 7
    # Total disk space cap for all log files combined (e.g., 1GB, 5GB)
    total-size-cap: 1GB
    # Optional: log directory path (default: ./logs if not set via logging.file.path property)
    # path: ./logs

# Operational endpoints: if using spring-boot-starter-actuator
management:
  endpoints:
    web:
      # Expose health, info, metrics; do NOT expose shutdown or env endpoints
      exposure:
        include: "health,info,metrics"
  endpoint:
    health:
      # show-details: "when-authorized" = only show to authenticated users (secure)
      show-details: "when-authorized"
      # probes.enabled: true for container health checks (K8s, Docker)
      # probes:
      #   enabled: true

