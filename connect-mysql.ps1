# Script de connexion directe à MySQL Railway
Write-Host "Connexion a MySQL Railway via CLI" -ForegroundColor Cyan

# Obtenir les variables d'environnement Railway
Write-Host "Recuperation des variables d'environnement..." -ForegroundColor Yellow

try {
    # Obtenir les variables Railway
    $railwayVars = railway variables --kv 2>&1
    
    if ($railwayVars -match "MYSQL_URL") {
        Write-Host "Variables MySQL trouvees!" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "Pour vous connecter manuellement a MySQL:" -ForegroundColor Cyan
        Write-Host "1. Executez: railway connect MySQL" -ForegroundColor White
        Write-Host "2. Puis dans MySQL, executez les commandes suivantes:"
        Write-Host ""
        Write-Host "SHOW DATABASES;" -ForegroundColor Gray
        Write-Host "USE railway;" -ForegroundColor Gray
        Write-Host "SHOW TABLES;" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Pour importer le SQL directement:"
        Write-Host "SOURCE /path/to/your/sql/file;" -ForegroundColor Gray
        
    } else {
        Write-Host "Variables MySQL non trouvees" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "Erreur lors de la recuperation des variables" -ForegroundColor Red
}

Write-Host ""
Write-Host "Connexion en cours..." -ForegroundColor Yellow
Write-Host "Tapez 'exit' pour quitter MySQL" -ForegroundColor Gray

# Se connecter à MySQL
railway connect MySQL
