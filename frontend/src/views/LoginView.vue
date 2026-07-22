<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import BrandLogo from '@/components/common/BrandLogo.vue'

const router = useRouter()
const auth = useAuthStore()
const mode = ref('login')
const loading = ref(false)
const error = ref('')
const showPwd = ref(false)
const form = reactive({ username: '', password: '' })

async function handleSubmit() {
  error.value = ''
  if (!form.username || !form.password) {
    error.value = '请输入用户名和密码'
    return
  }
  loading.value = true
  try {
    if (mode.value === 'login') {
      await auth.login(form.username, form.password)
    } else {
      await auth.register(form.username, form.password)
    }
    router.push('/jobs')
  } catch (e) {
    error.value = e.response?.data?.detail || '操作失败，请重试'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-bg">
      <span class="blob blob-a"></span>
      <span class="blob blob-b"></span>
      <span class="grid-overlay"></span>
    </div>

    <div class="login-card">
      <div class="brand">
        <BrandLogo :size="56" />
        <h1 class="brand-title">职业画像分析平台</h1>
        <p class="brand-subtitle">招聘数据采集与分析系统</p>
      </div>

      <div class="tabs" role="tablist">
        <button
          role="tab"
          :class="{ active: mode === 'login' }"
          @click="mode = 'login'; error = ''"
        >
          登录
        </button>
        <button
          role="tab"
          :class="{ active: mode === 'register' }"
          @click="mode = 'register'; error = ''"
        >
          注册
        </button>
        <span class="tab-indicator" :class="mode"></span>
      </div>

      <form @submit.prevent="handleSubmit" novalidate>
        <label class="field">
          <span class="field-label">用户名</span>
          <input v-model="form.username" placeholder="请输入用户名" autocomplete="username" />
        </label>

        <label class="field">
          <span class="field-label">密码</span>
          <div class="pwd-wrap">
            <input
              v-model="form.password"
              :type="showPwd ? 'text' : 'password'"
              placeholder="请输入密码"
              autocomplete="current-password"
            />
            <button type="button" class="pwd-toggle" @click="showPwd = !showPwd">
              {{ showPwd ? '隐藏' : '显示' }}
            </button>
          </div>
        </label>

        <p v-if="error" class="error">{{ error }}</p>

        <button type="submit" class="submit" :disabled="loading">
          {{ loading ? '提交中...' : mode === 'login' ? '登录' : '注册' }}
        </button>
      </form>

      <p class="footnote">职业画像分析平台 · 桌面端后台系统</p>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  background: radial-gradient(circle at 20% 20%, #2a3a5e 0%, #1f2a44 45%, #131a2e 100%);
  padding: 40px 16px;
}

/* ---- ambient background ---- */
.login-bg {
  position: absolute;
  inset: 0;
  pointer-events: none;
  overflow: hidden;
}
.blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.45;
}
.blob-a {
  width: 480px; height: 480px;
  background: #4fc08d;
  top: -120px; left: -120px;
  opacity: 0.22;
}
.blob-b {
  width: 420px; height: 420px;
  background: #2f7ad4;
  bottom: -140px; right: -100px;
  opacity: 0.22;
}
.grid-overlay {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(255,255,255,0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255,255,255,0.04) 1px, transparent 1px);
  background-size: 48px 48px;
  mask-image: radial-gradient(circle at center, #000 30%, transparent 75%);
}

/* ---- card ---- */
.login-card {
  position: relative;
  z-index: 1;
  width: 448px;
  max-width: 100%;
  padding: 40px 44px 28px;
  background: var(--surface-color);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-login);
}

/* ---- brand ---- */
.brand {
  text-align: center;
  margin-bottom: 28px;
}
.brand-title {
  font-size: 22px;
  font-weight: 700;
  color: var(--text-color);
  margin-top: 14px;
  letter-spacing: 1px;
}
.brand-subtitle {
  margin-top: 6px;
  font-size: var(--font-size-sm);
  color: var(--text-secondary);
}

/* ---- tabs ---- */
.tabs {
  position: relative;
  display: flex;
  margin-bottom: 24px;
  background: var(--surface-soft);
  border-radius: var(--radius-md);
  padding: 4px;
}
.tabs button {
  flex: 1;
  text-align: center;
  padding: 8px 0;
  border: none;
  background: transparent;
  color: var(--text-secondary);
  font-size: var(--font-size-base);
  font-weight: 500;
  border-radius: var(--radius-sm);
  transition: color var(--transition);
  z-index: 1;
}
.tabs button.active {
  color: var(--primary-color);
}
.tab-indicator {
  position: absolute;
  top: 4px;
  left: 4px;
  width: calc(50% - 4px);
  height: calc(100% - 8px);
  background: var(--surface-color);
  border-radius: var(--radius-sm);
  box-shadow: var(--shadow-sm);
  transform: translateX(0);
  transition: transform var(--transition);
}
.tab-indicator.register {
  transform: translateX(100%);
}

/* ---- fields ---- */
.field {
  display: block;
  margin-bottom: 18px;
}
.field-label {
  display: block;
  margin-bottom: 7px;
  font-size: var(--font-size-sm);
  font-weight: 500;
  color: var(--text-secondary);
}
.field input,
.pwd-wrap input {
  width: 100%;
  height: 44px;
  padding: 0 14px;
  border: 1px solid var(--border-color-strong);
  border-radius: var(--radius-md);
  font-size: var(--font-size-md);
  color: var(--text-color);
  background: var(--surface-color);
  transition: border-color var(--transition), box-shadow var(--transition);
}
.field input:focus,
.pwd-wrap input:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(79, 192, 141, 0.18);
}
.pwd-wrap {
  position: relative;
}
.pwd-toggle {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  height: 28px;
  padding: 0 8px;
  background: transparent;
  border: none;
  color: var(--text-tertiary);
  font-size: var(--font-size-xs);
  border-radius: var(--radius-sm);
}
.pwd-toggle:hover {
  color: var(--text-secondary);
}

.error {
  color: #e74c3c;
  font-size: var(--font-size-sm);
  margin-bottom: 12px;
}

.submit {
  width: 100%;
  height: 46px;
  margin-top: 6px;
  background: var(--primary-color);
  color: #fff;
  border: none;
  border-radius: var(--radius-md);
  font-size: var(--font-size-md);
  font-weight: 600;
  letter-spacing: 2px;
  transition: background var(--transition), transform var(--transition);
}
.submit:hover:not(:disabled) {
  background: var(--primary-hover);
}
.submit:active:not(:disabled) {
  transform: scale(0.99);
}
.submit:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

.footnote {
  margin-top: 22px;
  text-align: center;
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
}

@media (max-width: 480px) {
  .login-card {
    width: 100%;
    padding: 32px 24px 22px;
  }
}
</style>