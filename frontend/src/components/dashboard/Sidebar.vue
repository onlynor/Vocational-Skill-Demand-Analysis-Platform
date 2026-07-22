<script setup>
import { useAuthStore } from '@/stores/auth'
import BrandLogo from '@/components/common/BrandLogo.vue'

defineEmits(['logout'])

const auth = useAuthStore()

const menus = [
  { to: '/jobs', label: '职业画像', icon: 'profile' },
  { to: '/match', label: '技能匹配', icon: 'match' },
]
</script>

<template>
  <aside class="sidebar">
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
        <svg v-else class="ic" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
          <path d="M12 3v18M3 12h18" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
          <circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="1.8" />
        </svg>
        <span class="nav-label">{{ m.label }}</span>
      </RouterLink>
    </nav>

    <div class="user-area">
      <div class="user-avatar">{{ (auth.username || 'U').charAt(0).toUpperCase() }}</div>
      <div class="user-meta">
        <span class="username">{{ auth.username || '未登录' }}</span>
        <button class="logout-btn" @click="$emit('logout')">退出登录</button>
      </div>
    </div>
  </aside>
</template>

<style scoped>
.sidebar {
  width: var(--sidebar-width);
  background: var(--sidebar-bg);
  color: var(--text-on-dark);
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  z-index: 20;
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
  padding: 16px 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 14px;
  border-radius: var(--radius-md);
  color: var(--text-on-dark-muted);
  font-size: var(--font-size-base);
  font-weight: 500;
  transition: background var(--transition), color var(--transition);
}
.nav-item:hover {
  background: var(--sidebar-bg-hover);
  color: var(--text-on-dark);
}
.nav-item.active {
  background: rgba(79, 192, 141, 0.16);
  color: #fff;
  position: relative;
}
.nav-item.active::before {
  content: '';
  position: absolute;
  left: -12px;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 22px;
  background: var(--primary-color);
  border-radius: 0 3px 3px 0;
}
.ic {
  flex-shrink: 0;
  opacity: 0.9;
}

.user-area {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  border-top: 1px solid var(--border-on-dark);
  flex-shrink: 0;
}
.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: var(--primary-color);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: var(--font-size-base);
  flex-shrink: 0;
}
.user-meta {
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.username {
  font-size: var(--font-size-sm);
  color: var(--text-on-dark);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.logout-btn {
  align-self: flex-start;
  margin-top: 2px;
  padding: 2px 0;
  background: transparent;
  border: none;
  color: var(--text-on-dark-muted);
  font-size: var(--font-size-xs);
}
.logout-btn:hover {
  color: #fff;
}
</style>