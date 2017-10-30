FROM php:7.0-fpm-alpine

MAINTAINER Nebo#15 support@nebo15.com

ENV HOME=/app

RUN apk add --no-cache --virtual .ext-deps \
        libwebp-dev \
        freetype-dev \
        libmcrypt-dev

RUN \
    docker-php-ext-configure mcrypt

RUN \
    apk add --no-cache --virtual .mongodb-ext-build-deps openssl-dev && \
    pecl install mongodb && \
    pecl clear-cache && \
    apk del .mongodb-ext-build-deps

RUN \
    docker-php-ext-install mcrypt && \
    docker-php-ext-enable mongodb.so && \
    docker-php-source delete

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

RUN cd ${HOME}
WORKDIR ${HOME}

# Export PHP-FPM port
EXPOSE 9000

CMD ["php-fpm", "-F"]
