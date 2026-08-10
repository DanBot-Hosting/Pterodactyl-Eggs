# AGENTS.md

Guidance for AI coding assistants working in this repository. Humans are welcome to read it too —
it is the short version of how this repo is put together.

## What this repository is

Pterodactyl eggs (`eggs/egg-*.json`) and the Docker images those eggs run
(`docker-images/<name>/`). There is no application code, no test suite and no package manager here.
"Building" means `docker build`; "testing" means running the image the way Pterodactyl would.

Everything is on `main`. This repo used to keep each image on its own branch (`aio`, `nginx`) —
those are retired. Do not create per-image branches, and do not add workflows that trigger on them.

[DEVELOPMENT.md](./DEVELOPMENT.md) has the repository layout and the build/test commands. This file
covers the conventions those commands assume.

## Ground rules

- **Never delete or force-push branches.** If a branch looks stale, say so and let a maintainer
  handle it.
- **Do not edit `eggs/egg-*.json` by hand unless the change is genuinely surgical.** These are panel
  exports. If you must edit one, change the minimum number of keys, keep the existing escaping
  (Pterodactyl escapes forward slashes as `\/`), and leave `exported_at` alone.
- **Keep changes scoped to one image.** The CI workflows are path filtered per image; a change that
  touches two image folders triggers two builds and makes review harder.
- **Do not bump base images, action versions or language runtimes as a drive-by.** They are pinned
  deliberately. Propose it separately.
- **Never remove a licence header.** See [Licensing](#licensing).

## Licensing

This repository is **AGPL-3.0-or-later** with an attribution requirement added under section 7(b).
Two consequences you need to respect:

- Every file DanBot Hosting authored carries a copyright notice and an
  `SPDX-License-Identifier: AGPL-3.0-or-later` header. Preserve it. Do not strip, reword, reformat
  or relocate these headers, and do not "tidy" the `org.opencontainers.image.*` labels out of a
  Dockerfile. Removing them is a licence violation, not a style change.
- When you create a new file that is DanBot Hosting's own work — a Dockerfile, an entrypoint, a
  helper script — add the same header. Copy it verbatim from `docker-images/aio/entrypoint.sh`,
  adjusting only the comment character. Put it immediately after the shebang, never before it.

Do **not** add headers to `docker-images/nginx/nginx/**` or `docker-images/nginx/php-fpm/**`. Those
are stock upstream nginx and PHP configuration under their own licences (BSD 2-clause and PHP
License 3.01), and the `LICENSE` file carves them out explicitly. Claiming DanBot copyright over
them would be wrong. The same goes for any other upstream file you vendor in — add it to the
third-party section of `LICENSE` instead.

The egg JSON files carry no header because JSON has no comment syntax; they are covered by
`LICENSE` at the repository level.

If you are asked to change the licence, stop and escalate to a maintainer. Relicensing is not a
routine edit.

## Docker image conventions

Every image folder is a self-contained build context. A `Dockerfile` may only `COPY` from inside its
own folder.

Dockerfiles in this repo follow the Pterodactyl container contract:

```dockerfile
FROM <base>

LABEL maintainer="..."

# ... install packages as root ...

USER container
ENV USER=container
ENV HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
```

Non-negotiable parts of that contract:

- The runtime user is `container`, with `HOME` and `WORKDIR` at `/home/container`. Pterodactyl
  mounts the server's data directory there.
- Everything that needs root must happen **before** the `USER container` line.
- On Debian bases, create the user if the base does not provide it:
  `(id -u container >/dev/null 2>&1 || useradd -d /home/container -m container)`.
- The entrypoint is copied to `/entrypoint.sh` and invoked via `CMD` with an explicit shell —
  `/bin/bash` on Debian, `/bin/ash` on Alpine.
- Nothing may write outside `/home/container` at runtime. Temp paths, PID files and logs all belong
  under it (see `docker-images/nginx/nginx/nginx.conf` for how that is done).

## Entrypoint conventions

Every `entrypoint.sh` ends with the same startup-variable dance. Do not rewrite it, do not "fix" the
backticks, and do not quote `${MODIFIED_STARTUP}` — word splitting is intentional, the startup
command needs to split into argv:

```bash
# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
```

Before that block, an entrypoint should:

1. `sleep` briefly (2–3s) so the panel's console websocket is attached before output starts.
2. `cd /home/container`.
3. Print the banner (below), if the image has one.

### Banner format

The AIO image prints a banner on boot. It is exactly **106 columns wide** — every rule line is 106
`=` characters, and the ASCII art block is rendered to the same 106 columns. Anything that does not
line up at 106 looks broken in the panel console, which is a fixed-width terminal.

Structure, in order:

```
<106 × '=">
<6 lines of block ASCII art, 106 columns each>
<centred '=' rule containing " All Rights Reserved ">
<centred '=' rule containing " Support: dibster@danbot.host ">
<106 × '=">
Installed Versions:
<aligned "Label:   value" lines, one per runtime>
<centred '=' rule containing " SERVER MARKED AS RUNNING ">
```

Rules:

- The art uses full-width block characters with `░` as the fill; `docker-images/aio/entrypoint.sh`
  is the reference — copy its exact art rather than regenerating it.
- Text rules keep a single space either side of the text and pad with `=` so the total is still 106.
  Padding does not have to be perfectly symmetric; total width does.
- Version lines call each tool with its version flag and swallow errors so a missing tool cannot
  abort startup — e.g. `echo "Node.js:  $(node -v 2>/dev/null)"`. Labels are padded so the values
  form a single left-aligned column.
- The last rule before the startup block is always `SERVER MARKED AS RUNNING`. Pterodactyl egg
  configs key their "server started" detection off console output, so do not reword it.

Do not add a banner to an image that does not already have one without being asked — it changes
runtime output that egg start-detection may depend on.

## Shell scripts

- `#!/bin/bash` on Debian images, `#!/bin/ash` on Alpine.
- LF line endings, always. `.gitattributes` enforces `*.sh text eol=lf`; on Windows, do not let an
  editor rewrite them to CRLF.
- Scripts the egg installer copies to the server (like `docker-images/nginx/start.sh`) are chmodded
  by the install script, not by git.

## GitHub Actions

One workflow per image, named `.github/workflows/docker-build-<image>.yml`. Copy an existing one
rather than writing from scratch, and change only:

- `paths:` → `docker-images/<image>/**` plus the workflow file itself
- `context:` / `file:` → the image folder
- `tags:` → `danbothosting/<image>:latest`

Keep `runs-on: X64` (self-hosted) and the pinned action major versions. Never add a step that logs
`secrets.DOCKER_USERNAME` / `secrets.DOCKER_TOKEN`, and never add a `pull_request` trigger to a
workflow that pushes to Docker Hub — that would expose the credentials to fork PRs.

## Eggs and install scripts

An egg's install script runs in a throwaway container with the new server's directory at
`/mnt/server`. Where an egg seeds config files from this repo, it clones the repository's default
branch and copies out of `docker-images/<image>/` — see `eggs/egg-nginx.json`. If you move or rename
anything under `docker-images/`, grep the eggs for the old path:

```bash
grep -l 'docker-images' eggs/egg-*.json
```

Changing seeded files only affects **new** installs. Existing servers keep their copies. Call that
out in the PR description when it applies.

## Before you hand work back

- `docker build` each image you touched, and confirm it starts under a non-root user with
  `/home/container` mounted.
- Confirm no image folder references files outside itself.
- Confirm any path you changed is still correct in the workflows, the eggs, and
  `docker-images/README.md`.
