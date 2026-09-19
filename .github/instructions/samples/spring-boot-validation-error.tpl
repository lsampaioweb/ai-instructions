package com.example.demo.exception;

public record ValidationError(String field, String message) {
}