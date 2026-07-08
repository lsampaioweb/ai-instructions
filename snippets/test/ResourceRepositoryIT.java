// Integration test — use @MybatisTest for MyBatis mappers or @JdbcTest for JdbcClient repositories.
@MybatisTest
@ActiveProfiles("test")
class ResourceRepositoryIT {

  @Autowired
  private ResourceMapper resourceMapper;

  @Test
  void insert_whenNewResource_shouldGenerateId() {
    // ...
  }

  @Test
  void findById_whenResourceExists_shouldReturnResource() {
    // ...
  }

  @Test
  void deleteById_whenResourceExists_shouldRemoveRecord() {
    // ...
  }
}
