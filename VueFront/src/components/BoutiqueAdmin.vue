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
      <h1>Gestion de la Boutique</h1>
      <p>Administration des produits PSG</p>
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
            <p>Total Produits</p>
            <h3>{{ products.length }}</h3>
          </div>
          <div class="stat-icon">🛍️</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Stock Total</p>
            <h3>{{ totalStock }}</h3>
          </div>
          <div class="stat-icon">📦</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Valeur Stock</p>
            <h3>{{ totalValue }}€</h3>
          </div>
          <div class="stat-icon">💰</div>
        </div>
        <div class="stat-card">
          <div class="stat-info">
            <p>Stock Faible</p>
            <h3>{{ lowStockProducts }}</h3>
          </div>
          <div class="stat-icon">⚠️</div>
        </div>
      </div>

      <!-- Content -->
      <div class="content">
        <!-- Formulaire d'ajout de produit -->
        <div class="card">
          <h2>➕ Ajouter un Produit</h2>
          
          <form @submit.prevent="addProduct" class="form">
            <div class="form-row">
              <input v-model="newProduct.nom" type="text" placeholder="Nom du produit" required class="input" />
              <input v-model="newProduct.prix" type="number" step="0.01" placeholder="Prix (€)" required class="input" min="0" />
            </div>

            <div class="form-row">
              <select v-model="newProduct.taille" class="input">
                <option disabled value="">Sélectionnez une taille</option>
                <option value="XS">XS</option>
                <option value="S">S</option>
                <option value="M">M</option>
                <option value="L">L</option>
                <option value="XL">XL</option>
                <option value="XXL">XXL</option>
                <option value="Unique">Unique</option>
              </select>
              <input v-model="newProduct.couleur" type="text" placeholder="Couleur" required class="input" />
            </div>

            <textarea v-model="newProduct.description" placeholder="Description du produit" required class="textarea"></textarea>

            <div class="form-row">
              <input v-model="newProduct.stock" type="number" placeholder="Quantité en stock" required class="input" min="0" />
              <select v-model="newProduct.categorie" class="input">
                <option value="">Catégorie (optionnel)</option>
                <option value="Maillots">Maillots</option>
                <option value="Accessoires">Accessoires</option>
                <option value="Chaussures">Chaussures</option>
                <option value="Équipement">Équipement</option>
                <option value="Lifestyle">Lifestyle</option>
              </select>
            </div>

            <div class="form-actions">
              <button type="submit" class="btn-success" :disabled="isSubmitting">
                {{ isSubmitting ? '⏳ Ajout...' : '✅ Ajouter Produit' }}
              </button>
              <button type="button" @click="resetForm" class="btn-secondary">Réinitialiser</button>
            </div>
          </form>
        </div>

        <!-- Liste des produits -->
        <div class="card">
          <h2>📋 Catalogue Produits</h2>
          
          <!-- Filtres -->
          <div class="filters">
            <input v-model="searchTerm" placeholder="🔍 Rechercher un produit..." class="search-input" />
            <select v-model="filterCategory" class="filter-select">
              <option value="">Toutes les catégories</option>
              <option value="Maillots">Maillots</option>
              <option value="Accessoires">Accessoires</option>
              <option value="Chaussures">Chaussures</option>
              <option value="Équipement">Équipement</option>
              <option value="Lifestyle">Lifestyle</option>
            </select>
            <select v-model="filterStock" class="filter-select">
              <option value="">Tous les stocks</option>
              <option value="low">Stock faible (≤5)</option>
              <option value="medium">Stock moyen (6-20)</option>
              <option value="high">Stock élevé (>20)</option>
            </select>
          </div>

          <div v-if="filteredProducts.length === 0" class="empty">
            <p>Aucun produit trouvé</p>
          </div>

          <div v-else class="table-container">
            <table class="products-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Produit</th>
                  <th>Prix</th>
                  <th>Taille</th>
                  <th>Couleur</th>
                  <th>Catégorie</th>
                  <th>Stock</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="product in filteredProducts" :key="product.id" class="product-row" :class="{ 'low-stock': product.stock <= 5 }">
                  <td class="product-id">{{ product.id }}</td>
                  <td class="product-name">
                    <div>
                      <strong>{{ product.nom }}</strong>
                      <p class="description">{{ product.description }}</p>
                    </div>
                  </td>
                  <td class="price">{{ product.prix }}€</td>
                  <td>
                    <span v-if="product.taille" class="size-badge">{{ product.taille }}</span>
                    <span v-else class="no-size">-</span>
                  </td>
                  <td>
                    <span class="color-badge" :style="{ backgroundColor: getColorCode(product.couleur) }">
                      {{ product.couleur }}
                    </span>
                  </td>
                  <td>
                    <span v-if="product.categorie" class="category-badge">{{ product.categorie }}</span>
                    <span v-else class="no-category">-</span>
                  </td>
                  <td class="stock-cell">
                    <input
                      type="number"
                      v-model.number="product.stock"
                      @change="updateStock(product.id, product.stock)"
                      class="stock-input"
                      :class="{ 'low-stock-input': product.stock <= 5 }"
                      min="0"
                    />
                    <span v-if="product.stock <= 5" class="stock-warning">⚠️</span>
                  </td>
                  <td class="actions">
                    <button @click="editProduct(product)" class="btn-secondary btn-small" title="Modifier">✏️</button>
                    <button @click="deleteProduct(product)" class="btn-danger btn-small" title="Supprimer">🗑️</button>
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
  name: 'BoutiqueAdmin',
  data() {
    return {
      products: [],
      showNotifications: false,
      isSubmitting: false,
      notifications: [],
      activeTab: 'boutique',
      searchTerm: '',
      filterCategory: '',
      filterStock: '',
      
      // ===== CONFIGURATION =====
      tabs: [
        { id: 'actualites', label: 'Actualités', route: '/AccueilAdmin' },
        { id: 'matches', label: 'Matchs', route: '/AccueilAdmin' },
        { id: 'entrainements', label: 'Entraînements', route: '/AccueilAdmin' },
        { id: 'joueurs', label: 'Gérer les joueurs', route: '/JoueursAdmin' },
        { id: 'boutique', label: 'Gérer la boutique' }
      ],
      
      newProduct: {
        nom: "",
        prix: "",
        taille: "",
        couleur: "",
        description: "",
        stock: "",
        categorie: ""
      }
    };
  },

  computed: {
    totalStock() {
      return this.products.reduce((total, product) => total + product.stock, 0);
    },

    totalValue() {
      return this.products.reduce((total, product) => total + (product.prix * product.stock), 0).toFixed(2);
    },

    lowStockProducts() {
      return this.products.filter(product => product.stock <= 5).length;
    },

    filteredProducts() {
      let filtered = this.products;

      // Filtre par recherche
      if (this.searchTerm) {
        filtered = filtered.filter(product => 
          product.nom.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
          product.description.toLowerCase().includes(this.searchTerm.toLowerCase())
        );
      }

      // Filtre par catégorie
      if (this.filterCategory) {
        filtered = filtered.filter(product => product.categorie === this.filterCategory);
      }

      // Filtre par stock
      if (this.filterStock) {
        switch (this.filterStock) {
          case 'low':
            filtered = filtered.filter(product => product.stock <= 5);
            break;
          case 'medium':
            filtered = filtered.filter(product => product.stock > 5 && product.stock <= 20);
            break;
          case 'high':
            filtered = filtered.filter(product => product.stock > 20);
            break;
        }
      }

      return filtered;
    }
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
        this.$router.push(tab.route);
      } else {
        this.activeTab = tab.id;
      }
    },

    async addProduct() {
      if (!this.validateProduct()) {
        return;
      }

      this.isSubmitting = true;
      try {
        const response = await axios.post("http://localhost:8000/api/produits", this.newProduct);
        
        await this.loadProducts();
        this.resetForm();
        this.showSuccess("Produit ajouté avec succès");
      } catch (error) {
        console.error("Erreur lors de l'ajout du produit:", error);
        this.showError("Erreur lors de l'ajout du produit");
      } finally {
        this.isSubmitting = false;
      }
    },

    async updateStock(productId, newStock) {
      if (newStock < 0) {
        this.showError("Le stock ne peut pas être négatif");
        await this.loadProducts();
        return;
      }

      try {
        await axios.put(`http://localhost:8000/api/produits/${productId}/stock`, { stock: newStock });
        this.showSuccess("Stock mis à jour");
        
        // Check for low stock warning
        if (newStock <= 5 && newStock > 0) {
          this.showWarning(`Stock faible pour ce produit (${newStock} restant)`);
        }
      } catch (error) {
        console.error("Erreur lors de la mise à jour du stock:", error);
        this.showError("Erreur lors de la mise à jour du stock");
        await this.loadProducts();
      }
    },

    async deleteProduct(product) {
      if (!confirm(`Êtes-vous sûr de vouloir supprimer "${product.nom}" ?`)) {
        return;
      }

      try {
        await axios.delete(`http://localhost:8000/api/produits/${product.id}`);
        await this.loadProducts();
        this.showSuccess("Produit supprimé avec succès");
      } catch (error) {
        console.error("Erreur lors de la suppression:", error);
        this.showError("Erreur lors de la suppression du produit");
      }
    },

    editProduct(product) {
      this.newProduct = { ...product };
      document.querySelector('.form').scrollIntoView({ behavior: 'smooth' });
    },

    async loadProducts() {
      try {
        const response = await axios.get("http://localhost:8000/api/produits");
        this.products = response.data || [];
      } catch (error) {
        console.error("Erreur lors du chargement des produits:", error);
        this.showError("Erreur lors du chargement des produits");
      }
    },

    resetForm() {
      this.newProduct = {
        nom: "",
        prix: "",
        taille: "",
        couleur: "",
        description: "",
        stock: "",
        categorie: ""
      };
    },

    validateProduct() {
      if (!this.newProduct.nom || !this.newProduct.prix || !this.newProduct.couleur || 
          !this.newProduct.description || !this.newProduct.stock) {
        this.showError("Veuillez remplir tous les champs obligatoires");
        return false;
      }

      if (this.newProduct.prix <= 0) {
        this.showError("Le prix doit être supérieur à 0");
        return false;
      }

      if (this.newProduct.stock < 0) {
        this.showError("Le stock ne peut pas être négatif");
        return false;
      }

      return true;
    },

    getColorCode(colorName) {
      const colors = {
        'rouge': '#ff0000', 'bleu': '#0000ff', 'vert': '#008000',
        'jaune': '#ffff00', 'noir': '#000000', 'blanc': '#ffffff',
        'rose': '#ffc0cb', 'violet': '#800080', 'orange': '#ffa500',
        'gris': '#808080', 'marron': '#a52a2a'
      };
      return colors[colorName.toLowerCase()] || '#cccccc';
    },

    showSuccess(message) {
      this.notifications.unshift({
        id: Date.now(),
        message,
        time: 'Maintenant',
        type: 'success'
      });
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
      setTimeout(() => {
        this.notifications = this.notifications.filter(n => n.id !== this.notifications[0]?.id);
      }, 5000);
    },

    showWarning(message) {
      this.notifications.unshift({
        id: Date.now(),
        message,
        time: 'Maintenant',
        type: 'warning'
      });
      setTimeout(() => {
        this.notifications = this.notifications.filter(n => n.id !== this.notifications[0]?.id);
      }, 7000);
    }
  },

  async mounted() {
    await this.loadProducts();
  }
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
  max-width: 1400px;
  margin: 0 auto;
  padding: 30px 20px;
  background-color: #f7fafc;
  min-height: calc(100vh - 180px);
}

/* ===== STATISTICS CARDS ===== */
.stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
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

.input, .textarea, select {
  width: 100%;
  padding: 12px;
  border: 1px solid #cbd5e0;
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.3s, box-shadow 0.3s;
}

.input:focus, .textarea:focus, select:focus {
  outline: none;
  border-color: #9ca3af;
  box-shadow: 0 0 0 3px rgba(156, 163, 175, 0.1);
}

.textarea {
  resize: vertical;
  min-height: 80px;
  font-family: inherit;
  grid-column: 1 / -1;
}

.form-actions {
  display: flex;
  gap: 12px;
  margin-top: 24px;
}

/* ===== FILTERS ===== */
.filters {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr;
  gap: 16px;
  margin-bottom: 24px;
  padding: 20px;
  background: #f7fafc;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
}

.search-input, .filter-select {
  padding: 10px 12px;
  border: 1px solid #cbd5e0;
  border-radius: 8px;
  font-size: 14px;
}

.search-input:focus, .filter-select:focus {
  outline: none;
  border-color: #9ca3af;
  box-shadow: 0 0 0 2px rgba(156, 163, 175, 0.1);
}

/* ===== TABLE ===== */
.table-container {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
}

.products-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  min-width: 800px;
}

.products-table th {
  background: #f7fafc;
  color: #4a5568;
  font-weight: 600;
  padding: 16px 12px;
  text-align: left;
  border-bottom: 2px solid #e2e8f0;
  font-size: 14px;
  white-space: nowrap;
}

.products-table td {
  padding: 16px 12px;
  border-bottom: 1px solid #e2e8f0;
  font-size: 14px;
  vertical-align: top;
}

.product-row {
  transition: background-color 0.3s;
}

.product-row:hover {
  background: #f7fafc;
}

.product-row.low-stock {
  background: #fef5e7;
}

.product-id {
  font-weight: bold;
  color: #2d3748;
  text-align: center;
  background: #bee3f8;
  border-radius: 6px;
  min-width: 50px;
}

.product-name strong {
  color: #2d3748;
  font-size: 16px;
}

.description {
  color: #718096;
  font-size: 12px;
  margin: 4px 0 0 0;
  max-width: 200px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.price {
  font-weight: bold;
  color: #48bb78;
  font-size: 16px;
}

/* ===== BADGES ===== */
.size-badge {
  background: #bee3f8;
  color: #2b6cb0;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: bold;
}

.color-badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: bold;
  color: white;
  text-shadow: 1px 1px 1px rgba(0,0,0,0.5);
  border: 1px solid #ccc;
}

.category-badge {
  background: #d6f5d6;
  color: #276749;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: bold;
}

.no-size, .no-category {
  color: #a0aec0;
  font-style: italic;
}

/* ===== STOCK CELL ===== */
.stock-cell {
  text-align: center;
  position: relative;
}

.stock-input {
  width: 70px;
  text-align: center;
  padding: 6px;
  border: 1px solid #cbd5e0;
  border-radius: 6px;
}

.stock-input.low-stock-input {
  border-color: #f56565;
  background: #fed7d7;
}

.stock-warning {
  position: absolute;
  top: -5px;
  right: -5px;
  font-size: 16px;
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

.actions {
  display: flex;
  gap: 8px;
  justify-content: center;
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

.notification.warning {
  background: #fef5e7;
  border-left: 4px solid #f6ad55;
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
  
  .filters {
    grid-template-columns: 1fr;
  }
  
  .notifications-panel {
    width: 100%;
  }
  
  .tabs {
    flex-direction: column;
    gap: 10px;
  }

  .tab-btn {
    padding: 10px 20px;
    font-size: 14px;
  }
  
  .hero-section h1 {
    font-size: 28px;
  }

  .hero-section p {
    font-size: 16px;
  }

  .products-table th,
  .products-table td {
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

  .description {
    max-width: 150px;
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

  .size-badge, .category-badge {
    font-size: 10px;
    padding: 2px 6px;
  }

  .color-badge {
    font-size: 10px;
    padding: 2px 8px;
  }

  .stock-input {
    width: 50px;
    padding: 4px;
  }
}
</style>