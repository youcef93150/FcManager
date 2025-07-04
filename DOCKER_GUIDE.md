# 🐳 Guide de Déploiement Docker - Projet PSG

## 📋 Prérequis

### Installation Docker
- **Windows/Mac** : [Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Linux** : Docker Engine + Docker Compose

### Vérification
```bash
docker --version
docker-compose --version
docker info
```

---

## 🚀 Déploiement Rapide

### Option 1 : Script automatique (Windows)
```cmd
docker-deploy.bat
```

### Option 2 : Script automatique (Linux/Mac)
```bash
chmod +x docker-deploy.sh
./docker-deploy.sh
```

### Option 3 : Commandes manuelles
```bash
# 1. Configuration de l'environnement
cp .env.docker .env
# Modifiez .env avec vos mots de passe

# 2. Démarrage
docker-compose -f docker-compose.prod.yml up --build -d

# 3. Migrations
docker-compose -f docker-compose.prod.yml exec backend php bin/console doctrine:migrations:migrate --no-interaction
```

---

## 🔧 Configuration

### Variables d'environnement (.env)
```bash
# Base de données - CHANGEZ CES VALEURS
POSTGRES_DB=psg_app
POSTGRES_USER=app
POSTGRES_PASSWORD=VotreMotDePasseSecurise123!

# Symfony - CHANGEZ CETTE CLÉ
APP_SECRET=VotreCleSecreteSecurise123456789

# CORS - Remplacez par votre domaine
CORS_ALLOW_ORIGIN=http://localhost:3000

# API URL pour le frontend
VITE_API_URL=http://localhost:8000
```

---

## 📊 Services Déployés

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Frontend | http://localhost:3000 | 3000 | Interface Vue.js |
| Backend | http://localhost:8000 | 8000 | API Symfony |
| Database | localhost:5432 | 5432 | PostgreSQL |

---

## 🛠️ Commandes Utiles

### Gestion des conteneurs
```bash
# Voir le statut
docker-compose -f docker-compose.prod.yml ps

# Voir les logs
docker-compose -f docker-compose.prod.yml logs -f

# Redémarrer un service
docker-compose -f docker-compose.prod.yml restart backend

# Arrêter tout
docker-compose -f docker-compose.prod.yml down

# Arrêter et supprimer les volumes
docker-compose -f docker-compose.prod.yml down -v
```

### Accès aux conteneurs
```bash
# Shell dans le backend
docker-compose -f docker-compose.prod.yml exec backend bash

# Shell dans la base de données
docker-compose -f docker-compose.prod.yml exec database psql -U app -d psg_app

# Exécuter des commandes Symfony
docker-compose -f docker-compose.prod.yml exec backend php bin/console cache:clear
```

### Reconstruction
```bash
# Reconstruire une image
docker-compose -f docker-compose.prod.yml build backend

# Reconstruire tout sans cache
docker-compose -f docker-compose.prod.yml build --no-cache

# Reconstruire et redémarrer
docker-compose -f docker-compose.prod.yml up --build -d
```

---

## 🔍 Surveillance et Logs

### Logs en temps réel
```bash
# Tous les services
docker-compose -f docker-compose.prod.yml logs -f

# Service spécifique
docker-compose -f docker-compose.prod.yml logs -f backend

# Dernières lignes
docker-compose -f docker-compose.prod.yml logs --tail=100 backend
```

### Monitoring des ressources
```bash
# Utilisation des ressources
docker stats

# Espace disque
docker system df

# Informations détaillées
docker-compose -f docker-compose.prod.yml top
```

---

## 🐛 Dépannage

### Problèmes courants

**Conteneurs qui ne démarrent pas**
```bash
# Vérifier les logs
docker-compose -f docker-compose.prod.yml logs backend

# Vérifier la configuration
docker-compose -f docker-compose.prod.yml config
```

**Base de données non accessible**
```bash
# Vérifier le statut
docker-compose -f docker-compose.prod.yml exec database pg_isready -U app

# Recréer la base
docker-compose -f docker-compose.prod.yml down -v
docker-compose -f docker-compose.prod.yml up -d database
```

**Erreurs de permissions**
```bash
# Régler les permissions (Linux)
sudo chown -R $USER:$USER .
```

**Port déjà utilisé**
```bash
# Voir qui utilise le port
netstat -tulpn | grep :3000

# Modifier le port dans docker-compose.prod.yml
```

### Nettoyage complet
```bash
# Arrêter et supprimer tout
docker-compose -f docker-compose.prod.yml down -v

# Nettoyer Docker
docker system prune -a

# Supprimer les images
docker rmi $(docker images -q)
```

---

## 🔒 Sécurité Production

### À faire avant la production
- [ ] Changer tous les mots de passe par défaut
- [ ] Générer une nouvelle `APP_SECRET`
- [ ] Configurer HTTPS avec un reverse proxy
- [ ] Fermer les ports non nécessaires
- [ ] Configurer les sauvegardes

### Exemple avec Nginx reverse proxy
```nginx
server {
    listen 80;
    server_name votre-domaine.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    location /api {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## 📦 Sauvegarde et Restauration

### Sauvegarde de la base de données
```bash
# Créer une sauvegarde
docker-compose -f docker-compose.prod.yml exec database pg_dump -U app psg_app > backup.sql

# Ou avec un script automatique
docker-compose -f docker-compose.prod.yml exec database pg_dump -U app psg_app | gzip > backup_$(date +%Y%m%d_%H%M%S).sql.gz
```

### Restauration
```bash
# Restaurer depuis une sauvegarde
docker-compose -f docker-compose.prod.yml exec -T database psql -U app psg_app < backup.sql
```

### Sauvegarde des volumes
```bash
# Sauvegarder les volumes
docker run --rm -v projetfootfinannee-main_database_data:/data -v $(pwd):/backup alpine tar czf /backup/volumes_backup.tar.gz /data
```

---

## 🚀 Mise à jour

### Déploiement d'une nouvelle version
```bash
# 1. Récupérer le nouveau code
git pull origin main

# 2. Reconstruire et redéployer
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d

# 3. Migrations si nécessaire
docker-compose -f docker-compose.prod.yml exec backend php bin/console doctrine:migrations:migrate --no-interaction
```

---

## 📞 Support

- **Logs** : Consultez les logs Docker pour diagnostiquer les problèmes
- **Documentation** : Consultez la documentation Docker et Symfony
- **Monitoring** : Utilisez des outils comme Portainer pour une interface graphique
