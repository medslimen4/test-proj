FROM composer:2.8.1 as composer_build

WORKDIR /app
COPY . /app
RUN composer install --optimize-autoloader --no-dev --ignore-platform-reqs --no-interaction --no-plugins --no-scripts --prefer-dist

FROM php:8.3.12
COPY --from=composer_build /app/ /app/
WORKDIR /app
CMD php artisan serve --host=0.0.0.0 --port $PORT
EXPOSE $PORT