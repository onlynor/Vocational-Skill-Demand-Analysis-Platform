<template>
  <div class="job-profile">
    <div class="left-panel">
      <h2>职业画像</h2>
      <p class="hint">选择行业 → 选择职位，查看职业画像</p>

      <div class="category-list">
        <div
          v-for="cat in categories"
          :key="cat.category"
          class="category-item"
          :class="{ active: cat.category === activeCategory }"
          @click="selectCategory(cat.category)"
        >
          <span class="cat-name">{{ cat.category }}</span>
          <span class="cat-badge">{{ dataCount(cat) }}</span>
        </div>
      </div>

      <div v-if="activeJobs.length" class="job-list">
        <h4>{{ activeCategory }} · 职位</h4>
        <div
          v-for="job in activeJobs"
          :key="job.name"
          class="job-item"
          :class="{
            active: job.name === activeJob,
            'no-data': job.count === 0,
          }"
          @click="selectJob(job)"
        >
          <span>{{ job.name }}</span>
          <span class="job-count">{{ job.count }}条</span>
        </div>
      </div>
    </div>

    <div class="right-panel">
      <div v-if="!activeJob && !noDataMsg" class="empty-hint">
        <p>请从左侧选择行业和职位</p>
      </div>

      <div v-if="noDataMsg" class="empty-hint">
        <p>{{ noDataMsg }}</p>
      </div>

      <div v-if="loading" class="loading">加载中...</div>

      <template v-if="profile && !loading">
        <div class="profile-header">
          <h3>{{ profile.title }}</h3>
          <div class="stats-row">
            <div class="stat-card">
              <span class="stat-label">岗位数量</span>
              <span class="stat-value">{{ profile.job_count }}</span>
            </div>
            <div class="stat-card">
              <span class="stat-label">平均月薪</span>
              <span class="stat-value salary">¥{{ formatSalary(profile.avg_salary) }}</span>
            </div>
            <div class="stat-card">
              <span class="stat-label">薪资范围</span>
              <span class="stat-value range">¥{{ formatSalary(profile.salary_min) }} - ¥{{ formatSalary(profile.salary_max) }}</span>
            </div>
          </div>
        </div>

        <div class="charts-grid">
          <div class="chart-box">
            <h4>技能要求</h4>
            <v-chart v-if="profile.top_skills.length" class="chart" :option="skillOption" autoresize />
            <span v-else class="chart-empty">暂无数据</span>
          </div>
          <div class="chart-box">
            <h4>城市分布</h4>
            <v-chart v-if="profile.cities.length" class="chart" :option="cityOption" autoresize />
            <span v-else class="chart-empty">暂无数据</span>
          </div>
          <div class="chart-box">
            <h4>学历要求</h4>
            <v-chart v-if="profile.education.length" class="chart" :option="eduOption" autoresize />
            <span v-else class="chart-empty">暂无数据</span>
          </div>
          <div class="chart-box">
            <h4>招聘公司</h4>
            <div class="company-list">
              <span v-for="c in profile.companies" :key="c" class="company-tag">{{ c }}</span>
              <span v-if="!profile.companies.length" class="no-data">暂无数据</span>
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { BarChart, PieChart } from 'echarts/charts'
import { TitleComponent, TooltipComponent, GridComponent, LegendComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import api from '@/api'

use([BarChart, PieChart, TitleComponent, TooltipComponent, GridComponent, LegendComponent, CanvasRenderer])

const categories = ref([])
const activeCategory = ref('')
const activeJob = ref('')
const profile = ref(null)
const loading = ref(false)
const noDataMsg = ref('')

const activeJobs = computed(() => {
  const cat = categories.value.find(c => c.category === activeCategory.value)
  return cat ? cat.jobs : []
})

function dataCount(cat) {
  return cat.jobs.filter(j => j.count > 0).length
}

function selectCategory(cat) {
  activeCategory.value = cat
  activeJob.value = ''
  profile.value = null
  noDataMsg.value = ''
}

async function selectJob(job) {
  activeJob.value = job.name
  if (job.count === 0) {
    profile.value = null
    loading.value = false
    noDataMsg.value = `「${job.name}」暂无招聘数据`
    return
  }
  noDataMsg.value = ''
  loading.value = true
  profile.value = null
  try {
    const res = await api.get(`/profile/jobs/${encodeURIComponent(job.name)}`)
    profile.value = res.data
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

function formatSalary(val) {
  if (!val) return '--'
  if (val >= 1000) return (val / 1000).toFixed(0) + 'K'
  return val.toString()
}

const skillOption = computed(() => {
  if (!profile.value) return {}
  const data = profile.value.top_skills
  return {
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    xAxis: { type: 'value' },
    yAxis: {
      type: 'category',
      data: data.map(s => s.name).reverse(),
      axisLabel: { fontSize: 11 },
    },
    series: [{
      type: 'bar',
      data: data.map(s => s.value).reverse(),
      itemStyle: { color: '#4fc08d' },
    }],
    grid: { left: '25%', right: '5%', top: 10, bottom: 20 },
  }
})

const cityOption = computed(() => {
  if (!profile.value) return {}
  const data = profile.value.cities
  return {
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    xAxis: {
      type: 'category',
      data: data.map(c => c.name),
      axisLabel: { rotate: 30, fontSize: 11 },
    },
    yAxis: { type: 'value', minInterval: 1 },
    series: [{
      type: 'bar',
      data: data.map(c => c.value),
      itemStyle: { color: '#409EFF' },
    }],
    grid: { left: '10%', right: '5%', top: 15, bottom: '25%' },
  }
})

const eduOption = computed(() => {
  if (!profile.value) return {}
  const data = profile.value.education
  return {
    tooltip: { trigger: 'item' },
    legend: { orient: 'vertical', right: '5%', top: 'center', textStyle: { fontSize: 12 } },
    series: [{
      type: 'pie',
      radius: ['0%', '65%'],
      center: ['42%', '50%'],
      data: data.map(e => ({ name: e.name, value: e.value })),
      label: { formatter: '{b}', position: 'outside', fontSize: 11 },
      labelLine: { length: 15, length2: 20 },
    }],
  }
})

async function loadCategories() {
  try {
    const res = await api.get('/profile/jobs/tree')
    categories.value = res.data
    if (res.data.length) {
      activeCategory.value = res.data[0].category
    }
  } catch (e) {
    console.error(e)
  }
}

loadCategories()
</script>

<style scoped>
.job-profile {
  display: flex;
  height: 100vh;
}

/* ---- 左侧选择面板 ---- */
.left-panel {
  width: 260px;
  background: #fff;
  border-right: 1px solid #e8e8e8;
  padding: 20px 16px;
  overflow-y: auto;
  flex-shrink: 0;
}
.left-panel h2 {
  font-size: 18px;
  color: #1a1a2e;
  margin-bottom: 4px;
}
.hint {
  font-size: 12px;
  color: #999;
  margin-bottom: 20px;
}

.category-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.category-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 12px;
  border-radius: 6px;
  cursor: pointer;
  transition: 0.15s;
  font-size: 14px;
}
.category-item:hover {
  background: #f0f7ff;
}
.category-item.active {
  background: #e6f7e6;
  color: #2d8f2d;
  font-weight: 600;
}
.cat-badge {
  background: #f0f0f0;
  color: #999;
  padding: 1px 8px;
  border-radius: 10px;
  font-size: 11px;
}
.category-item.active .cat-badge {
  background: #c8e6c9;
  color: #2d8f2d;
}

.job-list {
  margin-top: 20px;
  border-top: 1px solid #eee;
  padding-top: 14px;
}
.job-list h4 {
  font-size: 13px;
  color: #888;
  margin-bottom: 8px;
}
.job-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
  transition: 0.12s;
}
.job-item:hover {
  background: #f0f7ff;
}
.job-item.active {
  background: #4fc08d;
  color: #fff;
  font-weight: 600;
}
.job-item.active .job-count {
  color: rgba(255,255,255,0.8);
}
.job-item.no-data {
  color: #ccc;
}
.job-count {
  font-size: 11px;
  color: #bbb;
}

/* ---- 右侧画像 ---- */
.right-panel {
  flex: 1;
  padding: 20px 24px;
  overflow-y: auto;
}
.empty-hint {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #bbb;
  font-size: 16px;
}
.loading {
  text-align: center;
  padding: 40px;
  color: #999;
}

.profile-header {
  margin-bottom: 20px;
}
.profile-header h3 {
  font-size: 22px;
  color: #1a1a2e;
  margin-bottom: 14px;
}
.stats-row {
  display: flex;
  gap: 16px;
}
.stat-card {
  background: #fff;
  border-radius: 8px;
  padding: 16px 24px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.stat-label {
  font-size: 12px;
  color: #999;
}
.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #333;
}
.stat-value.salary {
  color: #e6a23c;
}
.stat-value.range {
  font-size: 16px;
  color: #666;
  font-weight: 600;
}

.charts-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}
.chart-box {
  background: #fff;
  border-radius: 8px;
  padding: 14px 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
  display: flex;
  flex-direction: column;
  min-height: 260px;
}
.chart-box h4 {
  font-size: 14px;
  color: #555;
  margin-bottom: 8px;
  flex-shrink: 0;
}
.chart {
  flex: 1;
  min-height: 0;
}
.chart-empty {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ccc;
  font-size: 14px;
}

.company-list {
  flex: 1;
  display: flex;
  flex-wrap: wrap;
  align-content: flex-start;
  gap: 8px;
  overflow-y: auto;
  padding-top: 4px;
}
.company-tag {
  background: #f0f7ff;
  color: #409EFF;
  padding: 4px 12px;
  border-radius: 14px;
  font-size: 13px;
  white-space: nowrap;
}
.no-data {
  color: #ccc;
  font-size: 14px;
}

@media (max-width: 1100px) {
  .job-profile {
    flex-direction: column;
  }
  .left-panel {
    width: 100%;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 8px;
    padding: 12px;
  }
  .charts-grid {
    grid-template-columns: 1fr;
  }
  .stats-row {
    flex-direction: column;
  }
}
</style>
