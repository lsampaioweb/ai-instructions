package com.example.demo;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import org.junit.jupiter.api.Test;

class I18nConsistencyTest {

  private static final Pattern PLACEHOLDER_PATTERN = Pattern.compile("\\{(\\d+)}");
  private static final String EN_MESSAGES = "i18n/messages.properties";
  private static final String PT_BR_MESSAGES = "i18n/messages_pt_BR.properties";
  private static final Pattern MESSAGE_KEY_PATTERN = Pattern.compile(
      "\\\"((?:log|error)\\.[a-z0-9_-]+(?:\\.[a-z0-9_-]+)*)\\\""
        + "|\\{((?:log|error)\\.[a-z0-9_-]+(?:\\.[a-z0-9_-]+)*)\\}"
        + "|#\\{((?:log|error)\\.[a-z0-9_-]+(?:\\.[a-z0-9_-]+)*)\\}");

  @Test
  void localeBundlesShouldContainExactlySameKeysAndPlaceholderArity() {
    Properties en = loadProperties(EN_MESSAGES);
    Properties ptBr = loadProperties(PT_BR_MESSAGES);

    assertThat(ptBr.stringPropertyNames())
        .as("ptBR must contain all english keys")
        .containsExactlyInAnyOrderElementsOf(en.stringPropertyNames());

    assertThat(en.stringPropertyNames())
        .as("english must contain all ptBR keys")
        .containsExactlyInAnyOrderElementsOf(ptBr.stringPropertyNames());

    for (String key : en.stringPropertyNames()) {
        List<Integer> enPlaceholders = placeholderIndexes(en.getProperty(key));
        List<Integer> ptPlaceholders = placeholderIndexes(ptBr.getProperty(key));

        assertThat(ptPlaceholders)
          .as("placeholder indexes mismatch for key: %s", key)
          .isEqualTo(enPlaceholders);
    }
  }

  @Test
  void localeBundlesShouldNotContainUnusedKeysInCode() {
    Set<String> keysInBundles = loadProperties(EN_MESSAGES).stringPropertyNames();
    Set<String> keysUsedInCode = collectI18nKeysUsedInCode();

    Set<String> unusedKeys = new HashSet<>(keysInBundles);
    unusedKeys.removeAll(keysUsedInCode);

    assertThat(unusedKeys)
        .as("i18n keys defined but not used in code")
        .isEmpty();
  }

  @Test
  void codeShouldNotReferenceMissingKeysInLocaleBundles() {
    Set<String> keysInBundles = loadProperties(EN_MESSAGES).stringPropertyNames();
    Set<String> keysUsedInCode = collectI18nKeysUsedInCode();

    Set<String> missingInBundles = new HashSet<>(keysUsedInCode);
    missingInBundles.removeAll(keysInBundles);

    assertThat(missingInBundles)
        .as("i18n keys used in code but missing in locale bundles")
        .isEmpty();
  }

  private Set<String> collectI18nKeysUsedInCode() {
    Set<String> keys = new HashSet<>();

    try (Stream<Path> sourceFiles = Files.walk(Path.of("src/main"))) {
      sourceFiles
          .filter(this::isSupportedSourceFile)
          .forEach(path -> collectKeysFromSource(path, keys));
    } catch (IOException exception) {
      throw new IllegalStateException("Failed to scan application sources for i18n keys", exception);
    }

    return keys;
  }

  private void collectKeysFromSource(Path sourceFile, Set<String> keys) {
    try {
      Matcher matcher = MESSAGE_KEY_PATTERN.matcher(Files.readString(sourceFile));
      while (matcher.find()) {
        keys.add(firstNonNull(matcher.group(1), matcher.group(2), matcher.group(3)));
      }
    } catch (IOException exception) {
      throw new IllegalStateException("Failed to read application source file: " + sourceFile, exception);
    }
  }

  private boolean isSupportedSourceFile(Path path) {
    String fileName = path.toString();

    return fileName.endsWith(".java")
        || fileName.endsWith(".html")
        || fileName.endsWith(".js")
        || fileName.endsWith(".css")
        || fileName.endsWith(".yml")
        || fileName.endsWith(".yaml");
  }

  private String firstNonNull(String... values) {
    for (String value : values) {
      if (value != null) {
        return value;
      }
    }

    throw new IllegalStateException("Message key pattern matched without a key");
  }

  private Properties loadProperties(String classpathLocation) {
    Properties properties = new Properties();

    try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream(classpathLocation)) {
      if (inputStream == null) {
        throw new IllegalStateException("Could not find properties file: " + classpathLocation);
      }

      properties.load(new InputStreamReader(inputStream, StandardCharsets.UTF_8));
      return properties;
    } catch (IOException ex) {
      throw new IllegalStateException("Failed to load properties file: " + classpathLocation, ex);
    }
  }

  private List<Integer> placeholderIndexes(String messageTemplate) {
    Matcher matcher = PLACEHOLDER_PATTERN.matcher(messageTemplate);
    List<Integer> indexes = new ArrayList<>();

    while (matcher.find()) {
      indexes.add(Integer.valueOf(matcher.group(1)));
    }

    return indexes;
  }
}
