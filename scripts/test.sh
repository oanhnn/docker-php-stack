#!/bin/bash

# Note: In this test, i using native `composer` of TravisCI image for speed up test process
# You can use `docker run --rm -v $(pwd):/app <subcommand>` if you don't install `composer` yet

mkdir test-app

# Create Laravel project
composer create-project --no-dev --prefer-dist --ignore-platform-reqs laravel/laravel test-app $LARAVEL

# Setting up project
cd test-app
composer require predis/predis --ignore-platform-reqs --update-no-dev

# Set up Laravel Horizon
if [ "${APP_ENABLE_HORIZON}" -eq "1" ]; then
  composer require laravel/horizon --ignore-platform-reqs --update-no-dev
fi

rm -rf vendor

# Setup environment variables
sed -i "s|DB_CONNECTION=.*|DB_CONNECTION=mysql|i"   .env
sed -i "s|DB_HOST=.*|DB_HOST=db|i"                  .env
sed -i "s|REDIS_HOST=.*|REDIS_HOST=redis|i"         .env
sed -i "s|CACHE_DRIVER=.*|CACHE_DRIVER=redis|i"     .env
sed -i "s|SESSION_DRIVER=.*|SESSION_DRIVER=redis|i" .env
sed -i "s|MAIL_DRIVER=.*|MAIL_DRIVER=log|i"         .env

# Set up docker-compose
sudo chown `id -u`:`id -g` -R ./
cp -rT ../example-laravel .

# Build and run
docker-compose up -d

# Verifications
sleep 60
docker-compose ps
docker-compose logs app

cd ..

curl --retry 10 --retry-delay 5 -I http://127.0.0.1/
curl --retry 10 --retry-delay 5 -I http://127.0.0.1/socket.io/socket.io.js
