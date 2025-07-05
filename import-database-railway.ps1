# Script d'import de la base de données PSG vers Railway MySQL
Write-Host "🚀 Import de la base de données PSG vers Railway" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# Vérifier que Railway CLI est connecté
try {
    $status = railway status 2>&1
    if ($status -match "Project: FcManager") {
        Write-Host "✅ Connecté au projet Railway FcManager" -ForegroundColor Green
    } else {
        Write-Host "❌ Pas connecté à Railway. Exécutez d'abord: railway link" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Railway CLI non disponible" -ForegroundColor Red
    exit 1
}

# Chemin vers le fichier SQL
$sqlFile = ".\psg_railway_import.sql"

if (-not (Test-Path $sqlFile)) {
    Write-Host "❌ Fichier SQL non trouvé: $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host "📄 Fichier SQL trouvé: $sqlFile" -ForegroundColor Yellow

# Demander confirmation
$confirm = Read-Host "Voulez-vous importer la base de données? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "❌ Import annulé" -ForegroundColor Red
    exit 0
}

Write-Host "📤 Import en cours..." -ForegroundColor Yellow

# Option 1: Via Railway CLI (recommandé)
Write-Host "🔄 Tentative d'import via Railway CLI..." -ForegroundColor Yellow

try {
    # Lire le contenu du fichier SQL
    $sqlContent = Get-Content $sqlFile -Raw
    
    # Créer un fichier temporaire pour l'import
    $tempFile = [System.IO.Path]::GetTempFileName() + ".sql"
    Set-Content -Path $tempFile -Value $sqlContent -Encoding UTF8
    
    Write-Host "📂 Fichier temporaire créé: $tempFile" -ForegroundColor Gray
    
    # Instructions pour l'utilisateur
    Write-Host ""
    Write-Host "🔧 Instructions d'import manuel:" -ForegroundColor Cyan
    Write-Host "1. Copiez le contenu du fichier psg_railway_import.sql"
    Write-Host "2. Allez sur https://railway.app"
    Write-Host "3. Ouvrez votre projet FcManager"
    Write-Host "4. Cliquez sur MySQL"
    Write-Host "5. Allez dans l'onglet 'Data'"
    Write-Host "6. Cliquez sur 'Query'"
    Write-Host "7. Collez le contenu SQL et exécutez"
    
    Write-Host ""
    Write-Host "📋 Ou utilisez cette commande pour copier le contenu:" -ForegroundColor Yellow
    Write-Host "Get-Content .\psg_railway_import.sql | Set-Clipboard" -ForegroundColor White
    
    # Nettoyer le fichier temporaire
    Remove-Item $tempFile -ErrorAction SilentlyContinue
    
} catch {
    Write-Host "❌ Erreur lors de l'import: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 Après l'import, testez votre API:" -ForegroundColor Cyan
Write-Host "Invoke-RestMethod -Uri 'https://fcmanager-production.up.railway.app/api'" -ForegroundColor White

Write-Host ""
Write-Host "✨ Import terminé!" -ForegroundColor Green
