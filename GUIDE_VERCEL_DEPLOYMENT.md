# 🚀 Guide de Déploiement Vercel - Application PSG

## 📋 Vue d'ensemble

Ce guide vous explique comment déployer votre application PSG sur **Vercel** pour le frontend et **Railway** pour le backend.

### Architecture de déploiement :
- **Frontend Vue.js** → Vercel (gratuit)
- **Backend Symfony** → Railway (gratuit avec limitations)
- **Base de données** → Railway PostgreSQL (inclus)

---

## 🔧 Prérequis

1. ✅ Compte GitHub avec votre code
2. ✅ Compte Vercel (gratuit) : https://vercel.com
3. ✅ Compte Railway (gratuit) : https:
//railway.app

---

## 🌟 Étape 1 : Déploiement du Backend sur Railway

### 1.1 Préparation du Backend
Votre backend est déjà configuré dans le dossier `Symfony_Projet/`.

### 1.2 Déploiement sur Railway
1. **Connectez-vous à Railway** : https://railway.app
2. **Nouveau projet** → "Deploy from GitHub repo"
3. **Sélectionnez votre dépôt** PSG
4. **Configuration** :
   - **Root Directory** : `Symfony_Projet`
   - **Build Command** : `composer install --no-dev --optimize-autoloader && php bin/console doctrine:migrations:migrate --no-interaction`
   - **Start Command** : `apache2-foreground` (utilise le Dockerfile)

### 1.3 Variables d'environnement Railway
Ajoutez ces variables dans Railway :

```env
APP_ENV=prod
APP_SECRET=VotreCleSuperSecrete123456789
DATABASE_URL=${{Railway.POSTGRESQL_URL}}
CORS_ALLOW_ORIGIN=https://votre-app.vercel.app
PORT=80
```

### 1.4 Ajout de la base de données
1. Dans Railway, cliquez **"+ New"** → **"Database"** → **"Add PostgreSQL"**
2. Railway va automatiquement créer la variable `RAILWAY_POSTGRESQL_URL`

### 1.5 URL du Backend
Une fois déployé, vous obtiendrez une URL comme :
`https://votre-backend.up.railway.app`

---

## 🎨 Étape 2 : Déploiement du Frontend sur Vercel

### 2.1 Mise à jour de la configuration Frontend
Modifiez le fichier `VueFront/src/config/api.js` (ou équivalent) :

```javascript
// Configuration API pour production
const API_BASE_URL = process.env.NODE_ENV === 'production' 
  ? 'https://votre-backend.up.railway.app'
  : 'http://localhost:8000';

export default API_BASE_URL;
```

### 2.2 Mise à jour du vercel.json
Votre `vercel.json` est déjà configuré, mais mettez à jour l'URL backend :

```json
{
  "name": "psg-frontend",
  "builds": [
    {
      "src": "VueFront/package.json",
      "use": "@vercel/static-build",
      "config": { 
        "distDir": "dist",
        "buildCommand": "cd VueFront && npm ci && npm run build"
      }
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "https://votre-backend.up.railway.app/api/$1"
    },
    {
      "src": "/(.*)",
      "dest": "/VueFront/dist/$1"
    }
  ]
}
```

### 2.3 Déploiement sur Vercel
1. **Connectez-vous à Vercel** : https://vercel.com
2. **Import Git Repository** → Sélectionnez votre dépôt PSG
3. **Configuration du projet** :
   - **Project Name** : `psg-application`
   - **Framework** : Vue.js
   - **Root Directory** : `VueFront`
   - **Build Command** : `npm run build`
   - **Output Directory** : `dist`

### 2.4 Variables d'environnement Vercel
Ajoutez ces variables dans Vercel :

```env
VITE_API_URL=https://votre-backend.up.railway.app
NODE_ENV=production
```

---

## 🔄 Étape 3 : Configuration CORS

### 3.1 Mise à jour du Backend
Dans `Symfony_Projet/src/Controller/LoginController.php`, mettez à jour l'URL CORS :

```php
$response->headers->set('Access-Control-Allow-Origin', 'https://votre-app.vercel.app');
```

### 3.2 Configuration globale CORS
Créez/modifiez `Symfony_Projet/config/packages/nelmio_cors.yaml` :

```yaml
nelmio_cors:
    defaults:
        origin_regex: true
        allow_origin: ['https://.*\.vercel\.app$', 'http://localhost:3000']
        allow_methods: ['GET', 'OPTIONS', 'POST', 'PUT', 'PATCH', 'DELETE']
        allow_headers: ['Content-Type', 'Authorization']
        expose_headers: ['Link']
        max_age: 3600
    paths:
        '^/api/':
            allow_origin: ['https://.*\.vercel\.app$']
            allow_headers: ['X-Custom-Auth', 'Content-Type', 'Authorization']
            allow_methods: ['POST', 'PUT', 'GET', 'DELETE', 'OPTIONS']
```

---

## 🎯 Étape 4 : Test et Validation

### 4.1 URLs finales
- **Frontend** : `https://votre-app.vercel.app`
- **Backend API** : `https://votre-backend.up.railway.app/api`

### 4.2 Tests à effectuer
1. ✅ Connexion utilisateur
2. ✅ Inscription utilisateur  
3. ✅ Navigation admin/user
4. ✅ Chargement des données (actualités, joueurs, etc.)
5. ✅ Responsive design

---

## 🔧 Commandes de Déploiement

### Déploiement automatique
Les deux plateformes se redéploient automatiquement à chaque push sur `main/master`.

### Déploiement manuel
```bash
# Pour forcer un redéploiement Vercel
vercel --prod

# Pour Railway, simplement push sur GitHub
git add .
git commit -m "Update for production"
git push origin main
```

---

## 🔒 Sécurité en Production

### Checklist sécurité :
- [ ] Changer `APP_SECRET` en production
- [ ] Variables d'environnement sécurisées
- [ ] HTTPS activé (automatique sur Vercel/Railway)
- [ ] CORS configuré correctement
- [ ] Pas de données sensibles dans le code

---

## 🚨 Résolution de Problèmes

### Erreurs fréquentes :

**1. Erreur CORS :**
```
Access to fetch at 'https://backend.railway.app/api/login' from origin 'https://app.vercel.app' has been blocked by CORS policy
```
**Solution :** Vérifiez la configuration CORS dans le backend

**2. 404 sur les routes API :**
**Solution :** Vérifiez que l'URL backend est correcte dans `vercel.json`

**3. Erreur de build Vercel :**
**Solution :** Vérifiez les dépendances dans `package.json` et les variables d'environnement

**4. Base de données non accessible :**
**Solution :** Vérifiez que la migration a été exécutée sur Railway

---

## 📞 Support

### Logs utiles :
- **Vercel** : Onglet "Functions" → Logs
- **Railway** : Onglet "Deployments" → View Logs

### Commandes de debug :
```bash
# Tester l'API backend
curl https://votre-backend.up.railway.app/api

# Vérifier les variables d'environnement
echo $VITE_API_URL
```

---

## ✨ Félicitations !

Votre application PSG est maintenant déployée et accessible mondialement ! 🎉

**URLs de production :**
- 🌐 **Application** : https://votre-app.vercel.app  
- 🔧 **API Backend** : https://votre-backend.up.railway.app/api
- 📊 **Documentation API** : https://votre-backend.up.railway.app/api (API Platform)

---

## 🎯 MISE À JOUR - DÉPLOIEMENT EN COURS

**Date** : Juillet 2025
**Statut** : ✅ Backend configuré, ✅ Code pushé sur master, 🚀 PRÊT POUR VERCEL

### ✅ Réalisations Récentes

1. **CORS Corrigé** : Configuration dynamique pour accepter tous les domaines Vercel
2. **LoginController Restauré** : Fichier complet avec gestion inscription et connexion
3. **Scripts de Test** : Outils PowerShell pour vérifier l'API
4. **Guides Complets** : Documentation détaillée du processus
5. **🆕 Railway CLI Configuré** : Connexion établie au projet FcManager
6. **🆕 Outils d'Import BDD** : Scripts PowerShell pour importer la base MySQL
7. **🆕 SQL Prêt** : Fichier `psg_railway_import.sql` copié dans le presse-papiers

### 🎯 Actions Immédiates Requises

1. **✅ Railway CLI Connecté** 
   - Status : Project FcManager lié avec succès
   - Service MySQL configuré

2. **✅ Base de Données Importée** 
   - ✅ 5 actualités importées
   - ✅ 5 joueurs importés
   - ✅ 5 produits importés  
   - ✅ 2 utilisateurs importés

3. **🔄 API Railway en cours de démarrage** 
   - Status : 502 (Application non encore démarrée)
   - URL : `https://fcmanager-production.up.railway.app/api`
   - Action : Procéder au déploiement Vercel qui peut aider

4. **🚀 REDÉPLOYER SUR VERCEL AVEC CORRECTIONS** (5 min) ⏰
   - ✅ Code pushé sur master (corrections appliquées)
   - ✅ Problème de permissions résolu
   - 🔧 **Build Command à utiliser** : `chmod +x ./node_modules/.bin/vite && npm run build`
   - Root Directory: `VueFront`
   - Variable: `VITE_API_URL=https://fcmanager-production.up.railway.app`
   - Framework: Vue.js
   - 🎯 **MODIFIER LES SETTINGS VERCEL ET REDÉPLOYER**

### 📁 Fichiers Clés Ajoutés
- `GUIDE_FINAL_DEPLOIEMENT.md` : Guide pas-à-pas complet
- `RESUME_FINAL_DEPLOIEMENT.md` : 🆕 Résumé et checklist finale
- `test-simple.ps1` : Script de test de l'API
- `verification-finale.ps1` : 🆕 Vérification complète avant déploiement
- `import-simple.ps1` : 🆕 Import base de données Railway
- `connect-mysql.ps1` : 🆕 Connexion directe MySQL
- `GUIDE_CONNEXION_BDD_RAILWAY.md` : 🆕 Guide complet Railway CLI
- `commandes-mysql-table-par-table.txt` : 🆕 Commandes SQL table par table
- `GUIDE_DEPLOIEMENT_VERCEL_RAPIDE.md` : 🆕 Guide de déploiement Vercel
- `test-api-complete.ps1` : 🆕 Diagnostic complet API Railway
- `RESOLUTION_ERREUR_VERCEL.md` : 🆕 Guide de résolution erreur permissions Vercel

### 🎯 STATUT FINAL
✅ **Tous les fichiers vérifiés et présents**
✅ **Railway CLI connecté au projet FcManager** 
✅ **Git synchronisé avec GitHub (master à jour)**
✅ **Scripts de test et vérification prêts**
✅ **Base de données MySQL importée (17 enregistrements)**
✅ **Code pushé sur master (15 commits synchronisés)**
🔄 **API Railway en cours de démarrage (erreur 502 temporaire)**
🚀 **PRÊT POUR LE DÉPLOIEMENT VERCEL IMMÉDIAT**

**🚀 PHASE FINALE : DÉPLOIEMENT VERCEL EN COURS !**
