package com.example.demo.feature;

import java.util.Objects;

import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

import com.example.demo.i18n.LogMessages;

@Slf4j
@Component
class FeatureAuditListener {

  private static final String LOG_FEATURE_AUDIT_RECORDED = "log.feature.audit.recorded";

  private final LogMessages logMessages;

  FeatureAuditListener(LogMessages logMessages) {
    this.logMessages = Objects.requireNonNull(logMessages);
  }

  @EventListener
  void onFeaturePublished(FeaturePublishedEvent event) {
    log.info(logMessages.get(
        LOG_FEATURE_AUDIT_RECORDED,
        event.featureId(),
        event.contentLength(),
        event.localeTag(),
        event.publishedAt()));
  }
}