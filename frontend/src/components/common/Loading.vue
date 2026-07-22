<script setup>
defineProps({
  message: { type: String, default: '加载中...' },
  inline: { type: Boolean, default: false },
})
</script>

<template>
  <div class="loading" :class="{ inline }">
    <span class="spinner" aria-hidden="true"></span>
    <span class="loading-text">{{ message }}</span>
  </div>
</template>

<style scoped>
.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  min-height: 160px;
  color: var(--text-secondary);
}
.loading.inline {
  flex-direction: row;
  min-height: auto;
  padding: 12px;
  gap: 8px;
}
.spinner {
  width: 28px;
  height: 28px;
  border: 3px solid var(--border-color);
  border-top-color: var(--primary-color);
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
.loading-text {
  font-size: var(--font-size-base);
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>