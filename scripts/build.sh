#!/usr/bin/env bash

docker pull $DOCKER_REPO:latest || true
docker build --pull --cache-from $DOCKER_REPO:latest --tag $DOCKER_REPO:$BUILD_TAG .
docker tag $DOCKER_REPO:$BUILD_TAG $DOCKER_REPO:latest
