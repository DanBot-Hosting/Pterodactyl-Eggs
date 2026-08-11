# Eggs

Pterodactyl eggs used by [danbot.host](https://danbot.host). Import the JSON straight into your
panel under **Nests → Import Egg**.

| Egg | Image |
| --- | --- |
| [`egg-a-i-o.json`](./egg-a-i-o.json) | `danbothosting/aio` |
| [`egg-nginx.json`](./egg-nginx.json) | `danbothosting/nginx` |
| [`egg-share-x-upload-server.json`](./egg-share-x-upload-server.json) | `quay.io/parkervcp/pterodactyl-images:debian_nodejs-16` |

The images live in [`docker-images/`](../docker-images).

> [!NOTE]
> These files are panel exports. Export from the panel rather than editing the JSON by hand where
> you can — it keeps `exported_at` and the field ordering consistent.
