# Terrastories Offline Tile Server

For online or internet-connected instances of Terrastories, the tiles for Terrastories are provided by [Protomaps](https://protomaps.com/) with an API key. For offine, we are currently supporting the use of pmtiles; however, for legacy offline Terrastories projects using mbtiles, an additional tile server is required to serve the mbtiles for Terrastories to work. We are using Tileserver GL.

## Tileserver GL

Tileserver GL is a map tile server for Maplibre GL (and more) that will allow us to server local mbtiles for offline mode consumption.

The source for Tileserver GL is available at https://github.com/maptiler/tileserver-gl

## Setup for Offline Mode

We'll be using the Tileserver GL docker image `maptiler/tileserver-gl`. The setup scripts located in `bin/` should take care of downloading default offline map resources for you. However, if you want to use your own map tiles and style, please refer to the [Tileserver-GL documentation](https://maptiler-tileserver.readthedocs.io/) on how to set up your files. 

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
