// Configuration de l'API pour le développement et la production
const API_CONFIG = {
  // URL de base de l'API
  BASE_URL: import.meta.env.VITE_API_URL || 'http://localhost:8000',
  
  // Endpoints de l'API
  ENDPOINTS: {
    LOGIN: '/api/login',
    REGISTER: '/api/register',
    ACTUALITES: '/api/actualites',
    JOUEURS: '/api/joueurs',
    PRODUITS: '/api/produits',
    MATCHS: '/api/matchs',
    ENTRAINEMENTS: '/api/entrainements',
    DASHBOARD_STATS: '/api/dashboard/stats'
  }
}

// Fonction utilitaire pour construire l'URL complète
export const getApiUrl = (endpoint) => {
  return `${API_CONFIG.BASE_URL}${endpoint}`
}

// Export de la configuration
export default API_CONFIG
