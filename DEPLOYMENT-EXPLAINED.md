# 🚀 DÉPLOIEMENT DOCKER - APPLICATION PSG

## 📌 CE QUE PERMET CE DÉPLOIEMENT

### 🎯 **Architecture Complète Conteneurisée**
Votre application PSG est maintenant déployée dans un environnement Docker complet avec :

- **Frontend Vue.js** (port 3000) - Interface utilisateur moderne
- **Backend Symfony** (port 8000) - API REST robuste  
- **Base de données MySQL** (port 3306) - Stockage des données PSG
- **Reverse Proxy Nginx** - Distribution optimisée du frontend
- **Serveur Apache** - Hébergement optimisé du backend PHP

### ✅ **Avantages de ce Déploiement**

#### 🔒 **Isolation Complète**
- **Aucun conflit** avec votre système Windows local
- **Aucune installation requise** de PHP, Node.js, MySQL sur votre machine
- **Environnement propre** et reproductible

#### 🌐 **Production-Ready**
- **Configuration optimisée** pour de bonnes performances
- **Variables d'environnement** séparées pour la production
- **Base de données dédiée** avec vos données PSG
- **Logs centralisés** pour le monitoring

#### 🚀 **Facilité d'Utilisation**
- **1 clic** pour démarrer toute l'application (`start-psg-app.bat`)
- **1 clic** pour arrêter proprement (`stop-psg-app.bat`)
- **Tests automatiques** de santé des services (`test-psg-app.bat`)

#### 🔧 **Maintenance Simplifiée**
- **Mises à jour isolées** par service
- **Sauvegarde facile** de la base de données
- **Scalabilité** : possibilité d'ajouter facilement de nouveaux services

---

## 🌐 **SERVICES ACCESSIBLES**

| Service | URL | Description | Statut |
|---------|-----|-------------|---------|
| **Frontend Vue.js** | http://localhost:3000 | Interface utilisateur principale | ✅ Actif |
| **API Symfony** | http://localhost:8000/api | Documentation API interactive | ✅ Actif |
| **Base MySQL** | localhost:3306 | Base `vue_psg` (user: root) | ✅ Actif |

---

## 💾 **DONNÉES ET PERSISTANCE**

### 🗄️ **Base de Données**
- **Nom** : `vue_psg`
- **Type** : MySQL 8.0
- **Persistance** : Les données sont sauvegardées dans un volume Docker
- **Accès** : `mysql -h localhost -P 3306 -u root vue_psg`

### 📁 **Données CSV Intégrées**
Vos fichiers de données sont automatiquement accessibles :
- `classement_ligue_1.csv`
- `french_germany.csv` 
- `goalscorers.csv`
- `results.csv`
- `shootouts.csv`

---

## 🛠️ **OPÉRATIONS QUOTIDIENNES**

### 🚀 **Démarrage**
```batch
# Double-clic ou depuis PowerShell :
.\start-psg-app.bat
```

### 🛑 **Arrêt**
```batch
.\stop-psg-app.bat
```

### 🔍 **Tests de Santé**
```batch
.\test-psg-app.bat
```

### 📊 **Surveillance**
```bash
# Voir tous les logs en temps réel
docker-compose -f docker-compose.prod.yml logs -f

# Statut des services
docker-compose -f docker-compose.prod.yml ps

# Logs d'un service spécifique
docker-compose -f docker-compose.prod.yml logs frontend
docker-compose -f docker-compose.prod.yml logs backend
docker-compose -f docker-compose.prod.yml logs database
```

---

## 🔧 **CONFIGURATION**

### 📝 **Variables d'Environnement**
- **`.env`** : Configuration locale de développement
- **`.env.docker`** : Configuration pour le déploiement Docker

### 🐳 **Services Docker**
- **`docker-compose.prod.yml`** : Orchestration de tous les services
- **Images customisées** pour le frontend et backend
- **Réseau Docker interne** pour la communication entre services

---

## 🎯 **CAS D'USAGE**

### 👨‍💻 **Développement**
- Environnement de développement complet sans installations locales
- Tests d'intégration avec base de données réelle
- Débogage facilité avec logs centralisés

### 🌐 **Démonstration**
- Présentation de l'application à des clients/collègues
- Environnement stable et reproductible
- Données PSG réelles pour des démos crédibles

### 🚀 **Pré-Production**
- Test de l'application dans un environnement proche de la production
- Validation des performances et de la stabilité
- Tests de charge sur l'ensemble de la stack

### 🔒 **Sécurité**
- Isolation complète des services
- Pas d'exposition des ports internes
- Variables d'environnement sécurisées

---

## 🆘 **DÉPANNAGE RAPIDE**

### ❌ **Service inaccessible**
```bash
# Redémarrer un service spécifique
docker-compose -f docker-compose.prod.yml restart frontend
docker-compose -f docker-compose.prod.yml restart backend
docker-compose -f docker-compose.prod.yml restart database
```

### 🔄 **Reconstruction complète**
```bash
# Arrêt et reconstruction
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.prod.yml up -d
```

### 🗄️ **Accès base de données**
```bash
# Entrer dans le conteneur MySQL
docker exec -it projetfootfinann-e-main-database-1 mysql -u root vue_psg

# Backup de la base
docker exec projetfootfinann-e-main-database-1 mysqldump -u root vue_psg > backup_psg.sql
```

---

## 🏆 **RÉSUMÉ**

✅ **Votre application PSG est maintenant :**
- **Complètement conteneurisée** et isolée
- **Prête pour la production** avec une configuration optimisée
- **Facile à maintenir** avec des scripts automatisés
- **Évolutive** pour de futures améliorations
- **Portable** : fonctionne sur n'importe quel système avec Docker

🎉 **Profitez de votre application PSG professionnelle !**
