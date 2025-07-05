# Dockerfile simplifié pour Railway
FROM php:8.2-apache

# Installation des extensions PHP
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

# Configuration Apache simple
RUN a2enmod rewrite headers

# Configuration Apache basique
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html/public\n\
    <Directory /var/www/html/public>\n\
        AllowOverride All\n\
        Require all granted\n\
        DirectoryIndex index.php\n\
        <IfModule mod_rewrite.c>\n\
            RewriteEngine On\n\
            RewriteCond %{REQUEST_FILENAME} !-f\n\
            RewriteCond %{REQUEST_FILENAME} !-d\n\
            RewriteRule ^(.*)$ index.php [QSA,L]\n\
        </IfModule>\n\
    </Directory>\n\
    ErrorLog ${APACHE_LOG_DIR}/error.log\n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Répertoire de travail
WORKDIR /var/www/html

# Copier composer files
COPY composer*.json ./

# Installer dépendances PHP
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copier le code
COPY . .

# Permissions
RUN mkdir -p var/cache var/log \
    && chown -R www-data:www-data var/ \
    && chmod -R 775 var/ \
    && chown -R www-data:www-data public/

# Nettoyer le cache Symfony
RUN php bin/console cache:clear --env=prod --no-debug || true \
    && composer dump-autoload --optimize

# Exposer le port
EXPOSE 80

# Démarrer Apache directement
CMD ["apache2-foreground"]
