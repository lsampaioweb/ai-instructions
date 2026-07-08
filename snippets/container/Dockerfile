FROM docker.io/lsampaioweb/java-web:{jdk}-alpine.{alpine}-{date} AS image
# FROM docker.io/lsampaioweb/java-web:{jdk}-alpine.{alpine}-latest AS image
# FROM docker.io/lsampaioweb/java-web:{jdk}-alpine-latest AS image
# FROM docker.io/lsampaioweb/java-web:latest AS image

COPY --chown=${APP_USER_NAME}:${APP_GROUP_NAME} ./target/*.jar app.jar

ENV JAVA_TOOL_OPTIONS=""

EXPOSE 8080 9443

ENTRYPOINT ["java", "-jar", "app.jar"]
