
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
        // Utilise axios qui a été configuré avec les intercepteurs
        const response = await axios.get("/api/check-auth");

        this.isAuthenticated = true;
        this.userRole = response.data.role; // Récupère le rôle de l'utilisateur
        this.authChecked = true;
      } catch (error) {
        console.error("Erreur lors de la vérification :", error);
        // Nettoyer le localStorage en cas d'erreur
        localStorage.removeItem("authToken");
        localStorage.removeItem("userRole");
        localStorage.removeItem("userId");
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


