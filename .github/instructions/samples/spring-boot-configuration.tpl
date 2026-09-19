package com.example.demo.feature;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableConfigurationProperties(FeatureConfigurationProperties.class)
class FeatureConfiguration {
}