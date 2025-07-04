# 🚀 Guide de Déploiement Étape par Étape

## 📋 Préparation

### 1. Pousser votre code sur GitHub
```bash
git add .
git commit -m "Préparation pour le déploiement"
git push origin main
```

### 2. Préparer les variables d'environnement
- Copier `.env.production` et configurer avec vos vraies valeurs
- Générer un `APP_SECRET` sécurisé : `php bin/console secrets:generate-keys`

---

## 🌟 Option 1 : Déploiement Rapide (Recommandé)

### Backend sur Railway

1. **Créer un compte sur [Railway](https://railway.app)**
2. **Nouveau projet** → **Deploy from GitHub repo**
3. **Sélectionner votre repository**
4. **Configuration :**
   - Root Directory: `Symfony_Projet`
   - Variables d'environnement :
     ```
     APP_ENV=prod
     APP_SECRET=votre-clé-secrète-générée
     DATABASE_URL=${{Postgres.DATABASE_URL}}
     CORS_ALLOW_ORIGIN=https://votre-frontend.netlify.app
     ```
5. **Ajouter PostgreSQL** → Add service → PostgreSQL
6. **Deploy** 🚀

### Frontend sur Netlify

1. **Créer un compte sur [Netlify](https://netlify.com)**
2. **New site from Git** → Sélectionner votre repo
3. **Configuration de build :**
   - Build command: `cd VueFront && npm ci && npm run build`
   - Publish directory: `VueFront/dist`
   - Base directory: `/`
4. **Variables d'environnement :**
   ```
   VITE_API_URL=https://votre-backend.railway.app
   ```
5. **Deploy** 🚀

---

## 🐳 Option 2 : Déploiement Docker

### Prérequis
- Serveur avec Docker installé
- Nom de domaine pointant vers votre serveur

### Commandes
```bash
# Cloner le projet
git clone votre-repo.git
cd votre-projet

# Configurer les variables d'environnement
cp .env.production .env
# Modifier .env avec vos vraies valeurs

# Lancer avec Docker Compose
docker-compose -f docker-compose.prod.yml up --build -d

# Exécuter les migrations
docker-compose -f docker-compose.prod.yml exec backend php bin/console doctrine:migrations:migrate

# Vérifier les logs
docker-compose -f docker-compose.prod.yml logs -f
```

### Nginx reverse proxy (optionnel)
```bash
# Configuration Nginx pour le domaine
sudo cp nginx-vps.conf /etc/nginx/sites-available/psg-project
sudo ln -s /etc/nginx/sites-available/psg-project /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# SSL avec Let's Encrypt
sudo certbot --nginx -d votre-domaine.com
```

---

## 🖥️ Option 3 : VPS Manuel

### Sur Ubuntu/Debian
```bash
# Rendre le script exécutable
chmod +x deploy.sh

# Lancer le déploiement
./deploy.sh
```

Le script vous guidera à travers toutes les étapes.

---

## ✅ Vérifications Post-Déploiement

### Tests fonctionnels
- [ ] Frontend accessible
- [ ] API répond sur `/api/joueurs`
- [ ] Connexion à la base de données
- [ ] Authentification fonctionne
- [ ] CORS configuré correctement

### Sécurité
- [ ] HTTPS activé
- [ ] Variables d'environnement sécurisées
- [ ] Firewall configuré
- [ ] Sauvegardes automatiques

### Performance
- [ ] Compression gzip active
- [ ] Cache des assets configuré
- [ ] Monitoring en place

---

## 🔧 Commandes Utiles

### Symfony (Backend)
```bash
# Vider le cache
php bin/console cache:clear --env=prod

# Migrations
php bin/console doctrine:migrations:migrate

# Vérifier la configuration
php bin/console debug:config

# Logs en temps réel
tail -f var/log/prod.log
```

### Vue.js (Frontend)
```bash
# Build de production
npm run build

# Preview de la build
npm run preview

# Tests
npm run test
```

### Docker
```bash
# Logs du conteneur
docker-compose logs -f [service]

# Shell dans un conteneur
docker-compose exec [service] bash

# Reconstruire un service
docker-compose up --build [service]
```

---

## 🆘 Dépannage

### Erreurs communes

**CORS Error**
- Vérifier `CORS_ALLOW_ORIGIN` dans le backend
- S'assurer que l'URL frontend est exacte

**500 Error**
- Vérifier les logs Symfony : `var/log/prod.log`
- Permissions des fichiers : `chown -R www-data:www-data var/`

**Base de données**
- Vérifier `DATABASE_URL`
- Exécuter les migrations

**Assets non trouvés**
- Vérifier le build frontend : `npm run build`
- Vérifier la configuration Nginx

---

## 📞 Support

- **Logs Backend** : `/var/log/nginx/` et `Symfony_Projet/var/log/`
- **Logs Frontend** : Console du navigateur
- **Monitoring** : Mettre en place des outils comme Sentry

---

## 🔄 Mise à jour

### Mise à jour automatique avec GitHub Actions
```bash
# Créer .github/workflows/deploy.yml pour l'automatisation
```

### Mise à jour manuelle
```bash
git pull origin main
# Backend
cd Symfony_Projet && composer install --no-dev && php bin/console cache:clear
# Frontend  
cd VueFront && npm ci && npm run build
```
