#!/bin/bash

docker login -u $DOCKER_USER -p $DOCKER_PASSWORD

# master branch
if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
  docker push $DOCKER_REPO:latest;
fi

# develop branch
if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "develop" ]]; then
  docker tag $DOCKER_REPO:$BUILD_TAG $DOCKER_REPO:develop;
  docker push $DOCKER_REPO:develop;
fi

# tags
if [[ ! -z "$TRAVIS_TAG" ]]; then
  docker tag $DOCKER_REPO:$BUILD_TAG $DOCKER_REPO:$TRAVIS_TAG;
  docker push $DOCKER_REPO:$TRAVIS_TAG;
fi
