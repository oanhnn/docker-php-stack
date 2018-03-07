FROM alpine:3.7

LABEL maintainer="OanhNguyen <oanhnn.bk@gmail.com>"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TIMEZONE="UTC"

### Install dependencies
RUN apk add --update \
    ca-certificates \
    curl \
    nginx \
    openssl \
    php7 \
    php7-bcmath \
    php7-dom \
    php7-ctype \
    php7-curl \
    php7-fileinfo \
    php7-fpm \
    php7-gd \
    php7-iconv \
    php7-imagick \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-mcrypt \
    php7-mysqlnd \
    php7-opcache \
    php7-openssl \
    php7-pcntl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-phar \
    php7-posix \
    php7-redis \
    php7-session \
    php7-simplexml \
    php7-soap \
    php7-tokenizer \
    php7-xdebug \
    php7-xmlwriter \
    php7-xml \
    php7-zip \
    php7-zlib \
    supervisor \
 && rm -rf /tmp/* /var/cache/apk/*

### Install dockerize
### See https://github.com/jwilder/dockerize
ENV DOCKERIZE_VERSION="v0.6.0"
RUN wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
 && rm dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz

### Install composer
### See https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -s https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer \
 && chmod a+x /usr/local/bin/composer

### Ensure www-data (ID: 82) user and make webroot directory
RUN egrep -i "^www-data" /etc/group  || addgroup -g 82 -S www-data \
 && egrep -i "^www-data" /etc/passwd || adduser -u 82 -D -S -G www-data www-data \
 && mkdir -p /app/public \
 && echo "<?php phpinfo();" > /app/public/index.php \
 && chown -R www-data:www-data /app \

#RUN ln -nfs /usr/bin/php7 /usr/bin/php \
# && ln -nfs /usr/sbin/php-fpm7 /usr/sbin/php-fpm \
# && ln -nfs /etc/php7 /etc/php \
# && mkdir -p /var/log/php7

### Setting up for PHP
ENV PHP_MEMORY_LIMIT="512M" \
    PHP_UPLOAD_MAX_FILESIZE="10M" \
    PHP_MAX_FILE_UPLOAD="20" \
    PHP_POST_MAX_SIZE="20M"
RUN sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini \
 && sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini \
 && sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}|i" /etc/php7/php.ini \
 && sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini \
 && sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_POST_MAX_SIZE}|i" /etc/php7/php.ini \
 && sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo = 0|i" /etc/php7/php.ini

### Setting supervisord
RUN mkdir -p /etc/supervisor.d /var/log/supervisord \
 && sed -i "s|;*nodaemon=.*|nodaemon=true|i" /etc/supervisord.conf \
 && sed -i "s|;*pidfile=.*|pidfile=/run/supervisord.pid|i" /etc/supervisord.conf \
 && sed -i "s|;*childlogdir=.*|childlogdir=/var/log/supervisord|i" /etc/supervisord.conf

#### Copy config files
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY vhost.conf   /etc/nginx/conf.d/default.conf
COPY supervisor.d /etc/supervisor.d

VOLUME /app /var/log

WORKDIR /app

EXPOSE 80

CMD dockerize \
    -stdout /var/log/nginx/access.log \
    -stderr /var/log/nginx/error.log \
    -stderr /var/log/php7/fpm-error.log \
    supervisord -c /etc/supervisord.conf
