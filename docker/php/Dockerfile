FROM composer AS composer
FROM php:7.1-fpm

RUN apt-get update \
 && apt-get install -y git libmcrypt4 libicu-dev zlib1g-dev freetds-dev\
 && docker-php-ext-install zip \
 && docker-php-ext-install pdo_mysql \
 && docker-php-ext-install intl

RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/
RUN docker-php-ext-install pdo_dblib
RUN pecl install -o -f redis
RUN rm -rf /tmp/pear

RUN docker-php-ext-enable redis \
&& docker-php-ext-enable pdo_dblib

RUN useradd -ms /bin/bash devel
USER devel

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /code
