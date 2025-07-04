import { describe, it, expect, beforeEach, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import Login from '@/components/Login.vue'

// Mock d'axios
vi.mock('axios', () => ({
  default: {
    post: vi.fn()
  }
}))

// Mock du router
const mockRouter = {
  push: vi.fn()
}

// Mock de localStorage
const localStorageMock = {
  getItem: vi.fn(),
  setItem: vi.fn(),
  removeItem: vi.fn(),
  clear: vi.fn()
}

Object.defineProperty(window, 'localStorage', {
  value: localStorageMock
})

// Mock de alert
global.alert = vi.fn()

describe('Login.vue - Tests simples', () => {
  let wrapper

  beforeEach(() => {
    // Reset tous les mocks avant chaque test
    vi.clearAllMocks()
    localStorageMock.getItem.mockReturnValue(null)
    
    wrapper = mount(Login, {
      global: {
        mocks: {
          $router: mockRouter
        }
      }
    })
  })

  // Test 1: Le composant se monte correctement
  it('devrait se monter sans erreur', () => {
    expect(wrapper.exists()).toBe(true)
  })

  // Test 2: Vérifier les données initiales
  it('devrait avoir les bonnes données initiales', () => {
    expect(wrapper.vm.email).toBe('')
    expect(wrapper.vm.mdp).toBe('')
    expect(wrapper.vm.tentativesRestantes).toBe(5)
    expect(wrapper.vm.compteBloque).toBe(false)
  })

  // Test 3: Fonction sanitizeInput
  it('devrait nettoyer les entrées utilisateur', () => {
    const result = wrapper.vm.sanitizeInput('  test@test.com<script>  ')
    expect(result).toBe('test@test.comscript')
  })

  // Test 4: Validation d'email
  it('devrait valider les emails correctement', () => {
    expect(wrapper.vm.validateEmail('test@test.com')).toBe(true)
    expect(wrapper.vm.validateEmail('email-invalide')).toBe(false)
    expect(wrapper.vm.validateEmail('')).toBe(false)
  })

  // Test 5: Input email en temps réel
  it('devrait nettoyer l\'email en temps réel', async () => {
    const emailInput = wrapper.find('#email')
    await emailInput.setValue('test@test.com<script>')
    
    expect(wrapper.vm.email).toBe('test@test.comscript')
  })

  // Test 6: Input mot de passe en temps réel
  it('devrait nettoyer le mot de passe en temps réel', async () => {
    const passwordInput = wrapper.find('#mdp')
    await passwordInput.setValue('password<script>')
    
    expect(wrapper.vm.mdp).toBe('passwordscript')
  })

  // Test 7: Fonction debloquerCompte
  it('devrait débloquer le compte correctement', () => {
    wrapper.vm.compteBloque = true
    wrapper.vm.tentativesRestantes = 0
    
    wrapper.vm.debloquerCompte()
    
    expect(wrapper.vm.compteBloque).toBe(false)
    expect(wrapper.vm.tentativesRestantes).toBe(5)
    expect(localStorageMock.removeItem).toHaveBeenCalledWith('tentativesLogin')
    expect(localStorageMock.removeItem).toHaveBeenCalledWith('compteBloque')
    expect(localStorageMock.removeItem).toHaveBeenCalledWith('tempsDeblocage')
  })

  // Test 8: Fonction sauvegarderEtat
  it('devrait sauvegarder l\'état dans localStorage', () => {
    wrapper.vm.tentativesRestantes = 3
    wrapper.vm.compteBloque = true
    
    wrapper.vm.sauvegarderEtat()
    
    expect(localStorageMock.setItem).toHaveBeenCalledWith('tentativesLogin', '3')
    expect(localStorageMock.setItem).toHaveBeenCalledWith('compteBloque', 'true')
  })

  // Test 9: Affichage du bouton désactivé quand compte bloqué
  it('devrait désactiver le bouton quand le compte est bloqué', async () => {
    await wrapper.setData({ compteBloque: true })
    
    const button = wrapper.find('button[type="submit"]')
    expect(button.attributes('disabled')).toBeDefined()
    expect(button.text()).toBe('Compte bloqué')
  })

  // Test 10: Affichage des tentatives restantes
  it('devrait afficher les tentatives restantes', async () => {
    await wrapper.setData({ tentativesRestantes: 3 })
    
    const warning = wrapper.find('.tentatives-warning')
    expect(warning.exists()).toBe(true)
    expect(warning.text()).toContain('3 tentative(s) restante(s)')
  })
})
