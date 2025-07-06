#!/bin/bash

# Script de démarrage pour Railway
echo "🚀 Démarrage de l'application Symfony..."

# Attendre que MySQL soit disponible
echo "📡 Vérification de la connexion MySQL..."
until mysqladmin ping -h"mysql.railway.internal" -P3306 -u"root" -p"JzDmhoZHVbHovzBCcIjoVjUozbIVnlzC" --silent; do
    echo "⏳ En attente de MySQL..."
    sleep 2
done
echo "✅ MySQL disponible !"

# Nettoyer le cache Symfony
echo "🧹 Nettoyage du cache Symfony..."
php bin/console cache:clear --env=prod --no-debug || true

# Gestion intelligente des migrations
echo "🔄 Vérification et synchronisation des migrations..."
# Marquer toutes les migrations comme exécutées si la base existe déjà
if php bin/console doctrine:query:sql "SELECT COUNT(*) FROM user" --env=prod >/dev/null 2>&1; then
    echo "📋 Base de données existante détectée, marquage des migrations comme exécutées..."
    php bin/console doctrine:migrations:version --add --all --no-interaction --env=prod || echo "⚠️  Marquage migrations échoué"
else
    echo "🆕 Nouvelle base de données, exécution des migrations..."
    php bin/console doctrine:migrations:migrate --no-interaction --env=prod || echo "⚠️  Migrations échouées"
fi

# Vérifier que la base est accessible
echo "🔍 Test de connexion à la base de données..."
php bin/console doctrine:database:create --if-not-exists --env=prod || echo "Base déjà créée"

# Warm up du cache
echo "🔥 Préchauffage du cache..."
php bin/console cache:warmup --env=prod || true

# Vérifier les permissions
echo "🔐 Vérification des permissions..."
chown -R www-data:www-data var/ public/ || true
chmod -R 775 var/ public/ || true

# Test de la configuration Symfony
echo "🧪 Test de la configuration Symfony..."
php bin/console debug:router --env=prod | head -10 || echo "⚠️  Routeur non disponible"

echo "🎯 Démarrage d'Apache..."
# Démarrer Apache en foreground
apache2-foreground
