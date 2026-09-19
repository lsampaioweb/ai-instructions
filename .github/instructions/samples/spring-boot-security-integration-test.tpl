package com.example.demo.config;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.httpBasic;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.context.WebApplicationContext;

@SpringBootTest(properties = {
  // Test-only credentials; production credentials must remain externalized.
    "app.security.integration.username=actuator",
    "app.security.integration.password=secret"
})
class ActuatorSecurityIntegrationTest {

  private final WebApplicationContext webApplicationContext;

  private MockMvc mockMvc;

  @Autowired
  ActuatorSecurityIntegrationTest(WebApplicationContext webApplicationContext) {
    this.webApplicationContext = webApplicationContext;
  }

  @BeforeEach
  void setUp() {
    mockMvc = webAppContextSetup(webApplicationContext)
        .apply(springSecurity())
        .build();
  }

  @Test
  void getInfo_whenAnonymous_shouldReturnUnauthorized() throws Exception {
    mockMvc.perform(get("/actuator/info"))
        .andExpect(status().isUnauthorized());
  }

  @Test
  void getInfo_whenAuthenticated_shouldReturnOk() throws Exception {
    mockMvc.perform(get("/actuator/info").with(httpBasic("actuator", "secret")))
        .andExpect(status().isOk());
  }
}