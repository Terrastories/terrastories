# Developing with Terrastories

## Table of Contents

1. [Setting up your development environment](#setting-up-your-development-environment)

2. [Back up and restore Terrastories database](#backup-and-restore-the-Terrastories-database)

3. [Running Terrastories in offline mode](#running-terrastories-in-offline-mode)

## Setting up your Development Environment

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

If you are working in an internet-connected environment, you will need to add a valid Mapbox access token to your `.env` file in order for the Terrastories map to work (whether it is in the `dev` or `offline` profile). Alternatively, you may add an access token (and Mapbox map style) for a community via the Themes dashboard in the administrative menu, to get a map to work for that specific community only.

### ESLint

We use ESLint with Airbnb community style-guide for linting JavaScript and JSX for files under app/javascript.

Please check [ESLint editor-integrations page](https://eslint.org/docs/user-guide/integrations#editors) to read about how to integrate ESLint with your IDE/editor

### Tests

You can run RSpec and e2e tests with

```
script/test.sh
```

We also support Javascript unit testing, with Enzyme for snapshots. 

```
    docker-compose exec web yarn test 
```

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

Or using Powershell (Windows):

Backup the DB in PS with:

```
docker run --rm -v "terrastories_postgres_data:/pgdata" -v "$(pwd):/host" busybox tar -cvzf /host/db-backup-test.tgz -C /pgdata .
```

Restore a backup in PS with:

```
docker run --rm -i -v "terrastories_postgres_data:/pgdata" -v "$(pwd):/source/" busybox tar -xvzf /source/db-backup.tgz -C /pgdata
```

Note: the above code is assuming your build is called `terrastories`. It may be necessary to run `docker volume ls` to get the right Docker container name ending with `_postgres_data`.

## Running Terrastories in Offline Mode

Terrastories offline mode is generally used in the field, when there is no access to the internet.

To start Terrastories with the offline profile, run 

```bash
docker compose --profile offline up
```

In order to get the local tileserver map running, you will also need to generate an `MBtiles` dataset and place it in `tileserver/data/mbtiles/` with the filename `terrastories.mbtiles`, along with any fonts, sprites used in the map, and a `style.json` file that defines the appearance of the tiles. Please see the [customization guide](CUSTOMIZATION.md) for more information.

For more information on running Terrastories in an offline environment, see [SETUP-OFFLINE.md](SETUP-OFFLINE.md)