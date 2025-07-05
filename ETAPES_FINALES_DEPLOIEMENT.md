# 🚀 Étapes Finales de Déploiement - Application PSG

## ✅ Statut Actuel
- ✅ Backend Symfony configuré avec CORS pour Vercel
- ✅ Frontend Vue.js configuré avec variables d'environnement
- ✅ Base de données MySQL sur Railway
- ✅ Fichiers SQL d'import préparés
- ✅ Configuration Docker optimisée

---

## 🎯 Prochaines Étapes à Suivre

### Étape 1: Pousser les dernières modifications
```bash
git add .
git commit -m "Fix CORS configuration for Vercel deployment"
git push origin main
```

### Étape 2: Vérifier le déploiement Railway
1. Allez sur https://railway.app
2. Ouvrez votre projet **FcManager**
3. Vérifiez que le build est en cours ou terminé
4. Une fois terminé, testez l'URL: `https://fcmanager-production.up.railway.app/api`

### Étape 3: Importer la base de données (si nécessaire)
Si les tables sont manquantes :
1. Ouvrez l'onglet **MySQL** dans Railway
2. Cliquez sur **"Data"** puis **"Query"**
3. Copiez-collez le contenu de `psg_railway_import.sql`
4. Exécutez la requête

### Étape 4: Déployer sur Vercel
1. Allez sur https://vercel.com
2. Cliquez **"Add New Project"**
3. Importez votre dépôt GitHub
4. Configuration :
   - **Project Name**: `psg-application`
   - **Framework**: Vue.js
   - **Root Directory**: `VueFront`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`

### Étape 5: Variables d'environnement Vercel
Ajoutez dans les paramètres Vercel :
```
VITE_API_URL=https://fcmanager-production.up.railway.app
NODE_ENV=production
```

### Étape 6: Test final
1. Attendez la fin du déploiement Vercel
2. Testez votre application sur l'URL Vercel
3. Vérifiez : inscription, connexion, navigation

---

## 🔧 Commandes de Test

### Tester l'API Railway
```bash
# Test de base
curl https://fcmanager-production.up.railway.app/api

# Test de connexion (remplacez les données)
curl -X POST https://fcmanager-production.up.railway.app/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'
```

### Tester le frontend local avec l'API de production
```bash
cd VueFront
npm run dev
# Puis testez sur http://localhost:5173
```

---

## 🚨 Résolution de Problèmes

### Si l'API Railway ne répond pas :
1. Vérifiez les logs dans Railway → Deployments → View Logs
2. Assurez-vous que le port 80 est bien configuré
3. Vérifiez que la variable `DATABASE_URL` utilise `${{ MySQL.MYSQL_URL }}`

### Si Vercel échoue au build :
1. Vérifiez les logs de build Vercel
2. Assurez-vous que `package.json` est correct dans VueFront
3. Vérifiez que les variables d'environnement sont définies

### Si CORS ne fonctionne pas :
1. Vérifiez que l'origine Vercel est autorisée dans LoginController
2. Testez d'abord en local puis en production
3. Utilisez les outils développeur pour voir les erreurs CORS

---

## 📋 Checklist de Déploiement

- [ ] Code poussé sur GitHub
- [ ] Railway déployé et accessible
- [ ] Base de données importée
- [ ] Vercel configuré et déployé
- [ ] Variables d'environnement définies
- [ ] Test de connexion/inscription
- [ ] Test de navigation
- [ ] Test responsive mobile

---

## 🎉 URLs Finales

Une fois terminé, vous aurez :
- **Frontend** : `https://votre-nom-projet.vercel.app`
- **Backend API** : `https://fcmanager-production.up.railway.app/api`
- **Base de données** : Accessible via Railway

**Bon déploiement ! 🚀**
