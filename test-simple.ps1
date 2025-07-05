# Test simple de l'API PSG
Write-Host "=== Test de Deploiement PSG ===" -ForegroundColor Cyan

$BACKEND_URL = "https://fcmanager-production.up.railway.app"
$API_URL = "$BACKEND_URL/api"

Write-Host "Test de l'API Backend..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri $API_URL -Method GET
    Write-Host "API accessible !" -ForegroundColor Green
    Write-Host "Backend URL: $BACKEND_URL" -ForegroundColor Yellow
} catch {
    Write-Host "Erreur API: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Prochaines etapes pour Vercel:" -ForegroundColor Cyan
Write-Host "1. Aller sur https://vercel.com"
Write-Host "2. Importer le depot GitHub"
Write-Host "3. Configurer:"
Write-Host "   - Root Directory: VueFront"
Write-Host "   - Build Command: npm run build"
Write-Host "   - Output Directory: dist"
Write-Host "4. Ajouter la variable d'environnement:"
Write-Host "   VITE_API_URL=$BACKEND_URL"
Write-Host ""
Write-Host "Backend pret pour le deploiement !" -ForegroundColor Green
