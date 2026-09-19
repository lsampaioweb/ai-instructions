FROM docker.io/lsampaioweb/java-build:25-maven-alpine.3.23-2026.05 AS builder

COPY . .

RUN --mount=type=cache,target=/root/.m2 mvn package

FROM docker.io/lsampaioweb/java-web:25-alpine.3.23-2026.05 AS runtime

COPY --from=builder --chown=${APP_USER_NAME}:${APP_GROUP_NAME} ${APP_HOME}/target/*.jar app.jar

ENV JAVA_TOOL_OPTIONS=""

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]