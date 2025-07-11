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
        <router-link to="/AccueilUser">Accueil</router-link>  |
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
      <div class="table-container">
        <table class="table">
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

<style>
@import '@/assets/styles/user.css';
</style>

