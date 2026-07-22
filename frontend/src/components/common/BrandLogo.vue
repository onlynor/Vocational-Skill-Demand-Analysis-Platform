<script setup>
defineProps({
  size: { type: [Number, String], default: 44 },
})
</script>

<template>
  <svg
    class="brand-logo"
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 240 240"
    :width="size"
    :height="size"
    aria-hidden="true"
  >
    <rect x="12" y="12" width="216" height="216" rx="48" fill="#1f2a44" />
    <rect x="64" y="104" width="28" height="100" rx="14" fill="#4fc08d" opacity="0.78" />
    <rect x="108" y="74" width="28" height="130" rx="14" fill="#4fc08d" opacity="0.92" />
    <rect x="152" y="124" width="28" height="80" rx="14" fill="#4fc08d" />
    <circle cx="80" cy="92" r="13" fill="#4fc08d" />
    <circle cx="124" cy="62" r="13" fill="#4fc08d" opacity="0.85" />
    <circle cx="168" cy="112" r="13" fill="#4fc08d" />
  </svg>
</template>

<style scoped>
.brand-logo {
  display: block;
  flex-shrink: 0;
}
</style>