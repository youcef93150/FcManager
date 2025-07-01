<template>
  <div>
    <!-- Barre de navigation -->
    <nav class="navbar">
      <div class="logo">
        <router-link to="/AccueilUser">
          <img src="@/assets/images/psg.png" alt="PSG Logo" class="logo-img" />
        </router-link>
      </div>
      <div class="nav-links">
        <router-link to="/Classement">Classement</router-link>  |
        <router-link to="/JoueursUser">Voir les joueurs du club</router-link> |
        <router-link to="/BoutiqueUser">Stocks Boutique</router-link>
      </div>
      <button class="logout-button" @click="logout">Déconnexion</button>
    </nav>

    <!-- Contenu principal -->
    <div class="psg-results">
      <h1>Résultats des matchs</h1>
      <select v-model="selectedTeam" @change="filterResults" class="team-select">
        <option value="PSG">Paris Saint-Germain (PSG)</option>
        <option v-for="team in teams" :key="team" :value="team">
          {{ team }}
        </option>
      </select>
      <table class="results-table">
        <thead>
          <tr>
            <th>Date</th>
            <th>Heure</th>
            <th>Domicile</th>
            <th>Extérieur</th>
            <th>Score</th>
            <th>Saison</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="match in filteredResults" :key="match.id">
            <td>{{ match.Date_day }}</td>
            <td>{{ match.Date_hour }}</td>
            <td>{{ match.home_team }}</td>
            <td>{{ match.away_team }}</td>
            <td>{{ match.home_score }} - {{ match.away_score }}</td>
            <td>{{ match.season_year }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      results: [], // Liste complète des matchs
      filteredResults: [], // Résultats filtrés selon l'équipe sélectionnée
      teams: [], // Liste des équipes
      selectedTeam: "PSG", // Équipe sélectionnée par défaut
    };
  },
  methods: {
    async fetchResults() {
      try {
        const response = await axios.get("/french_germany.csv"); 
        this.results = this.parseCSV(response.data);
        this.extractTeams();
        this.filterResults();
      } catch (error) {
        console.error("Erreur lors de la récupération des résultats :", error);
      }
    },
    parseCSV(data) {
      const rows = data.split("\n");
      const headers = rows[0].split(",");
      return rows.slice(1).map((row) => {
        const values = row.split(",");
        return headers.reduce((acc, header, index) => {
          acc[header.trim()] = values[index]?.trim();
          return acc;
        }, {});
      });
    },
    extractTeams() {
      const teamSet = new Set();
      this.results.forEach((match) => {
        teamSet.add(match.home_team);
        teamSet.add(match.away_team);
      });
      this.teams = Array.from(teamSet).sort();
    },
    filterResults() {
      this.filteredResults = this.results.filter(
        (match) => match.home_team === this.selectedTeam || match.away_team === this.selectedTeam
      );
    },
    logout() {
      localStorage.removeItem("authToken");
      this.$router.push("/login");
    },
  },
  mounted() {
    this.fetchResults();
  },
};
</script>

<style scoped>
/* Style de la barre de navigation */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #002b5c; 
  padding: 15px 25px;
  color: white;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.logo-img {
  height: 50px;
}

.nav-links {
  display: flex;
  gap: 20px;
}

.nav-links a {
  color: white;
  text-decoration: none;
  font-size: 18px;
  font-weight: 500;
}

.nav-links a:hover {
  text-decoration: underline;
  color: #c8102e; 
}

.logout-button {
  background-color: #c8102e; 
  border: none;
  padding: 12px 18px;
  color: white;
  font-size: 16px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.logout-button:hover {
  background-color: #9b0d20;
}

/* Conteneur principal */
.psg-results {
  font-family: Arial, sans-serif;
  max-width: 1200px;
  margin: 20px auto;
  padding: 20px;
  background-color: #f4f4f4; 
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  text-align: center;
}

h1 {
  color: #002b5c;
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 20px;
}

/* Sélecteur d'équipe */
.team-select {
  margin-bottom: 20px;
  padding: 10px;
  font-size: 16px;
  border: 1px solid #ddd;
  border-radius: 5px;
  background-color: #ffffff; 
  color: #002b5c; 
}

/* Table des résultats */
.results-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
  background-color: #ffffff; 
}

th,
td {
  border: 1px solid #ddd;
  padding: 12px;
  text-align: center;
  font-size: 16px;
}

th {
  background-color: #002b5c; 
  color: white;
  font-weight: bold;
}

tr:nth-child(even) {
  background-color: #f9f9f9; 
}

tr:hover {
  background-color: #ddd; 
}

/* Réactivité */
@media (max-width: 768px) {
  .results-table th,
  .results-table td {
    font-size: 14px;
    padding: 8px;
  }

  .nav-links {
    flex-direction: column;
    gap: 10px;
  }
}
</style>
