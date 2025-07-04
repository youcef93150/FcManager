

<template>
  <div class="auth-container">
    <div class="auth-card">
      <h1 class="auth-title">S'inscrire</h1>

      <form @submit.prevent="handleSubmit" class="auth-form">
        <div class="form-group">
          <label for="nom" class="form-label">Nom</label>
          <input
            id="nom"
            v-model="nom"
            type="text"
            placeholder="Entrez votre nom"
            class="input"
            required
          />
        </div>
        
        <div class="form-group">
          <label for="prenom" class="form-label">Prénom</label>
          <input
            id="prenom"
            v-model="prenom"
            type="text"
            placeholder="Entrez votre prénom"
            class="input"
            required
          />
        </div>

        <div class="form-group">
          <label for="email" class="form-label">Email</label>
          <input
            id="email"
            v-model="email"
            type="email"
            placeholder="Entrez votre email"
            class="input"
            required
          />
        </div>

        <div class="form-group">
          <label for="password" class="form-label">Mot de passe</label>
          <input
            id="password"
            v-model="password"
            type="password"
            placeholder="Entrez votre mot de passe"
            class="input"
            required
          />
        </div>

        <button type="submit" class="btn btn-primary w-full">S'inscrire</button>
      </form>

      <div class="auth-link">
        <p>Déjà un compte ? <router-link to="/login">Connectez-vous</router-link></p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Register",
  data() {
    return {
      nom: "",
      prenom: "",
      email: "",
      password: "",
      role: "utilisateurs", 
    };
  },
  methods: {
    async handleSubmit() {
      // Validation côté client
      if (!this.nom || !this.prenom || !this.email || !this.password) {
        alert("Tous les champs doivent être remplis !");
        return;
      }

      try {
        // Appel API
        const response = await axios.post("http://localhost:8000/api/register", {
          nom: this.nom,
          prenom: this.prenom,
          email: this.email,
          password: this.password,
          role: this.role, 
        });

        // Message de succès
        alert(response.data.success || "Utilisateur inscrit avec succès !");
        
        // Réinitialiser le formulaire
        this.nom = "";
        this.prenom = "";
        this.email = "";
        this.password = "";
        this.role = "utilisateurs";

        
        this.$router.push("/login"); // Utilisation de Vue Router pour rediriger
      } catch (error) {
        // Gestion des erreurs
        console.error("Erreur lors de l'inscription :", error);
        if (error.response) {
          alert(error.response.data.error || "Une erreur s'est produite, veuillez réessayer.");
        } else {
          alert("Impossible de contacter le serveur.");
        }
      }
    },
  },
};
</script>

<style>
@import '@/assets/styles/user.css';
</style>
