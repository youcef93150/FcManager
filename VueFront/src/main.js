import { createApp } from 'vue'
import App from './App.vue'
import router from './Router.js'
import './utils/auth' // Importer la configuration axios

createApp(App).use(router).mount('#app')