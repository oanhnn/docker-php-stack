#!/bin/bash

# Build oanhnn/php-stack:latest
docker pull $DOCKER_REPO:latest || true
docker build --pull --cache-from $DOCKER_REPO:latest --tag $DOCKER_REPO:latest .

# Build oanhnn/php-stack:laravel
docker build --tag $DOCKER_REPO:laravel laravel
