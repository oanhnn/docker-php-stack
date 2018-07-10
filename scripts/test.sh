#!/usr/bin/env bash

mkdir laravel

# Create Laravel project
composer create-project --no-dev --prefer-dist laravel/laravel laravel 5.5.*

# Set up docker-compose
cp example-laravel/* example-laravel/.dockerignore laravel/
cd laravel
rm -rf composer.lock vendor

# Setup environment variables
sed -i "s|DB_CONNECTION=.*|DB_CONNECTION=mysql|i"   .env
sed -i "s|DB_HOST=.*|DB_HOST=db|i"                  .env
sed -i "s|CACHE_DRIVER=.*|CACHE_DRIVER=redis|i"     .env
sed -i "s|SESSION_DRIVER=.*|SESSION_DRIVER=redis|i" .env
sed -i "s|MAIL_DRIVER=.*|MAIL_DRIVER=log|i"         .env
sed -i "s|REDIS_HOST=.*|REDIS_HOST=redis|i"         .env

# Build images for example with Laravel
docker-compose build

docker-compose run app composer install
docker-compose run app composer require predis/predis ~1.0

# Setup Laravel Horizon or workers
if [ "$USE_LARAVEL_HORIZON" -eq "1" ]; then
  docker-compose run app composer require laravel/horizon
else
  sed -i "s|horizon.ini|workers.ini|gi" laravel/Dockerfile
fi

docker-compose up -d

# Verifications
sleep 30
docker-compose ps
docker-compose logs

cd ..

curl --retry 10 --retry-delay 5 -I http://127.0.0.1:80/
curl --retry 10 --retry-delay 5 -I http://127.0.0.1:80/socket.io/socket.io.js
curl --retry 10 --retry-delay 5 -I http://127.0.0.1:8080/
