# Image oanhnn/php-stack:build only be used for test build image with travis
# Please use image oanhnn/php-stack:latest in your project
FROM oanhnn/php-stack:latest

### Install composer
### See https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/root
RUN curl -s https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer \
 && chmod a+x /usr/local/bin/composer

### Install nodejs, npm, yarn
RUN apk add --update --no-cache \
    nodejs \
    nodejs-npm yarn

### Install laravel-echo-server
RUN apk add --update --no-cache sqlite wget openssl \
 && apk add --update --no-cache --virtual .build-deps \
        binutils-gold \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python \
 && yarn global add --prod --no-lockfile laravel-echo-server \
 && apk del .build-deps \
 && yarn cache clean

### Setting crond for laravel scheduler
RUN echo -e "* * * * * php /app/artisan schedule:run > /dev/null 2>&1" | crontab -u www-data -

COPY laravel-echo.ini /etc/supervisor.d/laravel-echo.ini
COPY laravel-horizon.ini /etc/supervisor.d/laravel-horizon.ini
#COPY laravel-workers.ini /etc/supervisor.d/laravel-workers.ini

EXPOSE 80 6001
