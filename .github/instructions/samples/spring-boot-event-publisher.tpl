package com.example.demo.feature;

import java.time.Clock;
import java.time.Instant;
import java.util.Objects;

import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;

@Component
class FeatureEventPublisher {

  private final ApplicationEventPublisher eventPublisher;

  FeatureEventPublisher(ApplicationEventPublisher eventPublisher) {
    this.eventPublisher = Objects.requireNonNull(eventPublisher);
  }

  void publishFeatureEvent(String featureId, String content) {
    String localeTag = LocaleContextHolder.getLocale().toLanguageTag();
    int contentLength = content == null ? 0 : content.length();

    eventPublisher.publishEvent(
        new FeaturePublishedEvent(featureId, contentLength, localeTag, Instant.now(Clock.systemUTC())));
  }
}