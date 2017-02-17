FROM alpine:3.5

MAINTAINER Nebo#15 support@nebo15.com

RUN apk --update add \
        wget \
        php5 \
        php5-fpm \
        php5-cli \
        php5-pdo \
        php5-zip \
        php5-phar \
        php5-zlib \
        php5-json \
        php5-curl \
        php5-ctype \
        php5-mcrypt \
        php5-openssl \
        php5-imagick && \
    # install Mongo PHP extension
    apk --no-cache add ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-php5-mongo/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-php5-mongo/releases/download/1.16.4-r0/php5-mongo-1.6.14-r0.apk && \
    apk add php5-mongo-1.6.14-r0.apk && \


# install Composer via https://getcomposer.org/download/
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

# clean build
RUN rm -rf /var/cache/apk/* && \
    apk del wget

COPY php.ini /etc/php5/conf.d/50-setting.ini
COPY php-fpm.conf /etc/php5/php-fpm.conf

EXPOSE 9000

CMD ["php-fpm", "-F"]