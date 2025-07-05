# 🔧 RÉSOLUTION ERREUR VERCEL - Permission denied

## 🚨 Problème identifié
```
sh: line 1: /vercel/path0/VueFront/node_modules/.bin/vite: Permission denied
Error: Command "npm run build" exited with 126
```

## ✅ Solutions appliquées

### 1️⃣ **vercel.json mis à jour**
- Ajout de `chmod +x` avant le build
- Configuration optimisée pour Vue.js
- Headers de sécurité ajoutés

### 2️⃣ **package.json modifié**
- Script `build:vercel` ajouté avec permissions
- Alternative pour contourner le problème

### 3️⃣ **build.sh créé**
- Script de build avec gestion des permissions
- Solution de fallback

## 🚀 REDÉPLOIEMENT VERCEL

### **Option 1 : Changer la Build Command dans Vercel**
1. Aller dans Vercel Dashboard
2. Project Settings → Build & Development Settings
3. Changer **Build Command** vers : `chmod +x ./node_modules/.bin/vite && npm run build`

### **Option 2 : Utiliser le nouveau script**
1. Build Command : `npm run build:vercel`

### **Option 3 : Utiliser le script shell**
1. Build Command : `chmod +x build.sh && ./build.sh`

## 📝 Configuration Vercel recommandée

```json
Project Settings:
- Framework: Vue.js
- Root Directory: VueFront
- Build Command: chmod +x ./node_modules/.bin/vite && npm run build
- Output Directory: dist
- Install Command: npm ci
```

### Variables d'environnement (inchangées)
```
VITE_API_URL=https://fcmanager-production.up.railway.app
NODE_ENV=production
VITE_APP_NAME=PSG Application
VITE_APP_VERSION=1.0.0
```

## 🔄 ÉTAPES POUR REDÉPLOYER

1. **Commit et Push les corrections**
2. **Aller sur Vercel Dashboard**
3. **Modifier la Build Command** (Option 1 recommandée)
4. **Redéployer le projet**

## 🎯 ALTERNATIVE RAPIDE

Si le problème persiste, essayer cette configuration :
- **Framework** : Other
- **Build Command** : `cd VueFront && chmod +x ./node_modules/.bin/vite && npm ci && npm run build`
- **Output Directory** : `VueFront/dist`

---

**🚀 PRÊT POUR REDÉPLOIEMENT !**
