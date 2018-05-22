# TerraStories Tile Server

## Tile Server GL

https://github.com/klokantech/tileserver-gl

Also available as docker container image `klokantech/tileserver-gl`. This is how we'll use it.

## Overview of creating the MBT files

1. Directory of shape files (downloaded from dropbox)
2. Generate GeoJSON (using ogr2ogr cli)
3. Convert to line-delimited GeoJSON (using jq cli)
4. Convert to MBTiles (using tippecanoe)
5. Server reads those MBTiles (hopefully just running docker from within the MBT dir)

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
`--rm` automatically removes the container when it stops
`-it`  establishes an interactive tty session so we can see the output
`-v`   maps the current working directory to a docker data volume `/data` exposing our local mbtile files to the container so the server can find them
`-p`   forwards the container's port 80 to localhost port 8080

