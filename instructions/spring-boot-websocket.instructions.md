---
description: "WebSocket/STOMP rules: endpoint topology, message flow contract, lifecycle handling, and client resilience."
applyTo: "**/*WebSocketConfiguration*.java, **/*SocketEndpoint.java, **/*SessionEventsListener.java, **/*ConnectionTracker.java, **/*StompMessage.java, **/*SocketMessage.java, **/*WebSocketMessage.java, **/static/js/*websocket*.js, **/static/js/*socket*.js"
---

# WebSocket and STOMP Rules

## Scope
- Use this file for WebSocket/STOMP transport concerns only (broker setup, endpoint contract, messaging flow, lifecycle events, and browser socket state)
- Keep business rules in service/domain instructions; do not move domain workflows into WebSocket endpoint classes

## Endpoint and Broker Topology
- Use a dedicated `@Configuration` class implementing `WebSocketMessageBrokerConfigurer` for WebSocket setup
- Define destination prefixes and endpoint paths as constants, not inline literals spread across methods
- Configure clear destination domains: application/inbound prefix (e.g., `/app`) for messages sent from clients to server handlers, and broker/outbound prefixes (e.g., `/topic`, `/queue`) for server-to-client delivery
- Register a STOMP endpoint and enable SockJS fallback when browser compatibility is required

## Configuration Binding
- Bind WebSocket settings using `@ConfigurationProperties` for grouped values (origins, endpoint roots, destination overrides)
- Do not hardcode environment-dependent origins in Java code
- Use wildcard origins (`*`) only for tutorials/local demos; production profiles must use explicit origin lists

## Message Handler Contract
- Implement STOMP handlers in dedicated `@Controller` endpoint classes with `@MessageMapping`
- Publish broadcast responses using explicit broker destinations (e.g., via `@SendTo`)
- Keep payload and response models as immutable records unless mutability is required
- Do not trust client-generated timestamps or metadata for canonical server events; set canonical server values in the handler or delegated service

## Lifecycle and Observability
- Handle connect/disconnect lifecycle events with listener classes and keep connection-state tracking thread-safe
- Skip connection-state updates when session ID is null or blank; log this branch at `DEBUG` level before returning
- Expose operational connection status via typed response DTOs/records when an HTTP status endpoint is required
- Apply existing logging instructions: use i18n log keys and avoid sensitive data in logs

## Browser Client Behavior
- Keep socket lifecycle in a single JS module with one active client reference and explicit connection-state flags
- Enforce reconnect safety: detect stale connections, reset state on close/error, and guard duplicate connect attempts
- Keep send and subscribe destinations explicit and aligned with server mapping conventions
- Disable message actions while disconnected and re-enable only after successful connection
- Externalize user-facing runtime text through server-rendered i18n values or configurable runtime strings

