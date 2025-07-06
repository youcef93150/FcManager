# Script de diagnostic Railway
Write-Host "DIAGNOSTIC RAILWAY BACKEND" -ForegroundColor Cyan

Write-Host "`n1. Status Railway:" -ForegroundColor Yellow
railway status

Write-Host "`n2. Variables d'environnement:" -ForegroundColor Yellow
railway variables

Write-Host "`n3. Test de connexion HTTPS:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://fcmanager-production.up.railway.app" -Method Head -ErrorAction Stop
    Write-Host "✅ Connexion OK - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur de connexion: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n4. Test de l'API /api:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://fcmanager-production.up.railway.app/api" -Method Get -ErrorAction Stop
    Write-Host "✅ API accessible - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ API non accessible: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nDIAGNOSTIC TERMINE" -ForegroundColor Cyan
