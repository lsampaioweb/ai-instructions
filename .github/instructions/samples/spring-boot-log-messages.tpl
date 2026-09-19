package com.example.demo.i18n;

import java.util.Locale;
import java.util.Objects;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

@Component
public class LogMessages {

  private final MessageSource messageSource;

  public LogMessages(MessageSource messageSource) {
    this.messageSource = Objects.requireNonNull(messageSource);
  }

  public String get(String key, Object... args) {
    return messageSource.getMessage(key, args, Locale.ENGLISH);
  }

  public String get(Locale locale, String key, Object... args) {
    return messageSource.getMessage(key, args, locale);
  }
}