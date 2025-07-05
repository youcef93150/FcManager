# 🚀 Déploiement Docker de l'Application PSG

Cette application PSG est un projet full-stack avec **Symfony** (backend) et **Vue.js** (frontend), déployée avec **Docker** et **MySQL**.

## 📋 Prérequis

- **Docker Desktop** installé et en cours d'exécution
- **Git** (si vous clonez le projet)
- **Windows 10/11** (pour les scripts .bat fournis)

## 🎯 Architecture du Déploiement

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   Vue.js        │    │   Symfony       │    │   MySQL         │
│   Port: 3000    │    │   Port: 8000    │    │   Port: 3306    │
│   (Nginx)       │    │   (Apache)      │    │   (vue_psg)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Démarrage Rapide

### Option 1: Script Automatique (Recommandé)
```bash
# Double-cliquez sur le fichier ou exécutez dans PowerShell :
.\start-psg-app.bat
```

### Option 2: Commandes Manuelles
```bash
# Construction et démarrage
docker-compose -f docker-compose.prod.yml up -d --build

# Vérification du statut
docker-compose -f docker-compose.prod.yml ps
```

## 🌐 URLs d'Accès

Une fois démarré, vous pouvez accéder à :

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:3000 | Interface utilisateur Vue.js |
| **Backend** | http://localhost:8000 | API Symfony |
| **API Docs** | http://localhost:8000/api | Documentation API Platform |
| **Database** | localhost:3306 | MySQL (base: `vue_psg`) |

## 🛠️ Gestion de l'Application

### Arrêter l'Application
```bash
# Script automatique
.\stop-psg-app.bat

# Ou manuellement
docker-compose -f docker-compose.prod.yml down
```

### Voir les Logs
```bash
# Tous les services
docker-compose -f docker-compose.prod.yml logs -f

# Service spécifique
docker-compose -f docker-compose.prod.yml logs -f frontend
docker-compose -f docker-compose.prod.yml logs -f backend
docker-compose -f docker-compose.prod.yml logs -f database
```

### Redémarrer un Service
```bash
docker-compose -f docker-compose.prod.yml restart frontend
docker-compose -f docker-compose.prod.yml restart backend
docker-compose -f docker-compose.prod.yml restart database
```

## 🗄️ Accès à la Base de Données

### Via Docker
```bash
# Entrer dans le conteneur MySQL
docker exec -it psg-database mysql -u root vue_psg

# Ou depuis l'extérieur
mysql -h localhost -P 3306 -u root vue_psg
```

### Informations de Connexion
- **Host**: localhost
- **Port**: 3306
- **Base**: vue_psg
- **Utilisateur**: root
- **Mot de passe**: (vide)

## 📁 Structure du Projet

```
projetFootFinAnn-e-main/
├── docker-compose.prod.yml     # Configuration Docker Compose
├── start-psg-app.bat          # Script de démarrage Windows
├── stop-psg-app.bat           # Script d'arrêt Windows
├── .env                       # Variables d'environnement locales
├── .env.docker               # Variables d'environnement Docker
├── VueFront/                 # Application Vue.js
│   ├── Dockerfile           # Image Docker Frontend
│   ├── nginx.conf           # Configuration Nginx
│   └── ...
├── Symfony_Projet/           # Application Symfony
│   ├── Dockerfile           # Image Docker Backend
│   ├── apache-config.conf   # Configuration Apache
│   └── ...
└── data/                     # Données CSV du projet
    ├── classement_ligue_1.csv
    └── ...
```

## 🔧 Configuration

### Variables d'Environnement (.env.docker)
```env
# Base de données
DATABASE_URL=mysql://root:@database:3306/vue_psg
MYSQL_DATABASE=vue_psg
MYSQL_ALLOW_EMPTY_PASSWORD=yes

# Symfony
APP_ENV=prod
APP_SECRET=your-secret-key
```

### Ports Utilisés
- **3000**: Frontend Vue.js (Nginx)
- **8000**: Backend Symfony (Apache)
- **3306**: Base de données MySQL

## 🚨 Dépannage

### Problèmes Courants

1. **Port déjà utilisé**
   ```bash
   # Vérifier les ports utilisés
   netstat -ano | findstr :3000
   netstat -ano | findstr :8000
   netstat -ano | findstr :3306
   ```

2. **Docker non démarré**
   - Démarrez Docker Desktop
   - Attendez que l'icône soit verte

3. **Erreur de construction**
   ```bash
   # Reconstruction complète
   docker-compose -f docker-compose.prod.yml build --no-cache
   ```

4. **Base de données non accessible**
   ```bash
   # Redémarrer le service database
   docker-compose -f docker-compose.prod.yml restart database
   ```

### Commandes de Debug

```bash
# Statut des conteneurs
docker-compose -f docker-compose.prod.yml ps

# Logs détaillés
docker-compose -f docker-compose.prod.yml logs --tail=50

# Espace disque Docker
docker system df

# Nettoyage Docker
docker system prune
```

## 🎉 Avantages du Déploiement Docker

✅ **Isolation Complète** - Aucun conflit avec votre système local
✅ **Reproductibilité** - Même environnement sur toutes les machines
✅ **Facilité de Déploiement** - Un seul script pour tout lancer
✅ **Base de Données Dédiée** - MySQL conteneurisé avec vos données
✅ **Développement Rapide** - Pas d'installation locale requise
✅ **Production-Ready** - Configuration optimisée pour la production

## 📞 Support

En cas de problème, vérifiez :
1. Docker Desktop fonctionne
2. Les ports 3000, 8000, 3306 sont libres
3. Les logs avec `docker-compose logs`

---

**🏆 Profitez de votre application PSG containerisée !**
