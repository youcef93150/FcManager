@echo off
REM Script de déploiement Docker pour Windows
REM Utilisation: docker-decho    • Base de données: localhost:3306ploy.bat

echo ==========================================
echo 🐳 Déploiement Docker - Projet PSG
echo ==========================================

REM Vérification de Docker
echo [INFO] Vérification de Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker n'est pas installé ou n'est pas dans le PATH
    echo Installez Docker Desktop depuis https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Compose n'est pas installé
    pause
    exit /b 1
)

echo [SUCCESS] Docker est prêt ✓

REM Configuration de l'environnement
echo [INFO] Configuration de l'environnement...
if not exist .env (
    copy .env.docker .env
    echo [WARNING] Fichier .env créé à partir de .env.docker
    echo [WARNING] Veuillez modifier les mots de passe dans .env
    pause
)

echo [SUCCESS] Environnement configuré ✓

REM Menu principal
:menu
echo.
echo Choisissez une option:
echo 1. Déploiement complet (recommandé)
echo 2. Démarrer les services existants
echo 3. Arrêter les services
echo 4. Voir les logs
echo 5. Reconstruire les images
echo 6. Nettoyer (supprimer conteneurs et volumes)
echo 7. Quitter
echo.
set /p choice="Votre choix [1-7]: "

if "%choice%"=="1" goto full_deploy
if "%choice%"=="2" goto start_services
if "%choice%"=="3" goto stop_services
if "%choice%"=="4" goto show_logs
if "%choice%"=="5" goto rebuild
if "%choice%"=="6" goto clean
if "%choice%"=="7" goto end
echo Option invalide
goto menu

:full_deploy
echo [INFO] Démarrage du déploiement complet...

echo [INFO] Arrêt des conteneurs existants...
docker-compose -f docker-compose.prod.yml down 2>nul

echo [INFO] Construction et démarrage des conteneurs...
docker-compose -f docker-compose.prod.yml up --build -d

echo [INFO] Attente de la base de données...
timeout /t 30 /nobreak >nul

echo [INFO] Exécution des migrations...
docker-compose -f docker-compose.prod.yml exec backend php bin/console doctrine:migrations:migrate --no-interaction

echo [SUCCESS] Déploiement terminé ✓
echo.
echo 📊 Services disponibles:
echo   • Frontend (Vue.js): http://localhost:3000
echo   • Backend (Symfony): http://localhost:8000
echo   • API: http://localhost:8000/api
echo   • Base de données: localhost:5432
echo.
set /p logs="Voulez-vous voir les logs? (y/N): "
if /i "%logs%"=="y" goto show_logs
goto menu

:start_services
echo [INFO] Démarrage des services...
docker-compose -f docker-compose.prod.yml up -d
echo [SUCCESS] Services démarrés ✓
goto menu

:stop_services
echo [INFO] Arrêt des services...
docker-compose -f docker-compose.prod.yml down
echo [SUCCESS] Services arrêtés ✓
goto menu

:show_logs
echo [INFO] Affichage des logs (Ctrl+C pour arrêter)...
docker-compose -f docker-compose.prod.yml logs -f
goto menu

:rebuild
echo [INFO] Reconstruction des images...
docker-compose -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.prod.yml up -d
echo [SUCCESS] Images reconstruites ✓
goto menu

:clean
echo [WARNING] Cette action va supprimer tous les conteneurs et volumes!
set /p confirm="Êtes-vous sûr? (y/N): "
if /i "%confirm%"=="y" (
    docker-compose -f docker-compose.prod.yml down -v
    docker system prune -f
    echo [SUCCESS] Nettoyage terminé ✓
)
goto menu

:end
echo Au revoir!
pause
