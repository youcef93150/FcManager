# Dockerfile pour le backend Symfony
FROM php:8.2-apache

# Installation des extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    libzip-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install \
    pdo_mysql \
    mysqli \
    zip \
    opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installation de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuration PHP pour la production
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.revalidate_freq=0" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/opcache.ini

# Configuration Apache
RUN a2enmod rewrite headers
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier composer.json et composer.lock
COPY composer*.json ./

# Installer les dépendances
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copier le code source
COPY . .

# Créer le répertoire var et définir les permissions
RUN mkdir -p var/cache var/log \
    && chown -R www-data:www-data var/ \
    && chmod -R 775 var/

# Exposer le port 80
EXPOSE 80

# Démarrer Apache
CMD ["apache2-foreground"]
