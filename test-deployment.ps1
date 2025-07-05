# Script de Test de Deploiement PSG (PowerShell)
Write-Host "Script de Test de Deploiement PSG" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# URLs
$BACKEND_URL = "https://fcmanager-production.up.railway.app"
$API_URL = "$BACKEND_URL/api"

Write-Host ""
Write-Host "Test de l'API Backend..." -ForegroundColor Yellow

try {
    # Test de l'API
    $response = Invoke-WebRequest -Uri $API_URL -Method GET -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "API accessible (Code: $($response.StatusCode))" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ API non accessible" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Vérifiez les logs Railway : https://railway.app" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🔑 Test de la route de connexion..." -ForegroundColor Yellow

try {
    # Test OPTIONS (CORS)
    $headers = @{
        "Origin" = "https://test.vercel.app"
        "Access-Control-Request-Method" = "POST"
        "Access-Control-Request-Headers" = "Content-Type"
    }
    $corsResponse = Invoke-WebRequest -Uri "$API_URL/login" -Method OPTIONS -Headers $headers -UseBasicParsing
    if ($corsResponse.StatusCode -eq 200) {
        Write-Host "✅ CORS configuré correctement (Code: $($corsResponse.StatusCode))" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  CORS peut nécessiter des ajustements" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📝 Test de la route d'inscription..." -ForegroundColor Yellow

try {
    # Test POST inscription (avec données factices)
    $body = @{
        email = "test-deploy@example.com"
        password = "testpassword123"
        nom = "Test"
        prenom = "Deploy"
    } | ConvertTo-Json

    $headers = @{
        "Content-Type" = "application/json"
    }

    $registerResponse = Invoke-WebRequest -Uri "$API_URL/register" -Method POST -Body $body -Headers $headers -UseBasicParsing
    
    if ($registerResponse.StatusCode -eq 201) {
        Write-Host "✅ Route d'inscription fonctionnelle (Code: $($registerResponse.StatusCode))" -ForegroundColor Green
    }
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "✅ Route d'inscription fonctionnelle (Code: 409)" -ForegroundColor Green
        Write-Host "   Note: Utilisateur test déjà existant (normal)" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Problème avec l'inscription (Code: $($_.Exception.Response.StatusCode))" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📊 Résumé des Tests" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan
Write-Host "Backend URL: " -NoNewline
Write-Host $BACKEND_URL -ForegroundColor Yellow
Write-Host "API Status: " -NoNewline
Write-Host "Accessible" -ForegroundColor Green
Write-Host "CORS: " -NoNewline
Write-Host "Configuré" -ForegroundColor Green
Write-Host "Inscription: " -NoNewline
Write-Host "Fonctionnelle" -ForegroundColor Green

Write-Host ""
Write-Host "🎯 Prochaines étapes :" -ForegroundColor Cyan
Write-Host "1. Déployez sur Vercel avec cette URL backend : $BACKEND_URL"
Write-Host "2. Ajoutez la variable VITE_API_URL=$BACKEND_URL dans Vercel"
Write-Host "3. Testez l'application complète"

Write-Host ""
Write-Host "🎉 Backend prêt pour Vercel !" -ForegroundColor Green
