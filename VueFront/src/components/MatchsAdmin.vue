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
      <h1>⚽ Gestion des Matchs</h1>
      <p>Planifiez et gérez les matchs du PSG</p>
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
      <div class="tab-content">
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
    </div>
  </div>
</template>

<script>
import axios from '@/utils/auth';

export default {
  name: 'MatchsAdmin',
  data() {
    return {
      loading: false,
      showMatchForm: false,
      isSubmitting: false,
      editingMatch: null,
      activeTab: 'matches',
      
      // ===== CONFIGURATION =====
      tabs: [
        { id: 'actualites', label: 'Actualités', route: '/AccueilAdmin' },
        { id: 'matches', label: 'Matchs' },
        { id: 'entrainements', label: 'Entraînements', route: '/EntrainementsAdmin' },
        { id: 'joueurs', label: 'Gérer les joueurs', route: '/JoueursAdmin' },
        { id: 'boutique', label: 'Gérer la boutique', route: '/BoutiqueAdmin' },
      ],
      
      matches: [],
      matchStats: {
        totalMatchs: 0,
        matchsJoues: 0,
        victoires: 0,
        defaites: 0,
        nuls: 0,
        prochainsMatchs: 0,
        pourcentageVictoires: 0
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
          this.loadMatches(),
          this.loadMatchStats()
        ]);
      } catch (error) {
        console.error('Erreur de chargement:', error);
      } finally {
        this.loading = false;
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

    async saveMatch() {
      if (!this.matchForm.equipe_adverse || !this.matchForm.date_match || 
          !this.matchForm.competition || !this.matchForm.lieu || !this.matchForm.stade) {
        alert('Remplissez tous les champs obligatoires');
        return;
      }

      const matchData = {
        date_match: this.matchForm.date_match,
        competition: this.matchForm.competition,
        stade: this.matchForm.stade,
        statut: this.matchForm.statut
      };

      if (this.matchForm.lieu === 'Domicile') {
        matchData.equipe_domicile = 'PSG';
        matchData.equipe_exterieur = this.matchForm.equipe_adverse;
        if (this.matchForm.score_psg !== null) {
          matchData.score_domicile = this.matchForm.score_psg;
        }
        if (this.matchForm.score_adverse !== null) {
          matchData.score_exterieur = this.matchForm.score_adverse;
        }
      } else {
        matchData.equipe_domicile = this.matchForm.equipe_adverse;
        matchData.equipe_exterieur = 'PSG';
        if (this.matchForm.score_psg !== null) {
          matchData.score_exterieur = this.matchForm.score_psg;
        }
        if (this.matchForm.score_adverse !== null) {
          matchData.score_domicile = this.matchForm.score_adverse;
        }
      }

      this.isSubmitting = true;
      try {
        if (this.editingMatch) {
          await axios.put(`http://localhost:8000/api/matchs/${this.editingMatch.id}`, matchData);
          alert('Match modifié avec succès');
        } else {
          await axios.post('http://localhost:8000/api/matchs', matchData);
          alert('Match créé avec succès');
        }
        
        await this.loadMatches();
        await this.loadMatchStats();
        this.cancelMatchForm();
      } catch (error) {
        console.error('Erreur sauvegarde match:', error);
        alert('Erreur lors de la sauvegarde');
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
        alert('Match supprimé');
      } catch (error) {
        console.error('Erreur suppression match:', error);
        alert('Erreur lors de la suppression');
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
