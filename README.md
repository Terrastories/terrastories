![Terrastories](documentation/logo.png)

## About Terrastories

**Terrastories** is a geostorytelling application built for indigenous and other local communities to locate and map their own oral storytelling traditions about places of significant meaning or value to them. 

It is a dockerized Rails / React app that uses [**Mapbox GL JS**](https://mapbox.com) / [**MapLibre GL JS**](https://maplibre.com/) to help users locate content geographically on an interactive map. As a local-first application, Terrastories is designed to work entirely offline, so that remote communities can access the application entirely without needing internet connectivity.

The Terrastories interface is principally composed of an interactive map and a sidebar with media content. Users can explore the map and click on activated points to see the stories associated with those points. Alternatively, users can interact with the sidebar and click on stories to see where in the landscape these narratives took place. 

By means of a content management system, users with the right level of access can also explore, add, edit, remove, and import stories, or set them as restricted so that they are viewable only with a special login. Users can design and customize the content of the interactive map entirely.

Learn more about Terrastories on [our website](https://terrastories.app/). 

*The remainder of the documentation on Github is for developers. For documentation on using or installing Terrastories, please visit the Terrastories Support Materials at **[https://docs.terrastories.app/](https://docs.terrastories.app/)***

![](documentation/terrastories.gif)
###### *Terrastories: Matawai Konde 1.0 (October 2018)*

## Install Terrastories

Terrastories can be set up for different hosting environments, including online, local (development), mesh network, or offline "field kit". For local or offline hosting, there is a convenience script that walks you through all of the steps, or you can choose to follow the more granular guides for the various environments and operating systems.

### Prerequisites

#### Docker
Local development and offline mode both require Docker to be installed.

Download and install [Docker](https://www.docker.com/products/docker-desktop/) for your platform.

> NOTE: Windows requires WSL 2.0 or virtualization in order to work.

#### Tileserver (Offline "Field Kit" Mode)

If you plan on running Terrastories offline, you'll need to configure local tiles for offline use.

A default, open-license map for using offline with Terrastories is available at https://github.com/terrastories/default-offline/tiles. You will have the option of downloading these using the setup script below. Alternatively, you can manually download these files and place them in the `tileserver/data` directory, and they should work when you load Terrastories in Field Kit mode.

### Setup

1. Clone this repository
1. Run
   ```sh
   $ ./bin/setup
   ```
   and follow the prompts.

Once you have set up Terrastories, you can log in to the super admin console, or the sample Terrastories community, using login information found in `rails/db/seeds.rb`.

If you are developing with an online (Mapbox) map, you will need to provide an access token. Copy the contents of the `.env.example` file into a newly created file called `.env` (Do not change .env.example!). In the `.env` file, replace where it says `pk.set-your-key-here` (after `DEFAULT_MAPBOX_TOKEN=`) with your mapbox access token. 

### Issues?

Review more granular setup options in the [Setup](documentation/SETUP.md) documentation.
## Developing with Terrastories

To find out how to develop with the Terrastories app, read our [developer guide](documentation/DEVELOPMENT.md) and check out our [Developer Community](https://terrastories.app/community/) pages on the Terrastories website.

For a general overview of the application as well as a Vision statement and Roadmap, please see our [Wiki](https://github.com/Terrastories/terrastories/wiki).

## Contributing

Please visit our [contributing](CONTRIBUTING.md) page for more details.
