FROM alpine:3.5

MAINTAINER Nebo#15 support@nebo15.com

RUN apk --update add \
        wget \
        php5 \
        php5-fpm \
        php5-cli \
        php5-pdo \
        php5-zip \
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
    # clear build
    rm -rf /var/cache/apk/* && \
    apk del wget

COPY php.ini /etc/php5/conf.d/50-setting.ini
COPY php-fpm.conf /etc/php5/php-fpm.conf

EXPOSE 9000

CMD ["php-fpm", "-F"]