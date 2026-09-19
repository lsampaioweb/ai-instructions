package com.example.demo.exception;

import java.util.Objects;

import org.springframework.http.HttpStatus;

public abstract class AppException extends RuntimeException {

  private final String messageKey;
  private final transient Object[] args;
  private final HttpStatus status;

  protected AppException(String messageKey, Object[] args, HttpStatus status) {
    super(messageKey);

    this.messageKey = Objects.requireNonNull(messageKey);
    this.args = args == null ? new Object[0] : args.clone();
    this.status = Objects.requireNonNull(status);
  }

  protected AppException(String messageKey, Object[] args, HttpStatus status, Throwable cause) {
    super(messageKey, cause);

    this.messageKey = Objects.requireNonNull(messageKey);
    this.args = args == null ? new Object[0] : args.clone();
    this.status = Objects.requireNonNull(status);
  }

  public String getMessageKey() {
    return messageKey;
  }

  public Object[] getArgs() {
    return args.clone();
  }

  public HttpStatus getStatus() {
    return status;
  }
}