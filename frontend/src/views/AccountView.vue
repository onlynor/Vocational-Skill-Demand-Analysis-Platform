<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import api from '@/api'

const router = useRouter()
const auth = useAuthStore()

const EDUCATION_OPTIONS = ['不限', '初中及以下', '高中', '中专/中技', '大专', '本科', '硕士', '博士']

const loading = ref(true)
const saving = ref(false)
const loadError = ref('')
const saveMsg = ref('')

const targetTitle = ref('')
const city = ref('')
const education = ref('')
const experience = ref('')
const salaryMinK = ref(null)
const salaryMaxK = ref(null)
const skills = ref([])
const skillInput = ref('')

function addSkill() {
  const name = skillInput.value.trim()
  if (name && !skills.value.includes(name)) {
    skills.value.push(name)
  }
  skillInput.value = ''
}

function removeSkill(name) {
  skills.value = skills.value.filter(s => s !== name)
}

async function loadProfile() {
  loading.value = true
  loadError.value = ''
  try {
    const { data } = await api.get('/account/me')
    targetTitle.value = data.target_title || ''
    city.value = data.city || ''
    education.value = data.education || ''
    experience.value = data.experience || ''
    salaryMinK.value = data.salary_min != null ? Math.round(data.salary_min / 1000) : null
    salaryMaxK.value = data.salary_max != null ? Math.round(data.salary_max / 1000) : null
    skills.value = data.skills || []
  } catch (e) {
    loadError.value = '加载个人画像失败，请刷新重试'
    console.error(e)
  } finally {
    loading.value = false
  }
}

async function saveProfile() {
  saving.value = true
  saveMsg.value = ''
  try {
    await api.put('/account/profile', {
      target_title: targetTitle.value || null,
      city: city.value || null,
      education: education.value || null,
      experience: experience.value || null,
      salary_min: salaryMinK.value != null ? salaryMinK.value * 1000 : null,
      salary_max: salaryMaxK.value != null ? salaryMaxK.value * 1000 : null,
      skills: skills.value,
    })
    saveMsg.value = 'success'
  } catch (e) {
    saveMsg.value = 'error'
    console.error(e)
  } finally {
    saving.value = false
    setTimeout(() => { saveMsg.value = '' }, 2500)
  }
}

function handleLogout() {
  auth.logout()
  router.push('/login')
}

loadProfile()
</script>

<template>
  <div class="account-page">
    <section class="panel card-surface">
      <h2 class="section-title">求职画像</h2>
      <p class="section-desc">手动填写你的求职意向，进入「技能匹配」时会自动带出已保存的技能（仍可再编辑）</p>

      <p v-if="loadError" class="error">{{ loadError }}</p>

      <form v-else class="profile-form" @submit.prevent="saveProfile">
        <div class="field-grid">
          <label class="field">
            <span class="field-label">期望职位</span>
            <input v-model="targetTitle" placeholder="如：Java开发" :disabled="loading" />
          </label>
          <label class="field">
            <span class="field-label">期望城市</span>
            <input v-model="city" placeholder="如：上海" :disabled="loading" />
          </label>
          <label class="field">
            <span class="field-label">学历</span>
            <select v-model="education" :disabled="loading">
              <option value="">未选择</option>
              <option v-for="opt in EDUCATION_OPTIONS" :key="opt" :value="opt">{{ opt }}</option>
            </select>
          </label>
          <label class="field">
            <span class="field-label">工作经验</span>
            <input v-model="experience" placeholder="如：3-5年" :disabled="loading" />
          </label>
          <label class="field">
            <span class="field-label">期望最低月薪（K）</span>
            <input v-model.number="salaryMinK" type="number" min="0" placeholder="如：15" :disabled="loading" />
          </label>
          <label class="field">
            <span class="field-label">期望最高月薪（K）</span>
            <input v-model.number="salaryMaxK" type="number" min="0" placeholder="如：25" :disabled="loading" />
          </label>
        </div>

        <label class="field">
          <span class="field-label">技能</span>
          <div class="input-row">
            <input
              v-model="skillInput"
              placeholder="输入技能名称，按回车添加（如：Python MySQL Docker）"
              :disabled="loading"
              @keydown.enter.prevent="addSkill"
            />
            <button type="button" class="ghost-btn" :disabled="loading" @click="addSkill">添加</button>
          </div>
        </label>
        <div class="tags" v-if="skills.length">
          <span v-for="s in skills" :key="s" class="tag" @click="removeSkill(s)">{{ s }} ✕</span>
        </div>

        <div class="form-footer">
          <button type="submit" class="save-btn" :disabled="loading || saving">
            {{ saving ? '保存中...' : '保存画像' }}
          </button>
          <span v-if="saveMsg === 'success'" class="save-msg success">已保存</span>
          <span v-if="saveMsg === 'error'" class="save-msg error">保存失败，请重试</span>
        </div>
      </form>
    </section>

    <section class="panel card-surface account-section">
      <h2 class="section-title">账户</h2>
      <p class="section-desc">当前登录：{{ auth.username || '未登录' }}</p>
      <button class="logout-btn" @click="handleLogout">退出登录</button>
    </section>
  </div>
</template>

<style scoped>
.account-page {
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-width: 900px;
}
.panel {
  padding: var(--space-6) 28px;
}
.section-title {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--text-color);
}
.section-desc {
  margin-top: 6px;
  color: var(--text-secondary);
  font-size: var(--font-size-sm);
}

.profile-form {
  margin-top: 18px;
}
.field-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px 20px;
  margin-bottom: 18px;
}
.field {
  display: block;
}
.field-label {
  display: block;
  margin-bottom: 7px;
  font-size: var(--font-size-sm);
  font-weight: 500;
  color: var(--text-secondary);
}
.field input,
.field select,
.input-row input {
  width: 100%;
  height: 42px;
  padding: 0 14px;
  border: 1px solid var(--border-color-strong);
  border-radius: var(--radius-md);
  font-size: var(--font-size-base);
  color: var(--text-color);
  background: var(--surface-color);
  transition: border-color var(--transition), box-shadow var(--transition);
}
.field input:focus,
.field select:focus,
.input-row input:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(79, 192, 141, 0.18);
}
.field input:disabled,
.field select:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.input-row {
  display: flex;
  gap: 10px;
}
.input-row input {
  flex: 1;
}
.ghost-btn {
  height: 42px;
  padding: 0 22px;
  background: var(--surface-soft);
  color: var(--text-color);
  border: 1px solid var(--border-color-strong);
  border-radius: var(--radius-full);
  font-size: var(--font-size-base);
  transition: border-color var(--transition), color var(--transition), transform var(--transition-fast);
}
.ghost-btn:hover {
  border-color: var(--primary-color);
  color: var(--primary-hover);
}
.ghost-btn:active {
  transform: scale(0.97);
}

.tags {
  margin-top: 14px;
}
.tag {
  display: inline-block;
  padding: 5px 12px;
  margin: 0 8px 8px 0;
  background: var(--accent-blue-soft);
  color: var(--accent-blue);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-sm);
  cursor: pointer;
  transition: opacity var(--transition);
}
.tag:hover {
  opacity: 0.7;
}

.form-footer {
  margin-top: 20px;
  display: flex;
  align-items: center;
  gap: 14px;
}
.save-btn {
  height: 44px;
  padding: 0 36px;
  background: var(--gradient-primary);
  color: #fff;
  border: none;
  border-radius: var(--radius-full);
  font-size: var(--font-size-md);
  font-weight: 600;
  box-shadow: var(--glow-primary);
  transition: filter var(--transition), transform var(--transition-fast);
}
.save-btn:hover:not(:disabled) {
  filter: brightness(1.06);
}
.save-btn:active:not(:disabled) {
  transform: scale(0.98);
}
.save-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
.save-msg {
  font-size: var(--font-size-sm);
}
.save-msg.success { color: var(--primary-hover); }
.save-msg.error { color: #e74c3c; }

.error {
  color: #e74c3c;
  font-size: var(--font-size-sm);
  margin-top: 12px;
}

.account-section .logout-btn {
  margin-top: 18px;
  height: 42px;
  padding: 0 24px;
  background: transparent;
  color: #e74c3c;
  border: 1px solid #e74c3c;
  border-radius: var(--radius-full);
  font-size: var(--font-size-base);
  font-weight: 500;
  transition: background var(--transition), color var(--transition);
}
.account-section .logout-btn:hover {
  background: #e74c3c;
  color: #fff;
}

@media (max-width: 640px) {
  .field-grid {
    grid-template-columns: 1fr;
  }
}
</style>
