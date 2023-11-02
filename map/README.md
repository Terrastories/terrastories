# Map Tiles

Terrastories uses [Maplibre](https://maplibre.org/) with [Protomaps](https://protomaps.com/) by default.

This folder is here to provide easy set-up for static Protomap .pmtiles map styles.

## Default Setup

By default, we make use of Protomap's free non-commercial API which provides vector map tiles in tilejson format. This is not configured in this folder.

For running environments that have local access to `localhost`, we provide a pre-packaged protomaps style using .pmtiles. These are automatically downloaded when you setup Terrastories for the first time when you run `bin/setup`.

If you wish to utilize the local .pmtiles, update the `.env` to:

1. Stop any running containers: `docker compose stop`
1. Comment out the `TILESERVER_URL` and add a Protomaps API key (free to obtain).
1. Uncomment `USE_PROTOMAPS`
1. Uncomment `OFFLINE_MAPSTYLE`, leaving the default value `terrastories-default`
1. Save the file.
1. Recreate your web container: `docker compose create web --force-recreate`
1. And reboot your services: `docker compose up`

## Self-Hosted Online Tiles

If you are setting up Terrastories for self-hosting in online environments, you will need to provide your own map tiles. Instructions for how to set up your Terrastories instance can be found in [our docs](https://docs.terrastories.app/).
