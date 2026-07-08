@Mapper
interface ResourceMapper {

  List<Resource> findAll();

  Optional<Resource> findById(Long id);

  int insert(Resource entity);

  int update(Resource entity);

  int deleteById(Long id);

  boolean existsById(Long id);
}
