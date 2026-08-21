<script setup>
import { ref } from 'vue'
import api from '@/api'
import EmptyState from '@/components/common/EmptyState.vue'
import Loading from '@/components/common/Loading.vue'

const input = ref('')
const skills = ref([])
const results = ref([])
const loading = ref(false)
const searched = ref(false)
const error = ref('')

function addSkill() {
  const name = input.value.trim()
  if (name && !skills.value.includes(name)) {
    skills.value.push(name)
  }
  input.value = ''
}

function removeSkill(name) {
  skills.value = skills.value.filter(s => s !== name)
}

async function doMatch() {
  loading.value = true
  searched.value = true
  error.value = ''
  try {
    const { data } = await api.post('/profile/skills/match', { skills: skills.value })
    results.value = data
  } catch (e) {
    error.value = '匹配请求失败，请稍后重试'
    console.error(e)
  } finally {
    loading.value = false
  }
}

// Prefill from the saved profile (个人中心) on first entry — still fully
// editable afterward, just saves retyping skills every time.
async function prefillFromProfile() {
  try {
    const { data } = await api.get('/account/me')
    if (data.skills?.length) {
      skills.value = [...data.skills]
    }
  } catch (e) {
    console.error(e)
  }
}

prefillFromProfile()
</script>

<template>
  <div class="match-page">
    <section class="panel card-surface">
      <h2 class="section-title">技能匹配分析</h2>
      <p class="section-desc">输入你掌握的技能，系统会匹配最适合的岗位，并分析技能差距</p>

      <div class="input-row">
        <input
          v-model="input"
          placeholder="输入技能名称，按回车添加（如：Python MySQL Docker）"
          @keydown.enter.prevent="addSkill"
        />
        <button class="ghost-btn" @click="addSkill">添加</button>
      </div>

      <div class="tags" v-if="skills.length">
        <span v-for="s in skills" :key="s" class="tag" @click="removeSkill(s)">{{ s }} ✕</span>
      </div>

      <button class="match-btn" @click="doMatch" :disabled="!skills.length || loading">
        {{ loading ? '匹配中...' : '开始匹配' }}
      </button>
    </section>

    <section class="panel card-surface">
      <Loading v-if="loading" message="正在匹配岗位..." />
      <p v-else-if="error" class="error">{{ error }}</p>
      <template v-else-if="searched">
        <div class="results-head">
          <h3 class="section-title">匹配结果</h3>
          <span class="result-count">共 {{ results.length }} 条 · 按匹配技能数排序</span>
        </div>
        <div v-if="results.length" class="table-wrap" :key="results.length + '-' + (results[0]?.title || '')">
          <table>
            <thead>
              <tr>
                <th>岗位名称</th>
                <th>公司</th>
                <th>城市</th>
                <th>平均薪资</th>
                <th>已匹配技能</th>
                <th>需学习技能</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(r, i) in results" :key="i">
                <td class="job-title">{{ r.title }}</td>
                <td>{{ r.company }}</td>
                <td>{{ r.city }}</td>
                <td class="salary">{{ r.salary_avg ? '¥' + r.salary_avg.toLocaleString() : '-' }}</td>
                <td><span v-for="s in r.matched_skills" :key="s" class="badge match">{{ s }}</span></td>
                <td><span v-for="s in r.missing_skills" :key="s" class="badge miss">{{ s }}</span></td>
              </tr>
            </tbody>
          </table>
        </div>
        <EmptyState v-else message="未找到匹配的岗位" />
      </template>
      <EmptyState v-else message="输入技能并开始匹配，查看推荐结果" />
    </section>
  </div>
</template>

<style scoped>
.match-page {
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-width: 1280px;
}
.panel {
  padding: var(--space-6) 28px;
  transition: box-shadow var(--transition-spring);
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

.input-row {
  display: flex;
  gap: 10px;
  margin-top: 18px;
}
.input-row input {
  flex: 1;
  height: 42px;
  padding: 0 14px;
  border: 1px solid var(--border-color-strong);
  border-radius: var(--radius-md);
  font-size: var(--font-size-base);
  color: var(--text-color);
  background: var(--surface-color);
  transition: border-color var(--transition), box-shadow var(--transition);
}
.input-row input:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(79, 192, 141, 0.18);
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

.match-btn {
  margin-top: 6px;
  height: 44px;
  padding: 0 36px;
  background: var(--gradient-primary);
  color: #fff;
  border: none;
  border-radius: var(--radius-full);
  font-size: var(--font-size-md);
  font-weight: 600;
  box-shadow: var(--glow-primary);
  transition: filter var(--transition), transform var(--transition-fast), box-shadow var(--transition);
}
.match-btn:hover:not(:disabled) {
  filter: brightness(1.06);
}
.match-btn:active:not(:disabled) {
  transform: scale(0.98);
}
.match-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.results-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-bottom: 14px;
}
.result-count {
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
}
.error {
  color: #e74c3c;
  padding: 8px 0;
}

.table-wrap {
  overflow-x: auto;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  animation: fade-up 0.5s var(--ease-spring) both;
}
table {
  width: 100%;
  border-collapse: collapse;
}
th, td {
  padding: 12px 14px;
  text-align: left;
  font-size: var(--font-size-sm);
  border-bottom: 1px solid var(--border-color);
  white-space: nowrap;
}
th {
  background: var(--surface-soft);
  font-weight: 600;
  color: var(--text-secondary);
}
tbody tr:hover {
  background: var(--surface-soft);
}
td.job-title {
  font-weight: 600;
  color: var(--text-color);
}
td.salary {
  color: var(--accent-orange);
  font-weight: 600;
}
.badge {
  display: inline-block;
  padding: 3px 9px;
  margin: 2px 3px;
  border-radius: var(--radius-sm);
  font-size: var(--font-size-xs);
}
.badge.match { background: var(--primary-soft); color: var(--primary-hover); }
.badge.miss { background: var(--accent-orange-soft); color: var(--accent-orange); }
</style>