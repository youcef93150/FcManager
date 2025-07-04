<template>
  <div class="league-standings">
    <div class="standings-header">
      <h2 class="standings-title">🏆 Classement des Ligues</h2>
      
      <!-- Sélecteurs -->
      <div class="selectors-container">
        <div class="selector-group">
          <label for="league-select">Ligue :</label>
          <select 
            id="league-select" 
            v-model="selectedLeague" 
            @change="loadStandings"
            class="selector"
          >
            <option value="">Sélectionner une ligue</option>
            <option value="618">Ligue 1 - France</option>
            <option value="39">Premier League - Angleterre</option>
            <option value="140">La Liga - Espagne</option>
            <option value="78">Bundesliga - Allemagne</option>
            <option value="135">Serie A - Italie</option>
          </select>
        </div>

        <div class="controls">
          <button 
            @click="loadStandings" 
            :disabled="!selectedLeague || loadingStandings"
            class="refresh-btn"
          >
            🔄 Actualiser
          </button>
          
          <div class="auto-refresh">
            <label>
              <input 
                type="checkbox" 
                v-model="autoRefresh"
                @change="toggleAutoRefresh"
              >
              Auto-refresh (30s)
            </label>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading States -->
    <div v-if="loadingStandings" class="loading-message">
      Chargement du classement...
    </div>

    <!-- Error Message -->
    <div v-else-if="error" class="error-message">
      <p>{{ error }}</p>
      <button @click="loadStandings" class="retry-btn">Réessayer</button>
    </div>

    <!-- Standings Table -->
    <div v-else-if="standings.length > 0" class="standings-container">
      <div class="league-info">
        <h3>{{ getLeagueName() }}</h3>
        <p>Saison 2024</p>
      </div>

      <div class="table-controls">
        <div class="sort-controls">
          <label>Trier par :</label>
          <select v-model="sortBy" class="sort-select">
            <option value="position">Position</option>
            <option value="points">Points</option>
            <option value="team">Nom d'équipe</option>
            <option value="goal_difference">Différence de buts</option>
          </select>
        </div>
      </div>

      <div class="table-container">
        <table class="standings-table">
          <thead>
            <tr>
              <th>Pos</th>
              <th>Équipe</th>
              <th>MJ</th>
              <th>V</th>
              <th>N</th>
              <th>D</th>
              <th>BP</th>
              <th>BC</th>
              <th>DB</th>
              <th>Pts</th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="team in sortedStandings" 
              :key="team.team_id"
              :class="getTeamRowClass(team)"
              class="team-row"
            >
              <td class="position-cell">
                <span :class="getPositionClass(team.position)">
                  {{ team.position }}
                </span>
              </td>
              <td class="team-cell">
                <div class="team-info">
                  <div class="team-logo-placeholder">⚽</div>
                  <span class="team-name">{{ team.team_name }}</span>
                </div>
              </td>
              <td>{{ team.played }}</td>
              <td class="stat-wins">{{ team.won }}</td>
              <td class="stat-draws">{{ team.drawn }}</td>
              <td class="stat-losses">{{ team.lost }}</td>
              <td class="stat-goals-for">{{ team.goals_for }}</td>
              <td class="stat-goals-against">{{ team.goals_against }}</td>
              <td :class="getDifferenceClass(team.goal_difference)">
                {{ team.goal_difference > 0 ? '+' : '' }}{{ team.goal_difference }}
              </td>
              <td class="stat-points"><strong>{{ team.points }}</strong></td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="last-updated">
        Dernière mise à jour : {{ lastUpdated }}
      </div>
    </div>

    <div v-else class="select-league-message">
      Veuillez sélectionner une ligue pour voir le classement.
    </div>
  </div>
</template>

<script>
import axios from 'axios';

const API_CONFIG = {
  baseURL: 'https://live-football-api.p.rapidapi.com',
  headers: {
    'x-rapidapi-key': 'ca8f98b2abmshad9aacb81df72ccp1a357ejsne616bf1e2bd9',
    'x-rapidapi-host': 'live-football-api.p.rapidapi.com'
  }
};

export default {
  name: 'LeagueStandings',
  data() {
    return {
      standings: [],
      selectedLeague: '',
      loadingStandings: false,
      error: null,
      autoRefresh: false,
      refreshInterval: null,
      lastUpdated: null,
      sortBy: 'position'
    }
  },
  computed: {
    sortedStandings() {
      let sorted = [...this.standings];
      
      switch (this.sortBy) {
        case 'position':
          sorted.sort((a, b) => a.position - b.position);
          break;
        case 'points':
          sorted.sort((a, b) => b.points - a.points);
          break;
        case 'team':
          sorted.sort((a, b) => a.team_name.localeCompare(b.team_name));
          break;
        case 'goal_difference':
          sorted.sort((a, b) => b.goal_difference - a.goal_difference);
          break;
      }
      
      return sorted;
    }
  },
  async mounted() {
    // Composant prêt, pas de chargement automatique
  },
  beforeUnmount() {
    this.clearAutoRefresh();
  },
  methods: {
    async loadStandings() {
      if (!this.selectedLeague) return;

      this.loadingStandings = true;
      this.error = null;
      this.standings = [];
      
      try {
        const response = await axios.get(`${API_CONFIG.baseURL}/league-standing`, {
          headers: API_CONFIG.headers,
          params: { 
            season: '2024',
            id: this.selectedLeague
          }
        });
        
        if (response.data && response.data.status === 'success' && response.data.response && response.data.response.length > 0) {
          const standingsData = response.data.response[0];
          if (Array.isArray(standingsData) && standingsData.length > 0) {
            this.standings = standingsData.map(team => ({
              position: team.rank || 0,
              team_id: team.team_id || 0,
              team_name: this.getTeamName(team.team_id),
              points: team.points || 0,
              played: team.all?.matches_played || 0,
              won: team.all?.win || 0,
              drawn: team.all?.draw || 0,
              lost: team.all?.lose || 0,
              goals_for: team.all?.goals_for || 0,
              goals_against: team.all?.goals_against || 0,
              goal_difference: team.goals_diff || 0
            }));
            
            this.lastUpdated = new Date().toLocaleString('fr-FR');
          } else {
            throw new Error('Format de données incorrect: standingsData n\'est pas un tableau valide');
          }
        } else {
          throw new Error('Aucune donnée de classement disponible pour cette ligue');
        }
      } catch (error) {
        console.error('Erreur lors du chargement du classement:', error);
        this.error = `Erreur lors du chargement du classement: ${error.message}`;
      } finally {
        this.loadingStandings = false;
      }
    },

    getTeamName(teamId) {
      // Mapping basique pour les équipes connues
      const teamNames = {
        // Ligue 1
        305: 'Paris Saint-Germain',
        306: 'Marseille',
        307: 'Lyon',
        308: 'Monaco',
        309: 'Lille',
        310: 'Rennes',
        311: 'Nice',
        312: 'Strasbourg',
        313: 'Nantes',
        314: 'Montpellier',
        315: 'Reims',
        316: 'Brest',
        317: 'Toulouse',
        318: 'Lens',
        319: 'Le Havre',
        320: 'Clermont',
        321: 'Lorient',
        322: 'Metz',
        323: 'Angers',
        324: 'Auxerre',
        
        // Premier League
        400: 'Manchester City',
        401: 'Arsenal',
        402: 'Liverpool',
        403: 'Aston Villa',
        404: 'Tottenham',
        405: 'Chelsea',
        406: 'Newcastle',
        407: 'Manchester United',
        408: 'West Ham',
        409: 'Crystal Palace',
        410: 'Brighton',
        411: 'Bournemouth',
        412: 'Fulham',
        413: 'Wolves',
        414: 'Everton',
        415: 'Brentford',
        416: 'Nottingham Forest',
        417: 'Luton Town',
        418: 'Burnley',
        419: 'Sheffield United'
      };
      
      return teamNames[teamId] || `Équipe ${teamId}`;
    },

    getLeagueName() {
      const leagueNames = {
        '618': 'Ligue 1 - France',
        '39': 'Premier League - Angleterre',
        '140': 'La Liga - Espagne',
        '78': 'Bundesliga - Allemagne',
        '135': 'Serie A - Italie'
      };
      
      return leagueNames[this.selectedLeague] || 'Ligue sélectionnée';
    },

    toggleAutoRefresh() {
      if (this.autoRefresh) {
        this.startAutoRefresh();
      } else {
        this.clearAutoRefresh();
      }
    },

    startAutoRefresh() {
      this.clearAutoRefresh();
      this.refreshInterval = setInterval(() => {
        if (this.selectedLeague && !this.loadingStandings) {
          this.loadStandings();
        }
      }, 30000); // 30 secondes
    },

    clearAutoRefresh() {
      if (this.refreshInterval) {
        clearInterval(this.refreshInterval);
        this.refreshInterval = null;
      }
    },

    getTeamRowClass(team) {
      const classes = [];
      
      // Positions spéciales (Champions League, Europe, Relégation)
      if (team.position <= 4) {
        classes.push('position-champions');
      } else if (team.position <= 6) {
        classes.push('position-europe');
      } else if (team.position >= this.standings.length - 2) {
        classes.push('position-relegation');
      }
      
      return classes.join(' ');
    },

    getPositionClass(position) {
      if (position <= 4) return 'position-top';
      if (position >= this.standings.length - 2) return 'position-bottom';
      return '';
    },

    getDifferenceClass(difference) {
      if (difference > 0) return 'stat-positive';
      if (difference < 0) return 'stat-negative';
      return '';
    }
  }
}
</script>

<style scoped>
.league-standings {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.standings-header {
  margin-bottom: 30px;
}

.standings-title {
  font-size: 2rem;
  color: #1a365d;
  margin-bottom: 20px;
  text-align: center;
}

.selectors-container {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  align-items: end;
  justify-content: center;
  padding: 20px;
  background: #f8fafc;
  border-radius: 12px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.selector-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.selector-group label {
  font-weight: 600;
  color: #2d3748;
  font-size: 0.9rem;
}

.selector {
  padding: 10px 15px;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  background: white;
  font-size: 1rem;
  min-width: 200px;
  transition: border-color 0.2s;
}

.selector:focus {
  outline: none;
  border-color: #3182ce;
  box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
}

.selector:disabled {
  background: #f7fafc;
  color: #a0aec0;
  cursor: not-allowed;
}

.controls {
  display: flex;
  flex-direction: column;
  gap: 10px;
  align-items: center;
}

.refresh-btn {
  padding: 10px 20px;
  background: #3182ce;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: background-color 0.2s;
}

.refresh-btn:hover:not(:disabled) {
  background: #2c5aa0;
}

.refresh-btn:disabled {
  background: #a0aec0;
  cursor: not-allowed;
}

.auto-refresh {
  font-size: 0.9rem;
}

.auto-refresh label {
  display: flex;
  align-items: center;
  gap: 5px;
  cursor: pointer;
}

.loading-message, .error-message, .no-data-message, .select-league-message {
  text-align: center;
  padding: 40px 20px;
  font-size: 1.1rem;
  border-radius: 8px;
  margin: 20px 0;
}

.loading-message {
  background: #e6fffa;
  color: #234e52;
}

.error-message {
  background: #fed7d7;
  color: #742a2a;
}

.no-data-message, .select-league-message {
  background: #f7fafc;
  color: #4a5568;
}

.retry-btn {
  margin-top: 10px;
  padding: 8px 16px;
  background: #e53e3e;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}

.standings-container {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.league-info {
  padding: 20px;
  background: #1a365d;
  color: white;
  text-align: center;
}

.league-info h3 {
  margin: 0 0 5px 0;
  font-size: 1.5rem;
}

.league-info p {
  margin: 0;
  opacity: 0.8;
}

.table-controls {
  padding: 15px 20px;
  background: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
}

.sort-controls {
  display: flex;
  align-items: center;
  gap: 10px;
}

.sort-select {
  padding: 6px 12px;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  background: white;
}

.table-container {
  overflow-x: auto;
}

.standings-table {
  width: 100%;
  border-collapse: collapse;
}

.standings-table th {
  background: #2d3748;
  color: white;
  padding: 15px 10px;
  text-align: center;
  font-weight: 600;
  font-size: 0.9rem;
  white-space: nowrap;
}

.standings-table td {
  padding: 12px 10px;
  text-align: center;
  border-bottom: 1px solid #e2e8f0;
}

.team-row:hover {
  background: #f7fafc;
}

.position-cell {
  font-weight: bold;
}

.position-top {
  color: #38a169;
  background: #c6f6d5;
  padding: 4px 8px;
  border-radius: 4px;
}

.position-bottom {
  color: #e53e3e;
  background: #fed7d7;
  padding: 4px 8px;
  border-radius: 4px;
}

.team-cell {
  text-align: left !important;
  min-width: 200px;
}

.team-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.team-logo {
  width: 24px;
  height: 24px;
  object-fit: contain;
}

.team-logo-placeholder {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f0f0f0;
  border-radius: 50%;
  font-size: 12px;
}

.team-name {
  font-weight: 600;
  color: #2d3748;
}

.stat-wins {
  color: #38a169;
  font-weight: 600;
}

.stat-draws {
  color: #d69e2e;
  font-weight: 600;
}

.stat-losses {
  color: #e53e3e;
  font-weight: 600;
}

.stat-goals-for {
  color: #3182ce;
  font-weight: 600;
}

.stat-goals-against {
  color: #e53e3e;
}

.stat-positive {
  color: #38a169;
  font-weight: 600;
}

.stat-negative {
  color: #e53e3e;
  font-weight: 600;
}

.stat-points {
  color: #1a365d;
  font-size: 1.1rem;
}

.position-champions {
  border-left: 4px solid #38a169;
}

.position-europe {
  border-left: 4px solid #3182ce;
}

.position-relegation {
  border-left: 4px solid #e53e3e;
}

.last-updated {
  padding: 15px 20px;
  background: #f8fafc;
  color: #4a5568;
  font-size: 0.9rem;
  text-align: center;
  border-top: 1px solid #e2e8f0;
}

@media (max-width: 768px) {
  .selectors-container {
    flex-direction: column;
    align-items: stretch;
  }
  
  .selector {
    min-width: auto;
    width: 100%;
  }
  
  .controls {
    flex-direction: row;
    justify-content: space-between;
  }
  
  .standings-table {
    font-size: 0.8rem;
  }
  
  .standings-table th,
  .standings-table td {
    padding: 8px 6px;
  }
  
  .team-info {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }
  
  .team-logo {
    align-self: center;
  }
}
</style>
