FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git unzip zip curl \
        libicu-dev \
        libpq-dev \
        libzip-dev \
        zlib1g-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install \
    bcmath \
    intl \
    gd \
    pdo_pgsql \
    pgsql \
    zip \
    opcache

RUN a2enmod rewrite headers

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

RUN composer create-project drupal/recommended-project .