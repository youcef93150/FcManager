
<template>
  <div id="app">
    

    <router-view />
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      isAuthenticated: false, // Indique si l'utilisateur est connecté
      authChecked: false, // Indique si la vérification est terminée
      userRole: null, // Rôle de l'utilisateur connecté
    };
  },
  methods: {
    async checkAuthentication() {
      const token = localStorage.getItem("authToken");

      if (!token) {
        this.isAuthenticated = false;
        this.authChecked = true;
        return;
      }

      try {
        const response = await axios.get("http://localhost:8000/api/check-auth", {
          headers: {
            Authorization: `Bearer ${token}`, // Envoie du token au format Bearer
          },
        });

        this.isAuthenticated = true;
        this.userRole = response.data.role; // Récupère le rôle de l'utilisateur
        this.authChecked = true;
      } catch (error) {
        console.error("Erreur lors de la vérification :", error);
        this.isAuthenticated = false;
        this.authChecked = true;
      }
    },

    logout() {
      localStorage.removeItem("authToken"); // Supprime le jeton de l'utilisateur
      this.isAuthenticated = false; // Réinitialise l'état de connexion
      this.userRole = null; // Réinitialise le rôle
      this.authChecked = true; // Indique que la vérification est terminée
      this.$router.push("/login"); // Redirige vers la page de connexion
    },
  },
  mounted() {
    this.checkAuthentication(); // Vérifie l'état d'authentification lors du montage
  },
};
</script>

<style scoped>
.navbar {
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #333;
  padding: 10px 20px;
}

.nav-link {
  color: white;
  text-decoration: none;
  margin: 0 15px;
  font-size: 16px;
  font-weight: bold;
  transition: color 0.3s ease;
}

.nav-link:hover {
  color: #007bff;
}

.nav-button {
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
}

.nav-button:hover {
  background-color: #0056b3;
}
</style>
