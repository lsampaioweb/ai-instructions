@Slf4j
@Controller
@RequestMapping("/resources")
class ResourcePageController {

  private final ResourceService resourceService;

  ResourcePageController(ResourceService resourceService) {
    this.resourceService = resourceService;
  }

  @GetMapping
  String index() {
    return "resources/index";
  }

  @GetMapping("/list")
  String list(Model model) {
    model.addAttribute("items", resourceService.findAll());
    return "resources/list";
  }
}
