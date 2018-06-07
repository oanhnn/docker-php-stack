# oanhnn/docker-php-stack

[![Build Status](https://travis-ci.org/oanhnn/docker-php-stack.svg?branch=master)](https://travis-ci.org/oanhnn/docker-php-stack)

Repository of `oanhnn/php-stack` Docker image.

## Features

- [x] Base from `alpine:3.7` image
- [x] Install supervisor
- [x] Install php-fpm 7.1
- [x] Install nginx
- [x] Install curl

## Requirement
- Docker Engine & Docker Compose

## Usage

Example for a Laravel application

1. Make `Dockerfile`

```docker
# Dockerfile
FROM oanhnn/php-stack:latest

RUN echo ">>> Install nodejs, npm, yarn and laravel-echo-server" \
 && apk add --update \
    nodejs \
    nodejs-npm yarn \
 && apk add --update --no-cache -t .build-deps python make g++ gcc \
 && yarn global add --prod --no-lockfile laravel-echo-server \
 && apk del .build-deps \
 && yarn cache clean \
 && rm -rf /tmp/* /var/cache/apk/* \
 && echo ">>> Setting crond for laravel scheduler" \
 && echo -e "*\t*\t*\t*\t*\tphp /path/to/artisan schedule:run > /dev/null 2>&1" | crontab -u www-data -

COPY laravel-echo.ini /etc/supervisor.d/laravel-echo.ini
COPY laravel-horizon.ini /etc/supervisor.d/laravel-horizon.ini
#COPY laravel-workers.ini /etc/supervisor.d/laravel-workers.ini
```

2. Make some supervisor's program config files

```ini
;; laravel-echo.ini
;; https://github.com/tlaverdure/laravel-echo-server
[program:laravel-echo]
process_name=%(program_name)s
directory=/app
command=/usr/local/bin/laravel-echo-server start
autostart=true
autorestart=true
user=www-data
numprocs=1
redirect_stderr=true
stdout_logfile=/var/log/supervisord/laravel-echo.log
```

```ini
;; laravel-horizon.ini
;; https://laravel.com/docs/5.5/horizon
[program:laravel-horizon]
process_name=%(program_name)s
directory=/app
command=php artisan horizon
autostart=true
autorestart=true
user=www-data
numprocs=1
redirect_stderr=true
stdout_logfile=/var/log/supervisord/laravel-horizon.log
```

> `laravel-wokers.ini` only use when your application dosen't install Laravel Horizon

```ini
;; laravel-workers.ini
;; https://laravel.com/docs/5.5/queues#supervisor-configuration
[program:laravel-worker]
process_name=worker_%(process_num)02d
directory=/app
command=php artisan queue:work redis --sleep=3 --tries=3 --queue=events,notifications,default
autostart=true
autorestart=true
user=www-data
numprocs=5
redirect_stderr=true
stdout_logfile=/var/log/supervisord/laravel-worker.log
```

3. Build and run

## Contributing

All code contributions must go through a pull request and approved by
a core developer before being merged. This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues](https://github.com/oanhnn/docker-php-stack/issues).

## License

This project is released under the MIT License.   
Copyright © 2017 [Oanh Nguyen](https://github.com/oanhnn)   
Please see [License File](https://github.com/oanhnn/docker-php-stack/blob/master/LICENSE) for more information.
