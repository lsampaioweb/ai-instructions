package com.example.demo.user;

public record PageQuery(Integer page, Integer size, String sort) {

  public PageQuery {
    page = (page == null) ? 0 : Math.max(page, 0);
    size = (size == null) ? 20 : Math.max(size, 1);
    sort = ((sort == null) || sort.isBlank()) ? "id,asc" : sort;
  }
}