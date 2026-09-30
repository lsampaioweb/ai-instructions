---
description: "Traefik ingress contract for app Compose labels, shared network, Host routing, and Traefik-only exposure."
applyTo: "**/docker-compose.yml, **/docker-compose*.yml, **/compose.yml, **/compose*.yml"
---

# Spring Boot Traefik Contract

Apply this contract when a Spring Boot app (or HTTP sidecar UI) is routed through
Traefik. Traefik proxy Compose, dashboard, sockets, and cert files stay in the
infrastructure runbook (`samples/infrastructure/traefik/README.md` in this
tutorial).

Container owns image build, resources, healthchecks, profiles, and generic
networks. TLS owns application keystores when the app terminates TLS itself.
Actuator and security own health exposure and actuator credentials.

## App Compose routing

- Join the shared external network `tutorial-network` (samples: `26-traefik`,
  Vault/RabbitMQ optional labels).
- Enable Traefik on the service with `traefik.enable=true`.
- Route with an explicit Host rule (sample: `Host(\`app.lan.home\`)`). Changing
  `TRAEFIK_DOMAIN` in Traefik's `.env` does not rewrite these labels — edit the
  Host rule when the suffix changes.
- Set `traefik.http.services.<name>.loadbalancer.server.port` to the container
  listen port (sample: `${SERVER_PORT:-9443}` aligned with the active Spring
  profile).
- Default entrypoint is `web`. For Traefik HTTPS termination, switch to
  `websecure` and `tls=true` together (commented pair in samples).
- Keep Traefik → app traffic **HTTP** on that loadbalancer port. Do not point
  Traefik at an HTTPS-only app listener unless the deployment explicitly
  terminates TLS in the app (container TLS-boundary rule).

## Traefik-only ingress (sample shape)

When Compose intends Traefik as the only ingress (samples: `26-traefik` +
`ComposeIngressGovernanceTest`):

- Do not publish app `ports:` on the host; Traefik is the entrypath.
- Keep the Host rule, enable flag, loadbalancer port, and `tutorial-network`
  declarations present and consistent.

## Optional service labels

- HTTP UIs on other infra services may use the same label pattern (commented
  examples on Vault / RabbitMQ management). Non-HTTP protocols stay on their
  native ports and are not Traefik-routed.

## Forbidden

- Never expect Traefik to discover an app that is off `tutorial-network` or
  missing `traefik.enable=true`.
- Never publish host `ports:` for an app that claims Traefik-only ingress.
- Never leave Host labels on an old domain after changing the tutorial DNS
  suffix without updating those labels.
- Never point `loadbalancer.server.port` at a different port than the process
  actually listens on inside the container.
