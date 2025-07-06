# 🚨 RÉSOLUTION PROBLÈME RAILWAY - Backend 502

## 🔍 Problème Identifié
- **Statut** : Erreur 502 (Application failed to respond)
- **Cause** : Apache démarre mais Symfony ne répond pas
- **Logs** : Apache fonctionne mais l'application ne se charge pas

## ✅ Solutions à Essayer

### 1. Vérifier la Configuration Railway (Interface Web)
Aller sur https://railway.app → Projet FcManager → Service FcManager

**Paramètres à vérifier** :
- **Root Directory** : `Symfony_Projet` ✅
- **Build Command** : `composer install --no-dev --optimize-autoloader`
- **Start Command** : `apache2-foreground` ✅

### 2. Variables d'Environnement Manquantes
Ajouter ces variables sur Railway :
```
SYMFONY_ENV=prod
APP_DEBUG=false
```

### 3. Problème de Migration Base de Données
Le service ne peut pas démarrer si les migrations ne sont pas appliquées.

**Solution** : Modifier le Build Command pour inclure les migrations :
```bash
composer install --no-dev --optimize-autoloader && php bin/console doctrine:migrations:migrate --no-interaction || true
```

### 4. Problème de Permissions ou Cache
Modifier le Dockerfile pour s'assurer des bonnes permissions :
```dockerfile
# Ajouter au Dockerfile
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html
```

### 5. Test de Débogage Simple
Créer un fichier `info.php` dans `public/` :
```php
<?php
phpinfo();
?>
```

## 🛠️ Actions Immédiates

### Option A : Interface Railway Web
1. Aller sur https://railway.app
2. Projet FcManager → Service FcManager  
3. Settings → Build & Deploy
4. Modifier **Build Command** :
   ```
   composer install --no-dev --optimize-autoloader && php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration || echo "Migration failed but continuing"
   ```
5. Redéployer

### Option B : Commande CLI
```powershell
# Dans PowerShell
railway redeploy
```

### Option C : Nouveau Push Git
Si les modifications du Dockerfile sont nécessaires :
```powershell
git add .
git commit -m "Fix Railway configuration and permissions"
git push origin master
```

## 🎯 Diagnostic Rapide

```powershell
# Vérifier les logs en temps réel
railway logs

# Vérifier les variables
railway variables

# Test de base
Invoke-WebRequest -Uri "https://fcmanager-production.up.railway.app" -Method Head
```

## ⚡ Solution Express

**Le plus probable** : Problème de migration base de données.

1. Aller sur Railway → FcManager service → Settings
2. Build Command : `composer install --no-dev --optimize-autoloader && php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration || true`
3. Cliquer "Deploy"

## 🔄 Si Rien ne Marche

Supprimer et recréer le service :
1. Railway → Supprimer service FcManager
2. Créer nouveau service depuis GitHub
3. Configuration complète from scratch

**Le frontend Vercel peut être déployé en attendant !**
