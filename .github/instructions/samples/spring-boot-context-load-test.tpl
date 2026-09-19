package com.example.demo;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;

@SpringBootTest
class DemoApplicationTests {

  private final ApplicationContext applicationContext;

  @Autowired
  DemoApplicationTests(ApplicationContext applicationContext) {
    this.applicationContext = applicationContext;
  }

  @Test
  void contextLoads_whenApplicationStarts_shouldLoadContext() {
    assertThat(applicationContext).isNotNull();
  }
}
