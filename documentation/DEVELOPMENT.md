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

### ESLint

We use ESLint with Airbnb community style-guide for linting JavaScript and JSX for files under app/javascript.

Please check [ESLint editor-integrations page](https://eslint.org/docs/user-guide/integrations#editors) to read about how to integrate ESLint with your IDE/editor

### Tests

You can run RSpec and e2e tests with

```
script/test.sh
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
 
In those cases, before starting the server, add `USE_LOCAL_MAP_SERVER=true` to your .env file. Remove this variable to go back to using mapbox.

In order to get the local tileserver map running, you will also need to download an mbtiles dataset [like this one](https://drive.google.com/open?id=1rWEyCosde507dlPcDwbmDA6jxqc0KAuk) and place it in `tileserver/data/mbtiles/basic.mbtiles` 

And instead of running docker-compose up, run 

```bash
script/run_offline_maps.sh
```

For more information on running Terrastories in an offline environment, see [documentation/SETUP-OFFLINE.md](SETUP-OFFLINE.md)