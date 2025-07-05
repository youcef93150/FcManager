# 🚀 Guide Pratique : Déploiement Frontend sur Vercel

## ✅ Étapes de Déploiement

### 1. Préparation du Code
Votre code est déjà prêt avec :
- ✅ Configuration API centralisée (`VueFront/src/config/api.js`)
- ✅ Variables d'environnement (`VueFront/.env.production`)
- ✅ Configuration Vercel (`vercel.json`)
- ✅ CORS corrigé dans le backend

### 2. URL Backend Actuelle
Backend Railway : `https://fcmanager-production.up.railway.app`

### 3. Déploiement sur Vercel

#### Option A : Interface Web Vercel
1. **Allez sur** : https://vercel.com
2. **Connectez-vous** avec GitHub
3. **Cliquez** "New Project"
4. **Importez** votre repository GitHub
5. **Configuration** :
   - **Project Name** : `psg-frontend`
   - **Framework Preset** : `Vue.js`
   - **Root Directory** : `VueFront`
   - **Build Command** : `npm run build`
   - **Output Directory** : `dist`

#### Option B : Ligne de Commande (Recommandé)
```bash
# 1. Installer Vercel CLI
npm i -g vercel

# 2. Se connecter
vercel login

# 3. Déployer depuis le dossier VueFront
cd VueFront
vercel

# 4. Configurer lors du premier déploiement :
# - Set up and deploy "VueFront"? [Y/n] Y
# - Which scope? [votre-compte]
# - Link to existing project? [y/N] N
# - What's your project's name? psg-frontend
# - In which directory is your code located? ./
```

### 4. Variables d'Environnement Vercel
Dans le dashboard Vercel → Settings → Environment Variables :

```env
VITE_API_URL=https://fcmanager-production.up.railway.app
NODE_ENV=production
```

### 5. Configuration Personnalisée
Si besoin, ajustez `vercel.json` à la racine :

```json
{
  "name": "psg-frontend",
  "builds": [
    {
      "src": "VueFront/package.json",
      "use": "@vercel/static-build",
      "config": { 
        "distDir": "dist"
      }
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "https://fcmanager-production.up.railway.app/api/$1"
    },
    {
      "src": "/(.*)",
      "dest": "/VueFront/dist/$1"
    }
  ]
}
```

## 🧪 Test de l'API Backend

Avant de déployer le frontend, testons l'API :

```bash
# Test de base
curl https://fcmanager-production.up.railway.app/api

# Test de connexion
curl -X POST https://fcmanager-production.up.railway.app/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'
```

## 🔧 URLs Finales

Après déploiement, vous aurez :
- **Frontend** : `https://votre-nom.vercel.app`
- **API Backend** : `https://fcmanager-production.up.railway.app/api`

## 🚨 Résolution de Problèmes

### Erreur de Build
```bash
# Nettoyer et rebuilder localement
cd VueFront
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Erreur CORS
Le backend accepte maintenant :
- `http://localhost:3000` (dev)
- `https://*.vercel.app` (prod)
- `https://fcmanager-production.up.railway.app` (backend)

### 404 sur les routes
Vérifiez que `vercel.json` est à la racine et contient la bonne URL backend.

## ⚡ Déploiement Rapide

```bash
# Commande complète pour déployer
cd c:\Users\you93\Music\projetFootFinAnn-e-main\VueFront
vercel --prod
```

## 📱 Test Final

Une fois déployé :
1. Ouvrez l'URL Vercel
2. Testez la connexion/inscription
3. Vérifiez les données (actualités, joueurs, etc.)

---

**🎉 Votre application PSG sera en ligne en quelques minutes !**
