package com.example.demo.feature;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.BDDMockito.given;

import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class FeatureServiceTest {

  @Mock
  private FeatureRepository featureRepository;

  @InjectMocks
  private FeatureServiceImpl featureService;

  @Test
  void findById_whenFeatureExists_shouldReturnFeature() {
    Feature feature = new Feature(1L, "Example");
    given(featureRepository.findById(1L)).willReturn(Optional.of(feature));

    FeatureResponse response = featureService.findById(1L);

    assertThat(response.id()).isEqualTo(1L);
    assertThat(response.name()).isEqualTo("Example");
  }
}
