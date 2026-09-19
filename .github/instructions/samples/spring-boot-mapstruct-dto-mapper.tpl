package com.example.demo.user;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface UserMapper {

  UserResponse toResponse(User user);

  @Mapping(target = "id", ignore = true)
  User toEntity(UserRequest request);

  User updateEntity(UserRequest request, @MappingTarget User user);
}
