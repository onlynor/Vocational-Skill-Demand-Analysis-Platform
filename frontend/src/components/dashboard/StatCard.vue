<script setup>
defineProps({
  label: { type: String, required: true },
  value: { type: [String, Number], required: true },
  accent: { type: String, default: 'primary' }, // primary | blue | orange
  icon: { type: String, default: '' },
})
</script>

<template>
  <div class="stat-card" :class="accent">
    <div class="stat-top">
      <span class="stat-label">{{ label }}</span>
      <span v-if="icon" class="stat-icon" v-html="icon" />
    </div>
    <span class="stat-value" :class="accent">{{ value }}</span>
    <span class="stat-foot"><slot /></span>
  </div>
</template>

<style scoped>
.stat-card {
  background: var(--surface-color);
  border-radius: var(--radius-lg);
  padding: 24px;
  box-shadow: var(--shadow-md);
  border-top: 3px solid var(--primary-color);
  display: flex;
  flex-direction: column;
  gap: 6px;
  height: 132px;
  transition: box-shadow var(--transition), transform var(--transition);
}
.stat-card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-2px);
}
.stat-card.blue { border-top-color: var(--accent-blue); }
.stat-card.orange { border-top-color: var(--accent-orange); }

.stat-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.stat-label {
  font-size: var(--font-size-sm);
  color: var(--text-secondary);
  font-weight: 500;
}
.stat-icon {
  opacity: 0.6;
}
.stat-value {
  margin-top: 2px;
  font-size: 34px;
  font-weight: 700;
  line-height: 1.15;
  color: var(--text-color);
}
.stat-value.blue { color: var(--accent-blue); }
.stat-value.orange { color: var(--accent-orange); }
.stat-foot {
  margin-top: auto;
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
}
</style>