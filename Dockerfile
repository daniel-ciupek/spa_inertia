FROM php:8.4-fpm-alpine

# 1. Aktualizacja bezpieczeństwa (zawsze na początku)
RUN apk update && apk upgrade --no-cache

# 2. Instalacja zależności systemowych (rzadko się zmieniają - cache'owane)
RUN apk add --no-cache \
    bash git curl zip unzip libpng-dev libxml2-dev \
    oniguruma-dev libzip-dev icu-dev freetype-dev libjpeg-turbo-dev

# 3. Rozszerzenia PHP (budują się raz i zostają w cache)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo_mysql mbstring xml ctype fileinfo bcmath zip intl exif pcntl gd opcache

# 4. Composer (pobierany z obrazu zewnętrznego)
COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

# 5. Konfiguracja użytkownika i katalogu
ARG UID=1000
ARG GID=1000
RUN addgroup -g ${GID} --system laravel \
    && adduser -G laravel --system -D -s /bin/bash -u ${UID} laravel

WORKDIR /var/www/html

# --- KLUCZ DO OPTYMALIZACJI (CACHE) ---

# 6. Kopiujemy TYLKO pliki definicji paczek
COPY composer.json composer.lock ./

# 7. Instalujemy zależności (Docker zapamięta tę warstwę)
# Jeśli nie zmienisz composer.json, ten krok zostanie pominięty przy kolejnym buildzie!
RUN composer install --no-interaction --no-scripts --no-autoloader --prefer-dist

# 8. Dopiero teraz kopiujemy resztę kodu projektu
COPY --chown=laravel:laravel . .

# 9. Kończymy autoloader (teraz ma już dostęp do wszystkich plików)
RUN composer dump-autoload --optimize

# --------------------------------------

# Uprawnienia
RUN chown -R laravel:laravel storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

USER laravel

EXPOSE 9000
CMD ["php-fpm"]