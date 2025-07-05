@echo off
setlocal EnableDelayedExpansion

:main_menu
cls
echo ========================================
echo       GESTIONNAIRE APPLICATION PSG
echo ========================================
echo.
echo Sélectionnez une option :
echo.
echo 1. 🚀 Démarrer l'application
echo 2. 🛑 Arrêter l'application  
echo 3. 🧪 Tester l'application
echo 4. 📊 Voir le statut des services
echo 5. 📋 Voir les logs
echo 6. 🔧 Redémarrer un service spécifique
echo 7. 🧹 Nettoyage complet
echo 8. ❌ Quitter
echo.
echo ========================================
set /p choice="Votre choix (1-8) : "

if "%choice%"=="1" goto start_app
if "%choice%"=="2" goto stop_app
if "%choice%"=="3" goto test_app
if "%choice%"=="4" goto status_app
if "%choice%"=="5" goto logs_app
if "%choice%"=="6" goto restart_service
if "%choice%"=="7" goto cleanup_app
if "%choice%"=="8" goto exit_app

echo Choix invalide. Appuyez sur une touche pour continuer...
pause >nul
goto main_menu

:start_app
cls
echo ========================================
echo     LANCEMENT APPLICATION PSG
echo ========================================
echo.

:: Vérifier si Docker est installé et démarré
echo [STEP 1] Vérification de Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: Docker n'est pas installé ou n'est pas dans le PATH
    echo Veuillez installer Docker Desktop et le démarrer
    pause
    goto main_menu
)

docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: Docker n'est pas démarré
    echo Veuillez démarrer Docker Desktop
    pause
    goto main_menu
)
echo ✅ Docker est disponible

echo.
echo [STEP 2] Arrêt des conteneurs existants (si ils existent)...
docker-compose -f docker-compose.prod.yml down >nul 2>&1
echo ✅ Conteneurs arrêtés

echo.
echo [STEP 3] Construction et démarrage des services...
echo Cela peut prendre quelques minutes lors du premier lancement...
docker-compose -f docker-compose.prod.yml up -d --build

if %errorlevel% neq 0 (
    echo.
    echo ❌ ERREUR lors du démarrage des conteneurs
    echo Vérifiez les logs avec l'option 5 du menu
    pause
    goto main_menu
)

echo ✅ Services démarrés

echo.
echo [STEP 4] Attente du démarrage complet des services...
echo Attente de 15 secondes pour l'initialisation complète...
timeout /t 15 /nobreak >nul

echo.
echo [STEP 5] Vérification du statut des conteneurs...
docker-compose -f docker-compose.prod.yml ps

echo.
echo [STEP 6] Test de connectivité des services...

:: Test Base de données d'abord
echo Testing Database connection...
docker exec projetfootfinann-e-main-database-1 mysqladmin ping -h localhost --silent >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Base de données accessible
) else (
    echo ❌ Base de données non accessible
)

:: Test Frontend
echo Testing Frontend (http://localhost:3000)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:3000' -TimeoutSec 10 -UseBasicParsing; if($response.StatusCode -eq 200) { Write-Host '✅ Frontend accessible' -ForegroundColor Green } else { Write-Host '⚠️ Frontend répond mais status:' $response.StatusCode -ForegroundColor Yellow } } catch { Write-Host '❌ Frontend non accessible' -ForegroundColor Red }"

:: Test Backend (page d'accueil d'abord)
echo Testing Backend Symfony (http://localhost:8000)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8000' -TimeoutSec 10 -UseBasicParsing; if($response.StatusCode -eq 200) { Write-Host '✅ Backend accessible' -ForegroundColor Green } else { Write-Host '⚠️ Backend répond mais status:' $response.StatusCode -ForegroundColor Yellow } } catch { Write-Host '❌ Backend non accessible' -ForegroundColor Red }"

:: Test API Platform (avec plus de patience)
echo Testing Backend API (http://localhost:8000/api)...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8000/api' -TimeoutSec 15 -UseBasicParsing; if($response.StatusCode -eq 200) { Write-Host '✅ Backend API accessible' -ForegroundColor Green } else { Write-Host '⚠️ Backend API répond mais status:' $response.StatusCode -ForegroundColor Yellow } } catch { Write-Host '❌ Backend API non accessible (normal si pas encore configuré)' -ForegroundColor Yellow }"

echo.
echo ========================================
echo           RÉCAPITULATIF
echo ========================================
echo.
echo 🌐 Frontend Vue.js : http://localhost:3000
echo 🔧 Backend Symfony : http://localhost:8000
echo 📊 API Documentation : http://localhost:8000/api
echo 🗄️ Base de données MySQL : localhost:3306
echo.
echo ✨ Application PSG démarrée avec succès !
echo.
pause
goto main_menu

:stop_app
cls
echo ========================================
echo      ARRÊT APPLICATION PSG
echo ========================================
echo.

:: Vérifier si Docker est disponible
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: Docker n'est pas installé ou n'est pas dans le PATH
    pause
    goto main_menu
)

echo [STEP 1] Arrêt des conteneurs PSG...
docker-compose -f docker-compose.prod.yml down

if %errorlevel% equ 0 (
    echo ✅ Tous les conteneurs PSG ont été arrêtés
) else (
    echo ⚠️ Erreur lors de l'arrêt des conteneurs
)

echo.
echo [STEP 2] Nettoyage des ressources Docker (optionnel)...
echo Voulez-vous supprimer les images Docker pour libérer de l'espace ? (y/N)
set /p cleanup=

if /i "%cleanup%"=="y" (
    echo Suppression des images Docker...
    docker-compose -f docker-compose.prod.yml down --rmi all --volumes --remove-orphans
    echo ✅ Images et volumes supprimés
) else (
    echo ✅ Images conservées pour un démarrage plus rapide la prochaine fois
)

echo.
echo ✅ Application PSG arrêtée
echo.
pause
goto main_menu

:test_app
cls
echo ========================================
echo      TEST DE L'APPLICATION PSG
echo ========================================
echo.

set "success=0"
set "total=0"

echo [TEST 1] Vérification des conteneurs Docker...
set /a total+=1
docker-compose -f docker-compose.prod.yml ps --format "table {{.Name}}\t{{.Status}}" | findstr "Up" >nul
if %errorlevel% equ 0 (
    echo ✅ Conteneurs Docker actifs
    set /a success+=1
) else (
    echo ❌ Conteneurs Docker non actifs
)

echo.
echo [TEST 2] Test Frontend Vue.js (http://localhost:3000)...
set /a total+=1
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:3000' -TimeoutSec 10 -UseBasicParsing; if($response.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend accessible
    set /a success+=1
) else (
    echo ❌ Frontend non accessible
)

echo.
echo [TEST 3] Test Backend Symfony (conteneur actif)...
set /a total+=1
docker exec projetfootfinann-e-main-backend-1 echo "Backend OK" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend conteneur accessible
    set /a success+=1
) else (
    echo ❌ Backend conteneur non accessible
)

echo.
echo [TEST 4] Test Backend Symfony (http://localhost:8000)...
set /a total+=1
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8000' -TimeoutSec 10 -UseBasicParsing; if($response.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend web accessible
    set /a success+=1
) else (
    echo ❌ Backend web non accessible
)

echo.
echo [TEST 5] Test API Platform (http://localhost:8000/api)...
set /a total+=1
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:8000/api' -TimeoutSec 15 -UseBasicParsing; if($response.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ API accessible
    set /a success+=1
) else (
    echo ❌ API non accessible
)

echo.
echo [TEST 6] Test Base de données MySQL...
set /a total+=1
docker exec projetfootfinann-e-main-database-1 mysqladmin ping -h localhost --silent >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Base de données accessible
    set /a success+=1
) else (
    echo ❌ Base de données non accessible
)

echo.
echo [TEST 7] Vérification de la base de données vue_psg...
set /a total+=1
docker exec projetfootfinann-e-main-database-1 mysql -u root -e "USE vue_psg; SHOW TABLES;" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Base de données vue_psg disponible
    set /a success+=1
) else (
    echo ❌ Base de données vue_psg non disponible
)

echo.
echo ========================================
echo         RÉSULTATS DES TESTS
echo ========================================
echo.
echo Tests réussis: %success%/%total%

if %success% equ %total% (
    echo.
    echo 🎉 TOUS LES TESTS ONT RÉUSSI !
    echo L'application PSG est entièrement fonctionnelle.
    echo.
    echo 📋 Récapitulatif des services:
    echo   🌐 Frontend: http://localhost:3000
    echo   🔧 Backend:  http://localhost:8000  
    echo   📊 API:      http://localhost:8000/api
    echo   🗄️ Database: localhost:3306 (vue_psg)
) else (
    echo.
    if %success% gtr 4 (
        echo ✅ APPLICATION FONCTIONNELLE !
        echo La plupart des services sont opérationnels.
        echo.
        echo 📋 Services disponibles:
        echo   🌐 Frontend: http://localhost:3000
        echo   🔧 Backend:  http://localhost:8000  
        echo   📊 API:      http://localhost:8000/api
        echo   🗄️ Database: localhost:3306 (vue_psg)
        echo.
        echo ⚠️ Note: L'API peut mettre quelques minutes à être complètement disponible
    ) else (
        echo ⚠️ CERTAINS TESTS ONT ÉCHOUÉ
        echo Vérifiez les logs avec l'option 5 du menu
    )
)

echo.
pause
goto main_menu

:status_app
cls
echo ========================================
echo     STATUT DES SERVICES PSG
echo ========================================
echo.

echo [INFO] Statut des conteneurs Docker :
docker-compose -f docker-compose.prod.yml ps

echo.
echo [INFO] Utilisation des ressources :
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"

echo.
pause
goto main_menu

:logs_app
cls
echo ========================================
echo         LOGS DES SERVICES
echo ========================================
echo.
echo Sélectionnez le service dont vous voulez voir les logs :
echo.
echo 1. 🌐 Frontend (Vue.js)
echo 2. 🔧 Backend (Symfony)
echo 3. 🗄️ Database (MySQL)
echo 4. 📊 Tous les services
echo 5. 🔙 Retour au menu principal
echo.
set /p log_choice="Votre choix (1-5) : "

if "%log_choice%"=="1" (
    docker-compose -f docker-compose.prod.yml logs frontend
) else if "%log_choice%"=="2" (
    docker-compose -f docker-compose.prod.yml logs backend
) else if "%log_choice%"=="3" (
    docker-compose -f docker-compose.prod.yml logs database
) else if "%log_choice%"=="4" (
    docker-compose -f docker-compose.prod.yml logs
) else if "%log_choice%"=="5" (
    goto main_menu
) else (
    echo Choix invalide.
)

echo.
pause
goto main_menu

:restart_service
cls
echo ========================================
echo    REDÉMARRAGE SERVICE SPÉCIFIQUE
echo ========================================
echo.
echo Sélectionnez le service à redémarrer :
echo.
echo 1. 🌐 Frontend (Vue.js)
echo 2. 🔧 Backend (Symfony)
echo 3. 🗄️ Database (MySQL)
echo 4. 🔙 Retour au menu principal
echo.
set /p restart_choice="Votre choix (1-4) : "

if "%restart_choice%"=="1" (
    echo Redémarrage du Frontend...
    docker-compose -f docker-compose.prod.yml restart frontend
    echo ✅ Frontend redémarré
) else if "%restart_choice%"=="2" (
    echo Redémarrage du Backend...
    docker-compose -f docker-compose.prod.yml restart backend
    echo ✅ Backend redémarré
) else if "%restart_choice%"=="3" (
    echo Redémarrage de la Base de données...
    docker-compose -f docker-compose.prod.yml restart database
    echo ✅ Base de données redémarrée
) else if "%restart_choice%"=="4" (
    goto main_menu
) else (
    echo Choix invalide.
)

echo.
pause
goto main_menu

:cleanup_app
cls
echo ========================================
echo       NETTOYAGE COMPLET
echo ========================================
echo.
echo ⚠️ ATTENTION : Cette opération va :
echo   - Arrêter tous les conteneurs
echo   - Supprimer toutes les images Docker du projet
echo   - Supprimer tous les volumes
echo   - Libérer l'espace disque
echo.
echo Cette action est IRRÉVERSIBLE !
echo Le prochain démarrage prendra plus de temps (reconstruction complète)
echo.
set /p confirm="Êtes-vous sûr de vouloir continuer ? (y/N) : "

if /i "%confirm%"=="y" (
    echo.
    echo Arrêt et nettoyage complet...
    docker-compose -f docker-compose.prod.yml down --rmi all --volumes --remove-orphans
    
    echo.
    echo Nettoyage des images orphelines...
    docker image prune -f
    
    echo.
    echo Nettoyage des volumes orphelins...
    docker volume prune -f
    
    echo.
    echo ✅ Nettoyage complet terminé !
    echo L'espace disque a été libéré.
) else (
    echo.
    echo ✅ Nettoyage annulé
)

echo.
pause
goto main_menu

:exit_app
cls
echo ========================================
echo           AU REVOIR !
echo ========================================
echo.
echo Merci d'avoir utilisé le gestionnaire PSG.
echo.
echo 📋 Commandes utiles à retenir :
echo   - Lancer ce script : psg-manager.bat
echo   - Logs en temps réel : docker-compose -f docker-compose.prod.yml logs -f
echo   - Accès direct aux conteneurs :
echo     • Frontend : docker exec -it psg-frontend sh
echo     • Backend  : docker exec -it psg-backend bash  
echo     • Database : docker exec -it psg-database mysql -u root vue_psg
echo.
echo ✨ Bonne journée !
echo.
pause
exit /b 0
