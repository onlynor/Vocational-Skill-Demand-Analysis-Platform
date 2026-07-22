<script setup>
import { ref, computed } from 'vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { BarChart, PieChart } from 'echarts/charts'
import { TitleComponent, TooltipComponent, GridComponent, LegendComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import api from '@/api'
import StatCard from '@/components/dashboard/StatCard.vue'
import ChartCard from '@/components/dashboard/ChartCard.vue'
import EmptyState from '@/components/common/EmptyState.vue'
import Loading from '@/components/common/Loading.vue'

use([BarChart, PieChart, TitleComponent, TooltipComponent, GridComponent, LegendComponent, CanvasRenderer])

const categories = ref([])
const activeCategory = ref('')
const activeJob = ref('')
const profile = ref(null)
const loading = ref(false)
const noDataMsg = ref('')
const initError = ref('')

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
    noDataMsg.value = '加载失败，请稍后重试'
    console.error(e)
  } finally {
    loading.value = false
  }
}

function formatSalary(val) {
  if (val == null || val === '') return '--'
  if (val >= 1000) return (val / 1000).toFixed(0) + 'K'
  return String(val)
}

/* ---- ECharts options (px grids to avoid overlap) ---- */
const skillOption = computed(() => {
  if (!profile.value) return {}
  const data = profile.value.top_skills
  const names = data.map(s => s.name).reverse()
  return {
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: 20, right: 24, top: 12, bottom: 12, containLabel: true },
    xAxis: {
      type: 'value',
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { lineStyle: { color: '#eef0f3' } },
    },
    yAxis: {
      type: 'category',
      data: names,
      axisLine: { lineStyle: { color: '#e5e7eb' } },
      axisTick: { show: false },
      axisLabel: { fontSize: 12, color: '#4b5563', width: 120, overflow: 'truncate' },
    },
    series: [{
      type: 'bar',
      data: data.map(s => s.value).reverse(),
      barMaxWidth: 20,
      itemStyle: { color: '#4fc08d', borderRadius: [0, 4, 4, 0] },
      label: { show: true, position: 'right', fontSize: 12, color: '#6b7280' },
    }],
  }
})

const cityOption = computed(() => {
  if (!profile.value) return {}
  const data = profile.value.cities
  return {
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: 20, right: 20, top: 16, bottom: 56, containLabel: true },
    xAxis: {
      type: 'category',
      data: data.map(c => c.name),
      axisLine: { lineStyle: { color: '#e5e7eb' } },
      axisTick: { show: false },
      axisLabel: {
        rotate: 32,
        fontSize: 12,
        color: '#4b5563',
        hideOverlap: true,
      },
    },
    yAxis: {
      type: 'value',
      minInterval: 1,
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { lineStyle: { color: '#eef0f3' } },
    },
    series: [{
      type: 'bar',
      data: data.map(c => c.value),
      barMaxWidth: 28,
      itemStyle: { color: '#2f7ad4', borderRadius: [4, 4, 0, 0] },
    }],
  }
})

const eduOption = computed(() => {
  if (!profile.value) return {}
  const data = profile.value.education
  return {
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    legend: {
      orient: 'vertical',
      right: 24,
      top: 'center',
      icon: 'circle',
      textStyle: { fontSize: 12, color: '#4b5563' },
      itemHeight: 8,
    },
    color: ['#4fc08d', '#2f7ad4', '#e6a23c', '#f56c6c', '#909399', '#9b59b6'],
    series: [{
      type: 'pie',
      radius: ['52%', '70%'],
      center: ['38%', '50%'],
      avoidLabelOverlap: true,
      itemStyle: { borderColor: '#fff', borderWidth: 2 },
      label: { show: true, formatter: '{d}%', fontSize: 12, color: '#4b5563' },
      labelLine: { length: 10, length2: 12 },
      data: data.map(e => ({ name: e.name, value: e.value })),
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
    initError.value = '行业数据加载失败，请刷新重试'
    console.error(e)
  }
}

loadCategories()
</script>

<template>
  <div class="job-profile">
    <aside class="left-panel">
      <h2 class="panel-title">职业画像</h2>
      <p class="panel-hint">选择行业 → 选择职位</p>

      <ul class="category-list">
        <li
          v-for="cat in categories"
          :key="cat.category"
          class="category-item"
          :class="{ active: cat.category === activeCategory }"
          @click="selectCategory(cat.category)"
        >
          <span class="cat-name">{{ cat.category }}</span>
          <span class="cat-badge">{{ dataCount(cat) }}</span>
        </li>
      </ul>
      <p v-if="initError" class="init-error">{{ initError }}</p>

      <div v-if="activeJobs.length" class="job-list">
        <h4 class="list-title">{{ activeCategory }} · 职位</h4>
        <ul>
          <li
            v-for="job in activeJobs"
            :key="job.name"
            class="job-item"
            :class="{ active: job.name === activeJob, 'no-data': job.count === 0 }"
            @click="selectJob(job)"
          >
            <span class="job-name">{{ job.name }}</span>
            <span class="job-count">{{ job.count }}条</span>
          </li>
        </ul>
      </div>
    </aside>

    <section class="right-panel">
      <EmptyState
        v-if="!activeJob && !noDataMsg && !loading"
        message="请从左侧选择行业和职位，查看职业画像"
      />
      <EmptyState v-else-if="noDataMsg && !loading" :message="noDataMsg" />
      <Loading v-else-if="loading" message="正在生成职业画像..." />

      <template v-else-if="profile">
        <header class="profile-header">
          <h3>{{ profile.title }}</h3>
          <p class="profile-desc">基于招聘数据的岗位多维度画像分析</p>
        </header>

        <div class="stats-row">
          <StatCard label="岗位数量" :value="profile.job_count" accent="primary" />
          <StatCard label="平均月薪" :value="'¥' + formatSalary(profile.avg_salary)" accent="orange" />
          <StatCard
            label="薪资范围"
            :value="'¥' + formatSalary(profile.salary_min) + ' - ¥' + formatSalary(profile.salary_max)"
            accent="blue"
          >
            薪资区间参考
          </StatCard>
        </div>

        <div class="charts-grid">
          <ChartCard title="技能要求排行" subtitle="该岗位出现频次最高的技能">
            <v-chart v-if="profile.top_skills.length" class="echarts" :option="skillOption" autoresize />
            <EmptyState v-else />
          </ChartCard>

          <ChartCard title="城市分布" subtitle="按岗位数量统计城市需求">
            <v-chart v-if="profile.cities.length" class="echarts" :option="cityOption" autoresize />
            <EmptyState v-else />
          </ChartCard>

          <ChartCard title="学历要求" subtitle="学历占比分布">
            <v-chart v-if="profile.education.length" class="echarts" :option="eduOption" autoresize />
            <EmptyState v-else />
          </ChartCard>

          <ChartCard title="招聘公司" subtitle="近期在招企业">
            <div class="company-list">
              <span v-for="c in profile.companies" :key="c" class="company-tag">{{ c }}</span>
              <EmptyState v-if="!profile.companies.length" />
            </div>
          </ChartCard>
        </div>
      </template>
    </section>
  </div>
</template>

<style scoped>
.job-profile {
  display: flex;
  gap: 24px;
  align-items: flex-start;
}

/* ---- left selection panel ---- */
.left-panel {
  width: 240px;
  flex-shrink: 0;
  background: var(--surface-color);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  padding: 20px 16px;
  position: sticky;
  top: calc(var(--header-height) + 24px);
  max-height: calc(100vh - var(--header-height) - 48px);
  overflow-y: auto;
}
.panel-title {
  font-size: var(--font-size-lg);
  color: var(--text-color);
  font-weight: 600;
}
.panel-hint {
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
  margin-top: 2px;
  margin-bottom: 16px;
}
.init-error {
  font-size: var(--font-size-sm);
  color: #e74c3c;
  padding: 8px 0;
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
  border-radius: var(--radius-md);
  cursor: pointer;
  font-size: var(--font-size-base);
  color: var(--text-color);
  transition: background var(--transition);
}
.category-item:hover {
  background: var(--primary-soft);
}
.category-item.active {
  background: var(--primary-soft);
  color: var(--primary-hover);
  font-weight: 600;
}
.cat-badge {
  background: var(--surface-soft);
  color: var(--text-tertiary);
  padding: 1px 8px;
  border-radius: var(--radius-full);
  font-size: var(--font-size-xs);
}
.category-item.active .cat-badge {
  background: var(--primary-color);
  color: #fff;
}

.job-list {
  margin-top: 20px;
  border-top: 1px solid var(--border-color);
  padding-top: 14px;
}
.list-title {
  font-size: var(--font-size-sm);
  color: var(--text-secondary);
  margin-bottom: 8px;
}
.job-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-size: var(--font-size-sm);
  transition: background var(--transition), color var(--transition);
}
.job-item:hover {
  background: var(--accent-blue-soft);
}
.job-item.active {
  background: var(--primary-color);
  color: #fff;
  font-weight: 600;
}
.job-item.active .job-count {
  color: rgba(255, 255, 255, 0.85);
}
.job-item.no-data {
  color: var(--text-tertiary);
  cursor: default;
}
.job-item.no-data:hover {
  background: transparent;
}
.job-count {
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
}

/* ---- right profile ---- */
.right-panel {
  flex: 1;
  min-width: 0;
  min-height: calc(100vh - var(--header-height) - 48px);
  background: var(--surface-color);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  padding: 24px 28px 32px;
  box-sizing: border-box;
}
.right-panel > :deep(.empty-state) {
  min-height: 320px;
}

.profile-header {
  margin-bottom: 20px;
}
.profile-header h3 {
  font-size: var(--font-size-xl);
  color: var(--text-color);
  font-weight: 700;
}
.profile-desc {
  margin-top: 4px;
  font-size: var(--font-size-sm);
  color: var(--text-tertiary);
}

.stats-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.charts-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}
.echarts {
  width: 100%;
  height: 320px;
}

.company-list {
  display: flex;
  flex-wrap: wrap;
  align-content: flex-start;
  gap: 10px;
  height: 320px;
  overflow-y: auto;
  padding: 2px;
}
.company-tag {
  background: var(--accent-blue-soft);
  color: var(--accent-blue);
  padding: 5px 12px;
  border-radius: var(--radius-full);
  font-size: var(--font-size-sm);
  white-space: nowrap;
}

@media (max-width: 1280px) {
  .stats-row {
    grid-template-columns: 1fr;
  }
}
@media (max-width: 1024px) {
  .charts-grid {
    grid-template-columns: 1fr;
  }
}
@media (max-width: 768px) {
  .job-profile {
    flex-direction: column;
  }
  .left-panel {
    position: static;
    width: 100%;
    max-height: none;
  }
}
</style>