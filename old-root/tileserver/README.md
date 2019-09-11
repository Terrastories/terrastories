# TerraStories Tile Server

## Tile Server

The source for TileServer GL is available at
https://github.com/klokantech/tileserver-gl

We'll be using its docker image `klokantech/tileserver-gl`.

## Start the tile server
This should be run from the project root directory.
```
$ docker-compose up tileserver
```

To run just this container on its own, we would run something like this.
```
docker run --rm -it -v $(pwd):/data -p 8080:80 klokantech/tileserver-gl
```

Let's break those options down a little bit:
- `--rm` automatically removes the container when it stops
- `-it`  establishes an interactive tty session so we can see the output
- `-v`   maps the current working directory to a docker data volume mounted on the container at `/data`, exposing our local mbtile files so the server can find them
- `-p`   forwards the container's port 80 to localhost port 8080
