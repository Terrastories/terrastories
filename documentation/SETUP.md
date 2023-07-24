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

Setup instructions for Docker: https://docs.docker.com/engine/install/

* On Linux, users should run all docker commands with `sudo` or check the [official documentation](https://docs.docker.com/install/linux/linux-postinstall/) to manage Docker as a non-root user.
* On Windows, Docker should install WSL-2 (Windows Subsystem for Linux 2) through which you should set up Terrastories. However, it is possible that you may need to configure some additional settings for Terrastories to properly work on Windows.

## Setup the application
1. Create a fork of the Terrastories/terrastories repository. Now clone the repository locally to your computer. 

2. Using the source-code editor of your choice, open the terrastories repository. There, a file can be found called `.env.example`. Copy the contents of this file into a newly created file called `.env` (Do not change .env.example!).

    Now, create an account at [Mapbox](https://mapbox.com/signup), and copy the mapbox access token (either your default public token or a new one you create) found under your acccount. 

    Navigate back to the `.env` file you created and replace where it says `pk.set-your-key-here` (after `DEFAULT_MAPBOX_TOKEN=`) with your mapbox access token. 

    *Note: if you are developing for offline (e.g. using TileServer-GL to serve tiles, you will not need to provide a Mapbox access token.*

## Build the application using our script (option 1)

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
  $ docker compose --profile dev up
  ```

(If you are building for offline, run this command with `--profile offline` instead.)

Enter `localhost:3000` into your internet browser to view the application.
## Build the application step by step (option 2)

Open your terminal and navigate to the terrastories repository and run:

   ```sh
  $ docker compose --profile dev build
  ```

(If you are building for offline, run this command with `--profile offline` instead.)
    
This will download and build all the docker images used in this project. Upon completion you should see output similar to:

  ```
  Successfully tagged terrastories:latest
  ```

Next, within the terminal, run:

  ```sh
  $ docker compose --profile dev up
  ```

If this fails, make sure all firewalls are turned off and you have a secure connection to the internet. If it continues to fail, check 
the [common setup errors](#having-troubles-check-our-common-errors--gotchas) section. 

For the first time running Terrastories, it may download some additional dependencies. Additionally, you have to create and seed a database. To do so, enter this command in a different terminal while Terrastories is running (and is listening at port 3000):

  ```sh
  $ docker compose exec web bin/setup
  ```

This command runs a setup script that lives in bin/setup, which does:

- install ruby gems
- install javascript packages
- setup database
- seed sample data

See the script file for the details.

Enter `localhost:3000` into your internet browser to view the application.

*Note: if you building Terrastories for a specific hosting environment, you may still need to take some additional steps like adding an alias to your hosts file, or downloading offline map tiles. For more information on setting up Terrastories for different hosting environments, see [this page](https://docs.terrastories.app/setting-up-a-terrastories-server/hosting-environments) on the Terrastories Support Materials website.*

## Using the application regularly

Everytime you want to open and use the application, make sure you have docker desktop running and run the following command in the terminal: 

  ```sh
  $ docker compose --profile dev up
  ```

You can view the running application at `localhost:3000`

It will take a moment to load when first opening the application.

## Setup for offline

The process of setting up Terrastories for offline is similar to the standard dev environment, with a few exceptions:

* Instead of `--profile dev`, use `--profile offline` when setting up and running Terrastories.
* You do not need to enter a Mapbox access token in your `.env` file. However, you do need to provide your own `mbtiles` map tiles and style. If you do not have your own, you can use Terrastories' [default offline map tiles](https://github.com/Terrastories/default-offline-map).

## Having troubles? Check our common errors & gotchas

If you run into any problems getting the application to start, please check out a list of common errors & gotchas that we have put together [here](https://docs.google.com/document/d/1uSbQl56rAh3AA8Xm7IRZ8qepAMVN55ZOkAqQ8Kh423E/edit)!

Additionally, feel free to join us in Slack [here](https://rubyforgood.slack.com/join/shared_invite/zt-1kfeimohe-KL~~~6Lkof7G94_7Ojd_Hw#/shared-invite/email) and find us in the channel #terrastories :) You can also post an issue and label it with `question`. We will get back to you ASAP!
