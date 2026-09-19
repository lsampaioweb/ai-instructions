package com.example.demo.user;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.stereotype.Component;

@Component
class UserPaginationService {

  private static final String ERROR_SORT_FORMAT = "error.pagination.sort.format";
  private static final String ERROR_SORT_PROPERTY = "error.pagination.sort.property";
  private static final String ERROR_SORT_DIRECTION = "error.pagination.sort.direction";

  private final MessageSource messageSource;

  UserPaginationService(MessageSource messageSource) {
    this.messageSource = Objects.requireNonNull(messageSource);
  }

  PagedModel<EntityModel<UserResponse>> createPage(List<UserResponse> users, PageQuery pageQuery) {
    List<UserResponse> sortedUsers = users.stream()
        .sorted(resolveComparator(pageQuery.sort()))
        .toList();
    List<UserResponse> paginatedUsers = getPaginatedList(sortedUsers, pageQuery.page(), pageQuery.size());
    List<EntityModel<UserResponse>> content = paginatedUsers.stream()
        .map(EntityModel::of)
        .toList();
    long totalPages = users.isEmpty() ? 0 : (users.size() + (long) pageQuery.size() - 1) / pageQuery.size();
    PagedModel.PageMetadata metadata = new PagedModel.PageMetadata(
        pageQuery.size(), pageQuery.page(), users.size(), totalPages);

    return PagedModel.of(content, metadata);
  }

  private Comparator<UserResponse> resolveComparator(String sort) {
    String[] sortParts = sort.split(",", 2);

    if (sortParts.length != 2) {
      throw new IllegalArgumentException(getMessage(ERROR_SORT_FORMAT));
    }

    if (!"id".equals(sortParts[0])) {
      throw new IllegalArgumentException(getMessage(ERROR_SORT_PROPERTY, sortParts[0]));
    }

    Comparator<UserResponse> comparator = Comparator.comparing(UserResponse::id);

    return switch (sortParts[1].toLowerCase()) {
      case "asc" -> comparator;
      case "desc" -> comparator.reversed();
      default -> throw new IllegalArgumentException(getMessage(ERROR_SORT_DIRECTION, sortParts[1]));
    };
  }

  private String getMessage(String key, Object... args) {
    return messageSource.getMessage(key, args, LocaleContextHolder.getLocale());
  }

  private List<UserResponse> getPaginatedList(List<UserResponse> users, int page, int size) {
    long fromIndex = (long) page * size;

    if (fromIndex >= users.size()) {
      return Collections.emptyList();
    }

    int startIndex = (int) fromIndex;
    int toIndex = Math.min(startIndex + size, users.size());

    return users.subList(startIndex, toIndex);
  }
}