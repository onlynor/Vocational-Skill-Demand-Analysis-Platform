import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '@/api'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || '')
  const username = ref(localStorage.getItem('username') || '')

  const isLoggedIn = () => !!token.value

  async function login(u, p) {
    const { data } = await api.post('/auth/login', { username: u, password: p })
    token.value = data.access_token
    username.value = u
    localStorage.setItem('token', data.access_token)
    localStorage.setItem('username', u)
  }

  async function register(u, p) {
    const { data } = await api.post('/auth/register', { username: u, password: p })
    token.value = data.access_token
    username.value = u
    localStorage.setItem('token', data.access_token)
    localStorage.setItem('username', u)
  }

  function logout() {
    token.value = ''
    username.value = ''
    localStorage.removeItem('token')
    localStorage.removeItem('username')
  }

  return { token, username, isLoggedIn, login, register, logout }
})
