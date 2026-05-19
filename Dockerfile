FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    git unzip zip curl \
    libicu-dev libpq-dev \
    libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
      bcmath intl gd pdo_pgsql pgsql zip opcache

RUN a2enmod rewrite headers

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Drupal installeren via Composer
RUN composer create-project drupal/recommended-project .