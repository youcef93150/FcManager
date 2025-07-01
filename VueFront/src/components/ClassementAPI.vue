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
      <h1>Classement Ligue 1</h1>
      <p>Saison 2024/2025 - Suivez le championnat en temps réel</p>
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

    <!-- Dashboard -->
    <div class="dashboard">
      <!-- Loading -->
      <div v-if="loading" class="loading">
        <div class="spinner"></div>
        <p>Chargement du classement...</p>
      </div>

      <!-- Error -->
      <div v-if="error" class="error-card">
        <h3>⚠️ Erreur</h3>
        <p>{{ error }}</p>
        <button @click="refreshData" class="btn-secondary">🔄 Réessayer</button>
      </div>

      <!-- Content -->
      <div v-if="!loading && !error" class="content">
        <!-- Statistics Cards -->
        <div class="stats">
          <div class="stat-card psg-highlight" v-if="psgStats">
            <div class="stat-info">
              <p>Position PSG</p>
              <h3>{{ psgStats.position }}{{ getPositionSuffix(psgStats.position) }}</h3>
            </div>
            <div class="stat-icon">👑</div>
          </div>
          <div class="stat-card" v-if="psgStats">
            <div class="stat-info">
              <p>Points PSG</p>
              <h3>{{ psgStats.points }}</h3>
            </div>
            <div class="stat-icon">⚽</div>
          </div>
          <div class="stat-card">
            <div class="stat-info">
              <p>Leader</p>
              <h3>{{ leaderTeam?.team?.name || '-' }}</h3>
            </div>
            <div class="stat-icon">🏆</div>
          </div>
          <div class="stat-card">
            <div class="stat-info">
              <p>Dernière MAJ</p>
              <h3>{{ lastUpdate }}</h3>
            </div>
            <div class="stat-icon">🕒</div>
          </div>
        </div>

        <!-- Main Content -->
        <div class="card">
          <div class="card-header">
            <h2>🏆 Classement Ligue 1 - Saison 2024/2025</h2>
            <button @click="refreshData" class="btn-secondary refresh-btn" :disabled="refreshing">
              {{ refreshing ? '🔄' : '↻' }} Actualiser
            </button>
          </div>

          <!-- Légende -->
          <div class="legend">
            <div class="legend-item champions">
              <span class="legend-color"></span>
              <span>Ligue des Champions</span>
            </div>
            <div class="legend-item europa">
              <span class="legend-color"></span>
              <span>Ligue Europa</span>
            </div>
            <div class="legend-item conference">
              <span class="legend-color"></span>
              <span>Conference League</span>
            </div>
            <div class="legend-item relegation">
              <span class="legend-color"></span>
              <span>Relégation</span>
            </div>
          </div>

          <!-- Table du classement -->
          <div class="table-container">
            <table class="standings-table">
              <thead>
                <tr>
                  <th>Pos</th>
                  <th>Équipe</th>
                  <th>Pts</th>
                  <th>MJ</th>
                  <th>V</th>
                  <th>N</th>
                  <th>D</th>
                  <th>BP</th>
                  <th>BC</th>
                  <th>Diff</th>
                </tr>
              </thead>
              <tbody>
                <tr 
                  v-for="team in standings" 
                  :key="team.team.id"
                  :class="getTeamRowClass(team)"
                >
                  <td class="position">
                    <span :class="getPositionClass(team.position)">
                      {{ team.position }}
                    </span>
                  </td>
                  <td class="team-name">
                    <div class="team-info">
                      <span class="team-logo">⚽</span>
                      <span class="name">{{ team.team.name }}</span>
                      <span v-if="team.team.name.includes('PSG')" class="psg-badge">👑</span>
                    </div>
                  </td>
                  <td class="points">
                    <strong>{{ team.points }}</strong>
                  </td>
                  <td>{{ team.played || team.matches || '-' }}</td>
                  <td class="wins">{{ team.wins }}</td>
                  <td class="draws">{{ team.draws }}</td>
                  <td class="losses">{{ team.losses }}</td>
                  <td class="goals-for">{{ team.scoresFor || '-' }}</td>
                  <td class="goals-against">{{ team.scoresAgainst || '-' }}</td>
                  <td :class="['goal-diff', getGoalDiffClass(team.scoresFor - team.scoresAgainst)]">
                    {{ formatGoalDiff(team.scoresFor - team.scoresAgainst) }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Stats supplémentaires -->
          <div class="additional-stats">
            <div class="stat-block">
              <h4>🔥 Forme récente</h4>
              <div v-if="psgStats" class="form-display">
                <span>PSG : </span>
                <span class="form-badge win">V</span>
                <span class="form-badge draw">N</span>
                <span class="form-badge win">V</span>
                <span class="form-badge win">V</span>
                <span class="form-badge loss">D</span>
              </div>
            </div>
            <div class="stat-block">
              <h4>📊 Statistiques</h4>
              <p>Total équipes: {{ standings.length }}</p>
              <p>Matchs joués: {{ totalMatches }}</p>
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
        <div v-for="notif in notifications" :key="notif.id" class="notification" :class="notif.type">
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
  name: 'ClassementLigue1',
  data() {
    return {
      standings: [],
      loading: true,
      error: null,
      refreshing: false,
      showNotifications: false,
      notifications: [],
      activeTab: 'classement',
      lastUpdate: '',
      
      // ===== CONFIGURATION =====
      tabs: [
        { id: 'actualites', label: 'Actualités', route: '/AccueilAdmin' },
        { id: 'matches', label: 'Matchs', route: '/AccueilAdmin' },
        { id: 'entrainements', label: 'Entraînements', route: '/AccueilAdmin' },
        { id: 'joueurs', label: 'Gérer les joueurs', route: '/JoueursAdmin' },
        { id: 'boutique', label: 'Gérer la boutique', route: '/BoutiqueAdmin' },
        { id: 'classement', label: 'Classement Ligue 1' }
      ]
    };
  },

  computed: {
    psgStats() {
      return this.standings.find(team => 
        team.team.name.toLowerCase().includes('psg') || 
        team.team.name.toLowerCase().includes('paris')
      );
    },

    leaderTeam() {
      return this.standings.find(team => team.position === 1);
    },

    totalMatches() {
      return this.standings.reduce((total, team) => total + (team.played || team.matches || 0), 0);
    }
  },

  async mounted() {
    await this.loadStandings();
  },

  methods: {
    logout() {
      localStorage.removeItem("authToken");
      this.$router.push("/login");
    },

    toggleNotifications() {
      this.showNotifications = !this.showNotifications;
    },

    // ===== NAVIGATION =====
    handleTabClick(tab) {
      if (tab.route) {
        this.$router.push(tab.route);
      } else {
        this.activeTab = tab.id;
      }
    },

    async loadStandings() {
      this.loading = true;
      this.error = null;
      
      try {
        const response = await axios.get(
          'https://sofascore.p.rapidapi.com/tournaments/get-standings',
          {
            params: {
              tournamentId: '34', // Ligue 1
              seasonId: '44230',  // 2024/2025
              type: 'total'
            },
            headers: {
              'x-rapidapi-key': 'ca8f98b2abmshad9aacb81df72ccp1a357ejsne616bf1e2bd9',
              'x-rapidapi-host': 'sofascore.p.rapidapi.com'
            }
          }
        );

        this.standings = response.data.standings || [];
        this.lastUpdate = new Date().toLocaleTimeString('fr-FR');
        this.showSuccess('Classement mis à jour avec succès');
      } catch (err) {
        this.error = 'Erreur lors de la récupération des données du classement';
        console.error('Erreur API:', err);
        this.showError('Impossible de charger le classement');
      } finally {
        this.loading = false;
      }
    },

    async refreshData() {
      this.refreshing = true;
      await this.loadStandings();
      this.refreshing = false;
    },

    getTeamRowClass(team) {
      const classes = [];
      
      if (team.team.name.toLowerCase().includes('psg') || team.team.name.toLowerCase().includes('paris')) {
        classes.push('psg-row');
      }
      
      if (team.position <= 3) classes.push('champions-league');
      else if (team.position === 4) classes.push('europa-league');
      else if (team.position === 5) classes.push('conference-league');
      else if (team.position >= 18) classes.push('relegation');
      
      return classes;
    },

    getPositionClass(position) {
      if (position <= 3) return 'pos-champions';
      if (position === 4) return 'pos-europa';
      if (position === 5) return 'pos-conference';
      if (position >= 18) return 'pos-relegation';
      return 'pos-normal';
    },

    getPositionSuffix(position) {
      if (position === 1) return 'er';
      return 'e';
    },

    getGoalDiffClass(diff) {
      if (diff > 0) return 'positive';
      if (diff < 0) return 'negative';
      return 'neutral';
    },

    formatGoalDiff(diff) {
      if (diff > 0) return `+${diff}`;
      return diff.toString();
    },

    showSuccess(message) {
      this.notifications.unshift({
        id: Date.now(),
        message,
        time: 'Maintenant',
        type: 'success'
      });
      setTimeout(() => {
        this.notifications = this.notifications.filter(n => n.id !== this.notifications[0]?.id);
      }, 5000);
    },

    showError(message) {
      this.notifications.unshift({
        id: Date.now(),
        message,
        time: 'Maintenant',
        type: 'error'
      });
      setTimeout(() => {
        this.notifications = this.notifications.filter(n => n.id !== this.notifications[0]?.id);
      }, 5000);
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
  max-width: 1400px;
  margin: 0 auto;
  padding: 30px 20px;
  background-color: #f7fafc;
  min-height: calc(100vh - 180px);
}

/* ===== ERROR CARD ===== */
.error-card {
  background: #fed7d7;
  border: 2px solid #f56565;
  border-radius: 12px;
  padding: 30px;
  text-align: center;
  margin-bottom: 30px;
}

.error-card h3 {
  color: #c53030;
  margin-bottom: 15px;
}

.error-card p {
  color: #742a2a;
  margin-bottom: 20px;
}

/* ===== STATISTICS CARDS ===== */
.stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
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

.stat-card.psg-highlight {
  border-left-color: #c8102e;
  background: linear-gradient(135deg, #fff 0%, #fef2f2 100%);
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

/* ===== CARDS ===== */
.card {
  background: white;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  border: 1px solid #e2e8f0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.card-header h2 {
  color: #4b5563;
  font-weight: bold;
  font-size: 24px;
  margin: 0;
}

.refresh-btn {
  display: flex;
  align-items: center;
  gap: 8px;
}

/* ===== LEGEND ===== */
.legend {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #4a5568;
}

.legend-color {
  width: 16px;
  height: 16px;
  border-radius: 3px;
}

.legend-item.champions .legend-color {
  background: #4299e1;
}

.legend-item.europa .legend-color {
  background: #ed8936;
}

.legend-item.conference .legend-color {
  background: #38b2ac;
}

.legend-item.relegation .legend-color {
  background: #e53e3e;
}

/* ===== TABLE ===== */
.table-container {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  margin-bottom: 30px;
}

.standings-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  min-width: 800px;
}

.standings-table th {
  background: #f7fafc;
  color: #4a5568;
  font-weight: 600;
  padding: 16px 12px;
  text-align: center;
  border-bottom: 2px solid #e2e8f0;
  font-size: 14px;
  white-space: nowrap;
}

.standings-table td {
  padding: 16px 12px;
  border-bottom: 1px solid #e2e8f0;
  font-size: 14px;
  text-align: center;
}

/* ===== TABLE ROWS ===== */
.psg-row {
  background: linear-gradient(135deg, #fef2f2 0%, #fff5f5 100%);
  font-weight: 600;
}

.champions-league {
  border-left: 4px solid #4299e1;
}

.europa-league {
  border-left: 4px solid #ed8936;
}

.conference-league {
  border-left: 4px solid #38b2ac;
}

.relegation {
  border-left: 4px solid #e53e3e;
}

/* ===== POSITION CLASSES ===== */
.position {
  font-weight: bold;
  width: 50px;
}

.pos-champions {
  background: #4299e1;
  color: white;
  padding: 6px 8px;
  border-radius: 50%;
  font-size: 12px;
}

.pos-europa {
  background: #ed8936;
  color: white;
  padding: 6px 8px;
  border-radius: 50%;
  font-size: 12px;
}

.pos-conference {
  background: #38b2ac;
  color: white;
  padding: 6px 8px;
  border-radius: 50%;
  font-size: 12px;
}

.pos-relegation {
  background: #e53e3e;
  color: white;
  padding: 6px 8px;
  border-radius: 50%;
  font-size: 12px;
}

.pos-normal {
  color: #4a5568;
  font-weight: bold;
}

/* ===== TEAM INFO ===== */
.team-name {
  text-align: left !important;
  min-width: 200px;
}

.team-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.team-logo {
  font-size: 16px;
}

.name {
  font-weight: 600;
  color: #2d3748;
}

.psg-badge {
  font-size: 16px;
}

/* ===== STATS COLUMNS ===== */
.points {
  font-weight: bold;
  color: #2d3748;
  font-size: 16px;
}

.wins {
  color: #38a169;
  font-weight: 600;
}

.draws {
  color: #ed8936;
  font-weight: 600;
}

.losses {
  color: #e53e3e;
  font-weight: 600;
}

.goals-for {
  color: #38a169;
}

.goals-against {
  color: #e53e3e;
}

.goal-diff {
  font-weight: bold;
}

.goal-diff.positive {
  color: #38a169;
}

.goal-diff.negative {
  color: #e53e3e;
}

.goal-diff.neutral {
  color: #4a5568;
}

/* ===== ADDITIONAL STATS ===== */
.additional-stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  padding: 20px;
  background: #f7fafc;
  border-radius: 12px;
}

.stat-block h4 {
  color: #4a5568;
  margin-bottom: 12px;
  font-size: 16px;
}

.form-display {
  display: flex;
  align-items: center;
  gap: 8px;
}

.form-badge {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: bold;
  color: white;
}

.form-badge.win {
  background: #38a169;
}

.form-badge.draw {
  background: #ed8936;
}

.form-badge.loss {
  background: #e53e3e;
}

/* ===== BUTTONS ===== */
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

.btn-secondary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
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
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 16px;
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

  .standings-table th,
  .standings-table td {
    padding: 8px 6px;
    font-size: 12px;
  }

  .additional-stats {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .legend {
    flex-direction: column;
    gap: 10px;
  }

  .card-header {
    flex-direction: column;
    gap: 15px;
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

  .navbar {
    padding: 10px 15px;
  }

  .nav-actions {
    gap: 10px;
  }

  .stat-card {
    padding: 16px;
  }
  
  .tabs {
    gap: 8px;
  }
  
  .tab-btn {
    padding: 8px 14px;
    font-size: 12px;
  }

  .standings-table {
    font-size: 10px;
  }

  .team-info {
    flex-direction: column;
    gap: 4px;
  }

  .form-display {
    flex-wrap: wrap;
  }
}
</style>