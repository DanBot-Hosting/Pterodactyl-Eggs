# Docker Images

Every container image DanBot Hosting builds for its Pterodactyl eggs lives here. Each image gets
its own subfolder, and that subfolder **is** the Docker build context — nothing outside of it is
copied into the image.

## Offered Images

| Image | Tags | Base | Context | Used by |
| --- | --- | --- | --- | --- |
| [`danbothosting/aio`](https://hub.docker.com/r/danbothosting/aio) | `latest` | `debian:trixie-slim` | [`aio/`](./aio) | [`egg-a-i-o.json`](../eggs/egg-a-i-o.json) |
| [`danbothosting/nginx`](https://hub.docker.com/r/danbothosting/nginx) | `latest` | `alpine:latest` | [`nginx/`](./nginx) | [`egg-nginx.json`](../eggs/egg-nginx.json) |

### `aio` — All In One

A general purpose runtime image bundling the toolchains most of our users ask for:

- OpenJDK 21 LTS (Oracle)
- Node.js LTS, plus `yarn`, `pnpm` and `pm2`
- Python 3.12 (built from source) and the distro `python3` / `pip3`
- Go 1.21.5
- Build tooling: `make`, `build-essential`, `cmake`, `git`, `imagemagick`, `ffmpeg`

Despite the name, it does **not** include Nginx. Use `danbothosting/nginx` for that.

### `nginx` — Nginx + PHP-FPM

An Alpine based Nginx and PHP 8.2 FPM image with Composer preinstalled.

Unlike `aio`, this image ships a runtime only — the actual server configuration (`nginx/`,
`php-fpm/`, `webroot/`, `logs/` and `start.sh`) is copied into the server's data directory by the
egg's install script, so users can edit it. Those files also live in [`nginx/`](./nginx) alongside
the Dockerfile; if you change them, remember they affect **new** installs only, not existing
servers.

## Layout

```
docker-images/
├── README.md
├── aio/
│   ├── Dockerfile
│   └── entrypoint.sh
└── nginx/
    ├── Dockerfile
    ├── entrypoint.sh
    ├── start.sh          # copied to the server root by the egg installer
    ├── logs/             # copied to the server root by the egg installer
    ├── nginx/            # copied to the server root by the egg installer
    ├── php-fpm/          # copied to the server root by the egg installer
    └── webroot/          # copied to the server root by the egg installer
```

## Building

```bash
docker build -t danbothosting/aio:latest ./docker-images/aio
```

CI does the same thing. `.github/workflows/docker-build-<image>.yml` is path filtered to
`docker-images/<image>/**`, so pushing a change to one image never rebuilds the others.

> [!IMPORTANT]
> Automatic builds of `nginx` are currently disabled — see
> [Publishing](../DEVELOPMENT.md#publishing) for how to re-enable them. `aio` is unaffected.

See [DEVELOPMENT.md](../DEVELOPMENT.md) for testing images locally and for adding a new one, and
[AGENTS.md](../AGENTS.md) for the container contract every image is expected to follow.
