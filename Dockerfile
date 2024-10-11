# Composer Stage
FROM composer:2.8.1 as composer_build

WORKDIR /app
COPY . /app
RUN composer install --optimize-autoloader --no-dev --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist

# PHP Stage
FROM php:8.3.12

# Install required PHP extensions (add more as needed)
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer_build /app/ /app/
WORKDIR /app

# Set the environment variable for the port
ENV PORT 8000  
#Change this if needed

# Start the Laravel server
CMD php artisan serve --host=0.0.0.0 --port=$PORT
EXPOSE $PORT
