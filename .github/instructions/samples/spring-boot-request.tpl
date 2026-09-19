package com.example.demo.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record UserRequest(
    @NotBlank(message = "{error.validation.name.required}") String name,
    @Email(message = "{error.validation.email.invalid}") String email) {
}