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
      <span class="stat-dot" aria-hidden="true" />
      <span class="stat-label">{{ label }}</span>
      <span v-if="icon" class="stat-icon" v-html="icon" />
    </div>
    <span class="stat-value">{{ value }}</span>
    <span class="stat-foot"><slot /></span>
  </div>
</template>

<style scoped>
.stat-card {
  position: relative;
  background: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-xl);
  padding: var(--space-6);
  box-shadow: var(--shadow-md);
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
  height: 136px;
  overflow: hidden;
  transition: box-shadow var(--transition-spring), transform var(--transition-spring),
    background-color var(--transition), border-color var(--transition);
}
/* faint gradient wash in the corner — the accent's "glow", not a full tint */
.stat-card::after {
  content: '';
  position: absolute;
  top: -40%;
  right: -30%;
  width: 160px;
  height: 160px;
  border-radius: 50%;
  background: var(--gradient-primary);
  opacity: 0.1;
  filter: blur(2px);
  transition: opacity var(--transition-spring), transform var(--transition-spring);
}
.stat-card.blue::after { background: var(--gradient-blue); }
.stat-card.orange::after { background: var(--gradient-orange); }
.stat-card:hover {
  box-shadow: var(--shadow-lg), var(--glow-primary);
  transform: translateY(-4px);
}
.stat-card.blue:hover { box-shadow: var(--shadow-lg), var(--glow-blue); }
.stat-card.orange:hover { box-shadow: var(--shadow-lg), var(--glow-orange); }
.stat-card:hover::after {
  opacity: 0.18;
  transform: scale(1.15);
}

.stat-top {
  position: relative;
  display: flex;
  align-items: center;
  gap: var(--space-2);
}
.stat-dot {
  width: 9px;
  height: 9px;
  border-radius: var(--radius-full);
  background: var(--gradient-primary);
  box-shadow: 0 0 0 4px rgba(79, 192, 141, 0.16);
  flex-shrink: 0;
}
.stat-card.blue .stat-dot { background: var(--gradient-blue); box-shadow: 0 0 0 4px rgba(47, 90, 212, 0.14); }
.stat-card.orange .stat-dot { background: var(--gradient-orange); box-shadow: 0 0 0 4px rgba(230, 137, 60, 0.14); }
.stat-label {
  font-size: var(--font-size-sm);
  color: var(--text-secondary);
  font-weight: 500;
}
.stat-icon {
  margin-left: auto;
  opacity: 0.6;
}
.stat-value {
  position: relative;
  margin-top: var(--space-1);
  font-size: 38px;
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1.15;
  font-variant-numeric: tabular-nums;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
.stat-card.blue .stat-value { background: var(--gradient-blue); -webkit-background-clip: text; background-clip: text; }
.stat-card.orange .stat-value { background: var(--gradient-orange); -webkit-background-clip: text; background-clip: text; }
.stat-foot {
  position: relative;
  margin-top: auto;
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
}
</style>