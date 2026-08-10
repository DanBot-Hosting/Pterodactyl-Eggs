# Pterodactyl Eggs and Docker Images

This repository stores all of the custom Pterodactyl eggs and Docker images we use for
[danbot.host](https://danbot.host). You are welcome to run any of these on your own Pterodactyl
panel — free of charge, commercial use included — provided you follow the
[LICENSE](./LICENSE). In short: **if you modify anything here and serve it to users, your changes
have to be public too, and DanBot Hosting has to stay credited.** See [License](#license).

## Eggs

Exported Pterodactyl eggs, ready to import into your panel. See [`eggs/`](./eggs).

## Docker Images

The container images our eggs run, one build context per image. See
[`docker-images/`](./docker-images).

## Contributing

Fork the repository, make your changes, open a pull request. Simple enough. Devs will go over the PR
to check over it. If approved, it gets merged. If not, it gets closed. If you want to suggest an
egg, open an issue stating the requested change.

[DEVELOPMENT.md](./DEVELOPMENT.md) covers the repository layout, how to build and test the images
locally, and what we expect before you open a PR.

Security issues should follow [SECURITY.md](./SECURITY.md) rather than being filed as a public
issue.

## License

[GNU Affero General Public License v3.0 or later](./LICENSE), with an attribution requirement added
under section 7(b).

- **Use it freely** — including commercially, at no cost and without asking.
- **Publish your changes** — if you modify anything here and let people interact with it over a
  network, which running a panel or a game server for customers is, you must offer those users the
  source of your modified version under this same licence. Plain GPL would let a private fork
  slide; AGPL does not.
- **Keep the credit** — leave copyright notices and `SPDX-License-Identifier` headers intact, ship
  the `LICENSE` file with any copy, and state in your source that it is based on this repository.
- **No trademark grant** — don't imply DanBot Hosting endorses or is affiliated with your fork.

> [!NOTE]
> Revisions published before the relicence were released under the MIT License. That grant is
> irrevocable — anyone may keep using those earlier revisions under MIT terms. The AGPL applies
> going forward.
