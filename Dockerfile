FROM php:fpm

ARG INSTALL_XDEBUG=true
ENV INSTALL_XDEBUG ${INSTALL_XDEBUG}
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pecl install xdebug && \
    docker-php-ext-enable xdebug \
;fi

RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev \
	&& docker-php-ext-install -j$(nproc) iconv \
	&& docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd

RUN apt-get update && apt-get install -y libz-dev libmemcached-dev libjpeg-dev libonig-dev zlib1g-dev g++ libpng-dev libxml2-dev libicu-dev libcurl4-gnutls-dev libzip-dev libzip4 \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install pdo pdo_mysql mysqli opcache \
    && docker-php-ext-enable pdo pdo_mysql mysqli opcache \
    && docker-php-ext-install mbstring bcmath json curl \
    && docker-php-ext-enable mbstring bcmath json curl \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

RUN brew install oniguruma

RUN pecl install apcu \
    && docker-php-ext-enable apcu

RUN apt-get update -y \
    && apt-get install -y libmcrypt-dev \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt

RUN docker-php-ext-install zip \
    && docker-php-ext-enable zip
RUN apt-get update \
    && apt-get install -y composer \
    && apt-get install -y git \
    && apt-get install -y nano \
    && apt-get install -y sudo \
    && apt-get install -y wget 

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
