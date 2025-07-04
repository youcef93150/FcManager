#!/bin/bash

# Script de déploiement Docker pour le projet PSG
# Utilisation: ./docker-deploy.sh

set -e

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
check_docker() {
    log "Vérification de Docker..."
    
    if ! command -v docker &> /dev/null; then
        error "Docker n'est pas installé. Installez Docker Desktop depuis https://www.docker.com/products/docker-desktop"
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        error "Docker Compose n'est pas installé."
    fi
    
    if ! docker info &> /dev/null; then
        error "Docker n'est pas démarré. Lancez Docker Desktop."
    fi
    
    log "Docker est prêt ✓"
}

# Configuration de l'environnement
setup_environment() {
    log "Configuration de l'environnement..."
    
    if [ ! -f .env ]; then
        cp .env.docker .env
        warning "Fichier .env créé à partir de .env.docker"
        warning "Veuillez modifier les mots de passe dans .env avant de continuer"
        read -p "Appuyez sur Entrée pour continuer après avoir modifié .env..."
    fi
    
    log "Environnement configuré ✓"
}

# Build et démarrage des conteneurs
start_containers() {
    log "Construction et démarrage des conteneurs..."
    
    # Arrêter les conteneurs existants si ils existent
    docker-compose -f docker-compose.prod.yml down 2>/dev/null || true
    
    # Construire et démarrer
    docker-compose -f docker-compose.prod.yml up --build -d
    
    log "Conteneurs démarrés ✓"
}

# Attendre que la base de données soit prête
wait_for_database() {
    log "Attente de la base de données..."
    
    # Attendre que PostgreSQL soit prêt
    timeout=60
    while ! docker-compose -f docker-compose.prod.yml exec -T database pg_isready -U app -d psg_app &>/dev/null; do
        timeout=$((timeout - 1))
        if [ $timeout -eq 0 ]; then
            error "Timeout: La base de données n'est pas prête"
        fi
        echo -n "."
        sleep 1
    done
    
    log "Base de données prête ✓"
}

# Exécuter les migrations
run_migrations() {
    log "Exécution des migrations..."
    
    # Attendre que le backend soit prêt
    sleep 10
    
    # Exécuter les migrations
    docker-compose -f docker-compose.prod.yml exec backend php bin/console doctrine:migrations:migrate --no-interaction
    
    log "Migrations exécutées ✓"
}

# Vérification du déploiement
verify_deployment() {
    log "Vérification du déploiement..."
    
    # Vérifier que tous les conteneurs sont en cours d'exécution
    if ! docker-compose -f docker-compose.prod.yml ps | grep -q "Up"; then
        error "Certains conteneurs ne sont pas démarrés"
    fi
    
    # Tester l'API
    sleep 5
    if curl -f http://localhost:8000/api >/dev/null 2>&1; then
        log "API accessible ✓"
    else
        warning "API non accessible à http://localhost:8000/api"
    fi
    
    # Tester le frontend
    if curl -f http://localhost:3000 >/dev/null 2>&1; then
        log "Frontend accessible ✓"
    else
        warning "Frontend non accessible à http://localhost:3000"
    fi
    
    log "Vérification terminée ✓"
}

# Affichage des informations finales
show_info() {
    info "🎉 Déploiement Docker terminé avec succès!"
    echo ""
    info "📊 Services disponibles:"
    info "  • Frontend (Vue.js): http://localhost:3000"
    info "  • Backend (Symfony): http://localhost:8000"
    info "  • API: http://localhost:8000/api"
    info "  • Base de données: localhost:5432"
    echo ""
    info "🔧 Commandes utiles:"
    info "  • Voir les logs: docker-compose -f docker-compose.prod.yml logs -f"
    info "  • Arrêter: docker-compose -f docker-compose.prod.yml down"
    info "  • Redémarrer: docker-compose -f docker-compose.prod.yml restart"
    info "  • Shell backend: docker-compose -f docker-compose.prod.yml exec backend bash"
    echo ""
    warning "💡 N'oubliez pas de:"
    warning "  • Modifier les mots de passe dans .env"
    warning "  • Configurer votre domaine pour la production"
    warning "  • Mettre en place des sauvegardes"
}

# Affichage des logs en temps réel
show_logs() {
    log "Affichage des logs (Ctrl+C pour arrêter)..."
    docker-compose -f docker-compose.prod.yml logs -f
}

# Menu principal
main() {
    echo "=========================================="
    echo "🐳 Déploiement Docker - Projet PSG"
    echo "=========================================="
    
    echo "Choisissez une option:"
    echo "1) Déploiement complet (recommandé)"
    echo "2) Démarrer les services existants"
    echo "3) Arrêter les services"
    echo "4) Voir les logs"
    echo "5) Reconstruire les images"
    echo "6) Nettoyer (supprimer tous les conteneurs et volumes)"
    echo "7) Quitter"
    
    read -p "Votre choix [1-7]: " choice
    
    case $choice in
        1)
            check_docker
            setup_environment
            start_containers
            wait_for_database
            run_migrations
            verify_deployment
            show_info
            read -p "Voulez-vous voir les logs en temps réel? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                show_logs
            fi
            ;;
        2)
            check_docker
            docker-compose -f docker-compose.prod.yml up -d
            log "Services démarrés ✓"
            ;;
        3)
            docker-compose -f docker-compose.prod.yml down
            log "Services arrêtés ✓"
            ;;
        4)
            show_logs
            ;;
        5)
            check_docker
            docker-compose -f docker-compose.prod.yml build --no-cache
            docker-compose -f docker-compose.prod.yml up -d
            log "Images reconstruites et services redémarrés ✓"
            ;;
        6)
            warning "Cette action va supprimer tous les conteneurs et volumes (données perdues!)"
            read -p "Êtes-vous sûr? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                docker-compose -f docker-compose.prod.yml down -v
                docker system prune -f
                log "Nettoyage terminé ✓"
            fi
            ;;
        7)
            exit 0
            ;;
        *)
            error "Option invalide"
            ;;
    esac
}

# Gestion des signaux
trap 'echo -e "\n${YELLOW}Arrêt du script...${NC}"; exit 0' INT TERM

# Exécution du script principal
main
