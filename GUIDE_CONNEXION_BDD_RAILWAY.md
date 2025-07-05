# 🗄️ GUIDE COMPLET - CONNEXION ET IMPORT BASE DE DONNÉES RAILWAY

## ✅ État Actuel
- ✅ Railway CLI installé et connecté
- ✅ Projet FcManager lié
- ✅ Service MySQL configuré
- ✅ Fichier SQL prêt à l'import (`psg_railway_import.sql`)
- ✅ SQL copié dans le presse-papiers

## 🎯 MÉTHODES D'IMPORT

### Méthode 1: Interface Web Railway (Recommandée)
1. **Allez sur** : https://railway.app
2. **Ouvrez le projet** : FcManager
3. **Cliquez sur** : MySQL (service)
4. **Onglet** : "Data"
5. **Cliquez** : "Query"
6. **Collez le SQL** (déjà dans votre presse-papiers)
7. **Exécutez** la requête

### Méthode 2: CLI Railway (Avancée)
```powershell
# Se connecter à MySQL
railway connect MySQL

# Dans MySQL, exécuter :
SHOW DATABASES;
USE railway;
SHOW TABLES;

# Puis coller votre SQL table par table
```

### Méthode 3: Commandes PowerShell Prêtes
```powershell
# Copier le SQL (déjà fait)
Get-Content .\psg_railway_import.sql | Set-Clipboard

# Se connecter à MySQL
.\connect-mysql.ps1

# Tester l'API après import
Invoke-RestMethod -Uri "https://fcmanager-production.up.railway.app/api"
```

## 🔧 RÉSOLUTION ERREUR 502

L'erreur 502 peut venir de :

### 1. Backend pas encore déployé
```powershell
# Vérifier le déploiement
railway logs --service=FcManager
```

### 2. Base de données vide
- **Solution** : Importer le SQL via l'interface web

### 3. Variables d'environnement manquantes
```powershell
# Vérifier les variables
railway variables
```

### 4. Port ou configuration Docker
- **Solution** : Vérifier que PORT=80 dans Railway

## 📋 CHECKLIST POST-IMPORT

Après l'import SQL :

- [ ] Tables créées (actualites, joueurs, users, etc.)
- [ ] Données insérées
- [ ] API répond : `https://fcmanager-production.up.railway.app/api`
- [ ] Test login : `POST /api/login`
- [ ] Test register : `POST /api/register`

## 🧪 COMMANDES DE TEST

### Test API de base
```powershell
Invoke-RestMethod -Uri "https://fcmanager-production.up.railway.app/api"
```

### Test inscription
```powershell
$body = @{
    email = "test@example.com"
    password = "password123"
    nom = "Test"
    prenom = "User"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://fcmanager-production.up.railway.app/api/register" -Method POST -Body $body -ContentType "application/json"
```

### Test connexion
```powershell
$body = @{
    email = "test@example.com"
    password = "password123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://fcmanager-production.up.railway.app/api/login" -Method POST -Body $body -ContentType "application/json"
```

## 🎯 PROCHAINES ÉTAPES

1. **Importer la BDD** (Méthode 1 recommandée)
2. **Vérifier l'API** répond correctement
3. **Déployer sur Vercel** le frontend
4. **Tester l'application** complète

## 📞 SUPPORT

### Logs Railway
```powershell
railway logs --service=FcManager
railway logs --service=MySQL
```

### Variables d'environnement
```powershell
railway variables --service=FcManager
```

### Statut des services
```powershell
railway status
```

---

**🚀 Votre base de données est prête à être importée !**

**Prochaine étape** : Utilisez la Méthode 1 (Interface Web) pour importer le SQL, puis testez l'API.
