#!/bin/bash
set -e

echo "🚀 Démarrage simplifié Symfony Railway..."

# Variables d'environnement importantes
export APP_ENV=prod
export APP_DEBUG=0

# Configuration du port Railway
PORT=${PORT:-80}
echo "🔌 Port configuré: $PORT"

# Configurer Apache pour le bon port
sed -i "s/\${PORT}/$PORT/g" /etc/apache2/sites-available/000-default.conf
echo "Listen $PORT" > /etc/apache2/ports.conf

# Attendre MySQL
echo "📡 Vérification MySQL..."
until mysqladmin ping -h"mysql.railway.internal" -P3306 -u"root" -p"JzDmhoZHVbHovzBCcIjoVjUozbIVnlzC" --silent; do
    sleep 2
done
echo "✅ MySQL OK"

# Gestion intelligente des migrations - approche alternative
echo "🔄 Gestion des migrations..."
if php bin/console doctrine:query:sql "SELECT COUNT(*) FROM user LIMIT 1" --env=prod >/dev/null 2>&1; then
    echo "📋 Tables existantes - marquage migrations"
    # Marquer toutes les migrations comme exécutées
    for migration in $(find migrations/ -name "*.php" | sed 's/migrations\///g' | sed 's/\.php//g'); do
        php bin/console doctrine:migrations:version --add $migration --no-interaction --env=prod 2>/dev/null || true
    done
else
    echo "🆕 Exécution migrations normales"
    php bin/console doctrine:migrations:migrate --no-interaction --env=prod || true
fi

# Cache et permissions
echo "🧹 Cache..."
php bin/console cache:clear --env=prod --no-debug 2>/dev/null || true
php bin/console cache:warmup --env=prod 2>/dev/null || true

echo "🔐 Permissions..."
chown -R www-data:www-data var/ public/ 2>/dev/null || true
chmod -R 775 var/ public/ 2>/dev/null || true

echo "🎯 Démarrage Apache..."
echo "🔍 Configuration Apache:"
echo "Port: $PORT"
echo "DocumentRoot: /var/www/html/public"

# Vérifier que les fichiers existent
if [ ! -f "/var/www/html/public/index.php" ]; then
    echo "❌ ERREUR: index.php non trouvé!"
    ls -la /var/www/html/public/
    exit 1
fi

# Test de syntaxe PHP
echo "🧪 Test syntaxe PHP..."
php -l /var/www/html/public/index.php || exit 1

# Démarrer Apache
echo "🚀 Lancement Apache sur port $PORT..."
exec apache2-foreground
