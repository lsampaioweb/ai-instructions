networks:
  application-network:

services:
  app:
    image: "example/app:1.0"
    restart: "unless-stopped"
    security_opt:
      - "no-new-privileges:true"
    cap_drop:
      - "ALL"
    environment:
      - "SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE:-production}"
      - "JAVA_TOOL_OPTIONS=${JAVA_TOOL_OPTIONS:-}"
    networks:
      - "application-network"
    volumes:
      - "./logs:/opt/app/logs"
    healthcheck:
      # Requires Spring Boot Actuator health and wget in the runtime image.
      test: ["CMD-SHELL", "wget -q -O- http://localhost:8080/actuator/health || exit 1"]
      start_period: "10s"
      interval: "10s"
      timeout: "5s"
      retries: 10