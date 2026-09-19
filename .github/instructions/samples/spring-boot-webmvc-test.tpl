package com.example.demo.feature;

import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(FeatureController.class)
class FeatureControllerTest {

  private final MockMvc mockMvc;

  private final FeatureService featureService;

  @Autowired
  FeatureControllerTest(MockMvc mockMvc, @MockitoBean FeatureService featureService) {
    this.mockMvc = mockMvc;
    this.featureService = featureService;
  }

  @Test
  void getById_whenFeatureExists_shouldReturnOk() throws Exception {
    given(featureService.findById(1L)).willReturn(new FeatureResponse(1L, "Example"));

    mockMvc.perform(get("/api/v1/features/1"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.id").value(1))
        .andExpect(jsonPath("$.name").value("Example"));
  }
}
