#!/bin/bash

# Script de déploiement automatique pour VPS
# Utilisation: ./deploy.sh

set -e

echo "🚀 Début du déploiement du projet PSG..."

# Variables
PROJECT_DIR="/var/www/psg-project"
NGINX_CONF="/etc/nginx/sites-available/psg-project"
PHP_VERSION="8.2"

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction de logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Vérification des prérequis
check_requirements() {
    log "Vérification des prérequis..."
    
    command -v php >/dev/null 2>&1 || error "PHP n'est pas installé"
    command -v composer >/dev/null 2>&1 || error "Composer n'est pas installé"
    command -v node >/dev/null 2>&1 || error "Node.js n'est pas installé"
    command -v npm >/dev/null 2>&1 || error "NPM n'est pas installé"
    command -v nginx >/dev/null 2>&1 || error "Nginx n'est pas installé"
    command -v psql >/dev/null 2>&1 || error "PostgreSQL client n'est pas installé"
    
    log "Tous les prérequis sont satisfaits ✓"
}

# Installation des dépendances système
install_dependencies() {
    log "Installation des dépendances système..."
    
    sudo apt update
    sudo apt install -y php${PHP_VERSION} php${PHP_VERSION}-fpm php${PHP_VERSION}-pgsql \
                        php${PHP_VERSION}-mbstring php${PHP_VERSION}-xml php${PHP_VERSION}-zip \
                        php${PHP_VERSION}-curl php${PHP_VERSION}-intl postgresql \
                        postgresql-contrib nginx nodejs npm git curl unzip
    
    # Installation de Composer si pas présent
    if ! command -v composer >/dev/null 2>&1; then
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
        sudo chmod +x /usr/local/bin/composer
    fi
    
    log "Dépendances installées ✓"
}

# Création du répertoire projet
setup_project_directory() {
    log "Configuration du répertoire projet..."
    
    sudo mkdir -p $PROJECT_DIR
    sudo chown -R $USER:www-data $PROJECT_DIR
    sudo chmod -R 755 $PROJECT_DIR
    
    log "Répertoire projet configuré ✓"
}

# Déploiement du code
deploy_code() {
    log "Déploiement du code..."
    
    # Si c'est un premier déploiement, cloner le repo
    if [ ! -d "$PROJECT_DIR/.git" ]; then
        info "Premier déploiement - clonage du repository..."
        read -p "URL du repository Git: " REPO_URL
        git clone $REPO_URL $PROJECT_DIR
    else
        info "Mise à jour du code existant..."
        cd $PROJECT_DIR
        git pull origin main
    fi
    
    log "Code déployé ✓"
}

# Configuration du backend Symfony
setup_backend() {
    log "Configuration du backend Symfony..."
    
    cd $PROJECT_DIR/Symfony_Projet
    
    # Installation des dépendances Composer
    composer install --no-dev --optimize-autoloader
    
    # Configuration de l'environnement
    if [ ! -f .env.local ]; then
        cp ../.env.production .env.local
        warning "Fichier .env.local créé. Veuillez le configurer avec vos variables d'environnement."
    fi
    
    # Permissions
    sudo chown -R www-data:www-data var/
    sudo chmod -R 775 var/
    
    # Migrations de base de données
    read -p "Exécuter les migrations de base de données? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        php bin/console doctrine:migrations:migrate --no-interaction
    fi
    
    log "Backend Symfony configuré ✓"
}

# Configuration du frontend Vue.js
setup_frontend() {
    log "Configuration du frontend Vue.js..."
    
    cd $PROJECT_DIR/VueFront
    
    # Installation des dépendances
    npm ci --only=production
    
    # Build de production
    npm run build
    
    log "Frontend Vue.js configuré ✓"
}

# Configuration de Nginx
setup_nginx() {
    log "Configuration de Nginx..."
    
    # Copie de la configuration Nginx
    sudo cp $PROJECT_DIR/nginx-vps.conf $NGINX_CONF
    
    # Modification du nom de domaine
    read -p "Nom de domaine (ex: psg.example.com): " DOMAIN_NAME
    sudo sed -i "s/your-domain.com/$DOMAIN_NAME/g" $NGINX_CONF
    
    # Activation du site
    sudo ln -sf $NGINX_CONF /etc/nginx/sites-enabled/
    
    # Test de la configuration
    sudo nginx -t || error "Erreur dans la configuration Nginx"
    
    # Redémarrage de Nginx
    sudo systemctl reload nginx
    
    log "Nginx configuré ✓"
}

# Configuration de PHP-FPM
setup_php_fpm() {
    log "Configuration de PHP-FPM..."
    
    # Redémarrage de PHP-FPM
    sudo systemctl restart php${PHP_VERSION}-fpm
    sudo systemctl enable php${PHP_VERSION}-fpm
    
    log "PHP-FPM configuré ✓"
}

# Configuration SSL avec Let's Encrypt (optionnel)
setup_ssl() {
    read -p "Configurer SSL avec Let's Encrypt? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log "Configuration SSL..."
        
        # Installation de Certbot
        sudo apt install -y certbot python3-certbot-nginx
        
        # Obtention du certificat
        sudo certbot --nginx -d $DOMAIN_NAME
        
        log "SSL configuré ✓"
    fi
}

# Vérification finale
final_check() {
    log "Vérification finale..."
    
    # Test des services
    sudo systemctl is-active --quiet nginx || error "Nginx n'est pas actif"
    sudo systemctl is-active --quiet php${PHP_VERSION}-fpm || error "PHP-FPM n'est pas actif"
    
    info "🎉 Déploiement terminé avec succès!"
    info "Votre application est maintenant disponible sur http://$DOMAIN_NAME"
    
    warning "N'oubliez pas de:"
    warning "- Configurer votre base de données dans .env.local"
    warning "- Vérifier les permissions des fichiers"
    warning "- Configurer les sauvegardes automatiques"
    warning "- Mettre en place un monitoring"
}

# Menu principal
main() {
    echo "=========================================="
    echo "🚀 Script de déploiement PSG Project"
    echo "=========================================="
    
    check_requirements
    
    echo "Choisissez une option:"
    echo "1) Déploiement complet (nouveau serveur)"
    echo "2) Mise à jour du code uniquement"
    echo "3) Reconfigurer Nginx"
    echo "4) Redémarrer les services"
    echo "5) Quitter"
    
    read -p "Votre choix [1-5]: " choice
    
    case $choice in
        1)
            install_dependencies
            setup_project_directory
            deploy_code
            setup_backend
            setup_frontend
            setup_nginx
            setup_php_fpm
            setup_ssl
            final_check
            ;;
        2)
            deploy_code
            setup_backend
            setup_frontend
            sudo systemctl reload nginx
            log "Mise à jour terminée ✓"
            ;;
        3)
            setup_nginx
            log "Nginx reconfiguré ✓"
            ;;
        4)
            sudo systemctl restart nginx php${PHP_VERSION}-fpm
            log "Services redémarrés ✓"
            ;;
        5)
            exit 0
            ;;
        *)
            error "Option invalide"
            ;;
    esac
}

# Exécution du script principal
main
