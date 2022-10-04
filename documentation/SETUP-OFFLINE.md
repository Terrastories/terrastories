# Setup Terrastories as an Offline "Field Kit"
This setup is for use in the "Field Kit" environment which is completely offline. If you are setting up Terrastories for an online environment, please follow the instructions for your operating system (Windows, Mac, Linux) [here](../README.md#setup).

## Table of Contents

1. [Docker prerequisites](#docker-prerequisites)

2. [Setting up offline environment and map](#setting-up-offline-environment-and-map)

3. [Setup and running the server](#setup-and-running-the-server)

5. [Instructions for setting up an offline computer](#instructions-for-setting-up-an-offline-computer)

## Docker Prerequisites

Install docker. Please refer to operating system-specific guidelines about Docker [here](../README.md#setup).

## Setting up offline environment and map 

### Step 1: setting the Terrastories environment to work offline

Create a fork of the Terrastories/terrastories repository. Now clone the repository locally to your computer. (Or, you can download Terrastories as a ZIP file from Github to get the application.)

Using the source-code editor of your choice, open the terrastories repository. There, a file can be found called `.env.example`. 
Copy the contents of this file into a newly created file called `.env` (Do not change .env.example!).

### Step 2: preparing the offline map (tiles and styles)

Terrastories in the "Field Kit" environment works by integrating map `tiles` and `styles`. Map tiles are square grids of spatial data consumed by the offline Tileserver, and can be in either raster (image) or vector format. Styles points the Terrastories tileserver to the tiles and in the case of vector data, gives style or symbology properties to the data (such as color, opacity, labels, visibility per zoom extent, and so on). Unlike the online environment (where Terrastories relies on Mapbox.com for all map content), each of these have to be made available to Terrastories in a file format.

#### Default offline map tiles
A default, open-license map for using offline with Terrastories is available at https://github.com/terrastories/default-offline-map. Download these files and place them in the `data` directory, and they should work when you load Terrastories in Field Kit mode.
#### Working with custom MBTiles

`MBTiles` can be generated from standard geospatial data (Shapefile, GeoJSON) in several ways. 

* The open-source GIS software QGIS has several tools for generating `MBTiles` in both raster and vector format. `Generate XYZ tiles (MBTiles)` can be used to create raster tiles of all of the content on your map canvas; this may also include XYZ Tiles from services such as OpenStreetMap, Bing, and Google Satellite. `Generate Vector Tiles (MBTiles)` can be used to create vector tiles from one or more vector layers. You can then further style these vector tiles in your ` style.json` file.
* There is also a command line option to generate vector `MBTiles` called `tippecanoe`, created by Mapbox: [guide](https://docs.mapbox.com/help/troubleshooting/large-data-tippecanoe/).
* If you already have tiles in a different format (like in the `tilelive-file` used by [Mapeo](https://mapeo.app/)), you can use a Node command line tool called `tl` to convert them to `MBTiles`. Please see our [Mapeo maps to Terrastories guide](MAPEO-MAPS-IN-TERRASTORIES.md).

Once generated, place the `MBTiles` in the `tileserver/data/mbtiles/` directory, with the right filename as referenced by `style.json`.

#### Working with custom styles

`Styles` (in style.json format) defines the visual appearance of a map: what data to draw, the order to draw it in, and how to style the data when drawing it. Mapbox provides a helpful [guide](https://docs.mapbox.com/mapbox-gl-js/style-spec/) with all of the possible style parameters, but it's generally useful to download an existing `style.json` file and modify it to suit your needs. One of the easiest ways to build a `style.json` file is by uploading and styling your data on [Mapbox Studio](http://mapbox.com/studio) and downloading the `style.json` file from there, in the following way:

* Follow the map design process described [here](CUSTOMIZATION.md#setting-up-a-custom-map).
* In the Mapbox Studio environment, click "Share" and then download the Map style ZIP file.
* Unzip the file, and extract the `style.json` and place it in `tileserver/data/styles`.
* Next, you will need to make some changes. The `style.json` from Mapbox will be referring to an online URL for the map sources. You need to change this to refer to the local `MBTiles`. Change `sources` > `composite` > `url` to the following format: `"url": "MBTiles://MBTiles/name.MBTiles"`. (Here, `name` is just an example; it can be called whatever you want, so long as the filename is the same.)

Importantly, the layer names referenced in `styles` and `MBTiles` have to match, in order for the raw tiles to receive a style property. It may be necessary to edit the layer names in `style.json` to reflect the names of the spatial data in the `MBTiles` file. 

(For example, sometimes when you upload shapefiles to Mapbox Studio, it adds six alphanumeric characters preceded by a dash (-) to your layer name. This is called a "hash." For example, a shapefile called "South_America" might be called "South_America-a2027z" in Mapbox Studio. And then in style.json file, all of the names for this layer will have "–a2027z" added to it. This is a problem because there is a discrepancy between the names in MBTiles, which does no include "-a2027z." So, you have to go into the json and look for "source-layer": "South_America-a2027z", and take out the "-a2027z", and do the same for each layer with a hash.)

*Raster tiles*: If you have raster tiles that you want to load in Terrastories, those will need to defined differently from the vector tiles above. In `sources`, create a new source definition with `url` pointing to the raster `MBTIles` in the same format as above, `type` set to `raster`, and `tileSize` to `256`. Then, in `layers`, create a map object with your `id` of choice, `type` set to `raster`, and `source` set to the name of your raster tiles as defined in `sources`. Here is an example:


```
    "sources": {
        "raster-tiles": {
            "url": "mbtiles://mbtiles/raster.mbtiles",
            "type": "raster"
			"tileSize": 256
        }
     },
     "layers": [
         {
             "id": "raster-background",
             "type": "raster",
             "source": "raster-tiles"
         },
```

You can define multiple `mbtiles` sources (vector as well as raster), and place your raster tile layer underneath vector layers. This is a good way to have an offline satellite imagery basemap with vector data (points, lines, polygons, and labels) overlaid on top of it.

## Setup and running the server

Once you have prepped the environment and offline map content, you may proceed to [the standard guides per operating system](/README.md#install-terrastories) to follow the same process for building and starting Terrastories, with one exception: changing the Docker profile from `dev` to `offline`. So, you would run:

```bash
docker compose --profile offline build
```

and

```bash
docker compose --profile offline up
```

It is possible to switch between offline and online mode by switching the profile from `offline` to `dev`.

Once you have started Terrastories, the next step will be to set up Terrastories communities and users. Please see the [community setup guide](COMMUNITY-SETUP.md) to proceed from here.

## Instructions for setting up an offline computer (serving Terrastories via a WiFi hotspot)

Under construction: https://gist.github.com/kalimar/ed14b5d026220ee5cd81d416b4f67b7b#file-matawai-nuc-md
