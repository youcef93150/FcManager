# Dockerfile pour le frontend Vue.js
FROM node:18-alpine AS build

# Variables d'environnement
ARG VITE_API_URL=http://localhost:8000
ENV VITE_API_URL=$VITE_API_URL

# Définir le répertoire de travail
WORKDIR /app

# Copier package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances avec npm install pour corriger le problème Rollup
RUN npm install

# Copier le code source
COPY . .

# Construire l'application
RUN npm run build

# Étape de production avec nginx
FROM nginx:alpine

# Copier les fichiers buildés
COPY --from=build /app/dist /usr/share/nginx/html

# Copier la configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Exposer le port 80
EXPOSE 80

# Démarrer nginx
CMD ["nginx", "-g", "daemon off;"]
