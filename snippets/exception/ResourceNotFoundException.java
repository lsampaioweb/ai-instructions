public class ResourceNotFoundException extends AppException {

  public ResourceNotFoundException(Object id) {
    super("resource.not.found", new Object[] { id }, HttpStatus.NOT_FOUND);
  }
}
