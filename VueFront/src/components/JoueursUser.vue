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
        <router-link to="/psg-results">Résultats des matchs</router-link> |
        <router-link to="/BoutiqueUser">Stocks Boutique</router-link>
        
      </div>
      <button class="logout-button" @click="logout">Déconnexion</button>
    </nav>

    <!-- Conteneur des joueurs -->
    <div class="players-container">
      <h1 class="page-title">Liste des Joueurs</h1>
      <div class="table-container">
        <table class="table">
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
  </div>
</template>

<script>
import axios from "axios";

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

<style>
@import '@/assets/styles/user.css';
</style>