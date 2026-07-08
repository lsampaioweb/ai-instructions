class I18nAcceptHeaderLocaleResolver extends AcceptHeaderLocaleResolver {

  @Override
  public Locale resolveLocale(HttpServletRequest request) {
    // ...
  }
}

@Configuration
class I18nLocaleResolverConfig implements WebMvcConfigurer {

  @Bean
  LocaleResolver localeResolver() {
    // ...
  }
}
