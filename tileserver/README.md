# Terrastories Offline Tile Server

For online or internet-connected instances of Terrastories, the tiles for Terrastories are provided by [Mapbox](https://www.mapbox.com) with a configurable API key and style url. For offine, however, a tile server is required to serve map tiles for Terrastories to work.

## TileServer GL

TileServer GL is a map tile server for Mapbox GL (and more) that will allow us to server local map tiles for offline mode consumption.

The source for TileServer GL is available at https://github.com/maptiler/tileserver-gl

## Setup for Offline Mode

We'll be using the TileServer GL docker image `maptiler/tileserver-gl`.

1. Download Default Offline Tiles

   A default, open-license map for using offline with Terrastories is available at https://github.com/terrastories/default-offline/tiles. Download these files and place them in the `tileserver/data` directory, and they should work when you load Terrastories in Field Kit mode.

2. Follow instructions to run Terrastories in offline mode from project root.

## Manually run the tile server

From project root directory, run:

```
$ docker-compose up tileserver
```

This will boot up the tileserver using the docker compose settings for the project.

Alternatively, create a container and run the server on its own with a command like

```
docker run --rm -it -v $(pwd):/data -p 8080:80 maptiler/tileserver-gl
```

Let's break those options down a little bit:
- `--rm` automatically removes the container when it stops
- `-it`  establishes an interactive tty session so we can see the output
- `-v`   maps the current working directory to a docker data volume mounted on the container at `/data`, exposing our local mbtile files so the server can find them
- `-p`   forwards the container's port 80 to localhost port 8080
