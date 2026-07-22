<script setup>
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Sidebar from '@/components/dashboard/Sidebar.vue'

const router = useRouter()
const route = useRoute()
const auth = useAuthStore()

const pageMeta = {
  '/jobs': { title: '职业画像', desc: '招聘数据采集与多维度统计分析' },
  '/match': { title: '技能匹配', desc: '输入已有技能，推荐匹配岗位并分析差距' },
}

function handleLogout() {
  auth.logout()
  router.push('/login')
}
</script>

<template>
  <template v-if="route.path === '/login'">
    <RouterView />
  </template>

  <div v-else class="shell">
    <Sidebar @logout="handleLogout" />

    <div class="main">
      <header class="topbar">
        <div>
          <h1 class="page-title">{{ pageMeta[route.path]?.title || '后台' }}</h1>
          <p class="page-desc">{{ pageMeta[route.path]?.desc || '' }}</p>
        </div>
        <div class="topbar-right">
          <span class="env-tag">职业画像分析平台</span>
        </div>
      </header>

      <main class="content">
        <RouterView v-slot="{ Component }">
          <KeepAlive>
            <component :is="Component" />
          </KeepAlive>
        </RouterView>
      </main>
    </div>
  </div>
</template>

<style scoped>
.shell {
  min-height: 100vh;
  width: 100%;
}
.main {
  margin-left: var(--sidebar-width);
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
.topbar {
  position: sticky;
  top: 0;
  z-index: 10;
  height: var(--header-height);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(8px);
  border-bottom: 1px solid var(--border-color);
}
.page-title {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--text-color);
}
.page-desc {
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
  margin-top: 2px;
}
.env-tag {
  padding: 6px 14px;
  border-radius: var(--radius-full);
  background: var(--primary-soft);
  color: var(--primary-hover);
  font-size: var(--font-size-xs);
  font-weight: 500;
}
.content {
  flex: 1;
  padding: 24px 32px;
  overflow-y: auto;
}
</style>