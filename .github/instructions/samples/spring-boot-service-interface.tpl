package com.example.demo.user;

import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;

interface UserService {

  PagedModel<EntityModel<UserResponse>> findAll(PageQuery pageQuery);

  UserResponse findById(Long id);

  UserResponse create(UserRequest request);

  UserResponse update(Long id, UserRequest request);

  int delete(Long id);
}