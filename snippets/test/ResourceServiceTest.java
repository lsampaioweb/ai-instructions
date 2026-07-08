// Pure unit test — no Spring context.
class ResourceServiceTest {

  @Mock
  private ResourceRepository resourceRepository;

  @Mock
  private ResourceMapper resourceMapper;

  @InjectMocks
  private ResourceServiceImpl resourceService;

  @BeforeEach
  void setUp() {
    // ...
  }

  @Test
  void findById_whenResourceExists_shouldReturnResponse() {
    // ...
  }

  @Test
  void findById_whenResourceNotFound_shouldThrowResourceNotFoundException() {
    // ...
  }

  @Test
  void create_whenValidRequest_shouldPersistAndReturnResponse() {
    // ...
  }
}
