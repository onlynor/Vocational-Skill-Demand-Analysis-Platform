<script setup>
defineProps({
  message: { type: String, default: '暂无数据' },
})
</script>

<template>
  <div class="empty-state">
    <svg class="empty-icon" viewBox="0 0 120 120" width="88" height="88" aria-hidden="true">
      <rect x="20" y="28" width="80" height="64" rx="10" fill="none" stroke="currentColor" stroke-width="4" />
      <path d="M20 50 h80 M40 70 h40 M40 82 h24" stroke="currentColor" stroke-width="4" stroke-linecap="round" opacity="0.6" />
      <circle cx="92" cy="92" r="18" fill="var(--surface-color)" stroke="currentColor" stroke-width="4" />
      <path d="M85 92 h14" stroke="currentColor" stroke-width="4" stroke-linecap="round" />
    </svg>
    <p class="empty-text">{{ message }}</p>
  </div>
</template>

<style scoped>
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  width: 100%;
  min-height: 160px;
  color: var(--text-tertiary);
}
.empty-icon {
  opacity: 0.45;
}
.empty-text {
  font-size: var(--font-size-base);
  color: var(--text-tertiary);
}
</style>