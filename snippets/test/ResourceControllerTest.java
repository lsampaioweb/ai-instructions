@WebMvcTest(ResourceController.class)
@ActiveProfiles("test")
class ResourceControllerTest {

  @Autowired
  private MockMvc mockMvc;

  @MockitoBean
  private ResourceService resourceService;

  private ResourceResponse sampleResource;

  @BeforeEach
  void setUp() {
    // ...
  }

  @Test
  void findById_whenResourceExists_shouldReturn200() throws Exception {
    // ...
  }

  @Test
  void findById_whenResourceNotFound_shouldReturn404() throws Exception {
    // ...
  }

  @Test
  void create_whenValidRequest_shouldReturn201() throws Exception {
    // ...
  }

  @Test
  void create_whenInvalidRequest_shouldReturn400() throws Exception {
    // ...
  }
}
