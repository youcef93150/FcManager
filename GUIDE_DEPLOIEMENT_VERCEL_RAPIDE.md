# 🚀 GUIDE DÉPLOIEMENT VERCEL - ÉTAPES RAPIDES

## 🎯 Étapes pour déployer sur Vercel

### 1️⃣ **Préparer le code** ✅
- Code prêt et committé sur GitHub
- Configuration API pointant vers Railway
- Variables d'environnement configurées

### 2️⃣ **Créer le projet Vercel**

1. **Aller sur** : https://vercel.com
2. **Se connecter** avec votre compte GitHub
3. **Cliquer** : "Add New" → "Project"
4. **Importer** votre repository GitHub PSG

### 3️⃣ **Configuration du projet**

**Paramètres à configurer :**
- **Project Name** : `psg-application`
- **Framework Preset** : Vue.js
- **Root Directory** : `VueFront`
- **Build Command** : `npm run build`
- **Output Directory** : `dist`
- **Install Command** : `npm ci`

### 4️⃣ **Variables d'environnement**

**Ajouter ces variables :**
```
VITE_API_URL=https://fcmanager-production.up.railway.app
NODE_ENV=production
VITE_APP_NAME=PSG Application
VITE_APP_VERSION=1.0.0
```

### 5️⃣ **Déployer**

1. **Cliquer** : "Deploy"
2. **Attendre** le build (2-3 minutes)
3. **Récupérer** l'URL de déploiement

### 6️⃣ **Tester l'application**

**URLs à tester :**
- Frontend : `https://votre-app.vercel.app`
- API Test : Ouvrir les outils de développement et vérifier les appels API

## 🔧 Configuration avancée (optionnel)

### Domains personnalisés
- Aller dans Settings → Domains
- Ajouter votre domaine personnalisé

### Build Settings
- Aller dans Settings → Build & Development Settings
- Modifier si nécessaire les commandes de build

## 🚨 Résolution de problèmes

### Si le build échoue :
1. Vérifier les dépendances dans `package.json`
2. Vérifier les variables d'environnement
3. Consulter les logs de build

### Si l'API ne répond pas :
1. Vérifier que Railway est démarré
2. Tester l'URL Railway directement
3. Vérifier les variables d'environnement

## 📱 Résultat attendu

Après déploiement, vous devriez avoir :
- ✅ Frontend accessible sur Vercel
- ✅ Connexion à l'API Railway
- ✅ Interface utilisateur fonctionnelle
- ✅ Responsive design

---

## 🎯 COMMANDES RAPIDES

### Tester l'API Railway :
```bash
# Test simple
Invoke-WebRequest -Uri "https://fcmanager-production.up.railway.app/api/actualites"

# Test avec browser
start "https://fcmanager-production.up.railway.app/api/actualites"
```

### Forcer un redéploiement Vercel :
```bash
# Si vous avez Vercel CLI installé
vercel --prod

# Sinon, push sur GitHub pour déclencher un nouveau déploiement
git add .
git commit -m "Trigger Vercel redeploy"
git push
```

---

**🚀 PRÊT POUR LE DÉPLOIEMENT VERCEL !**
