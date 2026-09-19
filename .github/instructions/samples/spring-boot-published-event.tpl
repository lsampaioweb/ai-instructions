package com.example.demo.feature;

import java.time.Instant;

record FeaturePublishedEvent(String featureId, int contentLength, String localeTag, Instant publishedAt) {
}