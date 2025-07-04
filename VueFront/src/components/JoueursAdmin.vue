<template>
  <div>
    <!-- Navigation -->
    <nav class="navbar">
      <div class="logo">
        <router-link to="/AccueilAdmin">
          <img src="@/assets/images/psg.png" alt="PSG Logo" class="logo-img" />
        </router-link>
      </div>
      <div class="nav-links">
        <!-- Navigation links vides maintenant -->
      </div>
      <div class="nav-actions">
        <button class="notification-btn" @click="toggleNotifications">
          🔔 <span v-if="notifications.length > 0" class="badge">{{ notifications.length }}</span>
        </button>
        <button class="logout-button" @click="logout">Déconnexion</button>
      </div>
    </nav>

    <!-- Header -->
    <header class="hero-section">
      <h1>Gestion des Joueurs</h1>
      <p>Administration de l'équipe PSG</p>
      <div class="tabs">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          @click="handleTabClick(tab)"
          :class="['tab-btn', { 'active': activeTab === tab.id }]"
        >
          {{ tab.label }}
        </button>
      </div>
    </header>

    <!-- Dashboard -->
    <div class="dashboard">
      <!-- Statistics Cards -->
      <div class="stats">
        <div class="stat-card">
          <div class="stat-info">
            <p>Total Joueurs</p>
            <h3>{{ joueurs.length }}</h3>
          </div>
          <div class="stat-icon">👥</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Gardiens</p>
            <h3>{{ getJoueursByPoste('Gardien').length }}</h3>
          </div>
          <div class="stat-icon">🥅</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Défenseurs</p>
            <h3>{{ getJoueursByPoste('Défenseur').length }}</h3>
          </div>
          <div class="stat-icon">🛡️</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Milieux</p>
            <h3>{{ getJoueursByPoste('Milieu').length }}</h3>
          </div>
          <div class="stat-icon">⚽</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Attaquants</p>
            <h3>{{ getJoueursByPoste('Attaquant').length }}</h3>
          </div>
          <div class="stat-icon">🎯</div>
        </div>
      </div>

      <!-- Content -->
      <div class="content">
        <!-- Formulaire d'ajout/modification -->
        <div class="card">
          <h2>👤 {{ form.id ? 'Modifier' : 'Ajouter' }} un Joueur</h2>
          
          <form @submit.prevent="saveJoueur" class="form">
            <div class="form-row">
              <input v-model="form.nom" placeholder="Nom" required class="input" />
              <input v-model="form.prenom" placeholder="Prénom" required class="input" />
            </div>

            <div class="form-row">
              <select v-model="form.poste" required class="input">
                <option value="" disabled>Choisir un poste</option>
                <option v-for="poste in postes" :key="poste" :value="poste">{{ poste }}</option>
              </select>

              <select v-model="form.pays_origine" required class="input">
                <option value="" disabled>Choisir un pays</option>
                <option v-for="pays in paysList" :key="pays" :value="pays">{{ pays }}</option>
              </select>
            </div>

            <div class="form-row">
              <input v-model="form.age" type="number" placeholder="Âge" required class="input" min="16" max="45" />
              <input v-model="form.numero_maillot" type="number" placeholder="Numéro de Maillot" required class="input" min="1" max="99" />
            </div>

            <div class="form-row">
              <input v-model="form.taille_cm" type="number" placeholder="Taille (cm)" required class="input" min="150" max="220" />
              <input v-model="form.poids_kg" type="number" placeholder="Poids (kg)" required class="input" min="50" max="120" />
            </div>

            <div class="form-actions">
              <button type="submit" class="btn-success" :disabled="isSubmitting">
                {{ isSubmitting ? '⏳ Sauvegarde...' : (form.id ? '✅ Modifier' : '✅ Ajouter') }}
              </button>
              <button type="button" @click="resetForm" class="btn-secondary">Annuler</button>
            </div>
          </form>
        </div>

        <!-- Table des joueurs -->
        <div class="card">
          <h2>📋 Liste des Joueurs</h2>
          
          <div v-if="joueurs.length === 0" class="empty">
            <p>Aucun joueur enregistré</p>
          </div>

          <div v-else class="players-list-table">
            <table class="table">
              <thead>
                <tr>
                  <th>N°</th>
                  <th>Nom</th>
                  <th>Prénom</th>
                  <th>Poste</th>
                  <th>Pays</th>
                  <th>Âge</th>
                  <th>Taille</th>
                  <th>Poids</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="joueur in joueurs" :key="joueur.id">
                  <td><span class="player-number">{{ joueur.numero_maillot }}</span></td>
                  <td class="player-name">{{ joueur.nom }}</td>
                  <td>{{ joueur.prenom }}</td>
                  <td>
                    <span class="player-position">
                      {{ joueur.poste }}
                    </span>
                  </td>
                  <td>{{ joueur.pays_origine }}</td>
                  <td><span class="player-age">{{ joueur.age }} ans</span></td>
                  <td><span class="player-stats">{{ joueur.taille_cm }} cm</span></td>
                  <td><span class="player-stats">{{ joueur.poids_kg }} kg</span></td>
                  <td class="actions">
                    <button @click="editJoueur(joueur)" class="btn-edit">Modifier</button>
                    <button @click="deleteJoueur(joueur.id)" class="btn-delete">Supprimer</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Notifications Panel -->
    <div v-if="showNotifications" class="notifications-panel">
      <div class="panel-header">
        <h3>Notifications</h3>
        <button @click="showNotifications = false">✕</button>
      </div>
      <div class="panel-body">
        <div v-for="notif in notifications" :key="notif.id" class="notification" :class="notif.type">
          <p>{{ notif.message }}</p>
          <small>{{ notif.time }}</small>
        </div>
        <div v-if="notifications.length === 0" class="notification">
          <p>Aucune notification</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: 'JoueursAdmin',
  data() {
    return {
      joueurs: [],
      showNotifications: false,
      isSubmitting: false,
      notifications: [],
      activeTab: 'joueurs',
      
      // ===== CONFIGURATION =====
      tabs: [
        { id: 'actualites', label: 'Actualités', route: '/AccueilAdmin' },
        { id: 'matches', label: 'Matchs', route: '/AccueilAdmin' },
        { id: 'entrainements', label: 'Entraînements', route: '/AccueilAdmin' },
        { id: 'joueurs', label: 'Gérer les joueurs' },
        { id: 'boutique', label: 'Gérer la boutique', route: '/BoutiqueAdmin' }
      ],
      
      form: {
        id: null,
        nom: "",
        prenom: "",
        poste: "",
        pays_origine: "",
        age: "",
        taille_cm: "",
        poids_kg: "",
        numero_maillot: "",
        equipe: "PSG",
      },
      postes: ["Gardien", "Défenseur", "Milieu", "Attaquant"],
      paysList: [
        "France", "Brésil", "Allemagne", "Argentine", "Espagne", "Italie", 
        "Angleterre", "Portugal", "Pays-Bas", "Belgique", "Maroc", "Sénégal",
        "Cameroun", "Côte d'Ivoire", "Uruguay", "Colombie", "Mexique", "Japon",
        "Corée du Sud", "Pologne", "Croatie", "Serbie", "Danemark", "Suède",
        "Norvège", "Autriche", "Suisse", "République tchèque", "Ghana", "Nigeria"
      ],
    };
  },
  methods: {
    logout() {
      localStorage.removeItem("authToken");
      this.$router.push("/login");
    },

    toggleNotifications() {
      this.showNotifications = !this.showNotifications;
    },

    // ===== NAVIGATION =====
    handleTabClick(tab) {
      if (tab.route) {
        // Si l'onglet a une route, navigue vers cette page
        this.$router.push(tab.route);
      } else {
        // Sinon, change l'onglet actif (reste sur la page actuelle)
        this.activeTab = tab.id;
      }
    },

    async fetchJoueurs() {
      try {
        const response = await axios.get("http://localhost:8000/api/joueurs");
        this.joueurs = response.data.filter(j => j.equipe === 'PSG') || [];
      } catch (error) {
        console.error('Erreur lors du chargement des joueurs:', error);
        this.showError('Erreur lors du chargement des joueurs');
      }
    },

    async saveJoueur() {
      // Validation
      if (!this.validateForm()) {
        return;
      }

      this.isSubmitting = true;
      try {
        const url = this.form.id
          ? `http://localhost:8000/api/joueurs/${this.form.id}`
          : "http://localhost:8000/api/joueurs";
        const method = this.form.id ? "put" : "post";

        await axios[method](url, this.form);
        
        await this.fetchJoueurs();
        this.resetForm();
        this.showSuccess(this.form.id ? 'Joueur modifié avec succès' : 'Joueur ajouté avec succès');
      } catch (error) {
        console.error('Erreur lors de la sauvegarde:', error);
        if (error.response?.data?.message) {
          this.showError(error.response.data.message);
        } else {
          this.showError('Erreur lors de la sauvegarde du joueur');
        }
      } finally {
        this.isSubmitting = false;
      }
    },

    async deleteJoueur(id) {
      if (!confirm('Êtes-vous sûr de vouloir supprimer ce joueur ?')) {
        return;
      }

      try {
        await axios.delete(`http://localhost:8000/api/joueurs/${id}`);
        await this.fetchJoueurs();
        this.showSuccess('Joueur supprimé avec succès');
      } catch (error) {
        console.error('Erreur lors de la suppression:', error);
        this.showError('Erreur lors de la suppression du joueur');
      }
    },

    editJoueur(joueur) {
      this.form = { ...joueur };
      // Scroll to form
      document.querySelector('.form').scrollIntoView({ behavior: 'smooth' });
    },

    resetForm() {
      this.form = {
        id: null,
        nom: "",
        prenom: "",
        poste: "",
        pays_origine: "",
        age: "",
        taille_cm: "",
        poids_kg: "",
        numero_maillot: "",
        equipe: "PSG",
      };
    },

    validateForm() {
      if (!this.form.nom || !this.form.prenom || !this.form.poste || !this.form.pays_origine) {
        this.showError('Veuillez remplir tous les champs obligatoires');
        return false;
      }

      if (this.form.age < 16 || this.form.age > 45) {
        this.showError('L\'âge doit être entre 16 et 45 ans');
        return false;
      }

      if (this.form.numero_maillot < 1 || this.form.numero_maillot > 99) {
        this.showError('Le numéro de maillot doit être entre 1 et 99');
        return false;
      }

      // Vérifier si le numéro de maillot est déjà pris
      const existingPlayer = this.joueurs.find(j => 
        j.numero_maillot == this.form.numero_maillot && j.id !== this.form.id
      );
      if (existingPlayer) {
        this.showError(`Le numéro ${this.form.numero_maillot} est déjà pris par ${existingPlayer.prenom} ${existingPlayer.nom}`);
        return false;
      }

      return true;
    },

    getJoueursByPoste(poste) {
      return this.joueurs.filter(j => j.poste === poste);
    },

    getPosteBadgeClass(poste) {
      const classes = {
        'Gardien': 'gardien',
        'Défenseur': 'defenseur',
        'Milieu': 'milieu',
        'Attaquant': 'attaquant'
      };
      return classes[poste] || '';
    },

    showSuccess(message) {
      this.notifications.unshift({
        id: Date.now(),
        message,
        time: 'Maintenant',
        type: 'success'
      });
      // Auto-remove after 5 seconds
      setTimeout(() => {
        this.notifications = this.notifications.filter(n => n.id !== this.notifications[0]?.id);
      }, 5000);
    },

    showError(message) {
      this.notifications.unshift({
        id: Date.now(),
        message,
        time: 'Maintenant',
        type: 'error'
      });
      // Auto-remove after 5 seconds
      setTimeout(() => {
        this.notifications = this.notifications.filter(n => n.id !== this.notifications[0]?.id);
      }, 5000);
    }
  },

  async mounted() {
    await this.fetchJoueurs();
  },
};
</script>

<style>
@import '@/assets/styles/admin.css';
</style>
