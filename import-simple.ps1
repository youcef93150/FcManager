# Import simple de la base PSG vers Railway
Write-Host "Import de la base de donnees PSG vers Railway" -ForegroundColor Cyan

# Vérifier la connection Railway
$status = railway status
Write-Host "Status Railway: $status" -ForegroundColor Yellow

# Vérifier le fichier SQL
if (Test-Path ".\psg_railway_import.sql") {
    Write-Host "Fichier SQL trouve: psg_railway_import.sql" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Pour importer la base de donnees:" -ForegroundColor Cyan
    Write-Host "1. Copiez le contenu du fichier SQL avec cette commande:"
    Write-Host "   Get-Content .\psg_railway_import.sql | Set-Clipboard" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Allez sur https://railway.app"
    Write-Host "3. Ouvrez le projet FcManager"
    Write-Host "4. Cliquez sur MySQL"
    Write-Host "5. Onglet 'Data' -> 'Query'"
    Write-Host "6. Collez et executez le SQL"
    
    Write-Host ""
    Write-Host "Voulez-vous copier le SQL maintenant? (y/N): " -NoNewline
    $response = Read-Host
    
    if ($response -eq "y" -or $response -eq "Y") {
        Get-Content .\psg_railway_import.sql | Set-Clipboard
        Write-Host "SQL copie dans le presse-papiers!" -ForegroundColor Green
    }
    
} else {
    Write-Host "Fichier SQL non trouve!" -ForegroundColor Red
}

Write-Host ""
Write-Host "Une fois importe, testez avec:"
Write-Host "Invoke-RestMethod -Uri 'https://fcmanager-production.up.railway.app/api'" -ForegroundColor White
