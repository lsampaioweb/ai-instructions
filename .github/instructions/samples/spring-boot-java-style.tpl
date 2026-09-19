package com.example.demo.style;

import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;

import com.example.demo.i18n.LogMessages;

/**
 * Illustrates the canonical Java class structure for a Spring Boot service.
 */
@Slf4j
@Service
class ExampleServiceImpl implements ExampleService {

  private static final String LOG_EXAMPLE_CREATING = "log.example.creating";
  private static final String LOG_EXAMPLE_UPDATING = "log.example.updating";

  private final ExampleRepository exampleRepository;
  private final ExampleMapper exampleMapper;
  private final LogMessages logMessages;

  ExampleServiceImpl(ExampleRepository exampleRepository, ExampleMapper exampleMapper, LogMessages logMessages) {
    this.exampleRepository = Objects.requireNonNull(exampleRepository);
    this.exampleMapper = Objects.requireNonNull(exampleMapper);
    this.logMessages = Objects.requireNonNull(logMessages);
  }

  @Override
  @Transactional(readOnly = true)
  public List<ExampleResponse> findAll() {
    return exampleRepository.findAll().stream()
        .map(exampleMapper::toResponse)
        .toList();
  }

  @Override
  @Transactional(readOnly = true)
  public ExampleResponse findById(Long id) {
    var example = exampleRepository.findById(id)
        .orElseThrow(() -> new ExampleNotFoundException(id));

    return exampleMapper.toResponse(example);
  }

  @Override
  @Transactional
  public ExampleResponse create(ExampleRequest request) {
    var example = exampleMapper.toEntity(request);

    log.info(logMessages.get(LOG_EXAMPLE_CREATING));
    exampleRepository.insert(example);

    return exampleMapper.toResponse(example);
  }

  @Override
  @Transactional
  public ExampleResponse update(Long id, ExampleRequest request) {
    var example = exampleRepository.findById(id)
        .orElseThrow(() -> new ExampleNotFoundException(id));
    var updatedExample = exampleMapper.updateEntity(request, example);

    log.info(logMessages.get(LOG_EXAMPLE_UPDATING));
    exampleRepository.update(updatedExample);

    return exampleMapper.toResponse(updatedExample);
  }

  @Override
  @Transactional
  public int delete(Long id) {
    exampleRepository.findById(id)
        .orElseThrow(() -> new ExampleNotFoundException(id));

    return exampleRepository.deleteById(id);
  }
}

