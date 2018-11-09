#========================
# Build backend source
#========================
FROM composer as vendor

WORKDIR /var/www/html

COPY composer.json composer.lock /var/www/html/
RUN composer install  \
    --ignore-platform-reqs \
    --no-autoloader \
    --no-dev \
    --no-interaction \
    --no-progress \
    --no-suggest \
    --no-scripts \
    --prefer-dist

COPY . /var/www/html/
RUN composer dump-autoload --classmap-authoritative --no-dev --optimize

##========================
## Build frontend assets
##========================
#FROM node:10-alpine as frontend
#
#RUN mkdir -p /var/www/html/public/frontend
#
#COPY package.json package-lock.json webpack.mix.js /var/www/html/
#COPY resources /var/www/html/resources
#WORKDIR /var/www/html
#
#RUN yarn install
#RUN npm run production

#========================
# Build app image
#========================
FROM oanhnn/php-stack:latest

COPY --from=vendor /var/www/html /var/www/html
#COPY --from=frontend /var/www/html/public /var/www/html/public

RUN chown -R www-data:www-data /var/www/html

COPY .docker/horizon.ini.default /etc/supervisor.d/horizon.ini.default
COPY .docker/workers.ini.default /etc/supervisor.d/workers.ini.default
COPY .docker/vhost.conf          /etc/nginx/conf.d/default.conf

COPY .docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]
