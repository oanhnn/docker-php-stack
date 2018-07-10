#!/usr/bin/env bash

docker build --tag $DOCKER_REPO:$BUILD_TAG .
docker tag $DOCKER_REPO:$BUILD_TAG $DOCKER_REPO:latest
