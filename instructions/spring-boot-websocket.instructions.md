---
description: "Spring Boot WebSocket contract for deterministic real-time messaging, secure endpoint exposure, and operable connection lifecycle behavior in production-grade projects."
applyTo: "**/src/main/java/**/*WebSocket*.java, **/src/main/java/**/*Socket*.java, **/src/main/java/**/*Stomp*.java, **/src/main/java/**/*Configuration*.java, **/src/main/resources/static/js/**/*.js, **/src/main/resources/templates/**/*.html, **/src/main/resources/application*.yml, **/src/main/resources/application*.yaml, **/pom.xml"
---

# Spring Boot WebSocket Contract
Use this file to enforce deterministic WebSocket and STOMP behavior.

## Scope
1. Apply to WebSocket endpoints, STOMP message mappings, broker configuration, and client handshake settings.
2. Keep real-time messaging boundaries explicit and separated from synchronous REST workflows.

## Protocol and Routing Rules
1. Keep WebSocket handshake endpoint paths explicit and stable.
2. Keep STOMP application destination prefixes explicit for client-to-server messages.
3. Keep broker destination prefixes explicit for server-to-client topics and queues.
4. Keep message payload contracts explicit, versioned, and backward-compatible across rollout windows.

## Broker and Delivery Rules
1. Keep broker mode explicit as simple broker or external broker relay per environment.
2. Keep destination naming deterministic by feature and event purpose.
3. Keep message ordering and duplicate-delivery handling explicit when business flows require it.
4. Keep publish and subscription paths aligned with deterministic authorization policy.

## Endpoint and Handler Rules
1. Keep @MessageMapping handlers focused on message orchestration and validation only.
2. Keep business logic delegated to feature services and publishers.
3. Keep outbound destinations explicit through @SendTo or messaging template routing.
4. Keep handler error semantics explicit and mapped to deterministic client-visible behavior.

## Security and Handshake Rules
1. Keep allowed origins explicitly configured and profile-aware.
2. Forbid wildcard allowed origins in production.
3. Keep authentication and authorization policy explicit for connect, subscribe, and send operations.
4. Keep CSRF, token, or session strategy explicit for the selected WebSocket/STOMP security model.

## Transport and Client Rules
1. Keep SockJS fallback enabled only when required by target client compatibility.
2. Keep reconnect, disconnect, and subscription lifecycle behavior explicit in client code.
3. Keep client destination paths centralized and consistent with server routing constants.
4. Keep browser-facing message rendering safe from untrusted content injection.

## Operability Rules
1. Keep connection lifecycle events observed through explicit connect and disconnect listeners.
2. Keep active connection metrics or status endpoints explicit for runtime diagnostics.
3. Keep heartbeat, timeout, and resource-bound settings explicit for production stability.
4. Keep logs correlated with session id, user identity, or message id where available.

## Quality Gates
1. Forbid blocking operations inside message handlers on high-frequency paths.
2. Forbid persistence or repository calls directly inside transport handlers when feature services exist.
3. Keep tests covering handshake, authorized and unauthorized messaging flows, and disconnect lifecycle behavior.
4. Keep profile-specific WebSocket behavior deterministic across development, test, and production.
