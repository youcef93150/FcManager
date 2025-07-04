# Guide de Déploiement - Projet PSG

## 🚀 Options de Déploiement

### Option 1 : Déploiement Simple (Railway/Heroku)
**Frontend** : Netlify/Vercel
**Backend** : Railway/Heroku  
**Base de données** : PostgreSQL hébergé

### Option 2 : Déploiement avec Docker
**Plateforme** : DigitalOcean, AWS, Google Cloud
**Conteneurs** : Docker + Docker Compose

### Option 3 : Déploiement VPS
**Serveur** : VPS Linux (Ubuntu/Debian)
**Reverse Proxy** : Nginx

---

## 📋 Prérequis

- Compte GitHub (pour le code source)
- Compte sur une plateforme cloud (Railway, Netlify, etc.)
- Variables d'environnement configurées

---

## 🌟 Option 1 : Déploiement Rapide (Recommandé)

### Frontend (Netlify)
1. Connectez votre dépôt GitHub à Netlify
2. Configuration de build :
   - **Build command** : `cd VueFront && npm install && npm run build`
   - **Publish directory** : `VueFront/dist`
   - **Base directory** : `.`

### Backend (Railway)
1. Connectez votre dépôt GitHub à Railway
2. Configuration :
   - **Root directory** : `Symfony_Projet`
   - **Build command** : `composer install --no-dev --optimize-autoloader`
   - **Start command** : `php public/index.php`

### Variables d'environnement Railway :
```
APP_ENV=prod
APP_SECRET=your-secret-key
DATABASE_URL=postgresql://username:password@host:5432/dbname
CORS_ALLOW_ORIGIN=https://your-frontend-url.netlify.app
```

---

## 🐳 Option 2 : Déploiement Docker

Utilisez les fichiers Docker fournis dans ce projet.

### Commandes :
```bash
# Build et démarrage
docker-compose up --build -d

# Migrations
docker-compose exec web php bin/console doctrine:migrations:migrate

# Arrêt
docker-compose down
```

---

## 🔧 Option 3 : VPS Linux

### Installation serveur :
```bash
# Installation PHP, Nginx, PostgreSQL
sudo apt update && sudo apt install php8.2 php8.2-fpm nginx postgresql nodejs npm

# Clone du projet
git clone your-repo.git
cd your-project

# Installation dependencies
cd Symfony_Projet && composer install --no-dev
cd ../VueFront && npm install && npm run build
```

### Configuration Nginx :
Voir le fichier `nginx.conf` fourni.

---

## 🔒 Sécurité Production

- [ ] Changer `APP_SECRET`
- [ ] Configurer HTTPS (Let's Encrypt)  
- [ ] Variables d'environnement sécurisées
- [ ] Firewall configuré
- [ ] Sauvegardes automatiques

---

## 📞 Support

Pour toute question sur le déploiement, consultez les logs ou contactez l'équipe de développement.
