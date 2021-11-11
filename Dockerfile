ARG PHP_VERSION="7.4"


FROM php:${PHP_VERSION}-fpm-alpine3.12

ARG COMPOSER_VERSION="1.10.16"
ENV COMPOSER_MEMORY_LIMIT=-1

# Returns an error code even when any command in a pipe command chain fails
# For details, please see https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apk add --update --no-cache make \ 
    && chmod +x /usr/local/bin/install-php-extensions \
    && sync  \
    && install-php-extensions pdo_mysql intl zip bcmath redis apcu \
    && docker-php-ext-enable opcache

RUN apk add --no-cache --virtual composer-deps curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version="${COMPOSER_VERSION}" \
    && composer global require hirak/prestissimo --no-plugins --no-scripts --no-cache \
    && apk del composer-deps \
    && apk add --no-cache npm \
    && apk add --no-cache yarn \
    && apk add --no-cache git

CMD [ "php-fpm", "--nodaemonize" ]

