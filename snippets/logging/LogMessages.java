@Component
public class LogMessages {

  private final MessageSource messageSource;

  LogMessages(MessageSource messageSource) {
    this.messageSource = messageSource;
  }

  public String get(String key, Object... args) {
    // ...
  }

  public String get(Locale locale, String key, Object... args) {
    // ...
  }
}
