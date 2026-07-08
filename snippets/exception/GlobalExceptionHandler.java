@Slf4j
@RestControllerAdvice
class GlobalExceptionHandler {

  private static final String SERVER_ERROR_INCLUDE_STACKTRACE = "server.error.include-stacktrace";
  private static final String STACKTRACE_ALWAYS = "always";
  private static final String ERR_INTERNAL = "error.internal.server";

  private final MessageSource messageSource;
  private final Environment environment;

  GlobalExceptionHandler(MessageSource messageSource, Environment environment) {
    this.messageSource = messageSource;
    this.environment = environment;
  }

  @ExceptionHandler(AppException.class)
  public ResponseEntity<ErrorResponse> handleAppException(AppException ex, HttpServletRequest request) {
    // ...
  }

  @ExceptionHandler(NoResourceFoundException.class)
  @ResponseStatus(HttpStatus.NOT_FOUND)
  public @ResponseBody ErrorResponse handleNoResourceFound(NoResourceFoundException ex, HttpServletRequest request) {
    // ...
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  public @ResponseBody List<ValidationError> handleValidation(MethodArgumentNotValidException ex) {
    // ...
  }

  @ExceptionHandler(Exception.class)
  @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
  public @ResponseBody ErrorResponse handleGeneric(Exception ex, HttpServletRequest request) {
    // ...
  }

  private ErrorResponse newErrorResponse(String message, Exception ex, HttpServletRequest request, HttpStatus status) {
    // ...
  }

  private boolean shouldIncludeStackTrace() {
    // ...
  }

  private String getStackTraceAsString(Exception ex) {
    // ...
  }
}
