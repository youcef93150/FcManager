import { createRouter, createWebHistory } from 'vue-router'
import AccueilUser from '@/components/AccueilUser.vue'
import AccueilAdmin from '@/components/AccueilAdmin.vue'
import Login from '@/components/Login.vue'
import Register from '@/components/Register.vue'
import BoutiqueAdmin from '@/components/BoutiqueAdmin.vue'
import BoutiqueUser from '@/components/BoutiqueUser.vue'
import Classement from '@/components/Classement.vue'
import ClassementAPI from '@/components/ClassementAPI.vue'
import JoueursAdmin from '@/components/JoueursAdmin.vue'
import JoueursUser from '@/components/JoueursUser.vue'
import PsgResults from '@/components/PsgResults.vue'

const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login
  },
  {
    path: '/AccueilUser',
    name: 'AccueilUser',
    component: AccueilUser,
    meta: { requiresAuth: true }
  },
  {
    path: '/AccueilAdmin',
    name: 'AccueilAdmin',
    component: AccueilAdmin,
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/login',
    name: 'LoginPage',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  },
  {
    path: '/boutique',
    name: 'BoutiqueUser',
    component: BoutiqueUser,
    meta: { requiresAuth: true }
  },
  {
    path: '/boutiqueadmin',
    name: 'BoutiqueAdmin',
    component: BoutiqueAdmin,
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/classement',
    name: 'Classement',
    component: Classement
  },
  {
    path: '/classement-api',
    name: 'ClassementAPI',
    component: ClassementAPI
  },
  {
    path: '/joueurs',
    name: 'JoueursUser',
    component: JoueursUser,
    meta: { requiresAuth: true }
  },
  {
    path: '/joueursadmin',
    name: 'JoueursAdmin',
    component: JoueursAdmin,
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/resultats',
    name: 'PsgResults',
    component: PsgResults
  }
]

const router = createRouter({
  history: createWebHistory('/'), // Corrigé : remplacé process.env.BASE_URL par '/'
  routes
})

// Guard de navigation pour vérifier l'authentification
router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('authToken');
  const userRole = localStorage.getItem('userRole');
  
  console.log('Navigation vers:', to.path);
  console.log('Authentifié:', isAuthenticated);
  console.log('Rôle:', userRole);
  
  // Vérifier si la route nécessite une authentification
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!isAuthenticated) {
      console.log('Redirection vers /login - pas authentifié');
      next('/login');
      return;
    }
    
    // Vérifier si la route nécessite des privilèges admin
    if (to.matched.some(record => record.meta.requiresAdmin)) {
      if (userRole !== 'admin') {
        console.log('Redirection vers /AccueilUser - pas admin');
        next('/AccueilUser');
        return;
      }
    }
  }
  
  // Si l'utilisateur est connecté et va sur login, rediriger selon son rôle
  if ((to.path === '/login' || to.path === '/') && isAuthenticated) {
    if (userRole === 'admin') {
      console.log('Redirection admin vers /AccueilAdmin');
      next('/AccueilAdmin');
    } else {
      console.log('Redirection utilisateur vers /AccueilUser');
      next('/AccueilUser');
    }
    return;
  }
  
  next();
});

export default router