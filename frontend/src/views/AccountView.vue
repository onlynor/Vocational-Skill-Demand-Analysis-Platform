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

// --- AI advisor config (OpenAI-compatible endpoint, user brings their own) ---
const aiBaseUrl = ref('')
const aiModel = ref('')
const aiKey = ref('')          // only ever holds NEW input; never populated from server
const aiHasKey = ref(false)
const aiSaving = ref(false)
const aiMsg = ref('')

// Model discovery + connection test
const aiModels = ref([])          // fetched from the endpoint's /models
const aiLoadingModels = ref(false)
const aiModelsError = ref('')
const aiTesting = ref(false)
const aiTestResult = ref(null)    // {ok, message, supports_tools, latency_ms}

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

async function loadAIConfig() {
  try {
    const { data } = await api.get('/account/ai-config')
    aiBaseUrl.value = data.api_base_url || ''
    aiModel.value = data.model || ''
    aiHasKey.value = data.has_api_key
  } catch (e) {
    console.error(e)
  }
}

// Both probes send whatever is currently typed; the backend falls back to
// stored values for anything omitted (notably the key, which the form never
// holds), so this works before OR after saving.
function aiProbePayload() {
  const p = {}
  if (aiBaseUrl.value.trim()) p.api_base_url = aiBaseUrl.value.trim()
  if (aiKey.value.trim()) p.api_key = aiKey.value.trim()
  if (aiModel.value.trim()) p.model = aiModel.value.trim()
  return p
}

async function fetchAIModels() {
  aiLoadingModels.value = true
  aiModelsError.value = ''
  aiModels.value = []
  try {
    const { data } = await api.post('/account/ai-config/models', aiProbePayload(), { timeout: 30000 })
    aiModels.value = data.models || []
  } catch (e) {
    aiModelsError.value = e.response?.data?.detail || '获取模型列表失败'
    console.error(e)
  } finally {
    aiLoadingModels.value = false
  }
}

function pickModel(m) {
  aiModel.value = m
  aiTestResult.value = null
}

async function testAIConnection() {
  aiTesting.value = true
  aiTestResult.value = null
  try {
    const { data } = await api.post('/account/ai-config/test', aiProbePayload(), { timeout: 60000 })
    aiTestResult.value = data
  } catch (e) {
    aiTestResult.value = {
      ok: false,
      message: e.response?.data?.detail || '连接测试失败',
    }
    console.error(e)
  } finally {
    aiTesting.value = false
  }
}

async function saveAIConfig() {
  if (!aiBaseUrl.value.trim() || !aiModel.value.trim()) {
    aiMsg.value = 'invalid'
    setTimeout(() => { aiMsg.value = '' }, 2500)
    return
  }
  aiSaving.value = true
  aiMsg.value = ''
  try {
    const payload = {
      api_base_url: aiBaseUrl.value.trim(),
      model: aiModel.value.trim(),
    }
    // Omit the key when left blank so the stored one is kept.
    if (aiKey.value.trim()) payload.api_key = aiKey.value.trim()
    const { data } = await api.put('/account/ai-config', payload)
    aiHasKey.value = data.has_api_key
    aiKey.value = ''
    aiMsg.value = aiHasKey.value ? 'success' : 'nokey'
  } catch (e) {
    aiMsg.value = 'error'
    console.error(e)
  } finally {
    aiSaving.value = false
    setTimeout(() => { aiMsg.value = '' }, 3000)
  }
}

async function clearAIConfig() {
  aiSaving.value = true
  try {
    await api.delete('/account/ai-config')
    aiBaseUrl.value = ''
    aiModel.value = ''
    aiKey.value = ''
    aiHasKey.value = false
    aiMsg.value = 'cleared'
  } catch (e) {
    aiMsg.value = 'error'
    console.error(e)
  } finally {
    aiSaving.value = false
    setTimeout(() => { aiMsg.value = '' }, 3000)
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
loadAIConfig()
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

    <section class="panel card-surface">
      <h2 class="section-title">AI 职业顾问配置</h2>
      <p class="section-desc">
        「AI职业顾问」使用你自己的模型服务，任何 <strong>OpenAI 兼容</strong>接口都可以
        （DeepSeek、通义千问、Moonshot，或自建 vLLM / Ollama 网关）。填写后即可在 AI 顾问页面提问。
      </p>

      <div class="field-grid">
        <label class="field">
          <span class="field-label">API 地址（v1 根路径）</span>
          <input v-model="aiBaseUrl" placeholder="如：https://api.deepseek.com/v1" />
        </label>
        <label class="field">
          <span class="field-label">模型名称</span>
          <div class="input-row">
            <input v-model="aiModel" placeholder="如：deepseek-chat（可手动输入）" />
            <button
              type="button"
              class="ghost-btn"
              :disabled="aiLoadingModels"
              @click="fetchAIModels"
            >{{ aiLoadingModels ? '获取中...' : '获取模型' }}</button>
          </div>
        </label>
      </div>

      <p v-if="aiModelsError" class="save-msg error">{{ aiModelsError }}</p>
      <div v-if="aiModels.length" class="model-picker">
        <p class="picker-label">从接口获取到 {{ aiModels.length }} 个模型，点击选择：</p>
        <div class="model-list">
          <button
            v-for="m in aiModels"
            :key="m"
            type="button"
            class="model-chip"
            :class="{ active: m === aiModel }"
            @click="pickModel(m)"
          >{{ m }}</button>
        </div>
      </div>

      <label class="field">
        <span class="field-label">
          API Key
          <span v-if="aiHasKey" class="key-badge">已保存，留空则不修改</span>
        </span>
        <input
          v-model="aiKey"
          type="password"
          autocomplete="new-password"
          :placeholder="aiHasKey ? '已保存（留空表示沿用原 Key）' : '粘贴你的 API Key'"
        />
      </label>
      <p class="key-note">
        Key 保存在本项目的数据库中，仅由后端在调用你填写的接口时使用，不会返回给浏览器。
        请使用你自己的、可随时撤销的 Key。
      </p>

      <div class="form-footer">
        <button type="button" class="save-btn" :disabled="aiSaving" @click="saveAIConfig">
          {{ aiSaving ? '保存中...' : '保存配置' }}
        </button>
        <button
          type="button"
          class="ghost-btn"
          :disabled="aiTesting"
          @click="testAIConnection"
        >{{ aiTesting ? '测试中...' : '测试连接' }}</button>
        <button
          v-if="aiHasKey || aiBaseUrl"
          type="button"
          class="ghost-btn"
          :disabled="aiSaving"
          @click="clearAIConfig"
        >清除配置</button>
        <span v-if="aiMsg === 'success'" class="save-msg success">已保存</span>
        <span v-if="aiMsg === 'nokey'" class="save-msg error">已保存，但还没有 API Key</span>
        <span v-if="aiMsg === 'invalid'" class="save-msg error">请填写 API 地址和模型名称</span>
        <span v-if="aiMsg === 'cleared'" class="save-msg success">已清除</span>
        <span v-if="aiMsg === 'error'" class="save-msg error">操作失败，请重试</span>
      </div>

      <p
        v-if="aiTestResult"
        class="test-result"
        :class="aiTestResult.ok ? 'ok' : 'fail'"
      >
        <span class="test-icon">{{ aiTestResult.ok ? '✓' : '✕' }}</span>
        {{ aiTestResult.message }}
      </p>
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

.model-picker { margin-top: var(--space-4); }
.picker-label {
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
  margin-bottom: var(--space-2);
}
.model-list { display: flex; flex-wrap: wrap; gap: var(--space-2); }
.model-chip {
  padding: 6px 14px;
  border-radius: var(--radius-full);
  border: 1px solid var(--border-color-strong);
  background: var(--surface-color);
  color: var(--text-secondary);
  font-size: var(--font-size-sm);
  font-family: var(--font-mono);
  transition: border-color var(--transition), color var(--transition), background var(--transition);
}
.model-chip:hover { border-color: var(--primary-color); color: var(--primary-hover); }
.model-chip.active {
  background: var(--gradient-primary);
  border-color: transparent;
  color: #fff;
  font-weight: 600;
  box-shadow: var(--glow-primary);
}

.test-result {
  margin-top: var(--space-4);
  padding: 10px 14px;
  border-radius: var(--radius-md);
  font-size: var(--font-size-sm);
  line-height: 1.6;
  display: flex;
  gap: 8px;
  align-items: flex-start;
}
.test-result.ok {
  background: var(--primary-soft);
  color: var(--primary-hover);
}
.test-result.fail {
  background: var(--accent-orange-soft);
  color: var(--accent-orange);
}
.test-icon { font-weight: 700; flex-shrink: 0; }

.key-badge {
  margin-left: 8px;
  padding: 1px 8px;
  border-radius: var(--radius-full);
  background: var(--primary-soft);
  color: var(--primary-hover);
  font-size: var(--font-size-xs);
  font-weight: 500;
}
.key-note {
  margin-top: var(--space-2);
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
  line-height: 1.6;
}

@media (max-width: 640px) {
  .field-grid {
    grid-template-columns: 1fr;
  }
}
</style>
