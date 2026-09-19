---
description: "Spring WebSocket STOMP server and SockJS browser client configuration, messaging, connection tracking, and event handling."
applyTo: "**/WebSocket*.java, **/*SocketEndpoint.java, **/*SessionEventsListener.java, **/*ConnectionTracker.java, **/*MessageEventPublisher.java, **/static/js/**/chat-*.js, **/*Socket*.java, **/*Stomp*.java"
---

## Dependencies
- Add `org.springframework.boot:spring-boot-starter-websocket` when STOMP WebSocket messaging is required.
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for Java formatting, imports, visibility, injection, constants, and JavaDoc.
- Follow `spring-boot-i18n.instructions.md` for localized page text and WebSocket log messages.
- Follow `spring-boot-model.instructions.md` for WebSocket transport records.
- Follow `spring-boot-async-events.instructions.md` for application event publishing and listener behavior.

## Naming Conventions
- Name the broker configuration class `WebSocketConfiguration`.
- Name the STOMP endpoint class `{Feature}SocketEndpoint`.
- Name WebSocket configuration properties `WebSocketConfigurationProperties`.
- Use `/ws` for the SockJS handshake endpoint, `/app` for application destinations, `/topic` for broadcasts, and `/queue` for point-to-point destinations.
- Declare all STOMP destination prefix strings as `private static final String` constants in the configuration class.

## Rules

### Server configuration
- Annotate the broker configuration with `@Configuration` and `@EnableWebSocketMessageBroker`, implementing `WebSocketMessageBrokerConfigurer`.
- Enable the simple broker with `/topic` and `/queue` destination prefixes; set `/app` as the application destination prefix.
- Register the `/ws` STOMP endpoint with SockJS support, calling `.withSockJS()` for browser transport fallback compatibility.
- Read allowed origin patterns from `app.websocket.allowed-origins` configuration properties.
- Permit wildcard origins only for explicitly documented development or local profiles; require constrained origin patterns for production profiles.
- Use explicit external origin values outside local development; do not hardcode deployment origins in Java source.
- Authenticate WebSocket connections at the HTTP handshake phase using the same authentication token as REST endpoints.
- Configure heartbeat intervals explicitly (`outgoingHeartbeat=10000ms`, `incomingHeartbeat=10000ms`).

### Message endpoints and events
- Use `@Controller` for STOMP message endpoints.
- Handle client messages with `@MessageMapping` beneath the `/app` prefix.
- Annotate every STOMP message handler parameter with `@Payload` to make the message source explicit.
- Broadcast a returned message with `@SendTo` beneath the `/topic` prefix when all subscribed clients receive it; use declarative `@SendTo` for simple, single-destination broadcasts.
- Use `SimpMessagingTemplate` when the broadcast destination is dynamic or computed at runtime.
- Route all `SimpMessagingTemplate` and `ApplicationEventPublisher` calls through a dedicated event publisher class.
- Keep message mapping destinations and broadcast target addresses statically defined as constants.
- Represent WebSocket message payloads and published events as immutable records.
- Publish application events through `ApplicationEventPublisher` when message side effects, such as auditing, must be decoupled from message delivery.
- Handle published WebSocket events with `@EventListener` components.
- Use UTC timestamps for WebSocket message payloads.

### Connection tracking
- Track active WebSocket session IDs in a thread-safe collection.
- Track WebSocket session lifecycle (connect/disconnect) events in a dedicated `@Component`, not in message handler classes.
- Ignore missing or blank session IDs when processing connection events.
- Update connection tracking from `SessionConnectedEvent` and `SessionDisconnectEvent` listeners.
- Expose connection status through a dedicated REST API only when operational visibility is required.

### Browser client
- Create the browser connection with `SockJS` and wrap it with `Stomp.over(...)`.
- Disable STOMP debug logging in the browser client unless active troubleshooting requires it.
- Subscribe to the server broadcast destination after a successful STOMP connection.
- Send client messages to the matching `/app` destination as JSON.
- Prevent duplicate connections and reset stale client references before reconnecting.
- Reset connection state after connection failure, socket closure, and successful disconnect.
- Do not send a message with blank sender or content values.
- Disconnect the client during page unload when a client connection exists.

### Verification
- Test that the server and browser-client application contexts load.
- Test message handling, broadcast destination, and session tracking when WebSocket behavior is implemented beyond configuration.

## Safety Guards
- Never couple broker configuration changes with unrelated features.

## Reference
- Use [samples/spring-boot-websocket-configuration.tpl](samples/spring-boot-websocket-configuration.tpl) for STOMP broker configuration.
- Use [samples/spring-boot-websocket-configuration-properties.tpl](samples/spring-boot-websocket-configuration-properties.tpl) for allowed-origin property binding.
- Use [samples/spring-boot-websocket-application.tpl](samples/spring-boot-websocket-application.tpl) for `app.websocket.allowed-origins` configuration.
- Use [samples/spring-boot-websocket-socket-endpoint.tpl](samples/spring-boot-websocket-socket-endpoint.tpl) for STOMP message endpoints.
- Use [samples/spring-boot-websocket-connection-tracker.tpl](samples/spring-boot-websocket-connection-tracker.tpl) for connection tracking.
- Use [samples/spring-boot-websocket-session-events-listener.tpl](samples/spring-boot-websocket-session-events-listener.tpl) for WebSocket session-event listeners.
- Use [samples/spring-boot-websocket-client.tpl](samples/spring-boot-websocket-client.tpl) for the browser STOMP client.
- Use [samples/spring-boot-application.tpl](samples/spring-boot-application.tpl) for shared application configuration.
- Use [samples/spring-boot-pom.tpl](samples/spring-boot-pom.tpl) for the WebSocket dependency.
