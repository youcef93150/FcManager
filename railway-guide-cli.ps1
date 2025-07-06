# Script de redéploiement Railway - Guide étape par étape
Write-Host "🚀 REDÉPLOIEMENT RAILWAY BACKEND" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

Write-Host "`n📋 Étapes à suivre :" -ForegroundColor Yellow
Write-Host "1. Vérifier le statut actuel" -ForegroundColor Gray
Write-Host "2. Se connecter au service FcManager" -ForegroundColor Gray  
Write-Host "3. Forcer un redéploiement" -ForegroundColor Gray
Write-Host "4. Surveiller les logs" -ForegroundColor Gray

Write-Host "`n🔧 Commandes à exécuter une par une :" -ForegroundColor Yellow

Write-Host "`n# Étape 1 - Vérifier le statut"
Write-Host "railway status" -ForegroundColor Green

Write-Host "`n# Étape 2 - Se connecter au service backend"  
Write-Host "railway service" -ForegroundColor Green
Write-Host "# ⚠️ CHOISIR : FcManager (pas MySQL)" -ForegroundColor Red

Write-Host "`n# Étape 3 - Redéployer"
Write-Host "railway redeploy" -ForegroundColor Green  
Write-Host "# ⚠️ RÉPONDRE : yes pour confirmer" -ForegroundColor Red

Write-Host "`n# Étape 4 - Surveiller les logs"
Write-Host "railway logs" -ForegroundColor Green

Write-Host "`n✅ Instructions détaillées dans le terminal ci-dessous" -ForegroundColor Cyan
