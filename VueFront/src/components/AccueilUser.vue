<template>
  <div>
    <!-- Barre de navigation -->
    <nav class="navbar">
      <div class="logo">
        <router-link to="/AccueilUser">
          <img src="@/assets/images/psg.png" alt="PSG Logo" class="logo-img" />
        </router-link>
      </div>
      <!-- <div class="nav-links">
        <router-link to="/Classement">Classement</router-link>  |
        <router-link to="/psg-results">Résultats des matchs</router-link> |
        <router-link to="/JoueursUser">Voir les joueurs du club</router-link> |
        <router-link to="/BoutiqueUser">Voir les stock de la boutique</router-link>
      </div> -->
      <div class="nav-actions">
        <button class="notification-btn" @click="toggleNotifications">
          <span class="notification-icon">🔔</span>
          <span v-if="notifications.length > 0" class="notification-badge">{{ notifications.length }}</span>
        </button>
        <button class="logout-button" @click="logout">Déconnexion</button>
      </div>
    </nav>

    <!-- Section héroïque -->
    <header class="hero-section">
      <h1 class="hero-title">Bienvenue sur le site officiel des supporters du PSG !</h1>
      <p class="hero-description">
        Découvrez les classements, résultats et joueurs de votre club favori.
      </p>
      <div class="dashboard-tabs">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          @click="activeTab = tab.id"
          :class="['tab-button', { 'active': activeTab === tab.id }]"
        >
          {{ tab.label }}
        </button>
      </div>
    </header>

    <!-- Dashboard Content -->
    <div class="dashboard-container">
      <!-- Statistics Cards -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-content">
            <div class="stat-info">
              <p class="stat-label">Joueurs du Club</p>
              <p class="stat-value">{{ stats.totalJoueurs }}</p>
            </div>
            <div class="stat-icon">👥</div>
          </div>
        </div>
        
        <div class="stat-card">
          <div class="stat-content">
            <div class="stat-info">
              <p class="stat-label">Victoires Saison</p>
              <p class="stat-value">{{ stats.victoires }}/{{ stats.matchsJoues }}</p>
            </div>
            <div class="stat-icon">🏆</div>
          </div>
        </div>
        
        <div class="stat-card">
          <div class="stat-content">
            <div class="stat-info">
              <p class="stat-label">Prochains Matchs</p>
              <p class="stat-value">{{ upcomingMatches.length }}</p>
            </div>
            <div class="stat-icon">⚽</div>
          </div>
        </div>
        
        <div class="stat-card">
          <div class="stat-content">
            <div class="stat-info">
              <p class="stat-label">Position Ligue</p>
              <p class="stat-value">1er</p>
            </div>
            <div class="stat-icon">🥇</div>
          </div>
        </div>
      </div>

      <!-- Tab Content -->
      <div class="tab-content">
        <!-- Actualités Tab -->
        <div v-if="activeTab === 'actualites'" class="content-grid">
          <div class="main-content">
            <div class="card">
              <h2 class="card-title">
                🔔 Actualités du club
              </h2>
              <div class="news-list">
                <div v-for="news in clubNews" :key="news.id" class="news-item">
                  <div class="news-image">
                    <div class="placeholder-image">📰</div>
                  </div>
                  <div class="news-content">
                    <h3 class="news-title">{{ news.title }}</h3>
                    <p class="news-description">{{ news.content }}</p>
                    <div class="news-footer">
                      <span class="news-date">{{ news.date }}</span>
                      <div class="news-engagement">
                        <button class="engagement-btn">
                          <span class="heart-icon">❤️</span>
                          <span>{{ news.likes || 0 }}</span>
                        </button>
                        <button class="engagement-btn">
                          <span class="comment-icon">💬</span>
                          <span>{{ news.comments || 0 }}</span>
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="sidebar">
            <div class="card">
              <h3 class="card-title">🏆 Derniers Résultats</h3>
              <div class="recent-results">
                <div v-for="result in recentResults" :key="result.id" class="result-item">
                  <div class="teams">
                    <span class="team home">{{ result.homeTeam }}</span>
                    <span class="score">{{ result.score }}</span>
                    <span class="team away">{{ result.awayTeam }}</span>
                  </div>
                  <div class="match-date">{{ result.date }}</div>
                </div>
              </div>
            </div>
            
            <div class="card">
              <h3 class="card-title">📊 Statistiques</h3>
              <div class="team-stats">
                <div class="stat-row">
                  <span>Buts marqués:</span>
                  <span>{{ teamStats.goalsFor }}</span>
                </div>
                <div class="stat-row">
                  <span>Buts encaissés:</span>
                  <span>{{ teamStats.goalsAgainst }}</span>
                </div>
                <div class="stat-row">
                  <span>Possession moy.:</span>
                  <span>{{ teamStats.avgPossession }}%</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Prochains Matchs Tab -->
        <div v-if="activeTab === 'matches'" class="content-grid">
          <div class="main-content">
            <div class="card">
              <h2 class="card-title">
                📅 Prochains matchs
              </h2>
              <div class="matches-list">
                <div v-for="match in upcomingMatches" :key="match.id" class="match-item">
                  <div class="match-header">
                    <h3 class="match-title">PSG vs {{ match.opponent }}</h3>
                    <span :class="['venue-badge', match.venue.toLowerCase()]">
                      {{ match.venue }}
                    </span>
                  </div>
                  <div class="match-details">
                    <span>📅 {{ match.date }}</span>
                    <span>⏰ {{ match.time }}</span>
                    <span>🏟️ {{ match.venue === 'Domicile' ? 'Parc des Princes' : match.stadium }}</span>
                  </div>
                  <div class="match-info">
                    <p class="match-competition">{{ match.competition }}</p>
                    <button class="reminder-btn">🔔 Me rappeler</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="sidebar">
            <div class="card">
              <h3 class="card-title">🎫 Billetterie</h3>
              <div class="ticket-info">
                <p>Prochains matchs à domicile disponibles :</p>
                <div v-for="match in homeMatches" :key="match.id" class="ticket-match">
                  <div class="ticket-match-info">
                    <strong>{{ match.opponent }}</strong>
                    <span>{{ match.date }}</span>
                  </div>
                  <button class="ticket-btn">Réserver</button>
                </div>
              </div>
            </div>
            
            <div class="card">
              <h3 class="card-title">📺 Où regarder</h3>
              <div class="broadcast-info">
                <div v-for="broadcast in broadcastInfo" :key="broadcast.match" class="broadcast-item">
                  <div class="broadcast-match">{{ broadcast.match }}</div>
                  <div class="broadcast-channels">
                    <span v-for="channel in broadcast.channels" :key="channel" class="channel-tag">
                      {{ channel }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Classement Tab -->
        <div v-if="activeTab === 'classement'" class="content-grid single-column">
          <div class="main-content-full">
            <LeagueStandings />
          </div>
        </div>

        <!-- Histoire du Club Tab -->
        <div v-if="activeTab === 'histoire'" class="content-grid single-column">
          <div class="main-content-full">
            <div class="card">
              <h2 class="card-title">
                📚 L'histoire du Paris Saint-Germain
              </h2>
              <div class="history-content">
                <div class="history-section">
                  <h3 class="history-subtitle">Les débuts (1970)</h3>
                  <p class="history-text">
                    Le Paris Saint-Germain (PSG) a été fondé en 1970 grâce à la fusion entre le Stade 
                    Saint-Germain et le Paris FC. Depuis ses débuts, le club est devenu une institution 
                    incontournable dans le monde du football, notamment grâce à ses performances et à sa 
                    popularité croissante.
                  </p>
                  <div class="history-image">
                    <div class="placeholder-image large">🏟️</div>
                    <p class="image-caption">Le PSG lors de ses premiers matchs en 1970.</p>
                  </div>
                </div>
                
                <div class="history-section">
                  <h3 class="history-subtitle">L'âge d'or des années 80</h3>
                  <p class="history-text">
                    Les années 80 ont marqué un tournant avec l'arrivée de grandes stars comme Safet 
                    Sušić, qui a transformé le jeu offensif du club. C'est aussi durant cette décennie 
                    que le PSG remporte son premier titre de Ligue 1, en 1986.
                  </p>
                  <div class="history-image">
                    <div class="placeholder-image large">🏆</div>
                    <p class="image-caption">Les joueurs du PSG célébrant leur premier titre de Ligue 1 en 1986.</p>
                  </div>
                </div>
                
                <div class="history-section">
                  <h3 class="history-subtitle">L'ère moderne (2011-aujourd'hui)</h3>
                  <p class="history-text">
                    Avec l'arrivée du Qatar Sports Investments (QSI) en 2011, le PSG entre dans une 
                    nouvelle ère. Le club attire des stars internationales comme Neymar Jr., Kylian Mbappé, 
                    et Lionel Messi. Le Parc des Princes devient un véritable temple du football moderne.
                  </p>
                  <div class="history-image">
                    <div class="placeholder-image large">⭐</div>
                    <p class="image-caption">Les stars actuelles du PSG célébrant leurs victoires.</p>
                  </div>
                </div>
                
                <div class="achievements">
                  <h3 class="history-subtitle">Palmarès</h3>
                  <div class="trophies-grid">
                    <div class="trophy-item">
                      <span class="trophy-icon">🏆</span>
                      <span class="trophy-count">11</span>
                      <span class="trophy-name">Ligue 1</span>
                    </div>
                    <div class="trophy-item">
                      <span class="trophy-icon">🏅</span>
                      <span class="trophy-count">14</span>
                      <span class="trophy-name">Coupe de France</span>
                    </div>
                    <div class="trophy-item">
                      <span class="trophy-icon">🥉</span>
                      <span class="trophy-count">9</span>
                      <span class="trophy-name">Coupe de la Ligue</span>
                    </div>
                    <div class="trophy-item">
                      <span class="trophy-icon">🌟</span>
                      <span class="trophy-count">1</span>
                      <span class="trophy-name">Finale LDC</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Joueurs Tab -->
        <div v-if="activeTab === 'joueurs'" class="content-grid single-column">
          <div class="main-content-full">
            <div class="card">
              <h2 class="card-title">
                👥 Joueurs du club
              </h2>
              <div v-if="loading" class="loading-message">
                Chargement des joueurs...
              </div>
              <div v-else-if="error" class="error-message">
                {{ error }}
              </div>
              <div v-else class="table-container">
                <table class="players-table">
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
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="joueur in joueurs" :key="joueur.id" class="player-row">
                      <td>{{ joueur.numero_maillot || '-' }}</td>
                      <td class="player-name">{{ joueur.nom }}</td>
                      <td>{{ joueur.prenom }}</td>
                      <td>
                        <span :class="['position-badge', joueur.poste.toLowerCase()]">
                          {{ joueur.poste }}
                        </span>
                      </td>
                      <td>{{ joueur.pays_origine }}</td>
                      <td>{{ joueur.age }} ans</td>
                      <td>{{ joueur.taille_cm }} cm</td>
                      <td>{{ joueur.poids_kg }} kg</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <!-- Boutique Tab -->
        <div v-if="activeTab === 'boutique'" class="content-grid single-column">
          <div class="main-content-full">
            <div class="card">
              <h2 class="card-title">
                🛍️ Boutique officielle
              </h2>
              <div v-if="loading" class="loading-message">
                Chargement des produits...
              </div>
              <div v-else-if="error" class="error-message">
                {{ error }}
              </div>
              <div v-else class="products-grid">
                <div v-for="product in products" :key="product.id" class="product-card">
                  <div class="product-header">
                    <h3 class="product-name">{{ product.nom }}</h3>
                    <span class="product-price">{{ product.prix }}€</span>
                  </div>
                  <div class="product-details">
                    <p class="product-description">{{ product.description }}</p>
                    <div class="product-attributes">
                      <span v-if="product.taille" class="attribute">
                        📏 {{ product.taille }}
                      </span>
                      <span v-if="product.couleur" class="attribute">
                        🎨 {{ product.couleur }}
                      </span>
                    </div>
                  </div>
                  <div class="product-footer">
                    <span :class="getStockClass(product.stock)">
                      <span v-if="product.stock > 0">
                        📦 {{ product.stock }} en stock
                      </span>
                      <span v-else class="out-of-stock">
                        ❌ Rupture de stock
                      </span>
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Notifications Panel -->
    <div v-if="showNotifications" class="notifications-panel">
      <div class="notifications-header">
        <h3>Notifications</h3>
        <button @click="toggleNotifications">✕</button>
      </div>
      <div class="notifications-body">
        <div v-for="notification in notifications" :key="notification.id" 
             :class="['notification-item', notification.type]">
          <p class="notification-message">{{ notification.message }}</p>
          <p class="notification-time">{{ notification.time }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import LeagueStandings from '@/components/LeagueStandings.vue';

export default {
  components: {
    LeagueStandings
  },
  data() {
    return {
      activeTab: 'actualites',
      showNotifications: false,
      tabs: [
        { id: 'actualites', label: 'Actualités du club' },
        { id: 'matches', label: 'Prochains matchs' },
        { id: 'classement', label: 'Classement' },
        { id: 'histoire', label: 'Histoire du club' },
        { id: 'joueurs', label: 'Joueurs du club' },
        { id: 'boutique', label: 'Boutique' },
        
      ],
      stats: {
        totalJoueurs: 0,
        matchsJoues: 0,
        victoires: 0
      },
      notifications: [
        
      ],
      clubNews: [],
      upcomingMatches: [],
      recentResults: [],
      teamStats: {
        goalsFor: 0,
        goalsAgainst: 0,
        avgPossession: 0
      },
      homeMatches: [],
      broadcastInfo: [
        { 
          match: "PSG vs OM", 
          channels: ["Canal+", "Prime Video"] 
        },
        { 
          match: "PSG vs Lyon", 
          channels: ["France 2", "Canal+"] 
        }
      ],
      joueurs: [],
      products: [],
      loading: false,
      error: null
    }
  },
  mounted() {
    this.loadAllData();
  },
  methods: {
    async loadAllData() {
      this.loading = true;
      try {
        await Promise.all([
          this.fetchActualites(),
          this.fetchMatchs(),
          this.fetchJoueurs(),
          this.fetchProducts()
        ]);
        this.calculateStats();
      } catch (error) {
        this.error = "Erreur lors du chargement des données";
        console.error("Erreur:", error);
      } finally {
        this.loading = false;
      }
    },

    async fetchActualites() {
      try {
        const response = await axios.get("http://localhost:8000/api/actualites");
        this.clubNews = response.data.map(actualite => ({
          id: actualite.id,
          title: actualite.titre,
          content: actualite.contenu,
          date: this.formatDate(actualite.date_publication),
          likes: actualite.likes || 0,
          comments: actualite.commentaires || 0,
          author: actualite.auteur,
          imageUrl: actualite.image_url,
          status: actualite.statut
        }));
      } catch (error) {
        console.error("Erreur lors de la récupération des actualités:", error);
      }
    },

    async fetchMatchs() {
      try {
        const response = await axios.get("http://localhost:8000/api/matchs");
        const matchs = response.data;
        
        // Séparer les matchs futurs et passés
        const now = new Date();
        
        this.upcomingMatches = matchs
          .filter(match => new Date(match.date_match) > now && match.statut !== 'terminé')
          .map(match => ({
            id: match.id,
            opponent: match.equipe_adverse,
            date: this.formatDate(match.date_match),
            time: this.formatTime(match.date_match),
            venue: match.lieu,
            competition: match.competition,
            stadium: match.stade
          }))
          .slice(0, 5);

        this.recentResults = matchs
          .filter(match => match.statut === 'terminé')
          .map(match => ({
            id: match.id,
            homeTeam: match.equipe_domicile,
            awayTeam: match.equipe_exterieur,
            score: `${match.score_domicile || 0}-${match.score_exterieur || 0}`,
            date: this.formatDateShort(match.date_match)
          }))
          .slice(0, 5);

        // Matchs à domicile pour la billetterie
        this.homeMatches = this.upcomingMatches
          .filter(match => match.venue === 'Domicile')
          .slice(0, 3);

      } catch (error) {
        console.error("Erreur lors de la récupération des matchs:", error);
      }
    },

    async fetchJoueurs() {
      try {
        const response = await axios.get("http://localhost:8000/api/joueurs");
        this.joueurs = response.data;
      } catch (error) {
        console.error("Erreur lors de la récupération des joueurs:", error);
      }
    },

    async fetchProducts() {
      try {
        const response = await axios.get("http://localhost:8000/api/produits");
        this.products = response.data;
      } catch (error) {
        console.error("Erreur lors de la récupération des produits:", error);
      }
    },

    calculateStats() {
      // Calculer les statistiques basées sur les vraies données
      this.stats.totalJoueurs = this.joueurs.length;
      
      const termines = this.recentResults.length;
      this.stats.matchsJoues = termines;
      
      // Compter les victoires du PSG
      let victoires = 0;
      this.recentResults.forEach(result => {
        const scores = result.score.split('-');
        const scorePSG = result.homeTeam === 'PSG' ? parseInt(scores[0]) : parseInt(scores[1]);
        const scoreAdverse = result.homeTeam === 'PSG' ? parseInt(scores[1]) : parseInt(scores[0]);
        if (scorePSG > scoreAdverse) {
          victoires++;
        }
      });
      this.stats.victoires = victoires;

      // Calculer les stats d'équipe
      let butsMarques = 0, butsEncaisses = 0;
      this.recentResults.forEach(result => {
        const scores = result.score.split('-');
        if (result.homeTeam === 'PSG') {
          butsMarques += parseInt(scores[0]) || 0;
          butsEncaisses += parseInt(scores[1]) || 0;
        } else {
          butsMarques += parseInt(scores[1]) || 0;
          butsEncaisses += parseInt(scores[0]) || 0;
        }
      });
      
      this.teamStats.goalsFor = butsMarques;
      this.teamStats.goalsAgainst = butsEncaisses;
      this.teamStats.avgPossession = 68; // Valeur par défaut, peut être calculée différemment
    },

    formatDate(dateString) {
      const date = new Date(dateString);
      return date.toLocaleDateString('fr-FR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    },

    formatDateShort(dateString) {
      const date = new Date(dateString);
      return date.toLocaleDateString('fr-FR', {
        month: '2-digit',
        day: '2-digit'
      });
    },

    formatTime(dateString) {
      const date = new Date(dateString);
      return date.toLocaleTimeString('fr-FR', {
        hour: '2-digit',
        minute: '2-digit'
      });
    },

    getStockClass(stock) {
      if (stock === 0) return 'product-stock out';
      if (stock < 5) return 'product-stock low';
      return 'product-stock';
    },

    logout() {
      localStorage.removeItem("authToken");
      this.$router.push("/login");
    },
    toggleNotifications() {
      this.showNotifications = !this.showNotifications;
    },
    scrollToHistory() {
      const historySection = document.getElementById("history");
      if (historySection) {
        historySection.scrollIntoView({ behavior: "smooth" });
      }
    }
  }
};
</script>

<style>
@import '@/assets/styles/user.css';
</style>

