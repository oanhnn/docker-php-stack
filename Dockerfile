FROM alpine:3.7

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TIMEZONE="UTC" \
    PHP_MEMORY_LIMIT="512M" \
    MAX_UPLOAD="10M" \
    PHP_MAX_FILE_UPLOAD=20 \
    PHP_MAX_POST="20M"

RUN echo ">>> Install dependencies" \
 && apk add --update \
    ca-certificates \
    curl \
    nginx \
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
 && rm -rf /tmp/* /var/cache/apk/* \
 && echo ">>> Ensure www-data (ID: 82) user and some directories exists" \
 #&& addgroup -g 82 -S www-data \
 && adduser -u 82 -D -S -G www-data www-data \
 && echo ">>> Make symlink to php binary file" \
 && ln -nfs /usr/bin/php7 /usr/bin/php \
 && ln -nfs /usr/sbin/php-fpm7 /usr/sbin/php-fpm \
 && ln -nfs /etc/php7 /etc/php \
 && mkdir -p /var/log/php7 /app/public \
 && echo "<?php phpinfo();" > /app/public/index.php \
 && chown -R www-data:www-data /app \
 && echo ">>> Setting php.ini" \
 && sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php/php.ini \
 && sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php/php.ini \
 && sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php/php.ini \
 && sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php/php.ini \
 && sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php/php.ini \
 && sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo = 0|i" /etc/php/php.ini \
 && echo ">>> Setting supervisord" \
 && mkdir -p /etc/supervisor.d /var/log/supervisord \
 && sed -i "s|;*nodaemon=.*|nodaemon=true|i" /etc/supervisord.conf \
 && sed -i "s|;*pidfile=.*|pidfile=/run/supervisord.pid|i" /etc/supervisord.conf \
 && sed -i "s|;*childlogdir=.*|childlogdir=/var/log/supervisord|i" /etc/supervisord.conf

# Copy config files
COPY php-fpm.conf /etc/php/php-fpm.conf
COPY vhost.conf   /etc/nginx/conf.d/default.conf
COPY supervisor.d /etc/supervisor.d

## Get composer
ONBUILD RUN curl -s https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer \
 && chmod a+x /usr/local/bin/composer

WORKDIR /app

EXPOSE 80

CMD ["supervisord", "--configuration", "/etc/supervisord.conf"]
