FROM php:8.3-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip zip curl \
    libicu-dev libpq-dev libzip-dev zlib1g-dev \
    libpng-dev libjpeg-dev libfreetype6-dev \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install bcmath intl gd pdo_pgsql pgsql zip opcache

RUN a2enmod rewrite headers

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

RUN composer create-project drupal/recommended-project .

# 👉 BELANGRIJK: pas NU bestaat /web
RUN chown -R www-data:www-data /var/www/html/
 
ENV APACHE_DOCUMENT_ROOT=/var/www/html/web

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
 /etc/apache2/sites-available/*.conf \
 /etc/apache2/apache2.conf \
 /etc/apache2/conf-available/*.conf

USER www-data

COPY init.sh /init.sh 
ENTRYPOINT ["/init.sh"]
CMD ["apache2-foreground"]