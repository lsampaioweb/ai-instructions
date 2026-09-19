package com.example.demo.exception;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Objects;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.resource.NoResourceFoundException;

@RestControllerAdvice
class GlobalExceptionHandler {

  private static final String SERVER_ERROR_INCLUDE_STACKTRACE = "server.error.include-stacktrace";
  private static final String STACKTRACE_ALWAYS = "always";
  private static final String ERROR_INTERNAL_SERVER = "error.internal.server";
  private static final String ERROR_RESOURCE_NOT_FOUND = "error.resource.not.found";

  private final MessageSource messageSource;
  private final Environment environment;

  GlobalExceptionHandler(MessageSource messageSource, Environment environment) {
    this.messageSource = Objects.requireNonNull(messageSource);
    this.environment = Objects.requireNonNull(environment);
  }

  @ExceptionHandler(AppException.class)
  ResponseEntity<ErrorResponse> handleAppException(AppException exception, HttpServletRequest request) {
    String message = messageSource.getMessage(
        exception.getMessageKey(), exception.getArgs(), LocaleContextHolder.getLocale());

    return ResponseEntity.status(exception.getStatus())
        .body(newErrorResponse(message, exception, request, exception.getStatus()));
  }

  @ExceptionHandler(NoResourceFoundException.class)
  ResponseEntity<ErrorResponse> handleNoResourceFoundException(
      NoResourceFoundException exception, HttpServletRequest request) {
    String message = messageSource.getMessage(
        ERROR_RESOURCE_NOT_FOUND, null, LocaleContextHolder.getLocale());

    return ResponseEntity.status(HttpStatus.NOT_FOUND)
        .body(newErrorResponse(message, exception, request, HttpStatus.NOT_FOUND));
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  ResponseEntity<List<ValidationError>> handleValidationException(MethodArgumentNotValidException exception) {
    List<ValidationError> errors = exception.getBindingResult().getFieldErrors().stream()
        .map(error -> new ValidationError(error.getField(), error.getDefaultMessage()))
        .toList();

    return ResponseEntity.badRequest().body(errors);
  }

  @ExceptionHandler(Exception.class)
  ResponseEntity<ErrorResponse> handleUnexpectedException(Exception exception, HttpServletRequest request) {
    String message = messageSource.getMessage(ERROR_INTERNAL_SERVER, null, LocaleContextHolder.getLocale());

    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .body(newErrorResponse(message, exception, request, HttpStatus.INTERNAL_SERVER_ERROR));
  }

  private ErrorResponse newErrorResponse(
      String message, Exception exception, HttpServletRequest request, HttpStatus status) {
    return new ErrorResponse(
        OffsetDateTime.now(ZoneOffset.UTC),
        status.value(),
        status.getReasonPhrase(),
        message,
        request.getRequestURI(),
        shouldIncludeStackTrace() ? getStackTraceAsString(exception) : null);
  }

  private boolean shouldIncludeStackTrace() {
    String value = environment.getProperty(SERVER_ERROR_INCLUDE_STACKTRACE, "never").toLowerCase();

    return STACKTRACE_ALWAYS.equals(value);
  }

  private String getStackTraceAsString(Exception exception) {
    StringWriter stringWriter = new StringWriter();

    exception.printStackTrace(new PrintWriter(stringWriter));

    return stringWriter.toString();
  }
}