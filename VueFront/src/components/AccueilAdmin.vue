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
            <p>Joueurs PSG</p>
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

        <!-- ======================== MATCHS TAB ======================== -->
        <div v-if="activeTab === 'matches'" class="tab-content">
          <div class="main">
            <div class="card">
              <h2>⚽ Gestion des matchs</h2>

              <!-- Formulaire d'ajout/modification de match -->
              <div v-if="showMatchForm" class="form">
                <h3>{{ editingMatch ? 'Modifier le match' : 'Programmer un nouveau match' }}</h3>
                
                <div class="form-row">
                  <input v-model="matchForm.equipe_adverse" placeholder="Équipe adverse" class="input" required>
                  <select v-model="matchForm.competition" class="input" required>
                    <option value="">Compétition</option>
                    <option value="Ligue 1">Ligue 1</option>
                    <option value="Coupe de France">Coupe de France</option>
                    <option value="Ligue des Champions">Ligue des Champions</option>
                    <option value="Ligue Europa">Ligue Europa</option>
                    <option value="Trophée des Champions">Trophée des Champions</option>
                    <option value="Match amical">Match amical</option>
                  </select>
                </div>

                <div class="form-row">
                  <input v-model="matchForm.date_match" type="datetime-local" class="input" required>
                  <select v-model="matchForm.lieu" class="input" required>
                    <option value="">Lieu</option>
                    <option value="Domicile">Domicile</option>
                    <option value="Extérieur">Extérieur</option>
                  </select>
                </div>

                <input v-model="matchForm.stade" placeholder="Stade" class="input" required>

                <select v-model="matchForm.statut" class="input">
                  <option value="programme">Programmé</option>
                  <option value="en-cours">En cours</option>
                  <option value="termine">Terminé</option>
                  <option value="reporte">Reporté</option>
                  <option value="annule">Annulé</option>
                </select>

                <!-- Section des scores (uniquement si match terminé) -->
                <div v-if="matchForm.statut === 'termine'" class="score-section">
                  <h4>Résultat du match</h4>
                  <div class="form-row">
                    <div class="score-input">
                      <label>Score PSG</label>
                      <input v-model="matchForm.score_psg" type="number" class="input" min="0">
                    </div>
                    <div class="score-input">
                      <label>Score {{ matchForm.equipe_adverse || 'Adversaire' }}</label>
                      <input v-model="matchForm.score_adverse" type="number" class="input" min="0">
                    </div>
                  </div>
                </div>

                <div class="form-actions">
                  <button @click="saveMatch" class="btn-success" :disabled="isSubmitting">
                    {{ isSubmitting ? '⏳ Sauvegarde...' : (editingMatch ? '✅ Modifier' : '✅ Créer') }}
                  </button>
                  <button @click="cancelMatchForm" class="btn-secondary">Annuler</button>
                </div>
              </div>

              <!-- Liste des matchs -->
              <div v-if="!showMatchForm" class="matches-list">
                <div v-if="matches.length === 0" class="empty">
                  <p>Aucun match programmé</p>
                </div>
                
                <div v-for="match in matches" :key="match.id" class="match-item">
                  <div class="match-header">
                    <h4>
                      <span v-if="match.lieu === 'Domicile'">PSG vs {{ match.equipe_adverse }}</span>
                      <span v-else>{{ match.equipe_adverse }} vs PSG</span>
                    </h4>
                    <div class="match-actions">
                      <button @click="editMatch(match)" class="btn-secondary">✏️</button>
                      <button @click="deleteMatch(match.id)" class="btn-danger">🗑️</button>
                    </div>
                  </div>
                  
                  <div class="match-info">
                    <span>📅 {{ formatDateTime(match.date_match) }}</span>
                    <span>🏆 {{ match.competition }}</span>
                    <span :class="['venue', match.lieu.toLowerCase()]">{{ match.lieu }}</span>
                    <span :class="['status', match.statut]">{{ formatStatus(match.statut) }}</span>
                  </div>

                  <div class="match-detail">
                    <span>🏟️ {{ match.stade }}</span>
                  </div>

                  <!-- Résultat si match terminé -->
                  <div v-if="match.statut === 'termine' && (match.score_psg !== null && match.score_adverse !== null)" class="match-result">
                    <div class="score">
                      <span class="team">PSG</span>
                      <span class="result">{{ match.score_psg }} - {{ match.score_adverse }}</span>
                      <span class="team">{{ match.equipe_adverse }}</span>
                    </div>
                    <div class="match-outcome">
                      <span v-if="match.score_psg > match.score_adverse" class="victory">🏆 Victoire</span>
                      <span v-else-if="match.score_psg < match.score_adverse" class="defeat">😞 Défaite</span>
                      <span v-else class="draw">🤝 Match nul</span>
                    </div>
                  </div>
                </div>
              </div>
              
              <button v-if="!showMatchForm" @click="openMatchForm" class="add-btn">
                ➕ Programmer un match
              </button>
            </div>
          </div>

          <!-- Sidebar avec statistiques des matchs -->
          <div class="sidebar">
            <div class="card">
              <h3>📊 Statistiques</h3>
              <div class="stats-list">
                <div class="stat-row">
                  <span>Matchs joués:</span>
                  <span>{{ matchStats.matchsJoues }}</span>
                </div>
                <div class="stat-row">
                  <span>Victoires:</span>
                  <span>{{ matchStats.victoires }}</span>
                </div>
                <div class="stat-row">
                  <span>Défaites:</span>
                  <span>{{ matchStats.defaites }}</span>
                </div>
                <div class="stat-row">
                  <span>Nuls:</span>
                  <span>{{ matchStats.nuls }}</span>
                </div>
                <div class="stat-row">
                  <span>% Victoires:</span>
                  <span>{{ matchStats.pourcentageVictoires }}%</span>
                </div>
                <div class="stat-row">
                  <span>Prochains matchs:</span>
                  <span>{{ matchStats.prochainsMatchs }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ======================== ENTRAÎNEMENTS TAB ======================== -->
        <div v-if="activeTab === 'entrainements'" class="tab-content-single">
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
import axios from 'axios';

export default {
  name: 'AccueilAdmin',
  data() {
    return {
      // ===== NAVIGATION & UI STATE =====
      activeTab: 'actualites',
      loading: false,
      showNotifications: false,
      showAddForm: false,
      showTrainingForm: false,
      showMatchForm: false,
      isSubmitting: false,
      editingMatch: null,
      
      // ===== CONFIGURATION =====
      tabs: [
        { id: 'actualites', label: 'Actualités' },
        { id: 'matches', label: 'Matchs' },
        { id: 'entrainements', label: 'Entraînements' },
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
      trainings: [],
      matches: [],
      availablePlayers: [],
      
      // ===== FORMULAIRES =====
      newActualite: {
        titre: '',
        contenu: '',
        auteur: '',
        statut: 'publie'
      },
      
      newTraining: {
        titre: '',
        description: '',
        date_entrainement: '',
        lieu: '',
        duree_minutes: 120,
        type_entrainement: '',
        joueurs_ids: []
      },

      matchForm: {
        equipe_adverse: '',
        date_match: '',
        competition: '',
        lieu: '',
        stade: '',
        statut: 'programme',
        score_psg: null,
        score_adverse: null
      }
    }
  },
  
  async mounted() {
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
          this.loadActualites(),
          this.loadTrainings(),
          this.loadPlayers(),
          this.loadMatches(),
          this.loadMatchStats()
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

    async loadMatches() {
      try {
        const response = await axios.get('http://localhost:8000/api/matchs');
        this.matches = response.data || [];
      } catch (error) {
        console.error('Erreur matchs:', error);
        this.matches = [];
      }
    },

    async loadMatchStats() {
      try {
        const response = await axios.get('http://localhost:8000/api/matchs/stats');
        this.matchStats = response.data || {
          totalMatchs: 0,
          matchsJoues: 0,
          victoires: 0,
          defaites: 0,
          nuls: 0,
          prochainsMatchs: 0,
          pourcentageVictoires: 0
        };
      } catch (error) {
        console.error('Erreur stats matchs:', error);
      }
    },

    // ===== GESTION DES MATCHS =====
    async saveMatch() {
      if (!this.matchForm.equipe_adverse || !this.matchForm.date_match || 
          !this.matchForm.competition || !this.matchForm.lieu || !this.matchForm.stade) {
        alert('Remplissez tous les champs obligatoires');
        return;
      }

      this.isSubmitting = true;
      try {
        if (this.editingMatch) {
          await axios.put(`http://localhost:8000/api/matchs/${this.editingMatch.id}`, this.matchForm);
          this.showSuccess('Match modifié avec succès');
        } else {
          await axios.post('http://localhost:8000/api/matchs', this.matchForm);
          this.showSuccess('Match créé avec succès');
        }
        
        await this.loadMatches();
        await this.loadMatchStats();
        this.cancelMatchForm();
      } catch (error) {
        console.error('Erreur sauvegarde match:', error);
        this.showError('Erreur lors de la sauvegarde');
      } finally {
        this.isSubmitting = false;
      }
    },

    async deleteMatch(id) {
      if (!confirm('Supprimer ce match ?')) return;

      try {
        await axios.delete(`http://localhost:8000/api/matchs/${id}`);
        await this.loadMatches();
        await this.loadMatchStats();
        this.showSuccess('Match supprimé');
      } catch (error) {
        console.error('Erreur suppression match:', error);
        this.showError('Erreur lors de la suppression');
      }
    },

    openMatchForm() {
      this.showMatchForm = true;
      this.editingMatch = null;
      this.resetMatchForm();
      const nextWeek = new Date();
      nextWeek.setDate(nextWeek.getDate() + 7);
      nextWeek.setHours(21, 0, 0, 0);
      this.matchForm.date_match = nextWeek.toISOString().slice(0, 16);
    },

    editMatch(match) {
      this.editingMatch = match;
      this.showMatchForm = true;
      this.matchForm = {
        equipe_adverse: match.equipe_adverse,
        date_match: new Date(match.date_match).toISOString().slice(0, 16),
        competition: match.competition,
        lieu: match.lieu,
        stade: match.stade,
        statut: match.statut,
        score_psg: match.score_psg,
        score_adverse: match.score_adverse
      };
    },

    cancelMatchForm() {
      this.showMatchForm = false;
      this.editingMatch = null;
      this.resetMatchForm();
    },

    resetMatchForm() {
      this.matchForm = {
        equipe_adverse: '',
        date_match: '',
        competition: '',
        lieu: '',
        stade: '',
        statut: 'programme',
        score_psg: null,
        score_adverse: null
      };
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

    // ===== GESTION DES ENTRAÎNEMENTS =====
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
        this.showSuccess('Entraînement créé');
      } catch (error) {
        console.error('Erreur création entraînement:', error);
        this.showError('Erreur lors de la création');
      } finally {
        this.isSubmitting = false;
      }
    },

    async deleteTraining(id) {
      if (!confirm('Supprimer cet entraînement ?')) return;

      try {
        await axios.delete(`http://localhost:8000/api/entrainements/${id}`);
        await this.loadTrainings();
        this.showSuccess('Entraînement supprimé');
      } catch (error) {
        console.error('Erreur suppression entraînement:', error);
        this.showError('Erreur lors de la suppression');
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
        titre: '', description: '', date_entrainement: '', lieu: '',
        duree_minutes: 120, type_entrainement: '', joueurs_ids: []
      };
    },

    // ===== UTILITAIRES =====
    formatDate(dateString) {
      return new Date(dateString).toLocaleDateString('fr-FR');
    },

    formatDateTime(dateString) {
      return new Date(dateString).toLocaleDateString('fr-FR', {
        weekday: 'long', day: 'numeric', month: 'long',
        hour: '2-digit', minute: '2-digit'
      });
    },

    formatStatus(status) {
      const statusMap = {
        'programme': 'Programmé',
        'en-cours': 'En cours',
        'termine': 'Terminé',
        'reporte': 'Reporté',
        'annule': 'Annulé'
      };
      return statusMap[status] || status;
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
      localStorage.removeItem("authToken");
      this.$router.push("/login");
    }
  }
};
</script>

<style scoped>
/* ===== RESET & BASE ===== */
* {
  box-sizing: border-box;
}

/* ===== NAVIGATION ===== */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #9ca3af;
  padding: 15px 25px;
  color: white;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.logo-img { 
  height: 50px; 
}

.nav-links {
  flex: 1;
  display: flex;
  justify-content: center;
}

.nav-actions {
  display: flex;
  gap: 15px;
  align-items: center;
}

.notification-btn, .logout-button {
  background: #d1d5db;
  border: none;
  color: #374151;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.notification-btn:hover, .logout-button:hover {
  background: #6b7280;
  color: white;
}

.badge {
  background: white;
  color: #9ca3af;
  border-radius: 50%;
  padding: 2px 6px;
  font-size: 12px;
  margin-left: 5px;
  font-weight: bold;
}

/* ===== HERO SECTION ===== */
.hero-section {
  background: linear-gradient(45deg, #9ca3af, #d1d5db);
  color: white;
  text-align: center;
  padding: 40px 20px;
}

.hero-section h1 {
  font-size: 36px;
  font-weight: bold;
  margin-bottom: 10px;
}

.hero-section p {
  font-size: 18px;
  margin-bottom: 30px;
  opacity: 0.9;
}

.tabs {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-top: 20px;
  flex-wrap: wrap;
}

.tab-btn {
  background: rgba(255,255,255,0.2);
  color: white;
  border: none;
  padding: 12px 20px;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s;
  font-weight: 500;
  font-size: 14px;
  white-space: nowrap;
}

.tab-btn:hover {
  background: rgba(255,255,255,0.3);
  transform: translateY(-2px);
}

.tab-btn.active {
  background: white;
  color: #9ca3af;
  font-weight: bold;
  box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

/* ===== LOADING ===== */
.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 50px;
  color: #9ca3af;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #9ca3af;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* ===== DASHBOARD ===== */
.dashboard {
  max-width: 1200px;
  margin: 0 auto;
  padding: 30px 20px;
  background-color: #f7fafc;
  min-height: calc(100vh - 180px);
}

/* ===== STATISTICS CARDS ===== */
.stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.stat-card {
  background: white;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-left: 4px solid #9ca3af;
  transition: transform 0.3s, box-shadow 0.3s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0,0,0,0.15);
}

.stat-info p {
  margin: 0;
  color: #9ca3af;
  font-size: 14px;
  font-weight: 500;
}

.stat-info h3 {
  margin: 8px 0 0 0;
  color: #4b5563;
  font-size: 28px;
  font-weight: bold;
}

.stat-icon {
  font-size: 32px;
  opacity: 0.8;
}

/* ===== CONTENT LAYOUT ===== */
.content {
  display: grid;
  gap: 30px;
}

.tab-content {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 30px;
}

.tab-content-single {
  display: grid;
  grid-template-columns: 1fr;
}

.main {
  display: flex;
  flex-direction: column;
}

.sidebar {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* ===== CARDS ===== */
.card {
  background: white;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  border: 1px solid #e2e8f0;
}

.card h2, .card h3 {
  color: #4b5563;
  margin-bottom: 24px;
  font-weight: bold;
}

.card h2 {
  font-size: 24px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.card h3 {
  font-size: 20px;
}

/* ===== FORMS ===== */
.form {
  background: #f7fafc;
  padding: 24px;
  border-radius: 12px;
  margin-bottom: 24px;
  border: 2px solid #e2e8f0;
}

.form h3 {
  color: #4b5563;
  margin-bottom: 20px;
  font-size: 18px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 16px;
}

.input, .textarea, select {
  width: 100%;
  padding: 12px;
  border: 1px solid #cbd5e0;
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.3s, box-shadow 0.3s;
}

.input:focus, .textarea:focus, select:focus {
  outline: none;
  border-color: #9ca3af;
  box-shadow: 0 0 0 3px rgba(156, 163, 175, 0.1);
}

.textarea {
  resize: vertical;
  min-height: 100px;
  font-family: inherit;
}

.form-actions {
  display: flex;
  gap: 12px;
  margin-top: 24px;
}

/* ===== SCORE SECTION ===== */
.score-section {
  background: linear-gradient(135deg, #edf2f7 0%, #e2e8f0 100%);
  padding: 20px;
  border-radius: 12px;
  margin: 20px 0;
  border-left: 4px solid #718096;
}

.score-section h4 {
  color: #2d3748;
  margin-bottom: 16px;
  font-size: 16px;
}

.score-input {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.score-input label {
  font-weight: 600;
  color: #2d3748;
  font-size: 14px;
}

/* ===== PLAYERS SECTION ===== */
.players-section {
  margin: 24px 0;
}

.players-section label {
  font-weight: 600;
  color: #2d3748;
  margin-bottom: 12px;
  display: block;
}

.players-buttons {
  display: flex;
  gap: 12px;
  align-items: center;
  margin: 12px 0;
  flex-wrap: wrap;
}

.players-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 8px;
  max-height: 250px;
  overflow-y: auto;
  border: 1px solid #e2e8f0;
  padding: 12px;
  border-radius: 8px;
  background: white;
}

.player-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px;
  cursor: pointer;
  border-radius: 6px;
  transition: background-color 0.3s;
}

.player-item:hover {
  background: #f7fafc;
}

.player-item input[type="checkbox"] {
  margin: 0;
  cursor: pointer;
}

/* ===== BUTTONS ===== */
.btn-success {
  background: #48bb78;
  color: white;
  border: none;
  padding: 12px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: background-color 0.3s;
}

.btn-success:hover {
  background: #38a169;
}

.btn-secondary {
  background: #9ca3af;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.3s;
}

.btn-secondary:hover {
  background: #6b7280;
}

.btn-danger {
  background: #f56565;
  color: white;
  border: none;
  padding: 8px 12px;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.3s;
}

.btn-danger:hover {
  background: #e53e3e;
}

.add-btn {
  width: 100%;
  background: #9ca3af;
  color: white;
  border: none;
  padding: 16px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
  font-weight: bold;
  margin-top: 24px;
  transition: background-color 0.3s;
}

.add-btn:hover {
  background: #6b7280;
}

.btn-success:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* ===== LISTS ===== */
.news-list, .trainings-list, .matches-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.news-item, .training-item, .match-item {
  border: 1px solid #e2e8f0;
  padding: 20px;
  border-radius: 12px;
  transition: all 0.3s;
  background: white;
}

.news-item:hover, .training-item:hover, .match-item:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  transform: translateY(-1px);
}

.training-header, .match-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.match-actions {
  display: flex;
  gap: 8px;
}

.training-info, .match-info {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  color: #718096;
  margin: 12px 0;
}

.match-detail {
  margin: 10px 0;
  color: #718096;
  font-size: 14px;
}

/* ===== MATCH SPECIFIC STYLES ===== */
.venue {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: bold;
}

.venue.domicile {
  background: #bee3f8;
  color: #2b6cb0;
}

.venue.extérieur {
  background: #fed7d7;
  color: #c53030;
}

.status {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: bold;
}

.status.programme {
  background: #bee3f8;
  color: #2b6cb0;
}

.status.en-cours {
  background: #faf089;
  color: #975a16;
}

.status.termine {
  background: #c6f6d5;
  color: #276749;
}

.status.reporte {
  background: #fed7aa;
  color: #c05621;
}

.status.annule {
  background: #fed7d7;
  color: #c53030;
}

.match-result {
  background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
  padding: 20px;
  border-radius: 12px;
  margin: 16px 0;
  text-align: center;
  border: 2px solid #e2e8f0;
}

.score {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 12px;
}

.result {
  font-size: 28px;
  color: #2d3748;
  font-weight: 900;
}

.team {
  color: #4a5568;
  font-weight: 600;
}

.match-outcome {
  margin-top: 12px;
}

.victory {
  color: #48bb78;
  font-weight: bold;
  font-size: 16px;
}

.defeat {
  color: #f56565;
  font-weight: bold;
  font-size: 16px;
}

.draw {
  color: #ed8936;
  font-weight: bold;
  font-size: 16px;
}

/* ===== PLAYER TAGS ===== */
.player-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 8px;
}

.player-tag {
  background: #bee3f8;
  color: #2b6cb0;
  padding: 4px 10px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 500;
}

.actions {
  margin-top: 12px;
}

.empty {
  text-align: center;
  padding: 60px 20px;
  color: #718096;
  background: #f7fafc;
  border-radius: 12px;
  border: 2px dashed #e2e8f0;
}

/* ===== SIDEBAR STATS ===== */
.stats-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.stat-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #e2e8f0;
  font-size: 14px;
}

.stat-row:last-child {
  border-bottom: none;
}

.stat-row span:first-child {
  color: #4a5568;
  font-weight: 500;
}

.stat-row span:last-child {
  color: #2d3748;
  font-weight: bold;
}

/* ===== NOTIFICATIONS PANEL ===== */
.notifications-panel {
  position: fixed;
  top: 0;
  right: 0;
  width: 400px;
  height: 100vh;
  background: white;
  box-shadow: -4px 0 20px rgba(0,0,0,0.15);
  z-index: 1000;
  transform: translateX(0);
  transition: transform 0.3s ease;
}

.panel-header {
  background: #9ca3af;
  color: white;
  padding: 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.panel-header h3 {
  margin: 0;
  font-size: 18px;
}

.panel-header button {
  background: none;
  border: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  transition: background-color 0.3s;
}

.panel-header button:hover {
  background: rgba(255,255,255,0.1);
}

.panel-body {
  padding: 20px;
  height: calc(100vh - 88px);
  overflow-y: auto;
}

.notification {
  padding: 16px;
  border-bottom: 1px solid #e2e8f0;
  border-radius: 8px;
  margin-bottom: 8px;
}

.notification.success {
  background: #c6f6d5;
  border-left: 4px solid #48bb78;
}

.notification.error {
  background: #fed7d7;
  border-left: 4px solid #f56565;
}

.notification p {
  margin: 0 0 4px 0;
  font-weight: 500;
  color: #2d3748;
}

.notification small {
  color: #718096;
  font-size: 12px;
}

/* ===== RESPONSIVE DESIGN ===== */
@media (max-width: 768px) {
  .stats {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
  }
  
  .tab-content {
    grid-template-columns: 1fr;
  }
  
  .form-row {
    grid-template-columns: 1fr;
  }
  
  .players-grid {
    grid-template-columns: 1fr;
  }
  
  .notifications-panel {
    width: 100%;
  }
  
  .tabs {
    flex-direction: column;
    gap: 10px;
  }

  .tab-btn {
    padding: 10px 20px;
    font-size: 14px;
  }

  .hero-section h1 {
    font-size: 28px;
  }

  .hero-section p {
    font-size: 16px;
  }

  .match-info, .training-info {
    flex-direction: column;
    gap: 8px;
  }

  .score {
    flex-direction: column;
    gap: 12px;
  }

  .match-actions {
    flex-direction: column;
    gap: 8px;
  }

  .players-buttons {
    flex-direction: column;
    align-items: flex-start;
  }
}

@media (max-width: 480px) {
  .dashboard {
    padding: 15px 10px;
  }
  
  .card {
    padding: 20px;
  }
  
  .stats {
    grid-template-columns: 1fr;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .navbar {
    padding: 10px 15px;
  }

  .nav-actions {
    gap: 10px;
  }

  .stat-card {
    padding: 16px;
  }

  .form {
    padding: 16px;
  }
  
  .tabs {
    gap: 8px;
  }
  
  .tab-btn {
    padding: 8px 14px;
    font-size: 12px;
  }
 
}
</style>