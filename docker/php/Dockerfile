FROM php:7.1-fpm

RUN apt-get update \
 && apt-get install -y git libmcrypt4 libicu-dev zlib1g-dev curl \
 && docker-php-ext-install zip \
 && docker-php-ext-install pdo_mysql \
 && docker-php-ext-install intl \
 && curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /code
