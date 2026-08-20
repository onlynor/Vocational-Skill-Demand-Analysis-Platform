import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useThemeStore = defineStore('theme', () => {
  // index.html's inline bootstrap script already resolved and applied the
  // theme (localStorage, falling back to system preference) before Vue even
  // mounts — this just reads back whatever it set, so there's no mismatch.
  const theme = ref(document.documentElement.getAttribute('data-theme') || 'light')

  function apply(next) {
    theme.value = next
    document.documentElement.setAttribute('data-theme', next)
    localStorage.setItem('theme', next)
  }

  function toggleTheme() {
    apply(theme.value === 'dark' ? 'light' : 'dark')
  }

  return { theme, toggleTheme }
})
