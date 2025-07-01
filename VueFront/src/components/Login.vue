<template>
  <div>
      <h1>Connexion</h1>
  </div>
  <form @submit.prevent="handleLogin">
      <div>
          <label for="email">Email : </label>
          <input
              id="email"
              v-model="email"
              type="email"
              placeholder="Entrez votre email"
              required
          />
      </div>

      <div>
          <label for="mdp">Mot de passe : </label>
          <input
              id="mdp"
              v-model="mdp"
              type="password"
              placeholder="Entrez votre mot de passe"
              required
          />
      </div>
      <button type="submit">Se Connecter</button>
  </form>

  <div class="register-link">
    <p>Pas encore de compte ? <router-link to="/register">Inscrivez-vous</router-link></p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      email: "",
      mdp: "",
    };
  },
  methods: {
    async handleLogin() {
      // Validation côté client
      if (!this.email || !this.mdp) {
        alert("Veuillez remplir tous les champs !");
        return;
      }

      try {
        // Appel API pour la connexion
        const response = await axios.post("http://localhost:8000/api/login", {
          email: this.email,
          password: this.mdp,
        });

        console.log("Réponse API :", response.data);

        // Stocker le token JWT et les infos utilisateur
        if (response.data.token) {
          localStorage.setItem('authToken', response.data.token);
          localStorage.setItem('userRole', response.data.user.role);
          localStorage.setItem('userId', response.data.user.id);
        }

        // Vérification du rôle et redirection
        const userRole = response.data.user.role;

        if (userRole === "admin") {
          this.$router.push('/AccueilAdmin'); 
        } else if(userRole === "utilisateurs") {
          this.$router.push('/AccueilUser'); 
        }

        alert(response.data.message || "Connexion réussie !");
      } catch (error) {
        console.error("Erreur lors de la connexion :", error);
        if (error.response) {
          alert(error.response.data.error || "Identifiants incorrects.");
        } else {
          alert("Impossible de contacter le serveur.");
        }
      }
    },
  },
};
</script>

<style scoped>
h1 {
  text-align: center;
  margin-bottom: 20px;
  color: #002b5c; 
  font-weight: bold;
}

form {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #c8102e; 
  border-radius: 5px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
  background-color: #ffffff; 
}

div {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #002b5c; 
}

input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 16px;
  background-color: #f4f4f4;
  transition: border-color 0.3s;
}

input:focus {
  border-color: #c8102e; 
  outline: none;
}

button {
  width: 100%;
  padding: 10px;
  background-color: #002b5c;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 16px;
  margin-top: 10px;
  font-weight: bold;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #c8102e; 
}

.register-link {
  text-align: center;
  margin-top: 20px;
}

.register-link a {
  color: #c8102e; 
  text-decoration: none;
  font-weight: bold;
}

.register-link a:hover {
  text-decoration: underline;
  color: #002b5c; 
}
</style>