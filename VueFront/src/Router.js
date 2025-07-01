import { createRouter, createWebHashHistory } from 'vue-router';
import Login from './components/Login.vue'; 
import Register from './components/Register.vue'; 
import Classement from './components/Classement.vue';
import PsgResults from './components/PsgResults.vue';
import AccueilUser from './components/AccueilUser.vue';
import AccueilAdmin from './components/AccueilAdmin.vue';
import JoueursAdmin from './components/JoueursAdmin.vue';
import JoueursUser from './components/JoueursUser.vue';
import BoutiqueAdmin from './components/BoutiqueAdmin.vue';
import BoutiqueUser from './components/BoutiqueUser.vue';

// Configuration des routes
const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login,
  },
  {
    path: "/BoutiqueUser",
    name: "BoutiqueUser",
    component: BoutiqueUser,
  },
  
  {
    path: '/BoutiqueAdmin',
    name: 'BoutiqueAdmin',
    component: BoutiqueAdmin,
  },

  {
    path: '/JoueursAdmin',
    name: 'JoueursAdmin',
    component: JoueursAdmin,
  },
  {
    path: '/JoueursUser',
    name: 'JoueursUser',
    component: JoueursUser,
  },

  {
    path: '/register',
    name: 'Register',
    component: Register,
  },
  {
    path: '/Classement',
    name: 'Classement',
    component: Classement,
  },
  {
    path: '/psg-results',
    name: 'PsgResults',
    component: PsgResults,
  },
  {
    path: '/AccueilUser',
    name: 'AccueilUser',
    component: AccueilUser,
  },
  {
    path: '/AccueilAdmin',
    name: 'AccueilAdmin',
    component: AccueilAdmin,
  },
  {
    path: '/',
    redirect: '/login', // Redirige vers la page de connexion par défaut
  },
  {
    path: '/:pathMatch(.*)*', // Gestion des routes inexistantes
    redirect: '/login',
  }

];

// Création du routeur
const router = createRouter({
  history: createWebHashHistory(), // Utilisation du mode hash pour les URLs
  routes,
});

// Exportation du routeur
export default router;
