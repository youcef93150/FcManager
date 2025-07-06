# Script de diagnostic Railway
Write-Host "🔍 DIAGNOSTIC RAILWAY BACKEND" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

# Test 1: Vérification du service
Write-Host "`n1. Status Railway:" -ForegroundColor Yellow
railway status

# Test 2: Variables d'environnement
Write-Host "`n2. Variables d'environnement:" -ForegroundColor Yellow
railway variables

# Test 3: Test de connexion basique
Write-Host "`n3. Test de connexion HTTPS:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://fcmanager-production.up.railway.app" -Method Head -ErrorAction Stop
    Write-Host "✅ Connexion OK - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur de connexion: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Test de l'API
Write-Host "`n4. Test de l'API /api:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://fcmanager-production.up.railway.app/api" -Method Get -ErrorAction Stop
    Write-Host "✅ API accessible - Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Contenu: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ API non accessible: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Réponse d'erreur: $responseBody" -ForegroundColor Red
    }
}

# Test 5: Test route Symfony basique
Write-Host "`n5. Test index.php:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://fcmanager-production.up.railway.app/index.php" -Method Get -ErrorAction Stop
    Write-Host "✅ index.php accessible - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ index.php non accessible: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🔍 DIAGNOSTIC TERMINÉ" -ForegroundColor Cyan
Write-Host "Si toutes les connexions échouent, vérifiez:" -ForegroundColor Yellow
Write-Host "- Les logs Railway avec: railway logs" -ForegroundColor Gray
Write-Host "- La configuration Apache dans le Dockerfile" -ForegroundColor Gray
Write-Host "- Les variables d'environnement DATABASE_URL" -ForegroundColor Gray
