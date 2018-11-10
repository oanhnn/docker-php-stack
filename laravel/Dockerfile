#========================
# Build backend source
#========================
FROM composer as source

WORKDIR /var/www/html

RUN rm -rf ./* \
 && composer create-project laravel/laravel . \
    --ignore-platform-reqs \
    --no-dev \
    --no-interaction \
    --no-progress \
    --prefer-dist \
    --stability stable \
 && composer require predis/predis \
    --ignore-platform-reqs \
    --update-no-dev

#========================
# Build app image
#========================
FROM oanhnn/php-stack:latest

COPY --from=source /var/www/html /var/www/html

RUN chown -R www-data:www-data /var/www/html

COPY horizon.ini.default /etc/supervisor.d/horizon.ini.default
COPY workers.ini.default /etc/supervisor.d/workers.ini.default
COPY vhost.conf          /etc/nginx/conf.d/default.conf
COPY cronjobs.conf       /etc/www-data-cronjobs

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

CMD supervisord -n -c /etc/supervisord.conf
