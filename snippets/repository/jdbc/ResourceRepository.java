// JdbcClient repository skeleton.
// SQL strings must be stored in external XML files and loaded by key — never hardcoded inline.
// Use NamedParameterJdbcTemplate.batchUpdate() for batch operations.
class ResourceRepository {

  private final JdbcClient jdbcClient;

  ResourceRepository(JdbcClient jdbcClient) {
    this.jdbcClient = jdbcClient;
  }

  List<Resource> findAll() {
    // ...
  }

  Optional<Resource> findById(Long id) {
    // ...
  }

  int insert(Resource entity) {
    // ...
  }

  int update(Resource entity) {
    // ...
  }

  int deleteById(Long id) {
    // ...
  }

  boolean existsById(Long id) {
    // ...
  }
}
