---
description: "Service layer rules: business logic ownership, @Transactional, domain exceptions, and interface+impl pattern."
applyTo: "**/*Service.java, **/*ServiceImpl.java"
---

# Service Rules

## Rules

- All business logic lives in the service layer; never in controllers, repositories, or entities
- Define a service interface; provide a single implementation class suffixed with `Impl` per interface
- Apply `@Transactional` at the method level, not on the class; read-only methods use `@Transactional(readOnly = true)`
- Throw domain-specific exceptions that extend the project's base exception class; do not throw raw Spring infrastructure exceptions
- If throwing operational exceptions (e.g., `IllegalStateException` for startup/validation), use i18n message keys resolved via `LogMessages`, never hardcode message text
- Services may call repositories, mappers, and integration clients; they do not call controllers
- Keep service classes and methods package-private when used only within the same feature package

## Exception Handling
- Only catch an exception when you can meaningfully recover from it, translate it into a domain exception, or must release a resource
- Never catch and silently swallow an exception
- Do not wrap every method body in a `try/catch` as boilerplate; let unchecked exceptions propagate to `@RestControllerAdvice`
- When catching a checked exception from an external library, wrap it in the appropriate domain exception before rethrowing
- For API error-response shape and stacktrace exposure policy, follow `spring-boot-exception.instructions.md`

## Templates

Service interface and implementation skeleton. Replace `{Resource}`, `{resource}`, and all DTO names with actual project values.
The implementation template below targets the repository contract documented in `spring-boot-repository.instructions.md` (`findAll`, `findById`, `insert`, `update`, `existsById`, `deleteById`).

```java
interface {Resource}Service {
  List<{Resource}Response> findAll();
  {Resource}Response findById(Long id);
  {Resource}Response create(Create{Resource}Request request);
  {Resource}Response update(Long id, Update{Resource}Request request);
  void delete(Long id);
}
```

```java
@Slf4j
@Service
class {Resource}ServiceImpl implements {Resource}Service {

  private final {Resource}Repository {resource}Repository;
  private final {Resource}Mapper {resource}Mapper;

  {Resource}ServiceImpl({Resource}Repository {resource}Repository, {Resource}Mapper {resource}Mapper) {
    this.{resource}Repository = {resource}Repository;
    this.{resource}Mapper = {resource}Mapper;
  }

  @Override
  @Transactional(readOnly = true)
  public List<{Resource}Response> findAll() {
    return {resource}Repository.findAll().stream().map({resource}Mapper::toResponse).toList();
  }

  @Override
  @Transactional(readOnly = true)
  public {Resource}Response findById(Long id) {
    {Resource} entity = {resource}Repository.findById(id)
      .orElseThrow(() -> new {Resource}NotFoundException(id));

    return {resource}Mapper.toResponse(entity);
  }

  @Override
  @Transactional
  public {Resource}Response create(Create{Resource}Request request) {
    {Resource} entity = {resource}Mapper.toEntity(request);

    {resource}Repository.insert(entity);

    return {resource}Mapper.toResponse(entity);
  }

  @Override
  @Transactional
  public {Resource}Response update(Long id, Update{Resource}Request request) {
    {Resource} entity = {resource}Repository.findById(id)
      .orElseThrow(() -> new {Resource}NotFoundException(id));

    {resource}Mapper.updateEntity(request, entity);

    {resource}Repository.update(entity);

    return {resource}Mapper.toResponse(entity);
  }

  @Override
  @Transactional
  public void delete(Long id) {
    if (!{resource}Repository.existsById(id)) {
      throw new {Resource}NotFoundException(id);
    }

    {resource}Repository.deleteById(id);
  }
}
```
