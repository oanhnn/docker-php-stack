#!/usr/bin/env bash

if [[ ! -z "$TRAVIS_TAG" ]]; then
    docker build --tag $DOCKER_REPO:$BUILD_TAG \
                 --build-arg BUILD_DATE=$(date -u -Iseconds) \
                 --build-arg VCS_REF=$BUILD_TAG \
                 --build-arg STACK_VERSION=${TRAVIS_TAG} .
else
    docker build --tag $DOCKER_REPO:$BUILD_TAG \
                 --build-arg BUILD_DATE=$(date -u -Iseconds) \
                 --build-arg VCS_REF=$BUILD_TAG .
fi
