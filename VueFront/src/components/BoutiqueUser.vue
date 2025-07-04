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
        <router-link to="/JoueursUser">Voir les joueurs du club</router-link> 
        
      </div>
      <button class="logout-button" @click="logout">Déconnexion</button>
    </nav>

    <!-- Contenu principal -->
    <div class="boutique-container">
      <h1 class="page-title">Stocks de la Boutique</h1>
      <div class="table-container">
        <table class="table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Nom</th>
              <th>Prix (€)</th>
              <th>Taille</th>
              <th>Couleur</th>
              <th>Description</th>
              <th>Stock</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in products" :key="product.id">
              <td>{{ product.id }}</td>
              <td>{{ product.nom }}</td>
              <td>{{ product.prix }}</td>
              <td>{{ product.taille || '-' }}</td>
              <td>{{ product.couleur }}</td>
              <td>{{ product.description }}</td>
              <td>
                <span :class="getStockClass(product.stock)">
                  {{ product.stock }}
                </span>
              </td>
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
  name: "BoutiqueUser",
  data() {
    return {
      products: [],
    };
  },
  methods: {
    async fetchProducts() {
      try {
        const response = await axios.get("http://localhost:8000/api/produits");
        this.products = response.data;
      } catch (error) {
        console.error("Erreur lors de la récupération des produits :", error);
      }
    },
    getStockClass(stock) {
      if (stock === 0) return 'product-stock out';
      if (stock < 5) return 'product-stock low';
      return 'product-stock';
    },
    logout() {
      localStorage.removeItem("authToken");
      this.$router.push("/login");
    },
  },
  mounted() {
    this.fetchProducts();
  },
};
</script>

<style>
@import '@/assets/styles/user.css';
</style>
