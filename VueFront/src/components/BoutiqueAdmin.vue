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

          <div v-else class="products-catalog-table">
            <table class="table">
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
                <tr v-for="product in filteredProducts" :key="product.id">
                  <td>{{ product.id }}</td>
                  <td class="product-name">{{ product.nom }}</td>
                  <td><span class="product-price">{{ product.prix }}€</span></td>
                  <td>
                    <span v-if="product.taille" class="size-badge">{{ product.taille }}</span>
                    <span v-else>-</span>
                  </td>
                  <td>
                    <span class="color-badge" :style="{ backgroundColor: getColorCode(product.couleur) }">
                      {{ product.couleur }}
                    </span>
                  </td>
                  <td>
                    <span v-if="product.categorie" class="product-category">{{ product.categorie }}</span>
                    <span v-else>-</span>
                  </td>
                  <td>
                    <span class="product-stock">{{ product.stock }}</span>
                    <span v-if="product.stock <= 5" class="stock-warning">⚠️</span>
                  </td>
                  <td class="actions">
                    <button @click="editProduct(product)" class="btn-edit">Modifier</button>
                    <button @click="deleteProduct(product)" class="btn-delete">Supprimer</button>
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

<style>
@import '@/assets/styles/admin.css';
</style>

