# TerraStories Tile Server

## Tile Server GL

https://github.com/klokantech/tileserver-gl

Also available as docker container image `klokantech/tileserver-gl`. This is how we'll use it.

## Overview of creating the MBT files

1. Directory of shape files (downloaded from dropbox)
2. Generate GeoJSON (using ogr2ogr cli)
3. Convert to line-delimited GeoJSON (using jq cli)
4. Convert to MBTiles (using tippecanoe cli)
5. Server reads those MBTiles (when running docker from within the MBT dir)

## Install dependencies
The `ogr2ogr` utility is provided by `gdal`. Also need some other utilities.

```
$ brew install gdal
$ brew install jq
$ brew install tippecanoe

$ which ogr2ogr
> /usr/local/bin/ogr2ogr
```

## Create mbtiles
The magic incantation:
```
$ ogr2ogr -f "GeoJSON" path/to/output.geojson path/to/shapefile.shp
$ jq -rc '.features[]' out.geojson > line-delimited.geojson
$ tippecanoe -o file.mbtiles line-delimited.geojson
```

Feeling lucky? Try it all at once:
```
$ ogr2ogr -f "GeoJSON" /dev/stdout shapefile.shp | jq -rc '.features[]' | tippecanoe -o file.mbtiles
```

## Start the tile server
```
docker run --rm -it -v $(pwd):/data -p 8080:80 klokantech/tileserver-gl
```

Let's break those options down a little bit:
- `--rm` automatically removes the container when it stops
- `-it`  establishes an interactive tty session so we can see the output
- `-v`   maps the current working directory to a docker data volume mounted on the container at `/data`, exposing our local mbtile files so the server can find them
- `-p`   forwards the container's port 80 to localhost port 8080

## Build a docker image
We can be a little more specific about how we want this container to behave by building an image that bakes in some of the run options. The `Dockerfile` contains just a few lines of configuration to help out.

Build the new image (from within the tileserver directory where this README is located):
```
$ docker build -t terrastories/tileserver .
```

The `-t` flag lets us tag the image so we can easily identify it later. This does not have to be any particular value, but we'll assume everyone is using `terrastories/tileserver`. The `.` references the current directory. This command can be run from anywhere as long as the last argument is a relative path to the tileserver directory. The Dockerfile there specifies a new image to be built based on `klokantech/tileserver-gl` and exposes our local mbtiles and tileserver config file to the container.

Now we can run the container with the remarkably, undeniably more concise:
```
$ docker run --rm -it -p 8080:80 terrastories/tileserver
```

Impressive, right? Meh. Don't worry, it will actually get much better once we add a `docker-compose.yml` to the entire project to start linking multiple containers and data volumes and run them with less inline configuration.



