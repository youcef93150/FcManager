<template>
  <div>
    <!-- Barre de navigation -->
    <nav class="navbar">
      <div class="logo">
        <router-link to="/AccueilUser">
          <img src="@/assets/images/psg.png" alt="PSG Logo" class="logo-img" />
        </router-link>
      </div>
      <div class="nav-links">
        <router-link to="/Classement">Classement</router-link>  |
        <router-link to="/psg-results">Résultats des matchs</router-link> |
        <router-link to="/JoueursUser">Voir les joueurs du club</router-link> |
        <router-link to="/BoutiqueUser">Voir les stock de la boutique</router-link>
      </div>
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
export default {
  data() {
    return {
      activeTab: 'actualites',
      showNotifications: false,
      tabs: [
        { id: 'actualites', label: 'Actualités du club' },
        { id: 'matches', label: 'Prochains matchs' },
        { id: 'histoire', label: 'Histoire du club' }
      ],
      stats: {
        totalJoueurs: 25,
        matchsJoues: 18,
        victoires: 14
      },
      notifications: [
        { id: 1, message: "Nouveau match programmé contre l'OM", time: "Il y a 2h", type: "info" },
        { id: 2, message: "Billetterie ouverte pour PSG vs Monaco", time: "Il y a 5h", type: "success" },
        { id: 3, message: "Conférence de presse avant le match", time: "Hier", type: "info" }
      ],
      clubNews: [
        {
          id: 1,
          title: "Victoire éclatante 3-0 contre Lille",
          content: "Le PSG s'impose avec brio au Parc des Princes grâce à un triplé de Mbappé...",
          date: "2025-06-18",
          likes: 1250,
          comments: 89
        },
        {
          id: 2,
          title: "Nouveau partenariat stratégique annoncé",
          content: "Le club parisien renforce ses alliances commerciales pour les prochaines saisons...",
          date: "2025-06-17",
          likes: 856,
          comments: 45
        },
        {
          id: 3,
          title: "Stage d'été au Qatar confirmé",
          content: "Les joueurs se prépareront dans des conditions optimales pour la nouvelle saison...",
          date: "2025-06-16",
          likes: 967,
          comments: 52
        }
      ],
      upcomingMatches: [
        { 
          id: 1, 
          opponent: "Olympique de Marseille", 
          date: "2025-06-25", 
          time: "21:00", 
          venue: "Domicile",
          competition: "Ligue 1",
          stadium: "Parc des Princes"
        },
        { 
          id: 2, 
          opponent: "AS Monaco", 
          date: "2025-07-02", 
          time: "17:00", 
          venue: "Extérieur",
          competition: "Ligue 1",
          stadium: "Stade Louis II"
        },
        { 
          id: 3, 
          opponent: "Olympique Lyonnais", 
          date: "2025-07-10", 
          time: "20:45", 
          venue: "Domicile",
          competition: "Coupe de France",
          stadium: "Parc des Princes"
        }
      ],
      recentResults: [
        { id: 1, homeTeam: "PSG", awayTeam: "Lille", score: "3-0", date: "15/06" },
        { id: 2, homeTeam: "Nice", awayTeam: "PSG", score: "1-2", date: "12/06" },
        { id: 3, homeTeam: "PSG", awayTeam: "Rennes", score: "4-1", date: "08/06" }
      ],
      teamStats: {
        goalsFor: 45,
        goalsAgainst: 12,
        avgPossession: 68
      },
      homeMatches: [
        { id: 1, opponent: "Olympique de Marseille", date: "25/06" },
        { id: 2, opponent: "Olympique Lyonnais", date: "10/07" }
      ],
      broadcastInfo: [
        { 
          match: "PSG vs OM", 
          channels: ["Canal+", "Prime Video"] 
        },
        { 
          match: "PSG vs Lyon", 
          channels: ["France 2", "Canal+"] 
        }
      ]
    }
  },
  async mounted() {
    // Vérifier l'authentification
    if (!localStorage.getItem('authToken')) {
      this.$router.push('/login');
      return;
    }

    // Vérifier le rôle utilisateur
    const userRole = localStorage.getItem('userRole');
    if (userRole === 'admin') {
      this.$router.push('/AccueilAdmin');
      return;
    }
  },
  methods: {
    logout() {
      // Nettoyer toutes les données d'authentification
      localStorage.removeItem("authToken");
      localStorage.removeItem("userRole");
      localStorage.removeItem("userId");
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

<style scoped>
/* Navigation */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #002b5c; 
  padding: 15px 25px;
  color: white;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.logo-img {
  height: 50px;
}

.nav-links {
  display: flex;
  gap: 20px;
}

.nav-links a {
  color: white;
  text-decoration: none;
  font-size: 18px;
  font-weight: 500;
}

.nav-links a:hover {
  text-decoration: underline;
  color: #c8102e; 
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 15px;
}

.notification-btn {
  position: relative;
  background: none;
  border: none;
  color: white;
  font-size: 20px;
  cursor: pointer;
  padding: 8px;
  border-radius: 5px;
  transition: background-color 0.3s;
}

.notification-btn:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.notification-badge {
  position: absolute;
  top: -5px;
  right: -5px;
  background-color: #c8102e;
  color: white;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  font-size: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.logout-button {
  background-color: #c8102e; 
  border: none;
  padding: 12px 18px;
  color: white;
  font-size: 16px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.logout-button:hover {
  background-color: #9b0d20; 
}

/* Hero Section */
.hero-section {
  background: linear-gradient(45deg, #002b5c, #c8102e);
  color: white;
  text-align: center;
  padding: 40px 20px;
}

.hero-title {
  font-size: 36px;
  font-weight: bold;
  margin-bottom: 10px;
}

.hero-description {
  font-size: 20px;
  margin-bottom: 30px;
}

/* Dashboard Tabs */
.dashboard-tabs {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 20px;
}

.tab-button {
  background-color: rgba(255, 255, 255, 0.2);
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 25px;
  cursor: pointer;
  font-size: 16px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.tab-button:hover {
  background-color: rgba(255, 255, 255, 0.3);
}

.tab-button.active {
  background-color: white;
  color: #002b5c;
  font-weight: bold;
}

/* Dashboard Container */
.dashboard-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 30px 20px;
  background-color: #f5f5f5;
  min-height: 70vh;
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  border-left: 4px solid #002b5c;
}

.stat-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.stat-label {
  color: #666;
  font-size: 14px;
  margin-bottom: 8px;
}

.stat-value {
  color: #002b5c;
  font-size: 28px;
  font-weight: bold;
  margin: 0;
}

.stat-icon {
  font-size: 32px;
  opacity: 0.8;
}

/* Content Grid */
.content-grid {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 30px;
}

.content-grid.single-column {
  grid-template-columns: 1fr;
}

.main-content, .sidebar, .main-content-full {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* Cards */
.card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.card-title {
  font-size: 24px;
  font-weight: bold;
  color: #002b5c;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 10px;
}

/* News */
.news-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.news-item {
  display: flex;
  gap: 16px;
  padding-bottom: 20px;
  border-bottom: 1px solid #eee;
}

.news-item:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.news-image {
  flex-shrink: 0;
}

.placeholder-image {
  width: 80px;
  height: 80px;
  background-color: #f0f0f0;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
}

.placeholder-image.large {
  width: 120px;
  height: 120px;
  font-size: 36px;
  margin: 0 auto 10px;
}

.news-content {
  flex: 1;
}

.news-title {
  font-size: 18px;
  font-weight: bold;
  color: #002b5c;
  margin-bottom: 8px;
}

.news-description {
  color: #666;
  line-height: 1.5;
  margin-bottom: 12px;
}

.news-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.news-date {
  color: #999;
  font-size: 14px;
}

.news-engagement {
  display: flex;
  gap: 12px;
}

.engagement-btn {
  background: none;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 4px;
  color: #666;
  font-size: 14px;
  padding: 4px 8px;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.engagement-btn:hover {
  background-color: #f5f5f5;
}

/* Matches */
.matches-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.match-item {
  background: linear-gradient(135deg, #f8f9ff 0%, #fff5f5 100%);
  padding: 20px;
  border-radius: 12px;
  border: 1px solid #eee;
}

.match-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.match-title {
  font-size: 18px;
  font-weight: bold;
  color: #002b5c;
  margin: 0;
}

.venue-badge {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: bold;
}

.venue-badge.domicile {
  background-color: #e3f2fd;
  color: #1976d2;
}

.venue-badge.extérieur {
  background-color: #ffebee;
  color: #d32f2f;
}

.match-details {
  display: flex;
  gap: 20px;
  color: #666;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.match-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.match-competition {
  color: #002b5c;
  font-weight: 500;
  margin: 0;
}

.reminder-btn {
  background-color: #002b5c;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 12px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.reminder-btn:hover {
  background-color: #001a3d;
}

/* Results */
.recent-results {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.result-item {
  background-color: #f8f9fa;
  padding: 12px;
  border-radius: 8px;
  border-left: 4px solid #28a745;
}

.teams {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}

.team {
  font-weight: 500;
  color: #002b5c;
}

.score {
  font-weight: bold;
  color: #28a745;
}

.match-date {
  font-size: 12px;
  color: #666;
}

/* Stats */
.team-stats, .stat-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}

.stat-row:last-child {
  border-bottom: none;
}

/* Tickets & Broadcast */
.ticket-info, .broadcast-info {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.ticket-match {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px;
  background-color: #f8f9fa;
  border-radius: 6px;
}

.ticket-match-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.ticket-btn {
  background-color: #28a745;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.broadcast-item {
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}

.broadcast-item:last-child {
  border-bottom: none;
}

.broadcast-match {
  font-weight: 500;
  color: #002b5c;
  margin-bottom: 4px;
}

.broadcast-channels {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.channel-tag {
  background-color: #e3f2fd;
  color: #1976d2;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 11px;
  font-weight: 500;
}

/* History Section */
.history-content {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.history-section {
  background-color: #fafafa;
  padding: 24px;
  border-radius: 12px;
  border-left: 4px solid #002b5c;
}

.history-subtitle {
  color: #002b5c;
  font-size: 20px;
  font-weight: bold;
  margin-bottom: 16px;
}

.history-text {
  color: #333;
  line-height: 1.6;
  margin-bottom: 20px;
  text-align: justify;
}

.history-image {
  text-align: center;
  margin: 20px 0;
}

.image-caption {
  color: #666;
  font-style: italic;
  margin-top: 8px;
  font-size: 14px;
}

/* Achievements */
.achievements {
  background: linear-gradient(135deg, #f8f9ff 0%, #fff5f5 100%);
  padding: 24px;
  border-radius: 12px;
  border: 1px solid #eee;
}

.trophies-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.trophy-item {
  text-align: center;
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.trophy-icon {
  font-size: 32px;
  display: block;
  margin-bottom: 8px;
}

.trophy-count {
  display: block;
  font-size: 24px;
  font-weight: bold;
  color: #002b5c;
  margin-bottom: 4px;
}

.trophy-name {
  display: block;
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

/* Notifications Panel */
.notifications-panel {
  position: fixed;
  top: 0;
  right: 0;
  width: 400px;
  height: 100vh;
  background: white;
  box-shadow: -4px 0 12px rgba(0, 0, 0, 0.15);
  z-index: 1000;
}

.notifications-header {
  padding: 20px;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #002b5c;
  color: white;
}

.notifications-header button {
  background: none;
  border: none;
  color: white;
  font-size: 20px;
  cursor: pointer;
}

.notifications-body {
  padding: 20px;
  height: calc(100vh - 80px);
  overflow-y: auto;
}

.notifications-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.notification-item {
  padding: 16px;
  border-radius: 8px;
  border-left: 4px solid;
}

.notification-item.info {
  background-color: #e3f2fd;
  border-left-color: #1976d2;
}

.notification-item.warning {
  background-color: #fff8e1;
  border-left-color: #f57c00;
}

.notification-item.success {
  background-color: #e8f5e8;
  border-left-color: #388e3c;
}

.notification-message {
  color: #002b5c;
  font-weight: 500;
  margin-bottom: 4px;
}

.notification-time {
  color: #666;
  font-size: 12px;
  margin: 0;
}

/* Responsive */
@media (max-width: 768px) {
  .content-grid {
    grid-template-columns: 1fr;
  }
  
  .stats-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  }
  
  .dashboard-tabs {
    flex-direction: column;
    gap: 10px;
  }
  
  .notifications-panel {
    width: 100%;
  }
  
  .match-details {
    flex-direction: column;
    gap: 8px;
  }
  
  .trophies-grid {
    grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  }
}
</style>