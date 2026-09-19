package com.example.demo.exception;

// Replaces handleAppException in the canonical GlobalExceptionHandler
// (see spring-boot-global-exception-handler.tpl) when the API contract requires a stable error code.

private static final String ERROR_CODE_USER_NOT_FOUND = "USER_NOT_FOUND";
private static final String ERROR_CODE_DOMAIN_ERROR = "DOMAIN_ERROR";

@ExceptionHandler(AppException.class)
ResponseEntity<ErrorCodeResponse> handleAppException(AppException exception, HttpServletRequest request) {
  String message = messageSource.getMessage(
      exception.getMessageKey(), exception.getArgs(), LocaleContextHolder.getLocale());

  return ResponseEntity.status(exception.getStatus())
      .body(newErrorCodeResponse(resolveDomainErrorCode(exception), message, exception, request));
}

private String resolveDomainErrorCode(AppException exception) {
  if (exception instanceof UserNotFoundException) {
    return ERROR_CODE_USER_NOT_FOUND;
  }

  return ERROR_CODE_DOMAIN_ERROR;
}

private ErrorCodeResponse newErrorCodeResponse(
    String errorCode, String message, AppException exception, HttpServletRequest request) {
  return new ErrorCodeResponse(
      OffsetDateTime.now(ZoneOffset.UTC),
      exception.getStatus().value(),
      exception.getStatus().getReasonPhrase(),
      errorCode,
      message,
      request.getRequestURI(),
      null);
}
