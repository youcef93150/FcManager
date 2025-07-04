<template>
  <div class="auth-container">
    <div class="auth-card">
      <h1 class="auth-title">Connexion</h1>
      
      <form @submit.prevent="handleLogin" class="auth-form">
        <div class="form-group">
          <label for="email" class="form-label">Email</label>
          <input
            id="email"
            v-model="email"
            type="email"
            placeholder="Entrez votre email"
            class="input"
            maxlength="100"
            @input="onEmailInput"
            required
          />
        </div>

        <div class="form-group">
          <label for="mdp" class="form-label">Mot de passe</label>
          <input
            id="mdp"
            v-model="mdp"
            type="password"
            placeholder="Entrez votre mot de passe"
            class="input"
            maxlength="100"
            @input="onPasswordInput"
            required
          />
        </div>
        
        <!-- Affichage des tentatives restantes -->
        <div v-if="tentativesRestantes < 5 && !compteBloque" class="tentatives-warning">
          ⚠️ {{ tentativesRestantes }} tentative(s) restante(s)
        </div>
        
        <!-- Message de blocage -->
        <div v-if="compteBloque" class="compte-bloque">
          🔒 Compte temporairement bloqué
        </div>
        
        <button type="submit" class="btn btn-primary w-full" :disabled="compteBloque">
          {{ compteBloque ? 'Compte bloqué' : 'Se Connecter' }}
        </button>
      </form>

      <div class="auth-link">
        <p>Pas encore de compte ? <router-link to="/register">Inscrivez-vous</router-link></p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      email: "",
      mdp: "",
      tentativesRestantes: 5,
      compteBloque: false,
    };
  },
  mounted() {
    // Récupérer les données du localStorage au chargement du composant
    const tentativesSauvegardees = localStorage.getItem('tentativesLogin');
    const compteBloqueSauvegarde = localStorage.getItem('compteBloque');
    const tempsDeblocage = localStorage.getItem('tempsDeblocage');
    
    if (tentativesSauvegardees) {
      this.tentativesRestantes = parseInt(tentativesSauvegardees);
    }
    
    if (compteBloqueSauvegarde === 'true') {
      // Vérifier si le temps de blocage est écoulé
      if (tempsDeblocage && Date.now() < parseInt(tempsDeblocage)) {
        this.compteBloque = true;
        
        // Programmer le déblocage
        const tempsRestant = parseInt(tempsDeblocage) - Date.now();
        setTimeout(() => {
          this.debloquerCompte();
        }, tempsRestant);
      } else {
        // Le temps est écoulé, débloquer
        this.debloquerCompte();
      }
    }
  },
  methods: {
    // Fonction pour nettoyer et valider les entrées
    sanitizeInput(input) {
      if (!input || typeof input !== 'string') return '';
      
      return input
        .trim() // Supprimer les espaces en début/fin
        .replace(/[<>'"]/g, '') // Supprimer les caractères dangereux
        .substring(0, 255); // Limiter la longueur
    },
    
    validateEmail(email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return emailRegex.test(email) && email.length <= 100;
    },
    
    // Validation en temps réel pour l'email
    onEmailInput(event) {
      // Supprimer les caractères dangereux au fur et à mesure
      this.email = event.target.value.replace(/[<>'"]/g, '');
    },
    
    // Validation en temps réel pour le mot de passe
    onPasswordInput(event) {
      // Supprimer les caractères dangereux au fur et à mesure
      this.mdp = event.target.value.replace(/[<>'"]/g, '');
    },
    
    debloquerCompte() {
      this.compteBloque = false;
      this.tentativesRestantes = 5;
      
      // Nettoyer le localStorage
      localStorage.removeItem('tentativesLogin');
      localStorage.removeItem('compteBloque');
      localStorage.removeItem('tempsDeblocage');
      
      alert("Compte débloqué. Vous pouvez réessayer.");
    },
    
    sauvegarderEtat() {
      localStorage.setItem('tentativesLogin', this.tentativesRestantes.toString());
      localStorage.setItem('compteBloque', this.compteBloque.toString());
    },
    
    async handleLogin() {
      // Vérifier si le compte est bloqué
      if (this.compteBloque) {
        alert("Compte temporairement bloqué. Veuillez réessayer plus tard.");
        return;
      }

      // Nettoyer et valider les entrées
      const cleanEmail = this.sanitizeInput(this.email);
      const cleanPassword = this.sanitizeInput(this.mdp);

      // Validation côté client
      if (!cleanEmail || !cleanPassword) {
        alert("Veuillez remplir tous les champs !");
        return;
      }

      // Validation email
      if (!this.validateEmail(cleanEmail)) {
        alert("Format d'email invalide !");
        return;
      }

      // Validation longueur mot de passe
      if (cleanPassword.length < 3 || cleanPassword.length > 100) {
        alert("Le mot de passe doit contenir entre 3 et 100 caractères !");
        return;
      }

      try {
        // Appel API pour la connexion avec les données nettoyées
        const response = await axios.post("http://localhost:8000/api/login", {
          email: cleanEmail,
          password: cleanPassword,
        });

        console.log("Réponse API :", response.data);

        // Réinitialiser les tentatives en cas de succès
        this.tentativesRestantes = 5;
        this.compteBloque = false;
        
        // Nettoyer le localStorage
        localStorage.removeItem('tentativesLogin');
        localStorage.removeItem('compteBloque');
        localStorage.removeItem('tempsDeblocage');

        // NOUVEAU : Stocker le token JWT et les infos utilisateur
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
        
        // Décrémenter les tentatives en cas d'erreur
        this.tentativesRestantes--;
        this.sauvegarderEtat(); // Sauvegarder après chaque tentative
        
        if (this.tentativesRestantes <= 0) {
          this.compteBloque = true;
          
          // Calculer le temps de déblocage (5 minutes dans le futur)
          const tempsDeblocage = Date.now() + 300000; // 5 minutes
          localStorage.setItem('tempsDeblocage', tempsDeblocage.toString());
          localStorage.setItem('compteBloque', 'true');
          
          alert("Trop de tentatives échouées. Compte bloqué pendant 5 minutes.");
          
          // Débloquer automatiquement après 5 minutes
          setTimeout(() => {
            this.debloquerCompte();
          }, 300000); // 5 minutes = 300000ms
        } else {
          if (error.response) {
            alert(`${error.response.data.error || "Identifiants incorrects."} (${this.tentativesRestantes} tentatives restantes)`);
          } else {
            alert(`Impossible de contacter le serveur. (${this.tentativesRestantes} tentatives restantes)`);
          }
        }
      }
    },
  },
};
</script>

<style>
@import '@/assets/styles/user.css';

/* Styles d'authentification */
.auth-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--gray-50);
  padding: 20px;
  font-family: 'Inter', 'Segoe UI', sans-serif;
}

.auth-card {
  background: white;
  padding: 40px;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
  width: 100%;
  max-width: 400px;
  backdrop-filter: blur(10px);
}

.auth-title {
  font-size: 28px;
  font-weight: 700;
  color: #1a202c;
  text-align: center;
  margin-bottom: 32px;
  letter-spacing: -0.5px;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-label {
  font-weight: 600;
  color: #374151;
  font-size: 14px;
  letter-spacing: 0.25px;
}

.input {
  padding: 14px 16px;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  font-size: 16px;
  transition: all 0.3s ease;
  background: #fafafa;
  outline: none;
}

.input:focus {
  border-color: #667eea;
  background: white;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  transform: translateY(-1px);
}

.btn {
  padding: 14px 24px;
  border-radius: 12px;
  font-weight: 600;
  font-size: 16px;
  transition: all 0.3s ease;
  cursor: pointer;
  border: none;
  letter-spacing: 0.25px;
  position: relative;
  overflow: hidden;
}

.btn-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-primary:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
}

.btn-primary:active:not(:disabled) {
  transform: translateY(0);
}

.w-full {
  width: 100%;
}

.auth-link {
  text-align: center;
  margin-top: 24px;
}

.auth-link p {
  color: #6b7280;
  font-size: 14px;
}

.auth-link a {
  color: #667eea;
  text-decoration: none;
  font-weight: 600;
  transition: color 0.3s ease;
}

.auth-link a:hover {
  color: #764ba2;
  text-decoration: underline;
}

/* Styles pour les tentatives et blocage */
.tentatives-warning {
  color: #ff6b35;
  font-size: 0.9em;
  margin-bottom: 10px;
  text-align: center;
  font-weight: bold;
  padding: 8px;
  background-color: #fff5f0;
  border-radius: 8px;
  border: 1px solid #fed7aa;
}

.compte-bloque {
  color: #dc3545;
  font-size: 0.9em;
  margin-bottom: 10px;
  text-align: center;
  font-weight: bold;
  background-color: #f8d7da;
  padding: 12px;
  border-radius: 8px;
  border: 1px solid #f5c6cb;
}

.btn:disabled {
  background: #9ca3af !important;
  cursor: not-allowed;
  opacity: 0.65;
  transform: none !important;
  box-shadow: none !important;
}

/* Responsive */
@media (max-width: 480px) {
  .auth-container {
    padding: 16px;
  }
  
  .auth-card {
    padding: 24px;
  }
  
  .auth-title {
    font-size: 24px;
    margin-bottom: 24px;
  }
}
</style>