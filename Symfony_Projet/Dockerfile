# Dockerfile propre pour Railway
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

# Configuration Apache
RUN a2enmod rewrite headers

# Configuration Apache via fichier
RUN echo '<VirtualHost *:80>\n\
    ServerName fcmanager-production.up.railway.app\n\
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

# Ajouter ServerName global pour éviter les warnings
RUN echo 'ServerName fcmanager-production.up.railway.app' >> /etc/apache2/apache2.conf

# Répertoire de travail
WORKDIR /var/www/html

# Copier uniquement les fichiers composer
COPY composer.json composer.lock ./

# Supprimer vendor existant et installer proprement
RUN rm -rf vendor/ \
    && composer clear-cache \
    && composer install --no-dev --optimize-autoloader --no-scripts --no-interaction

# Copier le reste du code (sans vendor/)
COPY --chown=www-data:www-data . .

# S'assurer que vendor n'est pas écrasé
RUN rm -rf vendor/ \
    && composer install --no-dev --optimize-autoloader --no-scripts --no-interaction

# Créer dossiers et permissions
RUN mkdir -p var/cache var/log public/uploads \
    && chown -R www-data:www-data var/ public/ \
    && chmod -R 775 var/ public/

# Nettoyer et optimiser
RUN composer dump-autoload --optimize --no-dev \
    && (php bin/console cache:clear --env=prod --no-debug 2>/dev/null || true)

# Copier et rendre exécutable le script de démarrage
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Exposer le port
EXPOSE 80

# Démarrer avec notre script simplifié
CMD ["/startup.sh"]
