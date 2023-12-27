# Setup

## Table of Contents

- [Setup](#setup)
  - [Table of Contents](#table-of-contents)
  - [Setup Docker](#setup-docker)
  - [Setup the application](#setup-the-application)
  - [Build the application using our script (option 1)](#build-the-application-using-our-script-option-1)
  - [Build the application step by step (option 2)](#build-the-application-step-by-step-option-2)
  - [Using the application regularly](#using-the-application-regularly)
  - [Setup for offline](#setup-for-offline)
  - [Having troubles? Check our common errors \& gotchas](#having-troubles-check-our-common-errors--gotchas)

## Setup Docker

Docker is a platform that serves to deliver software in packages called containers. Terrastories makes use of this to deliver the many facets included in the application in one easy package. 

Setup instructions for Docker: https://docs.docker.com/get-docker/

Be sure to follow the instructions for your OS carefully as the instructions vary per OS.

## Setup the application

1. Create a fork of the [Terrastories repository](https://github.com/Terrastories/terrastories/fork). Now clone the repository locally to your computer.

### Setup using our script (option 1)

Run
   ```sh
   $ ./bin/setup
   ```
and follow the prompts.

Upon completion you should see output similar to:

  ```
  Successfully tagged terrastories:latest
  ```

Next, within the terminal, run:

  ```sh
  $ docker compose up
  ```

Enter `localhost:3000` into your internet browser to view the application.

To find usernames and passwords to login to Terrastories, check [seeds.rb](https://github.com/Terrastories/terrastories/blob/master/rails/db/seeds.rb) (the admin username is probably the most useful for most dev purposes).

### Setup manually (option 2)

1. In your terminal, navigate to your cloned repository and run:

   ```sh
   cp .env.example .env
   ```
   This copies some default configuration for Docker to read.

1. Create a free [Protomap API key](https://app.protomaps.com/signup). It's free for non-commercial use.

1. Add your API key to your `.env` file under the `PROTOMAPS_API_KEY` env var.

1. Run first-time setup:

   ```sh
   # installs dependencies and runs setup
   docker compose run --rm web bin/setup
   # only needed the first time you setup!
   docker compose run --rm web bin/rails db:seed
   ```
    
   This will download the development docker images required to run our project, prepare your database, and seed your database.

1. You should be able to run your terrastories instance:

   ```sh
   docker compose up
   ```

Enter `localhost:3000` into your internet browser to view the application.

> If this fails, make sure all firewalls are turned off and you have a secure connection to the internet. If it continues to fail, check the [common setup errors](#having-troubles-check-our-common-errors--gotchas) section. 

To find usernames and passwords to login to Terrastories, check [seeds.rb](https://github.com/Terrastories/terrastories/blob/master/rails/db/seeds.rb) (the admin username is probably the most useful for most dev purposes).

*Note: if you building Terrastories for a specific hosting environment, you may still need to take some additional steps like adding an alias to your hosts file, or downloading offline map tiles. For more information on setting up Terrastories for different hosting environments, see [this page](https://docs.terrastories.app/setting-up-a-terrastories-server/hosting-environments) on the Terrastories Support Materials website.*

## Using the application regularly

Everytime you want to open and use the application, make sure you have docker desktop running and run the following command in the terminal:

  ```sh
  $ docker compose up
  ```

You can view the running application at `localhost:3000`

It will take a moment to load when first opening the application.

### Keep your dependencies up to date

```sh
docker compose run --rm web bundle install
docker compose run --rm web yarn
```

## Setup for offline

If you're a developer, you can configure your instance of Terrastories to run fully offline by setting the forcing Terrastories to run in offline mode.

You will also need to configure our offline .pmtiles Map Package. If you setup using our `bin/setup` script, this package is already available for use. If not, please follow the instructions in [map](/map/README.md#default-setup).

1. Add these lines to your `.env` file:
   ```
   OFFLINE_MODE=yes
   DEFAULT_MAP_PACKAGE=terrastories-map
   ```
1. Recreate your web container:
   ```
   docker compose create --force-recreate web
   ```
1. And boot up your instance:
   ```
   docker compose up
   ```

> Note: do NOT run in RAILS_ENV=offline as this environment does not utilize your local file changes or compile assets. It's intended to be used as a production instance. OFFLINE_MODE flag will treat your development environment the same as if it is in offline mode, but still with all of your development capabilities.

## Set for Offline Field Kit

<div style="background-color: #CC0000; color: white; padding: 5px 10px">
<p><strong>Setting up offline mode using these instructions is no longer supported</strong></p>
<p>Please follow our new <a href="https://github.com/terrastories/offline-field-kit">offline field kit setup instructions</a>.</p>
</div>

### Quick Setup (Option 1)

1. Download or clone this repository.
1. Run `bin/install`, and follow the prompts.
1. Run `bin/serve` to launch Terrastories.

### Manual Setup (Option 2)

1. Download or clone this repository.
1. In a File view of your choice, create an `.env` file at the root of the application.
1. Configure your offline maps with following [tileserver](/tileserver/README.md#setup-for-offline-mode)
1. Configure your default hostname (optional):
   By default, we serve offline terrastories at terrastories.local. You can configure this by opening .env.offline in your favorite text editor, uncommenting `HOST_HOSTNAME`, and adding your custom domain.
   You will also need to update your /etc/hosts file to point 127.0.0.1 to your custom hostname.
1. Run `bin/serve`

## Having troubles? Check our common errors & gotchas

If you run into any problems getting the application to start, please check out a list of common errors & gotchas that we have put together [here](https://docs.google.com/document/d/1uSbQl56rAh3AA8Xm7IRZ8qepAMVN55ZOkAqQ8Kh423E/edit)!

Additionally, feel free to join us in Slack [here](https://rubyforgood.slack.com/join/shared_invite/zt-1kfeimohe-KL~~~6Lkof7G94_7Ojd_Hw#/shared-invite/email) and find us in the channel #terrastories :) You can also post an issue and label it with `question`. We will get back to you ASAP!
