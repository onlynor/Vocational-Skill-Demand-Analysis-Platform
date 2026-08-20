<script setup>
import { useThemeStore } from '@/stores/theme'

const theme = useThemeStore()
</script>

<template>
  <button
    class="theme-toggle"
    type="button"
    :aria-label="theme.theme === 'dark' ? '切换到浅色主题' : '切换到深色主题'"
    :title="theme.theme === 'dark' ? '切换到浅色主题' : '切换到深色主题'"
    @click="theme.toggleTheme()"
  >
    <svg v-if="theme.theme === 'dark'" class="ic" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
      <circle cx="12" cy="12" r="4.5" fill="none" stroke="currentColor" stroke-width="1.8" />
      <path
        d="M12 2.5v2.5M12 19v2.5M4.9 4.9l1.8 1.8M17.3 17.3l1.8 1.8M2.5 12H5M19 12h2.5M4.9 19.1l1.8-1.8M17.3 6.7l1.8-1.8"
        stroke="currentColor" stroke-width="1.8" stroke-linecap="round"
      />
    </svg>
    <svg v-else class="ic" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
      <path
        d="M20 14.5A8.5 8.5 0 1 1 9.5 4a7 7 0 0 0 10.5 10.5Z"
        fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"
      />
    </svg>
  </button>
</template>

<style scoped>
.theme-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: var(--radius-full);
  background: var(--surface-soft);
  border: 1px solid var(--border-color);
  color: var(--text-secondary);
  transition: background var(--transition), color var(--transition), transform var(--transition-fast);
}
.theme-toggle:hover {
  color: var(--primary-color);
  border-color: var(--primary-color);
}
.theme-toggle:active {
  transform: scale(0.92);
}
.ic {
  transition: transform var(--transition-spring);
}
.theme-toggle:hover .ic {
  transform: rotate(20deg);
}
</style>
