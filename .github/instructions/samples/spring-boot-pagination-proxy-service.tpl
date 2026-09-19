package com.example.demo.user;

import java.util.Objects;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriComponentsBuilder;

@Service
class UserPaginationProxyService {

  private final RestClient restClient;
  private final ExternalApiProperties apiProperties;

  UserPaginationProxyService(RestClient restClient, ExternalApiProperties apiProperties) {
    this.restClient = Objects.requireNonNull(restClient);
    this.apiProperties = Objects.requireNonNull(apiProperties);
  }

  PagedModel<EntityModel<UserResponse>> findAll(PageQuery pageQuery) {
    UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(apiProperties.users())
        .queryParam("page", pageQuery.page())
        .queryParam("size", pageQuery.size())
        .queryParam("sort", pageQuery.sort());

    PagedModel<EntityModel<UserResponse>> page = restClient.get()
        .uri(builder.toUriString())
        .retrieve()
        .body(new ParameterizedTypeReference<PagedModel<EntityModel<UserResponse>>>() {
        });

    return page == null ? PagedModel.empty() : page;
  }
}