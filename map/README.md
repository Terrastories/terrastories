# Map Tiles

Terrastories uses [Maplibre](https://maplibre.org/) with [Protomaps](https://protomaps.com/) by default.

This folder is here to provide easy set-up for static Protomap .pmtiles map styles.

## Default Setup

By default, we utilize our default Terrastories map package using the protomaps .pmtiles single-file commpressed archive. This is setup automatically when Terrastories is setup with `bin/setup`.

If you do not wish to run `bin/setup`, you can manually download and place the required files accordingly:

- Download [`tiles.pmtiles`](https://t.ly/OTZpR) and place in `terrastories-map/tiles.pmtiles`.
- Download [protomaps basemaps fonts and sprites](https://github.com/protomaps/basemaps-assets/), and place them in their respective folders `terrastories-map/fonts` and `terrastories-map/sprites`.

If you have prior configuration in `.env` that configures an offline tileserver or mapbox, you'll need to remove that configuration before you can load our map package.

1. Ensure any Map related configuration in `.env` is commented out, including:
    - `TILESERVER_URL`
    - `OFFLINE_MAP_STYLE` that is set to something other than `terrastories-map`
    - `MAPBOX_ACCESS_TOKEN` or `DEFAULT_MAPBOX_TOKEN`
    - `MAPBOX_STYLE` or `DEFAULT_MAP_STYLE`
1. Set `OFFLINE_MAP_STYLE` to `terrastories-map`
1. If your server is currently running, recreate your web container: `docker compose up --force-recreate -d web` for the changes to take effect. Otherwise, your new configuration will be loaded on your next boot.

## Custom Map Package

If you are setting up Terrastories for self-hosting in online environments, you will need to provide your own map tiles. Instructions for how to set up your Terrastories instance can be found in [our docs](https://docs.terrastories.app/).

Once configured, set `OFFLINE_MAP_STYLE` to your custom map package name (e.g. `terrastories-map`) and recreate your web container.
