FROM php:8.2-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    libonig-dev \
    libicu-dev \
    libxslt1-dev \
    libmcrypt-dev \
    libcurl4-openssl-dev \
    zip \
    git \
    npm \
    unzip \
    libsodium-dev
RUN npm install -g magepack
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    gd \
    intl \
    mbstring \
    opcache \
    pdo_mysql \
    soap \
    xsl \
    zip \
    sockets \
    sodium
#    && pecl install mcrypt-1.0.4 \
#    && docker-php-ext-enable mcrypt

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html

USER www-data

EXPOSE 9000

CMD ["php-fpm"]
