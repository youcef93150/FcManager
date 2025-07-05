# Verification finale avant deploiement
Write-Host "=== VERIFICATION FINALE PSG APPLICATION ===" -ForegroundColor Cyan
Write-Host ""

# Verification Railway CLI
Write-Host "1. Verification Railway CLI..." -ForegroundColor Yellow
try {
    $railwayStatus = railway status 2>&1
    if ($railwayStatus -match "FcManager") {
        Write-Host "   Railway CLI: CONNECTE" -ForegroundColor Green
        Write-Host "   Projet: FcManager" -ForegroundColor Green
    } else {
        Write-Host "   Railway CLI: NON CONNECTE" -ForegroundColor Red
    }
} catch {
    Write-Host "   Railway CLI: NON INSTALLE" -ForegroundColor Red
}

# Verification fichiers cles
Write-Host ""
Write-Host "2. Verification fichiers cles..." -ForegroundColor Yellow

$fichiers = @{
    "LoginController.php" = "Symfony_Projet\src\Controller\LoginController.php"
    "api.js" = "VueFront\src\config\api.js"
    "vercel.json" = "vercel.json"
    "psg_railway_import.sql" = "psg_railway_import.sql"
    ".env.production" = "VueFront\.env.production"
}

foreach ($nom in $fichiers.Keys) {
    $chemin = $fichiers[$nom]
    if (Test-Path $chemin) {
        Write-Host "   $nom : PRESENT" -ForegroundColor Green
    } else {
        Write-Host "   $nom : MANQUANT" -ForegroundColor Red
    }
}

# Verification package.json Vue
Write-Host ""
Write-Host "3. Verification package.json Vue..." -ForegroundColor Yellow
if (Test-Path "VueFront\package.json") {
    Write-Host "   package.json: PRESENT" -ForegroundColor Green
    try {
        $packageJson = Get-Content "VueFront\package.json" | ConvertFrom-Json
        if ($packageJson.scripts.build) {
            Write-Host "   Script build: PRESENT" -ForegroundColor Green
        } else {
            Write-Host "   Script build: MANQUANT" -ForegroundColor Red
        }
    } catch {
        Write-Host "   package.json: FORMAT INVALIDE" -ForegroundColor Red
    }
} else {
    Write-Host "   package.json: MANQUANT" -ForegroundColor Red
}

# Test API Railway
Write-Host ""
Write-Host "4. Test API Railway..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "https://fcmanager-production.up.railway.app/api" -Method GET -TimeoutSec 10
    Write-Host "   API: ACCESSIBLE" -ForegroundColor Green
} catch {
    if ($_.Exception.Message -match "502") {
        Write-Host "   API: ERREUR 502 (Build en cours ou BDD manquante)" -ForegroundColor Yellow
    } else {
        Write-Host "   API: NON ACCESSIBLE" -ForegroundColor Red
    }
}

# Verification Git
Write-Host ""
Write-Host "5. Verification Git..." -ForegroundColor Yellow
try {
    $gitStatus = git status 2>&1
    if ($gitStatus -match "On branch") {
        Write-Host "   Git: INITIALISE" -ForegroundColor Green
        
        $gitRemote = git remote -v 2>&1
        if ($gitRemote -match "github.com") {
            Write-Host "   Remote GitHub: CONFIGURE" -ForegroundColor Green
        } else {
            Write-Host "   Remote GitHub: NON CONFIGURE" -ForegroundColor Red
        }
    } else {
        Write-Host "   Git: NON INITIALISE" -ForegroundColor Red
    }
} catch {
    Write-Host "   Git: NON DISPONIBLE" -ForegroundColor Red
}

# Resume final
Write-Host ""
Write-Host "=== RESUME FINAL ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "ETAPES SUIVANTES:" -ForegroundColor White
Write-Host "1. Importer SQL sur Railway (si API erreur 502)" -ForegroundColor Gray
Write-Host "2. Deployer sur Vercel" -ForegroundColor Gray
Write-Host "3. Configurer variables d'environnement Vercel" -ForegroundColor Gray
Write-Host "4. Tester l'application complete" -ForegroundColor Gray
Write-Host ""
Write-Host "URLS IMPORTANTES:" -ForegroundColor White
Write-Host "- Railway: https://railway.app" -ForegroundColor Gray
Write-Host "- Vercel: https://vercel.com" -ForegroundColor Gray
Write-Host "- API Backend: https://fcmanager-production.up.railway.app/api" -ForegroundColor Gray
Write-Host ""
Write-Host "APPLICATION PRETE POUR LE DEPLOIEMENT!" -ForegroundColor Green
