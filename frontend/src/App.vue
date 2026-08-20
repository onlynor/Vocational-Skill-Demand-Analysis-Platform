<script setup>
import { useRoute } from 'vue-router'
import Sidebar from '@/components/dashboard/Sidebar.vue'
import ThemeToggle from '@/components/common/ThemeToggle.vue'

const route = useRoute()

const pageMeta = {
  '/jobs': { title: '职业画像', desc: '招聘数据采集与多维度统计分析' },
  '/match': { title: '技能匹配', desc: '输入已有技能，推荐匹配岗位并分析差距' },
  '/skill-tree': { title: '技能树', desc: '计算机/互联网行业职位技能图谱' },
  '/advisor': { title: 'AI职业顾问', desc: '基于平台真实招聘数据的智能问答' },
  '/account': { title: '个人中心', desc: '管理你的求职画像与账户' },
}
</script>

<template>
  <template v-if="route.path === '/login'">
    <RouterView />
  </template>

  <div v-else class="shell">
    <div class="ambient-mesh" aria-hidden="true" />
    <Sidebar />

    <div class="main">
      <header class="topbar">
        <div>
          <h1 class="page-title">{{ pageMeta[route.path]?.title || '后台' }}</h1>
          <p class="page-desc">{{ pageMeta[route.path]?.desc || '' }}</p>
        </div>
        <div class="topbar-right">
          <span class="env-tag">职业画像分析平台</span>
          <ThemeToggle />
        </div>
      </header>

      <main class="content">
        <RouterView v-slot="{ Component }">
          <Transition name="page" mode="out-in">
            <KeepAlive>
              <component :is="Component" />
            </KeepAlive>
          </Transition>
        </RouterView>
      </main>
    </div>
  </div>
</template>

<style scoped>
.shell {
  min-height: 100vh;
  width: 100%;
  position: relative;
}
/* A static gradient wash instead of flat gray — costs one paint, not a
   per-frame blur, since nothing here moves or animates. */
.ambient-mesh {
  position: fixed;
  inset: 0;
  z-index: 0;
  background: var(--gradient-mesh), var(--background-color);
  pointer-events: none;
}
.main {
  position: relative;
  z-index: 1;
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
  padding: 0 var(--space-8);
  background: var(--glass-topbar-bg);
  backdrop-filter: blur(var(--glass-blur)) saturate(1.8);
  -webkit-backdrop-filter: blur(var(--glass-blur)) saturate(1.8);
  border-bottom: 1px solid var(--glass-border);
}
.page-title {
  font-size: var(--font-size-xl);
  font-weight: 700;
  letter-spacing: -0.01em;
  color: var(--text-color);
}
.page-desc {
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
  margin-top: 2px;
}
.topbar-right {
  display: flex;
  align-items: center;
  gap: 12px;
}
.env-tag {
  padding: 6px 16px;
  border-radius: var(--radius-full);
  background: var(--gradient-primary);
  color: #fff;
  font-size: var(--font-size-xs);
  font-weight: 600;
  box-shadow: var(--glow-primary);
}
.content {
  flex: 1;
  padding: var(--space-6) var(--space-8) var(--space-10);
  overflow-y: auto;
}
</style>