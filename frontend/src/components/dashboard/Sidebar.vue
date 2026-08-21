<script setup>
import { ref, onUnmounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import BrandLogo from '@/components/common/BrandLogo.vue'

const auth = useAuthStore()

const menus = [
  { to: '/match', label: '技能匹配', icon: 'match' },
  { to: '/jobs', label: '职业画像', icon: 'profile' },
  { to: '/skill-tree', label: '技能树', icon: 'tree' },
  { to: '/advisor', label: 'AI职业顾问', icon: 'advisor' },
]

/* ---- draggable sidebar width ----
   The sidebar's own width and App.vue's `.main { margin-left }` both read
   the same `--sidebar-width` custom property (defined in variables.css), so
   overriding it on <html> keeps both in sync automatically — no store or
   prop-drilling between the two components needed. */
const SIDEBAR_WIDTH_KEY = 'sidebarWidth'
const SIDEBAR_MIN_WIDTH = 180
const SIDEBAR_MAX_WIDTH = 360
const SIDEBAR_DEFAULT_WIDTH = 232

function clampWidth(px) {
  return Math.min(SIDEBAR_MAX_WIDTH, Math.max(SIDEBAR_MIN_WIDTH, px))
}

function applyWidth(px) {
  document.documentElement.style.setProperty('--sidebar-width', px + 'px')
}

const sidebarWidth = ref(
  clampWidth(parseInt(localStorage.getItem(SIDEBAR_WIDTH_KEY)) || SIDEBAR_DEFAULT_WIDTH)
)
applyWidth(sidebarWidth.value)

let dragging = false
let dragStartX = 0
let dragStartWidth = 0

function startDrag(e) {
  e.preventDefault()
  dragging = true
  dragStartX = e.clientX
  dragStartWidth = sidebarWidth.value
  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', stopDrag)
  document.body.style.cursor = 'col-resize'
  document.body.style.userSelect = 'none'
}

function onDrag(e) {
  if (!dragging) return
  const next = clampWidth(dragStartWidth + (e.clientX - dragStartX))
  sidebarWidth.value = next
  applyWidth(next)
}

function stopDrag() {
  if (!dragging) return
  dragging = false
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
  document.body.style.cursor = ''
  document.body.style.userSelect = ''
  localStorage.setItem(SIDEBAR_WIDTH_KEY, String(sidebarWidth.value))
}

onUnmounted(() => {
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
})
</script>

<template>
  <aside class="sidebar">
    <div
      class="sidebar-resizer"
      role="separator"
      aria-orientation="vertical"
      aria-label="调整侧边栏宽度"
      @mousedown="startDrag"
    ></div>

    <div class="brand">
      <BrandLogo :size="32" />
      <div class="brand-text">
        <span class="brand-name">职业画像</span>
        <span class="brand-desc">数据分析后台</span>
      </div>
    </div>

    <nav class="nav">
      <RouterLink
        v-for="m in menus"
        :key="m.to"
        :to="m.to"
        class="nav-item"
        active-class="active"
      >
        <svg v-if="m.icon === 'profile'" class="ic" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
          <rect x="3" y="4" width="18" height="16" rx="2" fill="none" stroke="currentColor" stroke-width="1.8" />
          <path d="M7 9h10M7 13h6M7 17h8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
        </svg>
        <svg v-else-if="m.icon === 'advisor'" class="ic" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
          <path d="M12 3l1.8 5.2L19 10l-5.2 1.8L12 17l-1.8-5.2L5 10l5.2-1.8z" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round" />
          <path d="M18 16l.7 2.1L21 19l-2.3.9L18 22l-.7-2.1L15 19l2.3-.9z" fill="none" stroke="currentColor" stroke-width="1.3" stroke-linejoin="round" />
        </svg>
        <svg v-else-if="m.icon === 'tree'" class="ic" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
          <circle cx="12" cy="5" r="2.5" fill="none" stroke="currentColor" stroke-width="1.8" />
          <circle cx="6" cy="19" r="2.5" fill="none" stroke="currentColor" stroke-width="1.8" />
          <circle cx="18" cy="19" r="2.5" fill="none" stroke="currentColor" stroke-width="1.8" />
          <path d="M12 7.5v4M12 11.5L6 16.5M12 11.5l6 5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
        </svg>
        <svg v-else class="ic" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
          <path d="M12 3v18M3 12h18" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
          <circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="1.8" />
        </svg>
        <span class="nav-label">{{ m.label }}</span>
      </RouterLink>
    </nav>

    <RouterLink to="/account" class="user-area" active-class="active" :title="(auth.username || '') + ' · 个人中心'">
      <div class="user-avatar">{{ (auth.username || 'U').charAt(0).toUpperCase() }}</div>
    </RouterLink>
  </aside>
</template>

<style scoped>
.sidebar {
  width: var(--sidebar-width);
  background: var(--glass-sidebar-bg);
  backdrop-filter: blur(var(--glass-blur)) saturate(1.4);
  -webkit-backdrop-filter: blur(var(--glass-blur)) saturate(1.4);
  color: var(--text-on-dark);
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  z-index: 20;
  border-right: 1px solid var(--border-on-dark);
}

/* Drag target is just this thin strip straddling the sidebar's right edge —
   not the whole sidebar — so nav/brand/avatar clicks are never affected.
   Invisible at rest (no change to the existing look); only a hover/drag
   state reveals the handle, same affordance pattern as Finder/VS Code. */
.sidebar-resizer {
  position: absolute;
  top: 0;
  bottom: 0;
  right: -3px;
  width: 6px;
  cursor: col-resize;
  z-index: 5;
  user-select: none;
  touch-action: none;
}
.sidebar-resizer::after {
  content: '';
  position: absolute;
  left: 50%;
  top: 8px;
  bottom: 8px;
  width: 3px;
  transform: translateX(-50%);
  background: transparent;
  border-radius: var(--radius-full);
  transition: background var(--transition-fast), width var(--transition-fast);
}
.sidebar-resizer:hover::after,
.sidebar-resizer:active::after {
  background: var(--primary-color);
  width: 4px;
}

.brand {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 18px 20px;
  height: var(--header-height);
  border-bottom: 1px solid var(--border-on-dark);
  flex-shrink: 0;
}
.brand-text {
  display: flex;
  flex-direction: column;
  line-height: 1.2;
  min-width: 0;
}
.brand-name,
.brand-desc {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.brand-name {
  font-size: var(--font-size-md);
  font-weight: 600;
}
.brand-desc {
  font-size: var(--font-size-xs);
  color: var(--text-on-dark-muted);
}

.nav {
  flex: 1;
  padding: var(--space-5) var(--space-3);
  display: flex;
  flex-direction: column;
  gap: var(--space-1);
}
.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 11px 14px;
  border-radius: var(--radius-full);
  color: var(--text-on-dark-muted);
  font-size: var(--font-size-base);
  font-weight: 500;
  min-width: 0;
  transition: background var(--transition), color var(--transition), box-shadow var(--transition-spring);
}
.nav-label {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.nav-item:hover {
  background: var(--sidebar-bg-hover);
  color: var(--text-on-dark);
}
.nav-item.active {
  background: var(--gradient-primary);
  color: #fff;
  font-weight: 600;
  box-shadow: var(--glow-primary);
}
.ic {
  flex-shrink: 0;
  opacity: 0.9;
}

.user-area {
  display: flex;
  align-items: center;
  padding: 16px 20px;
  border-top: 1px solid var(--border-on-dark);
  flex-shrink: 0;
  transition: background var(--transition);
}
.user-area:hover {
  background: var(--sidebar-bg-hover);
}
.user-area.active .user-avatar {
  box-shadow: var(--glow-primary), 0 0 0 2px rgba(255, 255, 255, 0.5);
}
.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: var(--gradient-primary);
  box-shadow: var(--glow-primary);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: var(--font-size-base);
  flex-shrink: 0;
  transition: box-shadow var(--transition), transform var(--transition-fast);
}
.user-area:hover .user-avatar {
  transform: scale(1.06);
}
</style>