---
description: "WebSocket/STOMP rules: endpoint topology, message flow contract, lifecycle handling, and client resilience."
applyTo: "**/*Socket*.java, **/*Stomp*.java"
---

# Spring Boot WebSocket

## Rules
- Keep STOMP endpoint and destination prefixes explicit.
- Declare all STOMP destination prefix strings as `private static final String` constants in the configuration class.
- Use `/app` as the application destination prefix for client-to-server messages.
- Use `/topic` for server-to-client broadcast subscriptions.
- Use `/queue` for point-to-point messages.
- Use `/ws` as the default STOMP endpoint path unless the module explicitly requires a different path.
- Call `.withSockJS()` on every STOMP endpoint registration for browser transport fallback compatibility.
- Keep allowed-origin strategy externalized through configuration.
- Permit wildcard origins only for explicitly documented development or local profiles.
- Require constrained origin patterns for production profiles.
- Authenticate WebSocket connections at the HTTP handshake phase using the same authentication token as REST endpoints.
- Configure heartbeat intervals explicitly (`outgoingHeartbeat=10000ms`, `incomingHeartbeat=10000ms`).
- Annotate every STOMP message handler parameter with `@Payload` to make the message source explicit.
- Use declarative `@SendTo` for simple, single-destination broadcasts.
- Use `SimpMessagingTemplate` when the broadcast destination is dynamic or computed at runtime.
- Keep message mapping destinations and broadcast target addresses statically defined as constants.
- Route all `SimpMessagingTemplate` and `ApplicationEventPublisher` calls through a dedicated event publisher class.
- Track WebSocket session lifecycle (connect/disconnect) events in a dedicated `@Component`, not in message handler classes.

## Safety Guards
- Never expose websocket endpoints with uncontrolled origin policy.
- Never allow unauthenticated connections to application-level STOMP destinations.
- Never couple broker configuration changes with unrelated features.
