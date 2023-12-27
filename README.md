![Terrastories](documentation/logo.png)

<p>
<a href="https://github.com/terrastories/terrastories/graphs/contributors" alt="Contributors"> <img src="https://img.shields.io/github/contributors/terrastories/terrastories?logo=github" /></a>
<a href="https://github.com/terrastories/terrastories/issues" alt="Contributors"> <img src="https://img.shields.io/github/issues-closed/terrastories/terrastories?logo=github" /></a>
<a href="https://github.com/terrastories/terrastories/search" alt="Languages"><img src="https://img.shields.io/github/languages/count/terrastories/terrastories?logo=github" /></a>
<a href="https://github.com/terrastories/terrastories/search" alt="Languages"><img src="https://img.shields.io/github/languages/top/terrastories/terrastories?logo=github" /></a>
<a href="https://github.com/terrastories/terrastories/ alt="Size"><img src="https://img.shields.io/github/repo-size/terrastories/terrastories?logo=github" /></a>
<a href="https://github.com/terrastories/terrastories/pulls" alt="Pull Requests"><img src="https://img.shields.io/github/issues-pr-closed-raw/terrastories/terrastories?logo=github" /></a>
<a href="https://github.com/terrastories/terrastories/ alt="LICENSE"><img src="https://badgen.net/github/license/terrastories/terrastories?icon=github&color=green" /></a>
<a href="https://github.com/badges/shields/pulse" alt="Activity"><img src="https://img.shields.io/github/commit-activity/m/terrastories/terrastories?logo=github" /></a>
<a href="https://github.com/terrastories/terrastories/commits/main" alt="Last Commit"><img src="https://img.shields.io/github/last-commit/terrastories/terrastories?logo=github" /></a>
<a href="https://github.com/terrastories/terrastories/commits/main" alt="Total Commits"><img src="https://badgen.net/github/commits/terrastories/terrastories/main?icon=github&color=green" /></a>
</p>

<p align="center">
<a href="https://github.com/terrastories/terrastories/" alt="Stars"><img src="https://img.shields.io/github/stars/terrastories/terrastories?style=social" /></a>
<a href="https://github.com/terrastories/terrastories/" alt="Forks"><img src="https://img.shields.io/github/forks/terrastories/terrastories?style=social" /></a>
<a href="https://github.com/terrastories/terrastories/" alt="Watchers"><img src="https://img.shields.io/github/watchers/terrastories/terrastories?style=social" /></a>
</p>

## About Terrastories

**Terrastories** is an open-source geostorytelling application for mapping, managing and sharing place-based stories. The application is being co-created with Indigenous and other local communities to collectively manage their oral histories and other cultural knowledge, but it can be used by anyone to create a map of their stories.

Terrastories is a Dockerized Rails and React app that uses [**MapLibre GL JS**](https://maplibre.com/) or [**Mapbox GL JS**](https://mapbox.com) to help users locate place-based media content or narrative stories on an interactive map. As a local-first application, Terrastories is designed to work entirely offline, so that remote communities can access the application entirely without needing internet connectivity.

The main Terrastories interface is principally composed of an interactive map and a sidebar with media content. Users can explore the map and click on activated points to see the stories associated with those points. Alternatively, users can interact with the sidebar and click on stories to see where in the landscape these narratives took place. 

By means of a content management system, users with the right level of access can also explore, add, edit, remove, and import stories, or set them as restricted so that they are viewable only with a special login. Users can design and customize the content of the interactive map entirely.

There is also [Explore Terrastories](https://github.com/terrastories/explore-terrastories), a separate React app that allows public exploration of unrestricted stories that communities have opted into sharing. Explore Terrastories queries the API of the main Terrastories application provided in this repository.

Learn more about Terrastories on [our website](https://terrastories.app/). 

> ❗️ *The remainder of the documentation on Github is **for developers**. For documentation on using Terrastories, or setting up Terrastories on an online, offline "Field Kit", or mesh network server, please visit the Terrastories Support Materials at **[https://docs.terrastories.app/](https://docs.terrastories.app/)***

![](documentation/terrastories.gif)
###### *Terrastories: Matawai Konde 1.0 (October 2018)*

## Install Terrastories

Terrastories can be set up for different hosting environments, including online, local (development), mesh network, or offline "field kit".

For local development, follow the [development](#development) setup.
For offline hosting, there is a convenient script that walks you through all of the steps.
For all other hosting environments, please see our [docs](https://docs.terrastories.app).

### Prerequisites

1. Download and install [Docker](https://docs.docker.com/get-docker/) for your platform.

### Offline "Field Kit" Mode

<div style="background-color: #CC0000; color: white; padding: 5px 10px">
<p><strong>Setting up offline mode using these instructions is no longer supported</strong></p>
<p>Please follow our new <a href="https://github.com/terrastories/offline-field-kit">offline field kit setup instructions</a>.</p>
</div>

#### **Why are you no longer supporting offline mode here?**

A few reasons. Namely, requiring offline communities to download and build the entire application from scratch was time-consuming, difficult on poor internet connections, and was often riddled with errors that were difficult to troubleshoot and fix without substantial support.

**Faster, stabler, and more streamlined download to runtime instructions**

Some of our latest efforts have been to create a more streamlined setup for communities wishing to host an offline instance out in the field, or what we like to call our "offline field kits." This involves us building and hosting production ready images that have everything they need to run terrastories, so you won't need to build it yourself.

We've set up a lightweight download-and-install [repository](https://github.com/terrastories/offline-field-kit). It also includes advanced setup if you wish to configure it more than the run install.sh and boot with default configurations.

**Protomaps and .pmtiles by default**

Our new default rendering of map tiles is using Protomaps. For online environments, we utilize the Protomaps API (with an API key); otherwise, we support rendering using a locally installed .pmtiles Map Package.

Terrastories still supports running your own Tileserver; however, we are deprecating support for running the Tileserver for you.

> If you previously set up Terrastories with Tileserver, your style data is safe and you can still run your instance using these instructions.

We recommend you convert your .mbtiles to .pmtiles and switch to using our offline field kit when you are able.

#### Setup

1. Clone repository
1. Run `bin/install`, and follow the prompts
1. After it completes, run `bin/serve`

If you are installing on a field kit with a hotspot, there are additional instructions for configuring those settings available in our [docs](https://docs.terrastories.app).

## Development

### Quick Start

1. [Fork & Clone](https://github.com/Terrastories/terrastories/fork)
1. Run `bin/setup`, and follow the prompts
1. When complete, boot with `docker compose up`

### Tests

We use rspec for running our Rails specs. You can run the entire suite using:

```
docker compose run --rm test
```

Additionally, all RSpec runtime flags, including running a specific test, are available:

```
docker compose run --rm test spec/models/user_spec.rb:15
```

The `--rm` flag tells Docker to clean up the container after it's done running the test suite.

### Issues?

Review more granular setup options in the [Setup](documentation/SETUP.md) documentation.
## Developing with Terrastories

To find out how to develop with the Terrastories app, read our [developer guide](documentation/DEVELOPMENT.md) and check out our [Developer Community](https://terrastories.app/community/) pages on the Terrastories website.

For a Vision statement and Roadmap, please see our [Wiki](https://github.com/Terrastories/terrastories/wiki).

## Contributing

Please visit our [contributing](CONTRIBUTING.md) page for more details.
