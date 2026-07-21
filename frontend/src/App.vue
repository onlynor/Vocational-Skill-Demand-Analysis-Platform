<script setup>
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const route = useRoute()
const auth = useAuthStore()

function handleLogout() {
  auth.logout()
  router.push('/login')
}
</script>

<template>
  <div class="app-layout">
    <!-- 登录页直接渲染，不加侧边栏 -->
    <template v-if="route.path === '/login'">
      <RouterView />
    </template>

    <!-- 主布局：侧边栏 + 内容 -->
    <template v-else>
      <aside class="sidebar">
        <div class="brand">
          <h1>职业画像分析</h1>
        </div>
        <nav>
          <RouterLink to="/jobs" class="nav-item" active-class="active">
            <span class="icon">&#9776;</span> 职业画像
          </RouterLink>
          <RouterLink to="/match" class="nav-item" active-class="active">
            <span class="icon">&#9878;</span> 技能匹配
          </RouterLink>
        </nav>
        <div class="user-area">
          <span class="username">{{ auth.username }}</span>
          <button @click="handleLogout" class="logout-btn">退出</button>
        </div>
      </aside>
      <main class="content">
        <RouterView v-slot="{ Component }">
          <KeepAlive>
            <component :is="Component" />
          </KeepAlive>
        </RouterView>
      </main>
    </template>
  </div>
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  background: #f5f6fa;
  color: #333;
}
a {
  text-decoration: none;
}
</style>

<style scoped>
.app-layout {
  display: flex;
  min-height: 100vh;
}
.sidebar {
  width: 220px;
  background: #1a1a2e;
  color: #fff;
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
}
.brand {
  padding: 24px 20px 20px;
  border-bottom: 1px solid rgba(255,255,255,0.1);
}
.brand h1 {
  font-size: 18px;
  font-weight: 600;
}
nav {
  flex: 1;
  padding: 16px 0;
}
.nav-item {
  display: block;
  padding: 12px 20px;
  color: rgba(255,255,255,0.7);
  font-size: 14px;
  transition: 0.15s;
}
.nav-item:hover {
  background: rgba(255,255,255,0.08);
  color: #fff;
}
.nav-item.active {
  background: rgba(79, 192, 141, 0.2);
  color: #4fc08d;
  border-right: 3px solid #4fc08d;
}
.icon {
  margin-right: 6px;
}
.user-area {
  padding: 16px 20px;
  border-top: 1px solid rgba(255,255,255,0.1);
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.username {
  font-size: 13px;
  color: rgba(255,255,255,0.8);
}
.logout-btn {
  background: rgba(255,255,255,0.15);
  color: rgba(255,255,255,0.8);
  border: none;
  padding: 4px 12px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}
.logout-btn:hover {
  background: rgba(255,255,255,0.25);
}
.content {
  margin-left: 220px;
  flex: 1;
  min-height: 100vh;
  height: 100vh;
  overflow-y: auto;
}
</style>
