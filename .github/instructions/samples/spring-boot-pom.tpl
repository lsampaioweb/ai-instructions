<?xml version="1.0" encoding="UTF-8"?>
<!--
  DEPENDENCY REFERENCE PALETTE

  This template shows ALL approved dependencies organized by feature/use case.
  Copy the dependency snippet that matches your feature. If a feature is not listed
  or a dependency is not in this palette, check with the Architect or it will be
  flagged as a violation by Testing.

  To add a new approved dependency, add it to this file and reference it in your ADR.
-->

<!--
  ============================================================================
  CORE INFRASTRUCTURE
  ============================================================================
  Basic Spring Boot setup required in all projects
-->
<properties>
  <java.version>25</java.version>
  <springdoc.version>2.8.13</springdoc.version>
  <mapstruct.version>1.6.3</mapstruct.version>
  <spring-cloud.version>2025.0.0</spring-cloud.version>
</properties>

<!--
  Unit and integration testing support
  Scope: test
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-test</artifactId>
  <scope>test</scope>
</dependency>

<!--
  Live reload and developer tools; excluded from production builds
  Scope: runtime, optional: true
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-devtools</artifactId>
  <scope>runtime</scope>
  <optional>true</optional>
</dependency>

<!--
  Boilerplate reduction via annotations (@Slf4j, @Data, etc.)
  Scope: provided
  Note: Requires maven-compiler-plugin annotation processor configuration
-->
<dependency>
  <groupId>org.projectlombok</groupId>
  <artifactId>lombok</artifactId>
  <scope>provided</scope>
</dependency>

<!--
  ============================================================================
  WEB & REST
  ============================================================================
-->

<!--
  Embedded web server, MVC, REST support
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!--
  Health and info endpoints via Spring Boot Actuator
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

<!--
  Input validation: @NotNull, @NotBlank, @Email, etc. for form/request validation
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-validation</artifactId>
</dependency>

<!--
  HTTP authentication and route authorization with Spring Security
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!--
  Spring Security test support for MockMvc authentication and authorization assertions
  Scope: test
-->
<dependency>
  <groupId>org.springframework.security</groupId>
  <artifactId>spring-security-test</artifactId>
  <scope>test</scope>
</dependency>

<!--
  OpenAPI 3 documentation with Swagger UI; serves the UI at /swagger-ui/index.html
  Version: Use property (e.g., ${springdoc.version}) in properties section
-->
<dependency>
  <groupId>org.springdoc</groupId>
  <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
  <version>${springdoc.version}</version>
</dependency>

<!--
  Hypermedia-driven REST responses with HATEOAS support
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-hateoas</artifactId>
</dependency>

<!--
  ============================================================================
  TEMPLATING
  ============================================================================
-->

<!--
  Server-side HTML templating with Thymeleaf
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>

<!--
  ============================================================================
  DATABASE
  ============================================================================
  Note: No JPA/Hibernate/ORM dependencies allowed. JDBC only.
-->

<!--
  Spring JDBC for database access without ORM; row mapper for result sets
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>

<!--
  PostgreSQL JDBC driver; enables connection to PostgreSQL databases
  Scope: runtime
-->
<dependency>
  <groupId>org.postgresql</groupId>
  <artifactId>postgresql</artifactId>
  <scope>runtime</scope>
</dependency>

<!--
  Connection pooling: manages database connection lifecycle and reuse
  Scope: runtime
-->
<dependency>
  <groupId>com.zaxxer</groupId>
  <artifactId>HikariCP</artifactId>
  <scope>runtime</scope>
</dependency>

<!--
  ============================================================================
  CACHING & IN-MEMORY DATA
  ============================================================================
-->

<!--
  Redis integration: Spring Data Redis and Lettuce client
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>

<!--
  ============================================================================
  MESSAGING & EVENTS
  ============================================================================
-->

<!--
  AMQP support for RabbitMQ queues, exchanges, bindings, and listeners
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>

<!--
  WebSocket and STOMP support for real-time bidirectional messaging
-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-websocket</artifactId>
</dependency>

<!--
  ============================================================================
  OBJECT MAPPING
  ============================================================================
-->

<!--
  MapStruct API for type-safe DTO and domain object mappings
  Version: Use property (e.g., ${mapstruct.version})
  Note: Requires mapstruct-processor in maven-compiler-plugin annotation processors
-->
<dependency>
  <groupId>org.mapstruct</groupId>
  <artifactId>mapstruct</artifactId>
  <version>${mapstruct.version}</version>
</dependency>

<!--
  ============================================================================
  SPRING CLOUD
  ============================================================================
  Import this BOM in <dependencyManagement> before using Spring Cloud starters.
-->

<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-dependencies</artifactId>
      <version>${spring-cloud.version}</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>

<!--
  Spring Cloud Config client for externalized configuration management
-->
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-config</artifactId>
</dependency>

<!--
  ============================================================================
  BUILD PLUGINS (Maven)
  ============================================================================
  Required in all projects
-->
<plugin>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-maven-plugin</artifactId>
  <configuration>
    <workingDirectory>${project.basedir}</workingDirectory>
  </configuration>
</plugin>

<!--
  Required when using Lombok or MapStruct
  Includes annotation processor paths for compile-time code generation
-->
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <configuration>
    <annotationProcessorPaths>
      <!-- Lombok processor (if using Lombok) -->
      <path>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
      </path>
      <!-- MapStruct processor (if using MapStruct) -->
      <path>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct-processor</artifactId>
        <version>${mapstruct.version}</version>
      </path>
    </annotationProcessorPaths>
  </configuration>
</plugin>
