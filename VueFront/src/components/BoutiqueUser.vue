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
        <router-link to="/JoueursUser">Voir les joueurs du club</router-link> 
        
      </div>
      <button class="logout-button" @click="logout">Déconnexion</button>
    </nav>

    <!-- Contenu principal -->
    <div class="stocks-container">
      <h1>Stocks de la Boutique</h1>
      <table class="stocks-table">
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
            <td>{{ product.stock }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from '@/utils/auth';

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

<style scoped>
/* Barre de navigation */
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
.stocks-container {
  max-width: 1200px;
  margin: 20px auto;
  padding: 20px;
  text-align: center;
  background-color: #ffffff;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  font-family: Arial, sans-serif;
}

.stocks-container h1 {
  color: #002b5c;
  margin-bottom: 20px;
}

.stocks-table {
  width: 100%;
  border-collapse: collapse;
}

.stocks-table th,
.stocks-table td {
  border: 1px solid #ddd;
  padding: 10px;
  text-align: center;
}

.stocks-table th {
  background-color: #002b5c;
  color: white;
  font-weight: bold;
}

.stocks-table tr:nth-child(even) {
  background-color: #f9f9f9;
}

.stocks-table tr:hover {
  background-color: #ddd;
}
</style>
