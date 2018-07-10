#!/usr/bin/env bash

mkdir laravel

# Create Laravel project
docker run --rm -v $(pwd):/app composer create-project --no-dev --prefer-dist laravel/laravel laravel 5.5.*

# Set up docker-compose
sudo chown `id -u`:`id -g` -R laravel/
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
docker-compose build app

docker-compose run --no-deps --rm app composer install --no-dev --prefer-dist
docker-compose run --no-deps --rm app composer require --update-no-dev predis/predis ~1.0

# Setup Laravel Horizon or workers
if [ "$USE_LARAVEL_HORIZON" -eq "1" ]; then
  docker-compose run --no-deps --rm app composer require --update-no-dev laravel/horizon
else
  sed -i "s|horizon.ini|workers.ini|gi" laravel/Dockerfile
fi

docker-compose up -d

# Verifications
sleep 60
docker-compose ps
docker-compose logs

cd ..

curl --retry 10 --retry-delay 5 -I http://127.0.0.1:81/
curl --retry 10 --retry-delay 5 -I http://127.0.0.1:81/socket.io/socket.io.js
curl --retry 10 --retry-delay 5 -I http://127.0.0.1:82/
