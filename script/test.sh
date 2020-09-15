#!/bin/bash

## Run App unit tests
docker-compose run --rm web-test rspec

## Run Javascript unit tests
docker-compose run --rm web-test yarn test

## Run App end to end tests
docker-compose run --rm e2e cucumber

