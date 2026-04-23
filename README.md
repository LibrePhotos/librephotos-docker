# 📦 librephotos-docker (archived)

> **This repository has been merged into [LibrePhotos/librephotos](https://github.com/LibrePhotos/librephotos).**
>
> Dockerfiles, Compose configs, k8s manifests, and the proxy now live under **[`deploy/`](https://github.com/LibrePhotos/librephotos/tree/dev/deploy)** in the monorepo:
>
> - **[`deploy/docker/`](https://github.com/LibrePhotos/librephotos/tree/dev/deploy/docker)** — Dockerfiles + entrypoints (backend, backend-gpu, frontend, proxy, unified)
> - **[`deploy/compose/`](https://github.com/LibrePhotos/librephotos/tree/dev/deploy/compose)** — `docker-compose.yml`, `docker-compose.dev.yml`, `docker-compose.e2e.yml`, `librephotos.env`
> - **[`deploy/k8s/`](https://github.com/LibrePhotos/librephotos/tree/dev/deploy/k8s)** — Kubernetes manifests

## Where things moved

| You used to do… | Now do… |
|---|---|
| `git clone https://github.com/LibrePhotos/librephotos-docker.git && cd librephotos-docker && docker compose up -d` | `git clone https://github.com/LibrePhotos/librephotos.git && cd librephotos/deploy/compose && docker compose up -d` |
| Pull `librephotos.env` from `main` | [Pull it from `dev`](https://raw.githubusercontent.com/LibrePhotos/librephotos/dev/deploy/compose/librephotos.env) in the monorepo |
| Open issues here | Open them on [LibrePhotos/librephotos](https://github.com/LibrePhotos/librephotos/issues) |

Image names on Docker Hub are unchanged — `reallibrephotos/librephotos`, `…-frontend`, `…-proxy`, `…-gpu`, `…-unified`, `…-base`, `…-base-gpu`. Existing `docker-compose.yml` files that reference these images keep working.

Tags from this repo are namespaced in the monorepo as `docker/<tag>` (e.g. `docker/2026w14`). The 79 weekly tags from this repo are preserved here in the archive and as namespaced tags on the monorepo.

Background: [issue #534](https://github.com/LibrePhotos/librephotos/issues/534).
