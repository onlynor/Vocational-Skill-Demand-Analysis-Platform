<template>
  <div class="match-page">
    <h2>技能匹配分析</h2>
    <p class="desc">输入你掌握的技能，系统会匹配最适合的岗位，并分析技能差距。</p>

    <div class="input-row">
      <input
        v-model="input"
        placeholder="输入技能名称，按回车添加（如：Python MySQL Docker）"
        @keydown.enter.prevent="addSkill"
      />
      <button @click="addSkill">添加</button>
    </div>

    <div class="tags" v-if="skills.length">
      <span v-for="s in skills" :key="s" class="tag" @click="removeSkill(s)">{{ s }} ✕</span>
    </div>

    <button class="match-btn" @click="doMatch" :disabled="!skills.length || loading">
      {{ loading ? '匹配中...' : '开始匹配' }}
    </button>

    <div class="results" v-if="results.length">
      <h3>匹配结果（按匹配技能数排序）</h3>
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
            <td>{{ r.title }}</td>
            <td>{{ r.company }}</td>
            <td>{{ r.city }}</td>
            <td>{{ r.salary_avg ? '¥' + r.salary_avg.toLocaleString() : '-' }}</td>
            <td>
              <span v-for="s in r.matched_skills" :key="s" class="badge match">{{ s }}</span>
            </td>
            <td>
              <span v-for="s in r.missing_skills" :key="s" class="badge miss">{{ s }}</span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <p v-if="searched && !results.length" class="empty">未找到匹配的岗位。</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import api from '@/api'

const input = ref('')
const skills = ref([])
const results = ref([])
const loading = ref(false)
const searched = ref(false)

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
  try {
    const { data } = await api.post('/profile/skills/match', { skills: skills.value })
    results.value = data
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.match-page {
  padding: 24px;
}
h2 {
  color: #1a1a2e;
  margin-bottom: 8px;
}
.desc {
  color: #888;
  margin-bottom: 20px;
}
.input-row {
  display: flex;
  gap: 10px;
  margin-bottom: 12px;
}
.input-row input {
  flex: 1;
  padding: 10px 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
}
.input-row button {
  padding: 10px 20px;
  background: #1a1a2e;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}
.tags {
  margin-bottom: 16px;
}
.tag {
  display: inline-block;
  padding: 4px 12px;
  margin: 0 6px 6px 0;
  background: #e8f4fd;
  color: #409EFF;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
}
.match-btn {
  padding: 10px 32px;
  background: #4fc08d;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 15px;
  cursor: pointer;
  margin-bottom: 24px;
}
.match-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
.results h3 {
  margin-bottom: 12px;
  color: #333;
}
table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
}
th, td {
  padding: 10px 12px;
  text-align: left;
  font-size: 13px;
  border-bottom: 1px solid #f0f0f0;
}
th {
  background: #f8f9fa;
  font-weight: 600;
  color: #555;
}
.badge {
  display: inline-block;
  padding: 2px 8px;
  margin: 1px 3px;
  border-radius: 3px;
  font-size: 12px;
}
.badge.match { background: #e8f5e9; color: #4caf50; }
.badge.miss { background: #fff3e0; color: #ff9800; }
.empty {
  color: #999;
  margin-top: 20px;
}
</style>
