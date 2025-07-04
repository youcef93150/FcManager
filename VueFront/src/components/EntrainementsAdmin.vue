<template>
  <div>
    <!-- Navigation -->
    <nav class="navbar">
      <div class="logo">
        <router-link to="/AccueilAdmin">
          <img src="@/assets/images/psg.png" alt="PSG Logo" class="logo-img" />
        </router-link>
      </div>
     
      <div class="nav-actions">
        <button class="logout-button" @click="logout">Déconnexion</button>
      </div>
    </nav>

    <!-- Header -->
    <header class="hero-section">
      <h1>🏃 Gestion des Entraînements</h1>
      <p>Planifiez et gérez les sessions d'entraînement du PSG</p>
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

    <!-- Content -->
    <div v-else class="dashboard">
      <div class="tab-content-single">
        <div class="card">
          <h2>🏃 Gestion des entraînements</h2>

          <!-- Formulaire d'entraînement -->
          <div v-if="showTrainingForm" class="form">
            <h3>Programmer un entraînement</h3>
            
            <div class="form-row">
              <input v-model="newTraining.titre" placeholder="Titre de l'entraînement" class="input">
              <select v-model="newTraining.type_entrainement" class="input">
                <option value="">Type d'entraînement</option>
                <option value="Tactique">Tactique</option>
                <option value="Physique">Physique</option>
                <option value="Technique">Technique</option>
                <option value="Match amical">Match amical</option>
                <option value="Récupération">Récupération</option>
              </select>
            </div>

            <textarea v-model="newTraining.description" placeholder="Description" class="textarea"></textarea>

            <div class="form-row">
              <input v-model="newTraining.date_entrainement" type="datetime-local" class="input">
              <input v-model="newTraining.duree_minutes" type="number" placeholder="Durée (min)" class="input" min="30" max="300">
            </div>

            <select v-model="newTraining.lieu" class="input">
              <option value="">Lieu</option>
              <option value="Centre d'entraînement Ooredoo">Centre d'entraînement Ooredoo</option>
              <option value="Parc des Princes">Parc des Princes</option>
              <option value="Camp des Loges">Camp des Loges</option>
            </select>

            <!-- Section sélection des joueurs -->
            <div class="players-section">
              <label>Joueurs convoqués :</label>
              <div class="players-buttons">
                <button @click="selectAllPlayers" class="btn-secondary">Tout sélectionner</button>
                <button @click="clearPlayers" class="btn-secondary">Tout désélectionner</button>
                <span>{{ newTraining.joueurs_ids.length }} sélectionné(s)</span>
              </div>
              
              <div class="players-grid">
                <label v-for="joueur in availablePlayers" :key="joueur.id" class="player-item">
                  <input type="checkbox" :value="joueur.id" v-model="newTraining.joueurs_ids">
                  <span>{{ joueur.prenom }} {{ joueur.nom }} ({{ joueur.poste }})</span>
                </label>
              </div>
            </div>

            <div class="form-actions">
              <button @click="addTraining" class="btn-success" :disabled="isSubmitting">
                {{ isSubmitting ? '⏳ Création...' : '✅ Créer' }}
              </button>
              <button @click="showTrainingForm = false" class="btn-secondary">Annuler</button>
            </div>
          </div>

          <!-- Liste des entraînements -->
          <div v-if="!showTrainingForm" class="trainings-list">
            <div v-if="trainings.length === 0" class="empty">
              <p>Aucun entraînement programmé</p>
            </div>
            
            <div v-for="training in trainings" :key="training.id" class="training-item">
              <div class="training-header">
                <h4>{{ training.titre }}</h4>
                <button @click="deleteTraining(training.id)" class="btn-danger">🗑️</button>
              </div>
              <p>{{ training.description }}</p>
              <div class="training-info">
                <span>📅 {{ formatDateTime(training.date_entrainement) }}</span>
                <span>⏰ {{ training.duree_minutes }}min</span>
                <span>📍 {{ training.lieu }}</span>
                <span>🏃 {{ training.type_entrainement }}</span>
              </div>
              <div v-if="training.joueurs_convoques" class="players">
                <p><strong>Joueurs convoqués ({{ training.nb_joueurs_convoques }}):</strong></p>
                <div class="player-tags">
                  <span v-for="joueur in training.joueurs_convoques.slice(0, 5)" :key="joueur.id" class="player-tag">
                    {{ joueur.prenom }} {{ joueur.nom }}
                  </span>
                  <span v-if="training.joueurs_convoques.length > 5" class="player-tag">
                    +{{ training.joueurs_convoques.length - 5 }} autres
                  </span>
                </div>
              </div>
            </div>
          </div>
          
          <button v-if="!showTrainingForm" @click="openTrainingForm" class="add-btn">
            ➕ Programmer un entraînement
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from '@/utils/auth';

export default {
  name: 'EntrainementsAdmin',
  data() {
    return {
      loading: false,
      showTrainingForm: false,
      isSubmitting: false,
      activeTab: 'entrainements',
      
      // ===== CONFIGURATION =====
      tabs: [
        { id: 'actualites', label: 'Actualités', route: '/AccueilAdmin' },
        { id: 'matches', label: 'Matchs', route: '/MatchsAdmin' },
        { id: 'entrainements', label: 'Entraînements' },
        { id: 'joueurs', label: 'Gérer les joueurs', route: '/JoueursAdmin' },
        { id: 'boutique', label: 'Gérer la boutique', route: '/BoutiqueAdmin' },
      ],
      
      trainings: [],
      availablePlayers: [],
      newTraining: {
        titre: '',
        description: '',
        date_entrainement: '',
        lieu: '',
        duree_minutes: 120,
        type_entrainement: '',
        joueurs_ids: []
      }
    }
  },

  async mounted() {
    if (!localStorage.getItem('authToken')) {
      this.$router.push('/login');
      return;
    }

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
        // Sinon, change l'onglet actif (reste sur la page actuelle)
        this.activeTab = tab.id;
      }
    },

    async loadData() {
      this.loading = true;
      try {
        await Promise.all([
          this.loadTrainings(),
          this.loadPlayers()
        ]);
      } catch (error) {
        console.error('Erreur de chargement:', error);
      } finally {
        this.loading = false;
      }
    },

    async loadTrainings() {
      try {
        const response = await axios.get('http://localhost:8000/api/entrainements');
        this.trainings = response.data || [];
      } catch (error) {
        console.error('Erreur entraînements:', error);
        this.trainings = [];
      }
    },

    async loadPlayers() {
      try {
        const response = await axios.get('http://localhost:8000/api/joueurs');
        this.availablePlayers = response.data.filter(j => j.equipe === 'PSG') || [];
      } catch (error) {
        console.error('Erreur joueurs:', error);
        this.availablePlayers = [];
      }
    },

    async addTraining() {
      if (!this.newTraining.titre || !this.newTraining.date_entrainement || !this.newTraining.lieu) {
        alert('Remplissez tous les champs obligatoires');
        return;
      }

      this.isSubmitting = true;
      try {
        await axios.post('http://localhost:8000/api/entrainements', this.newTraining);
        await this.loadTrainings();
        this.resetTrainingForm();
        this.showTrainingForm = false;
        alert('Entraînement créé avec succès');
      } catch (error) {
        console.error('Erreur création entraînement:', error);
        alert('Erreur lors de la création');
      } finally {
        this.isSubmitting = false;
      }
    },

    async deleteTraining(id) {
      if (!confirm('Supprimer cet entraînement ?')) return;

      try {
        await axios.delete(`http://localhost:8000/api/entrainements/${id}`);
        await this.loadTrainings();
        alert('Entraînement supprimé avec succès');
      } catch (error) {
        console.error('Erreur suppression entraînement:', error);
        alert('Erreur lors de la suppression');
      }
    },

    openTrainingForm() {
      this.showTrainingForm = true;
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      tomorrow.setHours(10, 0, 0, 0);
      this.newTraining.date_entrainement = tomorrow.toISOString().slice(0, 16);
    },

    selectAllPlayers() {
      this.newTraining.joueurs_ids = this.availablePlayers.map(p => p.id);
    },

    clearPlayers() {
      this.newTraining.joueurs_ids = [];
    },

    resetTrainingForm() {
      this.newTraining = {
        titre: '', 
        description: '', 
        date_entrainement: '', 
        lieu: '',
        duree_minutes: 120, 
        type_entrainement: '', 
        joueurs_ids: []
      };
    },

    formatDateTime(dateString) {
      return new Date(dateString).toLocaleDateString('fr-FR', {
        weekday: 'long', 
        day: 'numeric', 
        month: 'long',
        hour: '2-digit', 
        minute: '2-digit'
      });
    },

    logout() {
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
