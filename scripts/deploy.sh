#!/usr/bin/env bash

docker login -u $DOCKER_USER -p $DOCKER_PASSWORD

if [[ ! -z "$TRAVIS_TAG" ]]; then
  docker tag oanhnn/php-stack:build oanhnn/php-stack:$TRAVIS_TAG;
  docker push oanhnn/php-stack:$TRAVIS_TAG;
fi

if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
  docker tag oanhnn/php-stack:build oanhnn/php-stack:latest;
  docker push oanhnn/php-stack:latest;
fi
