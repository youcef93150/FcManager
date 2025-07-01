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

          <div v-else class="table-container">
            <table class="joueurs-table">
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
                <tr v-for="joueur in joueurs" :key="joueur.id" class="joueur-row">
                  <td class="numero">{{ joueur.numero_maillot }}</td>
                  <td class="nom">{{ joueur.nom }}</td>
                  <td class="prenom">{{ joueur.prenom }}</td>
                  <td>
                    <span :class="['poste-badge', getPosteBadgeClass(joueur.poste)]">
                      {{ joueur.poste }}
                    </span>
                  </td>
                  <td>{{ joueur.pays_origine }}</td>
                  <td>{{ joueur.age }} ans</td>
                  <td>{{ joueur.taille_cm }} cm</td>
                  <td>{{ joueur.poids_kg }} kg</td>
                  <td class="actions">
                    <button @click="editJoueur(joueur)" class="btn-secondary btn-small">✏️</button>
                    <button @click="deleteJoueur(joueur.id)" class="btn-danger btn-small">🗑️</button>
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
import axios from '@/utils/auth';

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

<style scoped>
/* ===== RESET & BASE ===== */
* {
  box-sizing: border-box;
}

/* ===== NAVIGATION ===== */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #9ca3af;
  padding: 15px 25px;
  color: white;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.logo-img { 
  height: 50px; 
}

.nav-links {
  flex: 1;
  display: flex;
  justify-content: center;
}

.nav-actions {
  display: flex;
  gap: 15px;
  align-items: center;
}

.notification-btn, .logout-button {
  background: #d1d5db;
  border: none;
  color: #374151;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.notification-btn:hover, .logout-button:hover {
  background: #6b7280;
  color: white;
}

.badge {
  background: white;
  color: #9ca3af;
  border-radius: 50%;
  padding: 2px 6px;
  font-size: 12px;
  margin-left: 5px;
  font-weight: bold;
}

/* ===== HERO SECTION ===== */
.hero-section {
  background: linear-gradient(45deg, #9ca3af, #d1d5db);
  color: white;
  text-align: center;
  padding: 40px 20px;
}

.hero-section h1 {
  font-size: 36px;
  font-weight: bold;
  margin-bottom: 10px;
}

.hero-section p {
  font-size: 18px;
  margin-bottom: 30px;
  opacity: 0.9;
}

.tabs {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-top: 20px;
  flex-wrap: wrap;
}

.tab-btn {
  background: rgba(255,255,255,0.2);
  color: white;
  border: none;
  padding: 12px 20px;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s;
  font-weight: 500;
  font-size: 14px;
  white-space: nowrap;
}

.tab-btn:hover {
  background: rgba(255,255,255,0.3);
  transform: translateY(-2px);
}

.tab-btn.active {
  background: white;
  color: #9ca3af;
  font-weight: bold;
  box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

/* ===== DASHBOARD ===== */
.dashboard {
  max-width: 1200px;
  margin: 0 auto;
  padding: 30px 20px;
  background-color: #f7fafc;
  min-height: calc(100vh - 180px);
}

/* ===== STATISTICS CARDS ===== */
.stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.stat-card {
  background: white;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-left: 4px solid #9ca3af;
  transition: transform 0.3s, box-shadow 0.3s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0,0,0,0.15);
}

.stat-info p {
  margin: 0;
  color: #9ca3af;
  font-size: 14px;
  font-weight: 500;
}

.stat-info h3 {
  margin: 8px 0 0 0;
  color: #4b5563;
  font-size: 28px;
  font-weight: bold;
}

.stat-icon {
  font-size: 32px;
  opacity: 0.8;
}

/* ===== CONTENT LAYOUT ===== */
.content {
  display: grid;
  gap: 30px;
}

/* ===== CARDS ===== */
.card {
  background: white;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  border: 1px solid #e2e8f0;
}

.card h2 {
  color: #4b5563;
  margin-bottom: 24px;
  font-weight: bold;
  font-size: 24px;
  display: flex;
  align-items: center;
  gap: 10px;
}

/* ===== FORMS ===== */
.form {
  background: #f7fafc;
  padding: 24px;
  border-radius: 12px;
  border: 2px solid #e2e8f0;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 16px;
}

.input, select {
  width: 100%;
  padding: 12px;
  border: 1px solid #cbd5e0;
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.3s, box-shadow 0.3s;
}

.input:focus, select:focus {
  outline: none;
  border-color: #9ca3af;
  box-shadow: 0 0 0 3px rgba(156, 163, 175, 0.1);
}

.form-actions {
  display: flex;
  gap: 12px;
  margin-top: 24px;
}

/* ===== BUTTONS ===== */
.btn-success {
  background: #48bb78;
  color: white;
  border: none;
  padding: 12px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: background-color 0.3s;
}

.btn-success:hover {
  background: #38a169;
}

.btn-success:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-secondary {
  background: #9ca3af;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.3s;
}

.btn-secondary:hover {
  background: #6b7280;
}

.btn-danger {
  background: #f56565;
  color: white;
  border: none;
  padding: 8px 12px;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.3s;
}

.btn-danger:hover {
  background: #e53e3e;
}

.btn-small {
  padding: 6px 10px;
  font-size: 12px;
}

/* ===== TABLE ===== */
.table-container {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
}

.joueurs-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
}

.joueurs-table th {
  background: #f7fafc;
  color: #4a5568;
  font-weight: 600;
  padding: 16px 12px;
  text-align: left;
  border-bottom: 2px solid #e2e8f0;
  font-size: 14px;
}

.joueurs-table td {
  padding: 16px 12px;
  border-bottom: 1px solid #e2e8f0;
  font-size: 14px;
}

.joueur-row {
  transition: background-color 0.3s;
}

.joueur-row:hover {
  background: #f7fafc;
}

.numero {
  font-weight: bold;
  color: #2d3748;
  text-align: center;
  background: #bee3f8;
  border-radius: 6px;
  min-width: 40px;
}

.nom, .prenom {
  font-weight: 600;
  color: #2d3748;
}

.actions {
  display: flex;
  gap: 8px;
  justify-content: center;
}

/* ===== POSTE BADGES ===== */
.poste-badge {
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: bold;
  text-align: center;
  display: inline-block;
  min-width: 80px;
}

.poste-badge.gardien {
  background: #fef5e7;
  color: #975a16;
  border: 1px solid #f6ad55;
}

.poste-badge.defenseur {
  background: #e6fffa;
  color: #234e52;
  border: 1px solid #4fd1c7;
}

.poste-badge.milieu {
  background: #edf2f7;
  color: #2d3748;
  border: 1px solid #a0aec0;
}

.poste-badge.attaquant {
  background: #fed7d7;
  color: #c53030;
  border: 1px solid #fc8181;
}

/* ===== EMPTY STATE ===== */
.empty {
  text-align: center;
  padding: 60px 20px;
  color: #718096;
  background: #f7fafc;
  border-radius: 12px;
  border: 2px dashed #e2e8f0;
}

/* ===== NOTIFICATIONS PANEL ===== */
.notifications-panel {
  position: fixed;
  top: 0;
  right: 0;
  width: 400px;
  height: 100vh;
  background: white;
  box-shadow: -4px 0 20px rgba(0,0,0,0.15);
  z-index: 1000;
  transform: translateX(0);
  transition: transform 0.3s ease;
}

.panel-header {
  background: #9ca3af;
  color: white;
  padding: 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.panel-header h3 {
  margin: 0;
  font-size: 18px;
}

.panel-header button {
  background: none;
  border: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  transition: background-color 0.3s;
}

.panel-header button:hover {
  background: rgba(255,255,255,0.1);
}

.panel-body {
  padding: 20px;
  height: calc(100vh - 88px);
  overflow-y: auto;
}

.notification {
  padding: 16px;
  border-bottom: 1px solid #e2e8f0;
  border-radius: 8px;
  margin-bottom: 8px;
}

.notification.success {
  background: #c6f6d5;
  border-left: 4px solid #48bb78;
}

.notification.error {
  background: #fed7d7;
  border-left: 4px solid #f56565;
}

.notification p {
  margin: 0 0 4px 0;
  font-weight: 500;
  color: #2d3748;
}

.notification small {
  color: #718096;
  font-size: 12px;
}

/* ===== RESPONSIVE DESIGN ===== */
@media (max-width: 768px) {
  .stats {
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 16px;
  }
  
  .form-row {
    grid-template-columns: 1fr;
  }
  
  .notifications-panel {
    width: 100%;
  }
  
  .hero-section h1 {
    font-size: 28px;
  }

  .hero-section p {
    font-size: 16px;
  }

  .tabs {
    flex-direction: column;
    gap: 10px;
  }

  .tab-btn {
    padding: 10px 20px;
    font-size: 14px;
  }

  .joueurs-table th,
  .joueurs-table td {
    padding: 8px 6px;
    font-size: 12px;
  }

  .actions {
    flex-direction: column;
    gap: 4px;
  }

  .btn-small {
    padding: 4px 8px;
    font-size: 11px;
  }
}

@media (max-width: 480px) {
  .dashboard {
    padding: 15px 10px;
  }
  
  .card {
    padding: 20px;
  }
  
  .stats {
    grid-template-columns: 1fr;
  }

  .navbar {
    padding: 10px 15px;
  }

  .nav-actions {
    gap: 10px;
  }

  .stat-card {
    padding: 16px;
  }

  .form {
    padding: 16px;
  }
  
  .tabs {
    gap: 8px;
  }
  
  .tab-btn {
    padding: 8px 14px;
    font-size: 12px;
  }

  .table-container {
    font-size: 11px;
  }

  .poste-badge {
    font-size: 10px;
    padding: 4px 8px;
    min-width: 60px;
  }
}
</style>