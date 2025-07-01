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
        
        <router-link to="/psg-results">Résultats des matchs</router-link> |
        <router-link to="/JoueursUser">Voir les joueurs du club</router-link> |
        <router-link to="/BoutiqueUser">Stocks Boutique</router-link>
      </div>
      <button class="logout-button" @click="logout">Déconnexion</button>
    </nav>

    <!-- Contenu principal -->
    <div class="classement">
      <h1>Classement Ligue 1</h1>
      <table>
        <thead>
          <tr>
            <th>Position</th>
            <th>Équipe</th>
            <th>Joués</th>
            <th>Gagnés</th>
            <th>Nuls</th>
            <th>Perdus</th>
            <th>Points</th>
            <th>But(s) marqués</th>
            <th>But(s) encaissés</th>
            <th>Différence de buts</th>
            <th>Meilleur buteur</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(team, index) in classement" :key="index">
            <td>{{ team.Clt }}</td>
            <td>{{ team["Équipe"] }}</td>
            <td>{{ team.MJ }}</td>
            <td>{{ team.V }}</td>
            <td>{{ team.N }}</td>
            <td>{{ team.D }}</td>
            <td>{{ team.Pts }}</td>
            <td>{{ team.BM }}</td>
            <td>{{ team.BE }}</td>
            <td>{{ team.DB }}</td>
            <td>{{ team["Meilleur buteur de l'équipe"] }}</td>
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
      classement: [] // Liste complète du classement
    };
  },
  methods: {
    async fetchClassement() {
      try {
        const response = await axios.get("/classement_ligue_1.csv");
        this.classement = this.parseCSV(response.data);
      } catch (error) {
        console.error("Erreur lors de la récupération du classement :", error);
      }
    },
    parseCSV(data) {
      const rows = data.split("\n").filter(row => row.trim() !== "");
      const headers = rows[0].split(",");
      return rows.slice(1).map((row) => {
        const values = row.split(",");
        return headers.reduce((acc, header, index) => {
          acc[header.trim()] = values[index]?.trim();
          return acc;
        }, {});
      });
    },
    logout() {
      localStorage.removeItem("authToken");
      this.$router.push("/login");
    }
  },
  mounted() {
    this.fetchClassement();
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
.classement {
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

table {
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
  table th,
  table td {
    font-size: 14px;
    padding: 8px;
  }

  .nav-links {
    flex-direction: column;
    gap: 10px;
  }
}
</style>
