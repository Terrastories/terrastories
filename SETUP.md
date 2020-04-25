# Setup

## Table of Contents

1. [Docker prerequisites](#docker-prerequisites)

2. [Setup and running the server](#Setup-and-running-the-server)

3. [Make it Go](#Make-It-Go)

6. [Common environment errors & gotchas](#having-troubles-check-our-common-errors--gotchas)

5. [Development](#development)

6. [Backup and restore the Terrastories database](#backup-and-restore-the-terrastories-database)

7. [Importing data into Terrastories](#importing-data-into-terrastories)

8. [Adding languages to Terrastories](#adding-languages-to-terrastories)

9. [Setting up your Development Environment](#setting-up-your-development-environment)

## Docker Prerequisites

Install docker. On linux, you may have to install docker-compose separately.

- https://docs.docker.com/install/
- https://docs.docker.com/compose/install/

On Windows, all terminal docker commands need to be run using Windows PowerShell, not Command Prompt.
PowerShell comes with Windows.

On Linux, users should run all docker commands with `sudo` or check the [official documentation](https://docs.docker.com/install/linux/linux-postinstall/) to manage Docker as a non-root user.

## Setup and running the server

First update your `.env` file using `.env.example` as a reference. You will need a Mapbox token. You can obtain one for free by signing up [on Mapbox](https://mapbox.com/signup)

On a fresh clone of this repo, run:

```
$ docker-compose build
```

This will download and build all the docker images used in this project. Upon completion you should see output similar to:.

```
...
Successfully tagged terrastories:latest
```

## Make It Go

Run the following:

```
$ docker-compose up
```

Use `ctrl-c` to stop.


The first time, open another terminal and run the following command to setup:

```
$ docker-compose exec web bin/setup
```

This command runs a setup script that lives in `bin/setup`, which does:

- install ruby gems
- install javascript packages
- setup database

See the script file for the details.

Once rails fully starts up, you can view the running app at `localhost:3000`

## Having troubles? Check our common errors & gotchas

If you run into any problems getting the application to start, please check out a list of common errors & gotchas that we have put together [here](https://docs.google.com/document/d/1uSbQl56rAh3AA8Xm7IRZ8qepAMVN55ZOkAqQ8Kh423E/edit)!

Additionally, feel free to join us in Slack [here](https://t.co/kUtI3lnpW1) and find us in the channel #terrastories :) You can also post an issue and label it with `question`. We will get back to you ASAP!

## Development

Most developer contributions will be focused on the rails app. Because this project uses
docker, we already have a uniform ruby/rails development environment in our rails docker
image. Any time you need to run a rails command you should do so from a running docker
container to take advantage of this consistent environment. Use the following command to
open a bash console on the rails container:

```
$ docker-compose exec web /bin/bash
```

Now you can treat this console like any other development environment, running rails or
bundler commands as needed. **Please refrain from running such commands in your local
environment. Always use the rails container instead.**

Any changes to source files should be made directly in your local filesystem under the
`/opt/terrastories` directory using your preferred editing tools.

## Backup and restore the Terrastories database

Terrastories stores Places, Speakers, and Stories in a database (Postgres DB). it is possible to back these data up and restore them by running lines of code in a bash terminal.

Backup the DB with:

```
docker run --rm -v "terrastories_postgres_data:/pgdata" busybox tar -cvzf - -C /pgdata . >db-backup.tgz 
```

Restore a backup with:

```
docker volume rm terrastories_postgres_data
docker run --rm -i -v "terrastories_postgres_data:/pgdata" busybox tar -xvzf - -C /pgdata <db-backup.tgz
```

**For Windows** applications like PowerShell (PS), a slightly different syntax is needed. 

Backup the DB in PS with:

```
docker run --rm -v "terrastories_postgres_data:/pgdata" -v "$(pwd):/host" busybox tar -cvzf /host/db-backup-test.tgz -C /pgdata .
```

Restore a backup in PS with:

```
docker run --rm -i -v "terrastories_postgres_data:/pgdata" -v "$(pwd):/source/" busybox tar -xvzf /source/db-backup.tgz -C /pgdata
```

Note: the above code is assuming your build is called `terrastories`. It may be necessary to run `docker volume ls` to get the right Docker container name ending with `_postgres_data`.

## Importing data into Terrastories

In the Terrastories back end, it is possible to import data in bulk using a CSV importer.

The data should be imported in the following order: Places, Speakers, and then Stories.

To prepare CSVs for importing, use the following workflow to ensure that character diacritics are properly imported:

-If the file is already an .xlsx, go to Google Sheets and File->Import from the menu. Then import the file.
-Otherwise create the file directly in Google Sheets. Make sure the file has a row for headers.
-Go to File -> Download As-> Comma Separated Values, and save the file to your machine.
-This CSV should be properly encoded as UTF-8. It's best to verify this with Notepad++ instead of Excel if you are on a Windows machine.

## Adding languages to Terrastories

Terrastories uses internationalization to translate the application's core text, like the welcome page, sidebar, and administrative back end content. We have made it easy to add new languages to Terrastories without needing to touch any of the code.

To add a language to Terrastories, navigate to the `rails/config/locales/` directory. Within this directory, each language has it's own subdirectory, like `en` (English) or `pt` (Portuguese). Currently, there are three files in each (using Portuguese as an example):

1.  `pt.yml`
2.  `devise.pt.yml`
3.  `administrate.pt.yml`

`pt.yml` contains the custom text used in the Terrastories application. `devise.pt.yml` and `administrative.pt.yml` are used by the administrative back end.

To set up a new language, create a new subdirectory in the `locales` folder. Let's assume you want to set up Papiamentu. Create a subdirectory called `pap` and copy over `en.yml` from the `en` folder. Rename it to `pap.yml`, change line 32 to `pap`, and translate each line of text in what follows.

For the `devise` and `administrate` files, there might be available translations already available online for common Western languages. If so, you can download these and place them in the directory, and make sure that the language code is consistent (for languages like Spanish and Portuguese, the language code might sometimes have a country-specific suffix like `pt-BR`). If translations are not available, do the same thing with these two files as translating `en.yml`.

If you want to change the default language for Terrastories, set the language on line 21 in `rails/config/application.rb`. To set it to Papiamentu, change this line to `config.i18n.default_locale = :pap`

Once you are done, the language should be available the next time you start Terrastories.


## Setting up your Development Environment

### ESLint

We use ESLint with Airbnb community style-guide for linting JavaScript and JSX for files under app/javascript.

Please check [ESLint editor-integrations page](https://eslint.org/docs/user-guide/integrations#editors) to read about how to integrate ESLint with your IDE/editor

### e2e Tests

You can run e2e tests with

```
script/test
```
