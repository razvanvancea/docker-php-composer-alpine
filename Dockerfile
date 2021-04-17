FROM alpine

MAINTAINER Razvan Vancea <razvanvancea94@gmail.com>

RUN apk update && apk upgrade
RUN apk add nginx
RUN apk add php7 php7-fpm php7-opcache
RUN apk add php7-gd php7-curl php7-zlib curl wget git php7-openssl php7-mbstring php7-json php7-phar

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN mkdir -p /var/www

WORKDIR /var/www

COPY . /var/www

VOLUME /var/www

CMD ["/bin/sh"]

ENTRYPOINT ["/bin/sh", "-c"]
