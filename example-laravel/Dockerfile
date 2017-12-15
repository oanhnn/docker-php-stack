# Image oanhnn/php-stack:build only be used for test build image with travis
# Please use image oanhnn/php-stack:latest in your project
FROM oanhnn/php-stack:build

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

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
 && echo -e "*\t*\t*\t*\t*\tphp /app/artisan schedule:run > /dev/null 2>&1" | crontab -u www-data -

COPY laravel-echo.ini /etc/supervisor.d/laravel-echo.ini
COPY laravel-horizon.ini /etc/supervisor.d/laravel-horizon.ini
#COPY laravel-workers.ini /etc/supervisor.d/laravel-workers.ini

EXPOSE 80 6001
