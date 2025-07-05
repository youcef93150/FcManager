# 🔍 TEST API RAILWAY - DIAGNOSTIC COMPLET

Write-Host "🚀 DIAGNOSTIC COMPLET DE L'API RAILWAY PSG" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan

$API_BASE = "https://fcmanager-production.up.railway.app"

Write-Host "🌐 URL de base : $API_BASE" -ForegroundColor Yellow

# Test 1: API racine
Write-Host "`n1️⃣ Test de l'API racine..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri "$API_BASE/api" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ API racine accessible - Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ API racine inaccessible: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Actualités
Write-Host "`n2️⃣ Test des actualités..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri "$API_BASE/api/actualites" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ Actualités accessibles - Status: $($response.StatusCode)" -ForegroundColor Green
    $content = $response.Content | ConvertFrom-Json
    Write-Host "📰 Nombre d'actualités trouvées: $($content.Count)" -ForegroundColor Green
} catch {
    Write-Host "❌ Actualités inaccessibles: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Joueurs
Write-Host "`n3️⃣ Test des joueurs..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri "$API_BASE/api/joueurs" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ Joueurs accessibles - Status: $($response.StatusCode)" -ForegroundColor Green
    $content = $response.Content | ConvertFrom-Json
    Write-Host "⚽ Nombre de joueurs trouvés: $($content.Count)" -ForegroundColor Green
} catch {
    Write-Host "❌ Joueurs inaccessibles: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Produits
Write-Host "`n4️⃣ Test des produits..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri "$API_BASE/api/products" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ Produits accessibles - Status: $($response.StatusCode)" -ForegroundColor Green
    $content = $response.Content | ConvertFrom-Json
    Write-Host "🛍️ Nombre de produits trouvés: $($content.Count)" -ForegroundColor Green
} catch {
    Write-Host "❌ Produits inaccessibles: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Test de connexion simple
Write-Host "`n5️⃣ Test de connexion HTTP simple..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri $API_BASE -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ Serveur accessible - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Serveur inaccessible: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "🎯 RÉSUMÉ DU DIAGNOSTIC" -ForegroundColor Green

# Vérification Railway CLI
Write-Host "`n6️⃣ Vérification Railway CLI..." -ForegroundColor Blue
try {
    $railwayStatus = railway status 2>&1
    Write-Host "✅ Railway CLI connecté" -ForegroundColor Green
    Write-Host "$railwayStatus" -ForegroundColor Gray
} catch {
    Write-Host "❌ Railway CLI non disponible" -ForegroundColor Red
}

Write-Host "`n🚀 PROCHAINES ÉTAPES :" -ForegroundColor Yellow
Write-Host "1. Si API non accessible : Vérifier Railway deployment" -ForegroundColor White
Write-Host "2. Si API accessible : Procéder au déploiement Vercel" -ForegroundColor White
Write-Host "3. Tester l'application complète" -ForegroundColor White

Write-Host "`n📱 URLs utiles :" -ForegroundColor Cyan
Write-Host "- Railway Dashboard: https://railway.app" -ForegroundColor White
Write-Host "- API Base: $API_BASE" -ForegroundColor White
Write-Host "- Vercel Dashboard: https://vercel.com" -ForegroundColor White

Read-Host "`nAppuyez sur Entrée pour continuer..."
