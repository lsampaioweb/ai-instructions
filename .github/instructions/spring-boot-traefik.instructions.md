---
description: "Traefik ingress contract for Compose and Podman/Quadlet apps, shared networks, Host routing, and Traefik-only exposure."
applyTo: "**/docker-compose.yml, **/docker-compose*.yml, **/compose.yml, **/compose*.yml, **/*.container, **/*.network"
---

# Spring Boot Traefik Contract

Apply this contract when a Spring Boot app (or HTTP sidecar UI) is routed through
Traefik. Traefik proxy, dashboard, sockets, and cert files stay in the
infrastructure runbook for the environment. Apply the Compose guidance only to
existing deployments when the user explicitly asks to work on them. Use the
Podman/Quadlet guidance below for new container deployments.

Container owns image build, resources, healthchecks, profiles, and generic
networks. TLS owns application keystores when the app terminates TLS itself.
Actuator and security own health exposure and actuator credentials.

## App Compose routing

- Join the shared external Docker network used by Traefik and the apps it routes.
- Enable Traefik on the service with `traefik.enable=true`.
- Route with an explicit Host rule (for example `Host(\`app.example.com\`)`).
  Changing a Traefik domain env var does not rewrite these labels — edit the Host
  rule when the suffix changes.
- Set `traefik.http.services.<name>.loadbalancer.server.port` to the container
  listen port (aligned with the active Spring profile / `SERVER_PORT`).
- Default entrypoint is `web`. For Traefik HTTPS termination, switch to
  `websecure` and `tls=true` together.
- Keep Traefik → app traffic **HTTP** on that loadbalancer port. Do not point
  Traefik at an HTTPS-only app listener unless the deployment explicitly
  terminates TLS in the app (container TLS-boundary rule).

## App Podman/Quadlet routing

- Attach the app container to a shared Podman network that Traefik can access.
- Configure Traefik's provider to discover Podman-managed containers on that
  network; do not assume Compose or Docker discovery is configured for Podman.
- Set the app's routing labels in the Quadlet `[Container]` section with
  `Label=key=value` entries, following the Host, entrypoint, TLS, and
  loadbalancer-port rules above.
- Set the Quadlet `Network=` entry to the shared Podman network.
- Keep Traefik-to-app traffic **HTTP** on the app's container listen port unless
  the deployment explicitly terminates TLS in the app.

## Traefik-only ingress

When Compose intends Traefik as the only ingress:

- Do not publish app `ports:` on the host; Traefik is the entrypath.
- Keep the Host rule, enable flag, loadbalancer port, and shared-network
  declarations present and consistent.

When a Quadlet app uses Traefik as the only ingress:

- Do not set `PublishPort=` on the app container; Traefik is the entrypath.
- Keep the Host rule, enable label, loadbalancer port, and shared-network
  attachment present and consistent.

## Optional service labels

- HTTP UIs on other infra services may use the same label pattern. Non-HTTP
  protocols stay on their native ports and are not Traefik-routed.

## Forbidden

- Never expect Traefik to discover an app that is off the shared Traefik network
  or missing `traefik.enable=true`.
- Never publish host `ports:` for an app that claims Traefik-only ingress.
- Never leave Host labels on an old domain after changing the DNS suffix without
  updating those labels.
- Never point `loadbalancer.server.port` at a different port than the process
  actually listens on inside the container.
