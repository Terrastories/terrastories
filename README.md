# TerraStories

### Note: This is currently a work in progress.

## Prerequisites
Install Docker and Docker Compose
 - https://docs.docker.com/install/
 - https://docs.docker.com/compose/install/

## Setup
Docker will automatically build images as needed when running `docker-compose`,
but to confirm everything builds correctly, run the following and check that the
output ends with something like this.
```
$ docker-compose build
...
> Successfully built 0123456789
> Successfully tagged terrastories/tilebuilder:latest
> tileserver uses an image; skipping
```

## Make It Go
In theory, this should simply require `docker-compose up -d`, but both of these
containers share the `mbtiles` volume and they both do extensive sqlite reads
and writes. And since the tilebuilder only needs to run once to initially
populate `mbtiles`, we can avoid potential database locks by running the
two services sequentially to gain more consistently successful results.
```
$ docker-compose run tilebuilder
... (eventually this process should exit with a code 0)
$ docker-compose up -d tileserver
```

To spin the whole thing back down run the following.
```
$ docker-compose down
```

If you make changes that require regenerating the mbtiles file, a few extra
steps are required to get the tilebuilder to run smoothly a second time. Any
time tilebuilder fails with a tippecanoe error `table metadata already exists`
you should try these steps to resolve it.
```
$ docker volume prune -f
```

Now that the old volume is deleted, the tilebuilder can be re-run just like the
first time.
```
$ docker-compose run tilebuilder
... (let it run, or add -d to detach it and suppress all that output)
$ docker-compose restart tileserver
```



## Tidying Up
Docker likes to accumulate cached volumes, containers, and images, some of which
are bound to be superfluous and quite large. Here's how to clean those up.
```
$ docker volume prune -f
$ docker container prune -f
$ docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
```

The last one may look a little risky, but basically relies on the concept that
any docker image without a useful tag is unlikely to be needed. Untagged images
show up as `<none>` when in the list provided by `docker images`. If you don't
trust that batch removal command, you can manually review the listed images and
delete by referencing the image id with something like
`docker image rm abc123f`.

With any of these steps, there's really no risk of removing anything that can't
be restored with a `docker build` or `docker pull` later.
