# Setup Terrastories as an Offline "Field Kit"
This setup is for use in the "Field Kit" environment which is completely offline. If you are setting up Terrastories for an online environment, please follow the instructions for your operating system (Windows, Mac, Linux) [here](README.md#setup)

## Table of Contents

1. [Docker prerequisites](#docker-prerequisites)

2. [Setting up offline environment and map](#setting-up-offline-environment-and-map)

3. [Setup and running the server](#setup-and-running-the-server)

5. [Instructions for setting up an offline computer](#instructions-for-setting-up-an-offline-computer)

## Docker Prerequisites

Install docker. Please refer to operating system-specific guidelines about Docker [here](README.md#setup).

## Setting up offline environment and map 

### Step 1: setting the Terrastories environment to work offline

Create a fork of the Terrastories/terrastories repository. Now clone the repository locally to your computer. 

Using the source-code editor of your choice, open the terrastories repository. There, a file can be found called `.env.example`. 
Copy the contents of this file into a newly created file called `.env` (Do not change .env.example!).

Next, add a line at the bottom of the `.env` file with the content: `USE_LOCAL_MAP_SERVER=true`. (Remove this variable to go back to using online maps from Mapbox.)

### Step 2: preparing the offline map (styles and tiles)

Terrastories in the "Field Kit" environment works by integrating map `styles` and `mbtiles`. Tiles are the raw spatial data, and styles gives a symbology to the data (like color, outline, opacity, label, and so on). Unlike the online environment (where Terrastories relies on Mapbox.com for all map content), each of these have to be made available to Terrastories in a file format.

`Styles` can be downloaded from Mapbox Studio and processed in the following way:

* Follow the map design process described [here](documentation/CUSTOMIZATION.md#setting-up-a-custom-map)
* In the Mapbox Studio environment, click "Share" and then download the Map style ZIP file.
* Unzip the file, and extract the `style.json` and place it in `tileserver/data/styles`.
* In `style.json`, the tiles are referenced in `sources` > `composite` > `url` in the following format: `"url": "mbtiles://mbtiles/name.mbtiles"`. (Here, `name` is just an example; it can be called whatever you want, so long as the filename is the same.)

`Mbtiles` 

* `mbtiles` can be generated from standard geospatial data (Shapefile, GeoJSON) in a number of ways. The easiest way is to use  `tippecanoe` created by Mapbox: [guide](https://docs.mapbox.com/help/troubleshooting/large-data-tippecanoe/).
* Once generated, place the `mbtiles` in the `tileserver/data/mbtiles/` directory, with the right filename as references by `style.json` as described above. 

Importantly, the layer names referenced in `styles` and `mbtiles` have to match, in order for the raw tiles to receive a style property. It may be necessary to edit the layer names in `style.json` to reflect the names of the spatial data in the `mbtiles` file. 

(For example, sometimes when you upload shapefiles to Mapbox Studio, it  adds on an additional six alphanumeric characters preceded by a dash (-), which is called "hash." For example, a shapefile called "South_America" might be called "South_America-a2027z" in Mapbox Studio. And then in style.json file, all of the names for this layer will have "–a2027z" added to it. This is a problem because there is a discrepancy between the names in mbtiles, which does no include "-a2027z." So, you have to go into the json and look for "source-layer": "South_America-a2027z", and take out the "-a2027z", and do the same for each layer with a hash.)

## Setup and running the server

Once you have prepped the environment and offline map content, you may proceed to [the standard guides per operating system](README.md#setup) for building and starting Terrastories.

It is possible to switch between offline and online by removing the `USE_LOCAL_MAP_SERVER=true` variable when Terrastories is down, so long as the other `.env` map variables (`MAPBOX_STYLE` and `MAPBOX_ACCESS_TOKEN`) are set.

## Instructions for setting up an offline computer

Under construction: https://gist.github.com/kalimar/ed14b5d026220ee5cd81d416b4f67b7b#file-matawai-nuc-md
