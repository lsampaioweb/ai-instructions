FROM docker.io/lsampaioweb/java-web:25-alpine.3.23-2026.05

COPY --chown=${APP_USER_NAME}:${APP_GROUP_NAME} ./target/*.jar app.jar

ENV JAVA_TOOL_OPTIONS=""

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]