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