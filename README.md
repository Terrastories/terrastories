![Terrastories](https://www.amazonteam.org/wp-content/uploads/2018/09/logo-1170x164.png)

**TerraStories** is an application designed to help communities map and access their own place-based storytelling. The project to develop this application was initiated by the [**Amazon Conservation Team**](http://amazonteam.org) (ACT), an organization who partners with indigenous and other traditional communities in the Amazon rainforest to help them protect their ancestral lands and traditional culture. The application is developed to be entirely open source and offline-compatible, so that it can be used by communities in the most remote locations of the world. It is a Dockerized Rails App that uses [**Mapbox**](https://mapbox.com) to help users locate content geographically on an interactive map. A team is attempting to finish this app at **Ruby for Good 2018**: http://rubyforgood.org/2018

## Table of Contents

1.  [How to Contribute](#contributing)

2.  [Prerequisites](#prerequisites)

3.  [Setup](#setup)

4.  [Running the Server](#make-it-go)

5.  [Updating the App](#make-it-go)

6.  [Development](#development)

7.  [Updating the Tileserver Map](#updating-the-tileserver-map)

## How to Contribute

We would love for you to contribute to terrastories! We welcome all types of contributions, but any pull requests that address open issues, have test coverage, or are tagged with the next milestone will be prioritized. Please visit our [Contributing Guidelines](CONTRIBUTING.md) for more information.

## Prerequisites

Install docker. On linux, you may have to install docker-compose separately.

- https://docs.docker.com/install/
- https://docs.docker.com/compose/install/

## Setup

This project uses these [GitHub conventions](https://github.com/github/scripts-to-rule-them-all)
to provide convenient scripts for developers.

On a fresh clone of this repo, run:

```
$ script/setup
```

This will download and build all the docker images used in this project. It will
also build the map tile data supporting the tileserver service. This step can
take a long time complete. Its output should end with something like the
following, which will eventually get to 100%, I promise.

```
...
> wwww features, xxxx bytes of geometry, yyyy bytes of separate metadata,
zzzz bytes of string pool
> 99.9% 11/2222/3333
```

## Make It Go

Just run:

```
$ script/server
```

Use `ctrl-c` to stop.

(Alternatively, the server can be started in detached mode with `script/start`.
In that case, stop it with `script/stop`.)

Once rails fully starts up, you can view the running app at `localhost:3000`
or an alternative port specified in `.env` if one exists. See `.env.example` for
available options and reasonable starting values.

To monitor the console output from just the rails app and not the other docker
containers, run:

```
$ script/logs
```

## Updating the App

After a `git pull` or any time ruby gems or node modules may have changed, run:

```
$ script/update
```

Then restart the app with `script/server` (or `script/start`).

## Development

Most developer contributions will be focused on the rails app. Because this project uses
docker, we already have a uniform ruby/rails development environment in our rails docker
image. Any time you need to run a rails command you should do so from a running docker
container to take advantage of this consistent environment. Use the following command to
open a bash console on the rails container:

```
$ script/console
```

Now you can treat this console like any other development environment, running rails or
bundler commands as needed. **Please refrain from running such commands in your local
environment. Always use the rails container instead.**

Any changes to source files should be made directly in your local filesystem under the
`/rails` directory using your preferred editing tools.

## Updating the Tileserver Map

### Step 1: preparing content in Mapbox Studio

Terrastories is designed to render a basemap as designed and styled in Mapbox Studio. There are two different components: shapefiles (the spatial data without any styling properties) and styles (the look and feel of the map, as designed in Mapbox Studio, exported in json format). The basic workflow is as follows:

1.  upload their shapefile content to [Mapbox Studio](https://www.mapbox.com/mapbox-studio/), and use the Studio interface to lay out the map. You have to have a Mapbox account to use Mapbox Studio (creating and designing maps using Mapbox Studio is free up to certain file size limitations.) To learn how to use Mapbox Studio, you can refer to the manuals and tutorials made available by Mapbox [here](https://www.mapbox.com/help/studio-manual-tutorials/) or other resources on the web.

2.  download the style.json from Mapbox Studio via the Mapbox Studio styles interface [here](https://www.mapbox.com/studio/styles/)

3.  copy both the shapefiles and style.json into the respective directories on Terrastories.
    Note: the user must provide their own shapefile content. It is not possible to use any of the standard OpenStreetMap (OSM) content used in the standard styles made available by Mapbox, unless the user first downloads that OSM content and converts it to shapefile first.

### Step 2: adding new or updating shapefiles to Terrastories

To add new shapefiles or update existing shapefiles, there are two steps:

1.  Include the new files in your `shapefile` directory (\tilebuilder\shapefiles])

2.  You will need to re-run the tilebuilder, following the instructions here: https://github.com/rubyforgood/terrastories/blob/master/tilebuilder/README.md

### Step 3: adding or updating style to the Map

To add or update the map style,

1.  download the style.json from Mapbox Studio via the Mapbox Studio styles interface [here](https://www.mapbox.com/studio/styles/)

2.  at this point, we have to edit the style.json a little. When you upload shapefiles to Mapbox Studio, it actually adds on an additional six alphanumeric characters preceded by a dash (-), which is called "hash." For example, a shapefile called "South_America" might be called "South_America-a2027z" in Mapbox Studio. And then in style.json file, all of the names for this layer will have "–a2027z" added to it. This is a problem because there is a discrepancy between the names of the shapefile you added in Step 2, which does no include "-a2027z." So, you have to go into the json and look for "source-layer": "South_America-a2027z", and take out the "-a2027z", and do the same for each layer.
    In the future, we will create an automatic script that will take care of this process.

3.  copy the style into your `styles` directory (tileserver\data\styles])

4.  make sure that config.json in \tileserver\data\ is pointing to the right style file.

### Instructions for setting up your offline computer

https://gist.github.com/kalimar/ed14b5d026220ee5cd81d416b4f67b7b#file-matawai-nuc-md
