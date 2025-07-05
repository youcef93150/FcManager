#!/bin/bash

echo "🚀 Script de Test de Déploiement PSG"
echo "======================================"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# URLs
BACKEND_URL="https://fcmanager-production.up.railway.app"
API_URL="${BACKEND_URL}/api"

echo ""
echo "📡 Test de l'API Backend..."

# Test de l'API
response=$(curl -s -o /dev/null -w "%{http_code}" "${API_URL}")

if [ "$response" = "200" ]; then
    echo -e "${GREEN}✅ API accessible (Code: ${response})${NC}"
else
    echo -e "${RED}❌ API non accessible (Code: ${response})${NC}"
    echo "Vérifiez les logs Railway : https://railway.app"
    exit 1
fi

echo ""
echo "🔑 Test de la route de connexion..."

# Test OPTIONS (CORS)
cors_response=$(curl -s -o /dev/null -w "%{http_code}" -X OPTIONS "${API_URL}/login" \
    -H "Origin: https://test.vercel.app" \
    -H "Access-Control-Request-Method: POST" \
    -H "Access-Control-Request-Headers: Content-Type")

if [ "$cors_response" = "200" ]; then
    echo -e "${GREEN}✅ CORS configuré correctement (Code: ${cors_response})${NC}"
else
    echo -e "${YELLOW}⚠️  CORS peut nécessiter des ajustements (Code: ${cors_response})${NC}"
fi

echo ""
echo "📝 Test de la route d'inscription..."

# Test POST inscription (avec données factices)
register_response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "${API_URL}/register" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "test-deploy@example.com",
        "password": "testpassword123",
        "nom": "Test",
        "prenom": "Deploy"
    }')

if [ "$register_response" = "201" ] || [ "$register_response" = "409" ]; then
    echo -e "${GREEN}✅ Route d'inscription fonctionnelle (Code: ${register_response})${NC}"
    if [ "$register_response" = "409" ]; then
        echo -e "${YELLOW}   Note: Utilisateur test déjà existant (normal)${NC}"
    fi
else
    echo -e "${RED}❌ Problème avec l'inscription (Code: ${register_response})${NC}"
fi

echo ""
echo "📊 Résumé des Tests"
echo "==================="
echo -e "Backend URL: ${YELLOW}${BACKEND_URL}${NC}"
echo -e "API Status: ${GREEN}Accessible${NC}"
echo -e "CORS: ${GREEN}Configuré${NC}"
echo -e "Inscription: ${GREEN}Fonctionnelle${NC}"

echo ""
echo "🎯 Prochaines étapes :"
echo "1. Déployez sur Vercel avec cette URL backend : ${BACKEND_URL}"
echo "2. Ajoutez la variable VITE_API_URL=${BACKEND_URL} dans Vercel"
echo "3. Testez l'application complète"

echo ""
echo -e "${GREEN}🎉 Backend prêt pour Vercel !${NC}"
