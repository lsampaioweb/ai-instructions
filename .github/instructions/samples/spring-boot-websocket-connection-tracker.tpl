package com.example.demo.chat;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;

@Component
class ConnectionTracker {

  private final Set<String> activeSessionIds = ConcurrentHashMap.newKeySet();

  void onConnect(String sessionId) {
    if ((sessionId == null) || sessionId.isBlank()) {
      return;
    }

    activeSessionIds.add(sessionId);
  }

  void onDisconnect(String sessionId) {
    if ((sessionId == null) || sessionId.isBlank()) {
      return;
    }

    activeSessionIds.remove(sessionId);
  }

  int getOpenConnections() {
    return activeSessionIds.size();
  }
}