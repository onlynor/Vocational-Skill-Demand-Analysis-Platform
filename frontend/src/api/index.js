import axios from 'axios'

// Falls back to the local backend for `pnpm dev`. Production deployments
// must set VITE_API_BASE_URL at build time (e.g. `/api` if the frontend is
// served behind the same reverse proxy as the backend, or a full origin
// otherwise) — a hardcoded localhost URL here would silently break in any
// real deployment.
const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api',
  timeout: 10000,
})

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

api.interceptors.response.use(
  (res) => res,
  (err) => {
    if (err.response?.status === 401) {
      localStorage.removeItem('token')
      window.location.href = '/login'
    }
    return Promise.reject(err)
  },
)

export default api
