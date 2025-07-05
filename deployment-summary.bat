@echo off
cls
echo ========================================
echo    DÉPLOIEMENT PSG DOCKER - RÉSUMÉ
echo ========================================
echo.

echo 📁 FICHIERS CRÉÉS POUR LE DÉPLOIEMENT :
echo.
echo ┌─ Configuration Docker
echo │  ├── docker-compose.prod.yml     # Orchestration des services
echo │  ├── .env                        # Variables locales
echo │  ├── .env.docker                 # Variables Docker
echo │  └── VueFront/
echo │      ├── Dockerfile              # Image Vue.js + Nginx
echo │      └── nginx.conf              # Configuration Nginx
echo │  └── Symfony_Projet/
echo │      ├── Dockerfile              # Image Symfony + Apache
echo │      └── apache-config.conf      # Configuration Apache
echo │
echo ├─ Scripts de Gestion
echo │  ├── start-psg-app.bat          # 🚀 Démarrage automatique
echo │  ├── stop-psg-app.bat           # 🛑 Arrêt propre
echo │  └── test-psg-app.bat           # 🔍 Tests de santé
echo │
echo └─ Documentation
echo    ├── README-DOCKER.md            # Guide d'utilisation
echo    └── DEPLOYMENT-EXPLAINED.md     # Explication détaillée
echo.

echo ========================================
echo         UTILISATION RAPIDE
echo ========================================
echo.
echo 1️⃣ DÉMARRER L'APPLICATION :
echo    .\start-psg-app.bat
echo.
echo 2️⃣ TESTER L'APPLICATION :
echo    .\test-psg-app.bat
echo.
echo 3️⃣ ARRÊTER L'APPLICATION :
echo    .\stop-psg-app.bat
echo.

echo ========================================
echo           SERVICES DÉPLOYÉS
echo ========================================
echo.
echo 🌐 Frontend Vue.js    : http://localhost:3000
echo 🔧 Backend Symfony    : http://localhost:8000
echo 📊 API Documentation  : http://localhost:8000/api
echo 🗄️ Base de données    : localhost:3306 (vue_psg)
echo.

echo ========================================
echo         ARCHITECTURE DÉPLOYÉE
echo ========================================
echo.
echo Frontend (Vue.js + Nginx)
echo     ↕ Port 3000
echo Backend (Symfony + Apache)
echo     ↕ Port 8000
echo Database (MySQL 8.0)
echo     ↕ Port 3306
echo.

if exist "docker-compose.prod.yml" (
    echo ✅ Configuration Docker prête
) else (
    echo ❌ Configuration Docker manquante
)

if exist "start-psg-app.bat" (
    echo ✅ Script de démarrage prêt
) else (
    echo ❌ Script de démarrage manquant
)

if exist ".env.docker" (
    echo ✅ Variables d'environnement configurées
) else (
    echo ❌ Variables d'environnement manquantes
)

echo.
echo ========================================
echo.
echo 🎉 DÉPLOIEMENT DOCKER PSG TERMINÉ !
echo.
echo 📖 Lisez DEPLOYMENT-EXPLAINED.md pour tous les détails
echo 🚀 Lancez start-psg-app.bat pour démarrer
echo.
echo ========================================
echo.
pause
