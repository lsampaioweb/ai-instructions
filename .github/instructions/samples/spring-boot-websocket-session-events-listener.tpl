package com.example.demo.chat;

import java.util.Objects;

import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

@Component
class WebSocketSessionEventsListener {

  private final ConnectionTracker connectionTracker;

  WebSocketSessionEventsListener(ConnectionTracker connectionTracker) {
    this.connectionTracker = Objects.requireNonNull(connectionTracker);
  }

  @EventListener
  void onSessionConnected(SessionConnectedEvent event) {
    String sessionId = SimpMessageHeaderAccessor.wrap(event.getMessage()).getSessionId();

    connectionTracker.onConnect(sessionId);
  }

  @EventListener
  void onSessionDisconnected(SessionDisconnectEvent event) {
    connectionTracker.onDisconnect(event.getSessionId());
  }
}