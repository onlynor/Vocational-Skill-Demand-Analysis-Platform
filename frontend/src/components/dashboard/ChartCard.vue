<script setup>
defineProps({
  title: { type: String, required: true },
  subtitle: { type: String, default: '' },
  height: { type: [Number, String], default: 320 },
})
</script>

<template>
  <section class="chart-card card-surface">
    <header class="chart-header">
      <div>
        <h4 class="chart-title">{{ title }}</h4>
        <p v-if="subtitle" class="chart-subtitle">{{ subtitle }}</p>
      </div>
      <slot name="action" />
    </header>
    <div class="chart-body" :style="{ minHeight: typeof height === 'number' ? height + 'px' : height }">
      <slot />
    </div>
  </section>
</template>

<style scoped>
.chart-card {
  display: flex;
  flex-direction: column;
  padding: 24px;
}
.chart-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 16px;
  flex-shrink: 0;
}
.chart-title {
  font-size: var(--font-size-md);
  font-weight: 600;
  color: var(--text-color);
}
.chart-subtitle {
  margin-top: 2px;
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
}
.chart-body {
  flex: 1;
  min-height: 0;
  position: relative;
}
.chart-body > :deep(.echarts) {
  width: 100%;
  height: 100%;
}
</style>