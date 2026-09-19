package com.example.demo.user;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

import com.example.demo.db.DatabaseException;

@Repository
class UserRepository {

  private static final String ERROR_USER_UPDATE = "error.user.update";
  private static final String ERROR_USER_DELETE = "error.user.delete";
  private static final String ERROR_USER_INSERT = "error.user.insert";
  private static final String ERROR_USER_FIND_ALL = "error.user.find.all";
  private static final String ERROR_USER_FIND_BY_ID = "error.user.find.by.id";

  private final JdbcClient jdbcClient;
  private final UserSqlConfigurationProperties sqlProperties;

  UserRepository(JdbcClient jdbcClient, UserSqlConfigurationProperties sqlProperties) {
    this.jdbcClient = Objects.requireNonNull(jdbcClient);
    this.sqlProperties = Objects.requireNonNull(sqlProperties);
  }

  List<User> findAll() {
    try {
      return jdbcClient
          .sql(sqlProperties.findAll())
          .query(User.class)
          .list();
    } catch (DataAccessException exception) {
      throw new DatabaseException(ERROR_USER_FIND_ALL, exception);
    }
  }

  Optional<User> findById(Long id) {
    try {
      return jdbcClient
          .sql(sqlProperties.findById())
          .param(UserSqlColumns.ID, id)
          .query(User.class)
          .optional();
    } catch (DataAccessException exception) {
      throw new DatabaseException(ERROR_USER_FIND_BY_ID, exception);
    }
  }

  int insert(User user) {
    try {
      return jdbcClient
          .sql(sqlProperties.insert())
          .param(UserSqlColumns.NAME, user.name())
          .param(UserSqlColumns.EMAIL, user.email())
          .update();
    } catch (DataAccessException exception) {
      throw new DatabaseException(ERROR_USER_INSERT, exception);
    }
  }

  int update(User user) {
    try {
      int rowsAffected = jdbcClient
          .sql(sqlProperties.update())
          .param(UserSqlColumns.ID, user.id())
          .param(UserSqlColumns.NAME, user.name())
          .param(UserSqlColumns.EMAIL, user.email())
          .update();

      if (rowsAffected == 0) {
        throw new UserNotFoundException(user.id());
      }

      return rowsAffected;
    } catch (UserNotFoundException exception) {
      throw exception;
    } catch (DataAccessException exception) {
      throw new DatabaseException(ERROR_USER_UPDATE, exception);
    }
  }

  int deleteById(Long id) {
    try {
      int rowsAffected = jdbcClient
          .sql(sqlProperties.deleteById())
          .param(UserSqlColumns.ID, id)
          .update();

      if (rowsAffected == 0) {
        throw new UserNotFoundException(id);
      }

      return rowsAffected;
    } catch (UserNotFoundException exception) {
      throw exception;
    } catch (DataAccessException exception) {
      throw new DatabaseException(ERROR_USER_DELETE, exception);
    }
  }
}
