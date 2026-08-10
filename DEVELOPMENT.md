# Development

How this repository is put together, and how to build and test the images before opening a PR.

If you are an AI coding assistant, read [AGENTS.md](./AGENTS.md) as well — it carries the same
conventions in more detail.

## Repository Layout

```
.
├── .github/
│   └── workflows/
│       ├── docker-build-aio.yml      # runs on changes to docker-images/aio/**
│       └── docker-build-nginx.yml    # runs on changes to docker-images/nginx/**
├── docker-images/
│   ├── README.md                     # index of every image we publish
│   ├── aio/
│   └── nginx/
├── eggs/
│   ├── README.md
│   └── egg-*.json                    # exported Pterodactyl eggs
├── AGENTS.md                         # conventions for AI coding assistants
├── DEVELOPMENT.md
├── README.md
├── SECURITY.md
└── LICENSE
```

Everything lives on `main`. This repository used to keep each image on its own branch (`aio`,
`nginx`); those are retired, so don't create per-image branches or workflows that trigger on them.

## Building Locally

The image folder is the whole build context — nothing outside it is copied into the image:

```bash
docker build -t danbothosting/aio:latest ./docker-images/aio
docker build -t danbothosting/nginx:latest ./docker-images/nginx
```

## Testing Locally

Pterodactyl runs containers as the unprivileged `container` user with the server data mounted at
`/home/container`, so reproduce that when testing:

```bash
docker run --rm -it \
  -v "$(pwd)/test-server:/home/container" \
  -e STARTUP='echo hello' \
  danbothosting/aio:latest
```

The entrypoint expands `${STARTUP}` and execs it, so `STARTUP` is how you drive the container.

For `danbothosting/nginx`, the server directory also needs the `nginx/`, `php-fpm/`, `webroot/`,
`logs/` and `start.sh` files that the egg installer normally copies in — copy them from
`docker-images/nginx/` first, then run with `STARTUP='./start.sh'`.

## Publishing

Pushes to `main` publish automatically. The workflows are path filtered to their own image folder,
so a change under `docker-images/nginx/` will not rebuild `aio`. Both workflows also support
`workflow_dispatch` if you need to force a rebuild — for example, to pick up upstream base image
updates.

> [!IMPORTANT]
> Automatic builds of `danbothosting/nginx` are currently **disabled**. Changes under
> `docker-images/nginx/` will not publish a new image; the tag on Docker Hub stays as it is until
> someone runs the workflow by hand or re-enables it.
>
> To re-enable, uncomment the `push:` block at the top of
> [`.github/workflows/docker-build-nginx.yml`](./.github/workflows/docker-build-nginx.yml). Nothing
> else needs changing.

## Adding a New Image

1. Create `docker-images/<name>/` containing at minimum a `Dockerfile` and an `entrypoint.sh`.
2. Copy an existing workflow to `.github/workflows/docker-build-<name>.yml` and update the `paths`
   filter, `context`, `file` and `tags`.
3. Add the image to the table in [`docker-images/README.md`](./docker-images/README.md) with a short
   description.
4. Point the egg's `docker_images` map at `danbothosting/<name>`.

[AGENTS.md](./AGENTS.md) documents the container contract every image follows: the `container` user,
`/home/container` as `WORKDIR`, the entrypoint startup-variable block, and the console banner
format.

## Before Opening a PR

- Keep changes scoped to one image or one egg where possible — it keeps the path filtered builds
  meaningful.
- Build the image locally and confirm it starts.
- Shell scripts are LF only and must stay executable (see [`.gitattributes`](./.gitattributes)).
- If you add or rename an image, update [`docker-images/README.md`](./docker-images/README.md) and
  add the matching workflow.
- If you change files that an egg's install script copies, remember existing servers will not pick
  the change up — only fresh installs will.
- Leave the copyright and `SPDX-License-Identifier` headers in place. Removing them breaks the
  [licence](./LICENSE) terms.

By opening a pull request you agree that your contribution is licensed under the same terms as the
rest of the repository.
