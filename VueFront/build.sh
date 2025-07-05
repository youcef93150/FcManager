#!/bin/bash
# Script de build pour Vercel - résout les problèmes de permissions

echo "🚀 Démarrage du build PSG Application..."

# Donner les permissions d'exécution à vite
chmod +x ./node_modules/.bin/vite

# Lancer le build
npm run build

echo "✅ Build terminé avec succès!"
