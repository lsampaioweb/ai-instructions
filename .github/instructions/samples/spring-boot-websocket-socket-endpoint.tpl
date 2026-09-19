package com.example.demo.chat;

import java.time.Clock;
import java.time.Instant;
import java.util.Objects;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
class ChatSocketEndpoint {

  private final ChatMessageEventPublisher chatMessageEventPublisher;

  ChatSocketEndpoint(ChatMessageEventPublisher chatMessageEventPublisher) {
    this.chatMessageEventPublisher = Objects.requireNonNull(chatMessageEventPublisher);
  }

  @MessageMapping("/chat.send")
  @SendTo("/topic/messages")
  ChatMessage publish(@Payload ChatMessage message) {
    chatMessageEventPublisher.publishChatMessageEvent(message.sender(), message.content());

    return new ChatMessage(message.sender(), message.content(), Instant.now(Clock.systemUTC()));
  }
}