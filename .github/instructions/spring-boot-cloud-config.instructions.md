---
description: "Spring Cloud Config contract for Config Server Git backends, clients, credentials, and Config Data import."
applyTo: "**/pom.xml, **/src/main/resources/application*.yml, **/src/main/resources/application*.yaml, **/*ConfigServer*.java, **/cloud/config/**/*.java, **/git-config/**/*.yml"
---

# Spring Cloud Config Contract

Apply this contract when a module is a Spring Cloud Config Server or a Config
client. Pom owns the Boot ↔ Cloud BOM train. Configuration owns profiles and
secrets. TLS owns HTTPS keystores and trust. Security owns filter-chain style.
Vault remains a separate secrets integration (Vault contract).

## Shared dependency management

- Import `spring-cloud-dependencies` as a BOM; choose the train from the pom
  contract (Boot 4.1.x: `2025.1.2` or newer). Do not pin Config Server/client
  artifact versions outside the BOM.

## Config Server

- Add `spring-cloud-config-server` and annotate the application with
  `@EnableConfigServer` (samples: `19-cloud-config/server`).
- Point `spring.cloud.config.server.git.uri` at the configuration Git repo
  (sample local default: `file://${CONFIG_REPO_PATH:${user.dir}/../git-config}`
  with `cloneOnStart: true`).
- Use `search-paths: "{application}/{profile}"` so
  `spring.application.name` + active profile select the right folder (samples:
  `git-config/<app>/<profile>/application.yml`).
- Protect client-facing config HTTP paths with authentication; supply server and
  client passwords from the environment (sample uses HTTP Basic and
  `CLOUD_CONFIG_CLIENT_*` / `USERNAME` / `PASSWORD`).
- When the server serves HTTPS, follow the TLS contract for keystore settings
  (sample listens on `9443` with PKCS12).

## Config client

- Add `spring-cloud-starter-config` (samples: `19-cloud-config/client`).
- Set `spring.application.name` to the Git application folder name the server
  should serve.
- Import Config Data with `spring.config.import` pointing at the Config Server
  URL (sample: `optional:configserver:https://localhost:9443`).
- Supply `spring.cloud.config.username` / `password` from the environment when
  the server requires auth; values must match the server.
- Bind remote properties through `@ConfigurationProperties` in the feature
  package (sample: `HelloConfigurationProperties` under `app.hello`).
- Keep context tests independent of a live Config Server (sample:
  `optional:configserver:` import and `spring.cloud.config.fail-fast=false` in
  tests).

## Forbidden

- Never commit Config Server or client passwords in YAML.
- Never pin `spring-cloud-config-*` versions outside the Cloud BOM.
- Never hardcode a machine-specific Git path when `CONFIG_REPO_PATH` (or an
  equivalent env override) can keep the sample portable.
- Never use Cloud Config as a substitute for Vault when the value is a secret
  that belongs in a secret store (Vault contract).
