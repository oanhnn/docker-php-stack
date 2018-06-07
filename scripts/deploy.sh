#!/usr/bin/env bash

docker login -u $DOCKER_USER -p $DOCKER_PASSWORD

if [[ ! -z "$TRAVIS_TAG" ]]; then
  docker tag $DOCKER_REPO:$BUILD_TAG $DOCKER_REPO:$TRAVIS_TAG;
  docker push $DOCKER_REPO:$TRAVIS_TAG;
fi

if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
  docker tag $DOCKER_REPO:$BUILD_TAG $DOCKER_REPO:latest;
  docker push $DOCKER_REPO:latest;
fi
