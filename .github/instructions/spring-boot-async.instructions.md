---
description: "Spring Boot @Async contract for enabling async execution, worker methods, and request/response job APIs."
applyTo: "**/*Application.java, **/*Worker.java, **/*AuditListener.java, **/job/AsyncJob*.java"
---

# Spring Boot Async Contract

Apply this contract when the application uses Spring `@Async` (background methods
or async event listeners). Virtual-thread enablement stays in the virtual-threads
contract. Application-event *when* to listen async stays in the events contract;
this file owns `@EnableAsync` and how `@Async` methods behave.

Architecture owns feature packages and constructor injection. Controller owns REST
boundaries. Logging and i18n own log keys. Exception handling owns API error
mapping.

## Enablement

- Add `@EnableAsync` on the Spring Boot application class when any `@Async`
  method or async `@EventListener` exists (samples: `27-async/basics`,
  `15-events`).
- Do not add a custom `TaskExecutor` bean unless the product needs a named
  executor beyond Boot's default (virtual-threads contract).

## @Async methods

- Put `@Async` on Spring-managed beans called through the container proxy
  (samples: dedicated `AsyncJobWorker`). Self-invocation on the same class does
  not run asynchronously.
- Prefer `@Async` for work that should leave the request thread (samples: job
  processing; events sample: blocking/latency-sensitive listeners). Keep trivial
  in-memory reactions synchronous (events contract).
- Return `CompletableFuture` (or another `CompletionStage`) when the caller must
  observe completion (samples: `AsyncJobWorker.process` →
  `whenComplete` in the service).
- Do not put `@Async` on REST controller methods.

## Request-scoped async jobs (sample shape)

When HTTP clients submit work that finishes later (samples: `27-async/basics`):

- Accept the job in the service, start the `@Async` worker, and return quickly
  (sample uses `202 Accepted` with a `Location` to a status resource).
- Track lifecycle in a feature store (sample: in-memory `AsyncJobStore` with
  queued → running → succeeded/failed).
- Surface executor rejection as a feature exception (sample:
  `TaskRejectedException` → `AsyncJobSubmissionRejectedException`).
- Record failures from the completion callback; do not leave jobs stuck in
  running forever after worker errors.

## Forbidden

- Never call an `@Async` method via `this` on the same class and expect a new
  thread.
- Never block the HTTP thread waiting on the full async job when the API is
  meant to accept-and-poll (sample pattern).
- Never treat `@Async` as durable cross-process messaging (use RabbitMQ when
  work must survive process restart or run on another node).
