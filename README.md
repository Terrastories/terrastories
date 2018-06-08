# TerraStories

### Note: This is currently a work in progress.

## Prerequisites
Install docker. On linux, you may have to install docker-compose separately.
 - https://docs.docker.com/install/
 - https://docs.docker.com/compose/install/

## Setup
Docker will automatically build images as needed when running `docker-compose up`,
but to confirm everything builds correctly, run the following and check that the
output ends with something like this.
```
$ docker-compose build
  ...
> mariadb uses an image; skipping
  ...
> Successfully built 0123456789
> Successfully tagged terrastories/tilebuilder:latest
> tileserver uses an image; skipping
> rails uses an image; skipping
```

## Build The Map Tiles
The tilebuilder service will need to be run once to populate the `mbtiles`
shared volume that the tileserver will read from. The tilebuilder does not need
to stay running along with the other services. Building map tiles may take quite
a long time, but it should show progress similar to the following and eventually
get to 100%, exiting with code 0.
```
$ docker-compose run tilebuilder
...
> wwww features, xxxx bytes of geometry, yyyy bytes of separate metadata,
zzzz bytes of string pool
> 99.9% 11/2222/3333
```

Any time the shapefiles change and require regenerating the mbtiles file,
this service will need to be run again and the tileserver restarted once the
tilebuilder finishes (just run `docker-compose restart tileserver`).

## Make It Go
In `docker-compose.yml`, the tileserver and rails database are listed as
dependencies for the rails service. So to start the whole thing up (omitting
tilebuilder, which only needs to run once) just run the following. Omit the
`-d` flag if you prefer to see all of the rails server output.
```
$ docker-compose up -d nginx
```

To spin all the services back down run the following.
```
$ docker-compose down
```

## Tidying Up
Docker likes to accumulate cached containers and images, some of which
are bound to be superfluous and quite large. Here's how to clean those up.
```
$ docker container prune -f
$ docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
```

The last one may look a little risky, but basically relies on the idea that any
docker image without a useful tag is unlikely to be needed. Untagged images
show up as `<none>` when in the list provided by `docker images`. If you don't
trust that batch removal command, you can manually review the listed images and
delete by referencing the image id as something like `docker image rm abc123f`.

With any of these steps, there's really no risk of removing anything that can't
be restored with a `docker build` or `docker pull` later.
