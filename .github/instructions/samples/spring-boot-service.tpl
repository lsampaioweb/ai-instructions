package com.example.demo.user;

import java.util.List;
import java.util.Objects;

import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
class UserServiceImpl implements UserService {

  private final UserRepository userRepository;
  private final UserMapper userMapper;
  private final UserPaginationService paginationService;

  UserServiceImpl(UserRepository userRepository, UserMapper userMapper, UserPaginationService paginationService) {
    this.userRepository = Objects.requireNonNull(userRepository);
    this.userMapper = Objects.requireNonNull(userMapper);
    this.paginationService = Objects.requireNonNull(paginationService);
  }

  @Override
  @Transactional(readOnly = true)
  public PagedModel<EntityModel<UserResponse>> findAll(PageQuery pageQuery) {
    List<UserResponse> users = userRepository.findAll().stream()
        .map(userMapper::toResponse)
        .toList();

    return paginationService.createPage(users, pageQuery);
  }

  @Override
  @Transactional(readOnly = true)
  public UserResponse findById(Long id) {
    User user = userRepository.findById(id)
        .orElseThrow(() -> new UserNotFoundException(id));

    return userMapper.toResponse(user);
  }

  @Override
  @Transactional
  public UserResponse create(UserRequest request) {
    User user = userMapper.toEntity(request);
    userRepository.insert(user);

    return userMapper.toResponse(user);
  }

  @Override
  @Transactional
  public UserResponse update(Long id, UserRequest request) {
    User user = userRepository.findById(id)
        .orElseThrow(() -> new UserNotFoundException(id));

    User updatedUser = userMapper.updateEntity(request, user);
    userRepository.update(updatedUser);

    return userMapper.toResponse(updatedUser);
  }

  @Override
  @Transactional
  public int delete(Long id) {
    userRepository.findById(id)
        .orElseThrow(() -> new UserNotFoundException(id));

    return userRepository.deleteById(id);
  }
}
