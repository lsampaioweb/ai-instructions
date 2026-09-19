package com.example.demo.user;

import java.util.Objects;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users")
class UserController {

  private final UserService userService;

  UserController(UserService userService) {
    this.userService = Objects.requireNonNull(userService);
  }

  @GetMapping
  ResponseEntity<PagedModel<EntityModel<UserResponse>>> findAll(
      @ModelAttribute PageQuery pageQuery) {
    PagedModel<EntityModel<UserResponse>> users = userService.findAll(pageQuery);

    return ResponseEntity.ok(users);
  }

  @GetMapping("/{id}")
  ResponseEntity<UserResponse> findById(@PathVariable @Positive Long id) {
    return ResponseEntity.ok(userService.findById(id));
  }

  @PostMapping
  ResponseEntity<UserResponse> create(@Valid @RequestBody UserRequest request) {
    return ResponseEntity.status(HttpStatus.CREATED).body(userService.create(request));
  }

  @PutMapping("/{id}")
  ResponseEntity<UserResponse> update(@PathVariable @Positive Long id,
      @Valid @RequestBody UserRequest request) {
    return ResponseEntity.ok(userService.update(id, request));
  }

  @DeleteMapping("/{id}")
  ResponseEntity<Void> delete(@PathVariable @Positive Long id) {
    userService.delete(id);

    return ResponseEntity.noContent().build();
  }
}
