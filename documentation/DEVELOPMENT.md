# Developing with Terrastories

## Table of Contents

- [Developing with Terrastories](#developing-with-terrastories)
  - [Table of Contents](#table-of-contents)
  - [Setting up your Development Environment](#setting-up-your-development-environment)
    - [Rails](#rails)
    - [ESLint](#eslint)
    - [Tests](#tests)
  - [Working with Explore Terrastories](#working-with-explore-terrastories)
  - [Backup and restore the Terrastories database](#backup-and-restore-the-terrastories-database)
  - [Running Terrastories in Offline Mode](#running-terrastories-in-offline-mode)

## Setting up your Development Environment

If you are working in an internet-connected environment, we recommend you generate a free Protomaps API key and place it in your `.env` file.

Alternatively, you may utilize our default .pmtiles Map Package to serve tiles locally. If you setup using `bin/setup`, these are already available for use. If not, you'll need to set them up using following our [map instructions](/map/README.md).

### Rails

Many developer contributions will be focused on the rails app. Because this project uses
docker, we already have a uniform ruby/rails development environment in our rails docker
image. Any time you need to run a rails command you should do so from a running docker
container to take advantage of this consistent environment. Use the following command to
open a bash console on the rails container:

```
$ docker compose exec web /bin/bash
```

Now you can treat this console like any other development environment, running rails or
bundler commands as needed. **Please refrain from running such commands in your local
environment. Always use the rails container instead.**

Any changes to source files should be made directly in your local filesystem and not in the container.

### ESLint

We use ESLint with Airbnb community style-guide for linting JavaScript and JSX for files in `rails/app/javascript`.

Please check [ESLint editor-integrations page](https://eslint.org/docs/user-guide/integrations#editors) to read about how to integrate ESLint with your IDE/editor.

### Tests

Terrastories uses RSpec for testing and we try to have unit tests for as many components of the application as possible. 

```
docker compose run --rm test
```

If you wish to run a specific test or test file, you may pass that as the first argument:

```
docker compose run --rm test spec/path/to/my_spec.rb:line
```

## Working with Explore Terrastories

Explore Terrastories is a React application that provides an opt-in view of unrestricted stories for public exploration. It is a different application and server from what is deployed in this repository. 

More specific instructions on working with Explore Terrastories can be found [in the repo](https://github.com/terrastories/explore-terrastories), but it is important to know that Explore Terrastories works by accessing an API orchestrated by the controllers in `/controllers/api/` and with responses provided through JBuilder. 

Access to the API is controlled through CORS via an env var `CORS_ORIGINS` that should specify the address of your Explore Terrastories server in the `.env` file. Reasonable defaults are provided.

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


Note: the above code is assuming your build is called `terrastories`. If it is not, it may be necessary to run `docker volume ls` to get the right Docker container name ending with `_postgres_data`.

## Running Terrastories in Offline Mode

Terrastories offline mode is generally used in the field, when there is no access to the internet. It is a heavily cached production build that should not be used for direct development work. You can simulate offline mode for development by setting `OFFLINE_MODE` to yes in your `.env` and rebooting your container.

For more information on running Terrastories in an offline environment, see [SETUP.md](./SETUP.md#setup-for-offline).
