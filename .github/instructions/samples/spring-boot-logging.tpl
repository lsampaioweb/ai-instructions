<?xml version="1.0" encoding="UTF-8"?>
<configuration>

  <!-- Extract application name from Spring property (used in log filenames) -->
  <springProperty scope="context" source="spring.application.name" name="APPLICATION_NAME" />

  <!-- Extract log directory path from Spring property (default to ./logs if not set) -->
  <springProperty scope="context" source="logging.file.path" name="LOG_DIR" defaultValue="./logs" />

  <!-- Extract rolling policy configuration from Spring properties (customizable per project) -->
  <springProperty scope="context" source="logging.file.max-size" name="MAX_FILE_SIZE" defaultValue="10MB" />
  <springProperty scope="context" source="logging.file.max-history" name="MAX_HISTORY" defaultValue="7" />
  <springProperty scope="context" source="logging.file.total-size-cap" name="TOTAL_SIZE_CAP" defaultValue="1GB" />

  <!-- Console appender: colorized output for development visibility -->
  <appender name="Console" class="ch.qos.logback.core.ConsoleAppender">
    <encoder>
      <!-- Pattern: black timestamp | highlighted level | blue thread | yellow logger | message | stacktrace -->
      <Pattern>%black(%d{ISO8601}) %highlight(%-5level) [%blue(%t)] %yellow(%logger{60}): %msg%n%throwable</Pattern>
    </encoder>
  </appender>

  <!-- File appender: writes to rolling log files with size and time-based rotation -->
  <appender name="RollingFile" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <!-- Current log file: {APP_NAME}.log -->
    <file>${LOG_DIR}/${APPLICATION_NAME}.log</file>
    <encoder>
      <!-- Pattern without colors (plain text for log files) -->
      <Pattern>%d{ISO8601} %-5level [%t] %logger{60}: %msg%n%throwable</Pattern>
    </encoder>
    <!-- Rolling policy: rotate by size or daily, keep configured days, max configured space -->
    <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
      <!-- Archived file pattern: {APP_NAME}-{date}.{counter}.gz (gzipped) -->
      <fileNamePattern>${LOG_DIR}/archived/${APPLICATION_NAME}-%d{yyyy-MM-dd}.%i.gz</fileNamePattern>
      <!-- Each active log file: max size before rotation (configured in application.yml) -->
      <maxFileSize>${MAX_FILE_SIZE}</maxFileSize>
      <!-- Keep archived logs for this many days (configured in application.yml) -->
      <maxHistory>${MAX_HISTORY}</maxHistory>
      <!-- Total disk space for all logs (configured in application.yml) -->
      <totalSizeCap>${TOTAL_SIZE_CAP}</totalSizeCap>
    </rollingPolicy>
  </appender>

  <!-- Async wrapper for RollingFile: buffers log events to avoid blocking application threads -->
  <appender name="File" class="ch.qos.logback.classic.AsyncAppender">
    <appender-ref ref="RollingFile" />
  </appender>

  <!-- DEBUG profile: verbose logging for troubleshooting -->
  <springProfile name="debug">
    <root level="DEBUG">
      <appender-ref ref="Console" />
      <appender-ref ref="File" />
    </root>
  </springProfile>

  <!-- DEVELOPMENT profile: info-level logging with console output -->
  <springProfile name="development">
    <root level="INFO">
      <appender-ref ref="Console" />
      <appender-ref ref="File" />
    </root>
  </springProfile>

  <!-- PRODUCTION profile (default): info-level logging to file only (no console) -->
  <springProfile name="default | production">
    <root level="INFO">
      <appender-ref ref="File" />
    </root>
  </springProfile>

</configuration>
