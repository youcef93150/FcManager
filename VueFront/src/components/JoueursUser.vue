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
        <router-link to="/psg-results">Résultats des matchs</router-link> |
        <router-link to="/BoutiqueUser">Stocks Boutique</router-link>
        
      </div>
      <button class="logout-button" @click="logout">Déconnexion</button>
    </nav>

    <!-- Conteneur des joueurs -->
    <div class="joueurs-container">
      <h1 class="joueurs-title">Liste des Joueurs</h1>
      <table class="joueurs-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Prénom</th>
            <th>Poste</th>
            <th>Pays d'Origine</th>
            <th>Âge</th>
            <th>Taille (cm)</th>
            <th>Poids (kg)</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="joueur in joueurs" :key="joueur.id">
            <td>{{ joueur.id }}</td>
            <td>{{ joueur.nom }}</td>
            <td>{{ joueur.prenom }}</td>
            <td>{{ joueur.poste }}</td>
            <td>{{ joueur.pays_origine }}</td>
            <td>{{ joueur.age }}</td>
            <td>{{ joueur.taille_cm }}</td>
            <td>{{ joueur.poids_kg }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from '@/utils/auth';

export default {
  data() {
    return {
      joueurs: [], // Liste des joueurs
    };
  },
  methods: {
    // Récupérer les données des joueurs depuis l'API
    fetchJoueurs() {
      axios.get("http://localhost:8000/api/joueurs").then((response) => {
        this.joueurs = response.data;
      });
    },
    logout() {
      localStorage.removeItem("authToken");
      this.$router.push("/login");
    },
  },
  mounted() {
    // Charger les joueurs au montage du composant
    this.fetchJoueurs();
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
.joueurs-container {
  max-width: 1200px;
  margin: 20px auto;
  padding: 20px;
  background-color: #f4f4f4; 
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  text-align: center;
}

.joueurs-title {
  color: #002b5c;
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 20px;
}

/* Table des joueurs */
.joueurs-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

.joueurs-table th,
.joueurs-table td {
  border: 1px solid #ddd;
  padding: 12px;
  text-align: center;
  font-size: 16px;
}

.joueurs-table th {
  background-color: #002b5c;
  color: white;
  font-weight: bold;
}

.joueurs-table tr:nth-child(even) {
  background-color: #f9f9f9;
}

.joueurs-table tr:hover {
  background-color: #ddd;
}

/* Réactivité */
@media (max-width: 768px) {
  .joueurs-table th,
  .joueurs-table td {
    font-size: 14px;
    padding: 8px;
  }

  .nav-links {
    flex-direction: column;
    gap: 10px;
  }
}
</style>
