# TerraStories Tile Server

## Overview of creating the MBT files

1. Directory of shape files (downloaded from dropbox)
2. Generate GeoJSON (using ogr2ogr cli)
3. Convert to line-delimited GeoJSON (using jq cli)
4. Convert to MBTiles (using tippecanoe cli)
5. Server reads those MBTiles (when running docker from within the MBT dir)

## Building the docker image
The tilebuilder `Dockerfile` takes a generic debian linux image and adds all
the dependencies needed to run the steps above. Via the `docker-compose.yml`,
it will have access to the local `script` and `shapefiles` directories and
will output any generated mbtiles files to the shared `mbtiles` volume, which
the tileserver will also have access to.

This image should be built automatically when running `docker-compose up`,
but there are a few ways to force it to build on its own if needed.
```
$ docker build -t terrastories/tilebuilder ./tilebuilder
$ docker-compose build tilebuilder
$ docker-compose up -d --build tilebuilder
```

## Run the docker container
When the docker container runs it finds and executes `/script/convert.sh`.
This script will convert all `.shp` files in the `/shapefiles` to GeoJSON
format using `ogr2ogr` and then combine the generated `.json` files into layers
of a single `mbtiles` file.

The conversion script should provide the magic sauce that performs steps 2-4
from the overview above. For reference, it is roughly equivalent to running
the following statements.
```
$ ogr2ogr -f "GeoJSON" path/to/output.geojson path/to/shapefile.shp
$ jq -rc '.features[]' out.geojson > line-delimited.geojson
$ tippecanoe -o file.mbtiles line-delimited.geojson
```
