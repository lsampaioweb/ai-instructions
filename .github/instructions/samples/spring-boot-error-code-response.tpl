package com.example.demo.exception;

import java.time.OffsetDateTime;

public record ErrorCodeResponse(
    OffsetDateTime timestamp,
    int status,
    String error,
    String errorCode,
    String message,
    String path,
    String trace) {
}