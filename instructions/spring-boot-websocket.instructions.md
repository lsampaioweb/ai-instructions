---
description: "WebSocket/STOMP rules: endpoint topology, message flow contract, lifecycle handling, and client resilience."
applyTo: "**/*Socket*.java, **/*Stomp*.java"
---

# Spring Boot WebSocket Engine

## Scope & Analysis
- Inspect WebSocket broker configuration and endpoint registration.
- Inspect message routing handlers and destination prefixes.
- Inspect event publication and realtime status API behavior.

## Dependencies
- To use Spring Boot WebSocket/STOMP, add `spring-boot-starter-websocket` dependency in pom.xml.
- For persistent message delivery or broker-backed failover, add `spring-boot-starter-amqp` (RabbitMQ) alongside WebSocket configuration.

## Resolution Rules
- Keep STOMP endpoint and destination prefixes explicit.
- Keep allowed-origin strategy externalized through configuration.
- Allow wildcard origins only for explicitly documented development/local profiles; production profiles must define constrained origin patterns.
- Keep message mapping and broadcast targets deterministic.
- Keep event publication isolated from transport handlers.
- Keep connection state tracking in dedicated components.
- Keep websocket and REST status contracts aligned.

## Safety Guards
- Never expose websocket endpoints with uncontrolled origin policy.
- Never allow wildcard origin policy in production profiles.
- Never publish mutable payload state across async boundaries.
- Never couple broker configuration changes with unrelated features.

## Review Plan Layout
- Report endpoint and broker configuration changes.
- Report message route changes and delivery impact.
- Report event publication flow and listener effects.
- Report connection-state visibility and API behavior changes.

