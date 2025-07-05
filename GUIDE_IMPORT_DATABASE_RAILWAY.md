# Guide d'Import de la Base de Données sur Railway MySQL

## 📋 Étapes pour importer votre base de données locale vers Railway

### 1. Préparer les fichiers SQL

Vous avez deux fichiers SQL :
- `vue_psg.sql` (225 lignes) - Version basique
- `vue_psg_complete.sql` (409 lignes) - Version avec plus de données

**Recommandation : Utilisez `vue_psg_complete.sql` pour avoir toutes vos données.**

### 2. Nettoyer le fichier SQL pour Railway

Railway MySQL peut avoir des restrictions. Il faut créer une version nettoyée :

```sql
-- Supprimez les lignes suivantes du début du fichier :
-- SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
-- START TRANSACTION;
-- SET time_zone = "+00:00";

-- Remplacez :
-- CREATE DATABASE IF NOT EXISTS `vue_psg`;
-- USE `vue_psg`;

-- Par (si présent) :
-- (rien - Railway gère automatiquement la DB)
```

### 3. Méthodes d'import

#### **Méthode 1 : Via l'interface web Railway (Recommandée)**

1. **Connectez-vous à Railway** : https://railway.app
2. **Allez dans votre projet** FcManager
3. **Cliquez sur le service MySQL**
4. **Onglet "Data"** ou **"Connect"**
5. **Utilisez l'outil d'import** ou le **Query Editor**
6. **Copiez-collez le contenu** de `vue_psg_complete.sql`

#### **Méthode 2 : Via MySQL Workbench**

1. **Téléchargez MySQL Workbench** : https://dev.mysql.com/downloads/workbench/
2. **Créez une nouvelle connexion** avec vos données Railway :
   - **Hostname** : Votre host Railway MySQL
   - **Port** : Votre port Railway MySQL  
   - **Username** : Votre username Railway MySQL
   - **Password** : Votre password Railway MySQL
3. **File → Run SQL Script** → Sélectionnez `vue_psg_complete.sql`

#### **Méthode 3 : Via ligne de commande (si MySQL installé)**

```bash
mysql -h [RAILWAY_HOST] -P [RAILWAY_PORT] -u [RAILWAY_USER] -p[RAILWAY_PASSWORD] [RAILWAY_DATABASE] < vue_psg_complete.sql
```

### 4. Récupérer les informations de connexion Railway

1. **Dans Railway**, allez dans votre **service MySQL**
2. **Onglet "Variables"** ou **"Connect"**
3. **Copiez les valeurs** :
   - `MYSQL_HOST`
   - `MYSQL_PORT` 
   - `MYSQL_USER`
   - `MYSQL_PASSWORD`
   - `MYSQL_DATABASE`

### 5. Vérifier l'import

Après l'import, vérifiez que les tables sont créées :

```sql
SHOW TABLES;
SELECT COUNT(*) FROM user;
SELECT COUNT(*) FROM joueurs;
SELECT COUNT(*) FROM product;
```

### 6. Problèmes courants et solutions

#### **Erreur de caractères**
```sql
-- Ajoutez au début du fichier SQL :
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
```

#### **Erreur AUTO_INCREMENT**
```sql
-- Si problème avec AUTO_INCREMENT, remplacez par :
-- AUTO_INCREMENT=1
```

#### **Erreur de contraintes**
```sql
-- Désactivez temporairement les contraintes :
SET FOREIGN_KEY_CHECKS=0;
-- ... votre SQL ...
SET FOREIGN_KEY_CHECKS=1;
```

### 7. Alternative : Reset complet

Si vous voulez repartir de zéro :

1. **Supprimez toutes les tables** dans Railway MySQL
2. **Laissez Doctrine recréer** la structure via les migrations
3. **Importez seulement les données** (INSERT statements)

### 8. Script de nettoyage automatique

Voici un script PowerShell pour nettoyer automatiquement votre fichier SQL :

```powershell
# Nettoie le fichier SQL pour Railway
$inputFile = "vue_psg_complete.sql"
$outputFile = "vue_psg_railway.sql"

$content = Get-Content $inputFile -Raw
$content = $content -replace "SET SQL_MODE = `"NO_AUTO_VALUE_ON_ZERO`";", ""
$content = $content -replace "START TRANSACTION;", ""
$content = $content -replace "SET time_zone = `"\+00:00`";", ""
$content = $content -replace "COMMIT;", ""

# Ajouter les bonnes options
$cleanContent = @"
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

$content

SET FOREIGN_KEY_CHECKS=1;
"@

$cleanContent | Out-File -FilePath $outputFile -Encoding UTF8
Write-Host "Fichier nettoyé créé : $outputFile"
```

---

## 🔄 Étapes suivantes après l'import

1. **Vérifiez la connexion** de votre backend Railway avec la base
2. **Testez les endpoints** API depuis votre URL Railway
3. **Déployez le frontend** sur Vercel
4. **Testez l'application complète** en production

---

## 📞 En cas de problème

- Vérifiez que les **variables d'environnement** Railway sont correctes
- Assurez-vous que la **DATABASE_URL** est bien configurée
- Testez la connexion avec un simple `SELECT 1` d'abord
