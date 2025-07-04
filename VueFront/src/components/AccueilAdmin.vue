<template>
  <div>
    <!-- Navigation -->
    <nav class="navbar">
      <div class="logo">
        <router-link to="/AccueilAdmin">
          <img src="@/assets/images/psg.png" alt="PSG Logo" class="logo-img" />
        </router-link>
      </div>
      <div class="nav-links">
        <!-- Navigation links vides maintenant -->
      </div>
      <div class="nav-actions">
        <button class="notification-btn" @click="toggleNotifications">
          🔔 <span v-if="notifications.length > 0" class="badge">{{ notifications.length }}</span>
        </button>
        <button class="logout-button" @click="logout">Déconnexion</button>
      </div>
    </nav>

    <!-- Header -->
    <header class="hero-section">
      <h1>Tableau de bord</h1>
      <p>Bienvenue sur la plateforme d'administration</p>
      <div class="tabs">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          @click="handleTabClick(tab)"
          :class="['tab-btn', { 'active': activeTab === tab.id }]"
        >
          {{ tab.label }}
        </button>
      </div>
    </header>

    <!-- Loading -->
    <div v-if="loading" class="loading">
      <div class="spinner"></div>
      <p>Chargement...</p>
    </div>

    <!-- Dashboard -->
    <div v-else class="dashboard">
      <!-- Statistics Cards -->
      <div class="stats">
        <div class="stat-card">
          <div class="stat-info">
            <p>Joueurs</p>
            <h3>{{ stats.totalJoueurs }}</h3>
          </div>
          <div class="stat-icon">👥</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Produits</p>
            <h3>{{ stats.produitsEnStock }}</h3>
          </div>
          <div class="stat-icon">🛍️</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Matchs joués</p>
            <h3>{{ matchStats.matchsJoues }}</h3>
          </div>
          <div class="stat-icon">⚽</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Victoires</p>
            <h3>{{ matchStats.victoires }}</h3>
          </div>
          <div class="stat-icon">🏆</div>
        </div>
      </div>

      <!-- Tab Content -->
      <div class="content">
        <!-- ======================== ACTUALITÉS TAB ======================== -->
        <div v-if="activeTab === 'actualites'" class="tab-content-single">
          <div class="card">
            <h2>📰 Actualités du club</h2>
            
            <button v-if="!showAddForm" @click="showAddForm = true" class="add-btn">
              ➕ Ajouter une actualité
            </button>
            
            <!-- Formulaire d'ajout d'actualité -->
            <div v-if="showAddForm" class="form">
              <h3>Ajouter une nouvelle actualité</h3>
              <input v-model="newActualite.titre" placeholder="Titre" class="input">
              <textarea v-model="newActualite.contenu" placeholder="Contenu" class="textarea"></textarea>
              <input v-model="newActualite.auteur" placeholder="Auteur" class="input">
              <div class="form-actions">
                <button @click="addActualite" class="btn-success">Publier</button>
                <button @click="showAddForm = false" class="btn-secondary">Annuler</button>
              </div>
            </div>

            <!-- Liste des actualités -->
            <div class="news-list">
              <div v-for="news in clubNews" :key="news.id" class="news-item">
                <div class="news-content">
                  <h4>{{ news.titre }}</h4>
                  <p>{{ news.contenu }}</p>
                  <small>Par {{ news.auteur }} - {{ formatDate(news.date_publication) }}</small>
                  <div class="actions">
                    <button @click="deleteActualite(news.id)" class="btn-danger">🗑️</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Notifications Panel -->
    <div v-if="showNotifications" class="notifications-panel">
      <div class="panel-header">
        <h3>Notifications</h3>
        <button @click="showNotifications = false">✕</button>
      </div>
      <div class="panel-body">
        <div v-for="notif in notifications" :key="notif.id" class="notification">
          <p>{{ notif.message }}</p>
          <small>{{ notif.time }}</small>
        </div>
        <div v-if="notifications.length === 0" class="notification">
          <p>Aucune notification</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from '@/utils/auth'; // Import modifié pour JWT

export default {
  name: 'AccueilAdmin',
  data() {
    return {
      // ===== NAVIGATION & UI STATE =====
      activeTab: 'actualites',
      loading: false,
      showNotifications: false,
      showAddForm: false,
      
      // ===== CONFIGURATION =====
      tabs: [
        { id: 'actualites', label: 'Actualités' },
        { id: 'matches', label: 'Matchs', route: '/MatchsAdmin' },
        { id: 'entrainements', label: 'Entraînements', route: '/EntrainementsAdmin' },
        { id: 'joueurs', label: 'Gérer les joueurs', route: '/JoueursAdmin' },
        { id: 'boutique', label: 'Gérer la boutique', route: '/BoutiqueAdmin' },
        
      ],
      
      // ===== STATISTIQUES =====
      stats: {
        totalJoueurs: 0,
        produitsEnStock: 0,
        totalActualites: 0,
        revenusThisMois: "0€"
      },

      matchStats: {
        totalMatchs: 0,
        matchsJoues: 0,
        victoires: 0,
        defaites: 0,
        nuls: 0,
        prochainsMatchs: 0,
        pourcentageVictoires: 0
      },
      
      // ===== DONNÉES =====
      notifications: [],
      clubNews: [],
      
      // ===== FORMULAIRES =====
      newActualite: {
        titre: '',
        contenu: '',
        auteur: '',
        statut: 'publie'
      }
    }
  },
  
  async mounted() {
    // Vérifier l'authentification JWT
    if (!localStorage.getItem('authToken')) {
      this.$router.push('/login');
      return;
    }

    // Vérifier le rôle admin
    const userRole = localStorage.getItem('userRole');
    if (userRole !== 'admin') {
      this.$router.push('/AccueilUser');
      return;
    }

    await this.loadData();
  },

  methods: {
    // ===== NAVIGATION =====
    handleTabClick(tab) {
      if (tab.route) {
        // Si l'onglet a une route, navigue vers cette page
        this.$router.push(tab.route);
      } else {
        // Sinon, change l'onglet actif
        this.activeTab = tab.id;
      }
    },

    // ===== CHARGEMENT DES DONNÉES =====
    async loadData() {
      this.loading = true;
      try {
        await Promise.all([
          this.loadStats(),
          this.loadActualites()
        ]);
      } catch (error) {
        console.error('Erreur de chargement:', error);
        this.showError('Erreur de chargement des données');
      } finally {
        this.loading = false;
      }
    },

    async loadStats() {
      try {
        const response = await axios.get('http://localhost:8000/api/dashboard/stats');
        this.stats = {
          totalJoueurs: response.data.totalJoueurs || 0,
          produitsEnStock: response.data.totalStock || 0,
          totalActualites: response.data.totalActualites || 0,
          revenusThisMois: response.data.revenus || "0€"
        };
      } catch (error) {
        console.error('Erreur stats:', error);
      }
    },

    async loadActualites() {
      try {
        const response = await axios.get('http://localhost:8000/api/actualites');
        this.clubNews = response.data || [];
      } catch (error) {
        console.error('Erreur actualités:', error);
        this.clubNews = [];
      }
    },

    // ===== GESTION DES ACTUALITÉS =====
    async addActualite() {
      if (!this.newActualite.titre || !this.newActualite.contenu) {
        alert('Titre et contenu requis');
        return;
      }

      try {
        await axios.post('http://localhost:8000/api/actualites', this.newActualite);
        await this.loadActualites();
        this.resetActualiteForm();
        this.showAddForm = false;
        this.showSuccess('Actualité ajoutée');
      } catch (error) {
        console.error('Erreur ajout actualité:', error);
        this.showError('Erreur lors de l\'ajout');
      }
    },

    async deleteActualite(id) {
      if (!confirm('Supprimer cette actualité ?')) return;

      try {
        await axios.delete(`http://localhost:8000/api/actualites/${id}`);
        await this.loadActualites();
        this.showSuccess('Actualité supprimée');
      } catch (error) {
        console.error('Erreur suppression actualité:', error);
        this.showError('Erreur lors de la suppression');
      }
    },

    resetActualiteForm() {
      this.newActualite = { titre: '', contenu: '', auteur: '', statut: 'publie' };
    },

    // ===== UTILITAIRES =====
    formatDate(dateString) {
      return new Date(dateString).toLocaleDateString('fr-FR');
    },

    showSuccess(message) {
      this.notifications.unshift({
        id: Date.now(), message, time: 'Maintenant', type: 'success'
      });
    },

    showError(message) {
      this.notifications.unshift({
        id: Date.now(), message, time: 'Maintenant', type: 'error'
      });
    },

    toggleNotifications() {
      this.showNotifications = !this.showNotifications;
    },

    logout() {
      // Nettoyer les données d'authentification JWT
      localStorage.removeItem("authToken");
      localStorage.removeItem("userRole");
      localStorage.removeItem("userId");
      this.$router.push("/login");
    }
  }
};
</script>

<style>
@import '@/assets/styles/admin.css';
</style>