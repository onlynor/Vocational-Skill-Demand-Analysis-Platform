<script setup>
import { ref, computed, onUnmounted } from 'vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { BarChart, PieChart } from 'echarts/charts'
import { TitleComponent, TooltipComponent, GridComponent, LegendComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import api from '@/api'
import { useThemeStore } from '@/stores/theme'
import StatCard from '@/components/dashboard/StatCard.vue'
import ChartCard from '@/components/dashboard/ChartCard.vue'
import EmptyState from '@/components/common/EmptyState.vue'
import Loading from '@/components/common/Loading.vue'

use([BarChart, PieChart, TitleComponent, TooltipComponent, GridComponent, LegendComponent, CanvasRenderer])

// ECharts renders to canvas, so it can't read CSS variables — these colors
// have to be resolved in JS and swapped explicitly when the theme changes,
// otherwise the charts stay light-themed (unreadable) after switching to dark.
const themeStore = useThemeStore()
const isDark = computed(() => themeStore.theme === 'dark')
const axisTextColor = computed(() => (isDark.value ? '#a1a1a6' : '#4b5563'))
const axisLineColor = computed(() => (isDark.value ? 'rgba(255,255,255,0.16)' : '#e5e7eb'))
const splitLineColor = computed(() => (isDark.value ? 'rgba(255,255,255,0.08)' : '#eef0f3'))
const chartBorderColor = computed(() => (isDark.value ? '#1c1c1e' : '#ffffff'))

const categories = ref([])
const activeCategory = ref('')
const activeJob = ref('')
const profile = ref(null)
const loading = ref(false)
const noDataMsg = ref('')
const initError = ref('')

/* ---- draggable left/right split ---- */
const PANEL_WIDTH_KEY = 'jobProfileLeftPanelWidth'
const PANEL_MIN_WIDTH = 160
const PANEL_MAX_WIDTH = 400
const leftPanelWidth = ref(
  Math.min(PANEL_MAX_WIDTH, Math.max(PANEL_MIN_WIDTH, parseInt(localStorage.getItem(PANEL_WIDTH_KEY)) || 200))
)
let dragging = false
let dragStartX = 0
let dragStartWidth = 0

function startDrag(e) {
  // Without this, the browser's native text-selection/drag-start competes
  // with the custom drag and makes it feel broken or completely inert.
  e.preventDefault()
  dragging = true
  dragStartX = e.clientX
  dragStartWidth = leftPanelWidth.value
  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', stopDrag)
  document.body.style.cursor = 'col-resize'
  document.body.style.userSelect = 'none'
}

function onDrag(e) {
  if (!dragging) return
  const next = dragStartWidth + (e.clientX - dragStartX)
  leftPanelWidth.value = Math.min(PANEL_MAX_WIDTH, Math.max(PANEL_MIN_WIDTH, next))
}

function stopDrag() {
  if (!dragging) return
  dragging = false
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
  document.body.style.cursor = ''
  document.body.style.userSelect = ''
  localStorage.setItem(PANEL_WIDTH_KEY, String(leftPanelWidth.value))
}

onUnmounted(() => {
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
})

function dataCount(cat) {
  return cat.jobs.filter(j => j.count > 0).length
}

/* Accordion tree: clicking a category expands it in place (jobs render
   directly beneath that node) and collapses whichever was open — instead of
   a second job list appended after the full category list, which forced
   scrolling past every other industry to reach the jobs. Clicking the
   already-open category collapses it. */
function toggleCategory(cat) {
  activeCategory.value = activeCategory.value === cat ? '' : cat
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

/* ---- ECharts options ----
   All grids use containLabel so ECharts measures actual rendered label size
   and reserves space accordingly, instead of a fixed px guess that breaks
   whenever the card width or font changes (this was the source of clipped/
   overlapping labels — "distorted" charts). */
const skillOption = computed(() => {
  if (!profile.value) return {}
  const data = profile.value.top_skills
  const names = data.map(s => s.name).reverse()
  return {
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: 16, right: 48, top: 12, bottom: 12, containLabel: true },
    xAxis: {
      type: 'value',
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { lineStyle: { color: splitLineColor.value } },
    },
    yAxis: {
      type: 'category',
      data: names,
      axisLine: { lineStyle: { color: axisLineColor.value } },
      axisTick: { show: false },
      axisLabel: { fontSize: 12, color: axisTextColor.value, interval: 0 },
    },
    series: [{
      type: 'bar',
      data: data.map(s => s.value).reverse(),
      barMaxWidth: 20,
      itemStyle: {
        borderRadius: [0, 4, 4, 0],
        color: {
          type: 'linear', x: 0, y: 0, x2: 1, y2: 0,
          colorStops: [{ offset: 0, color: '#8de3c0' }, { offset: 1, color: '#2f9ed4' }],
        },
      },
      label: { show: true, position: 'right', fontSize: 12, fontWeight: 600, color: axisTextColor.value },
      animationDuration: 700,
      animationEasing: 'cubicOut',
    }],
  }
})

const cityOption = computed(() => {
  if (!profile.value) return {}
  const data = profile.value.cities
  return {
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: 8, right: 16, top: 16, bottom: 8, containLabel: true },
    xAxis: {
      type: 'category',
      data: data.map(c => c.name),
      axisLine: { lineStyle: { color: axisLineColor.value } },
      axisTick: { show: false },
      axisLabel: {
        rotate: 32,
        fontSize: 12,
        color: axisTextColor.value,
        hideOverlap: true,
      },
    },
    yAxis: {
      type: 'value',
      minInterval: 1,
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { lineStyle: { color: splitLineColor.value } },
    },
    series: [{
      type: 'bar',
      data: data.map(c => c.value),
      barMaxWidth: 28,
      itemStyle: {
        borderRadius: [4, 4, 0, 0],
        color: {
          type: 'linear', x: 0, y: 1, x2: 0, y2: 0,
          colorStops: [{ offset: 0, color: '#63a4ff' }, { offset: 1, color: '#2f5ad4' }],
        },
      },
      emphasis: { itemStyle: { color: '#2f5ad4' } },
      animationDuration: 700,
      animationEasing: 'cubicOut',
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
      textStyle: { fontSize: 12, color: axisTextColor.value },
      itemHeight: 8,
    },
    color: ['#4fc08d', '#2f5ad4', '#ffb457', '#f56c6c', '#8b5cf6', '#22c1c3'],
    series: [{
      type: 'pie',
      radius: ['52%', '72%'],
      center: ['38%', '50%'],
      avoidLabelOverlap: true,
      itemStyle: {
        borderColor: chartBorderColor.value,
        borderWidth: 3,
        shadowBlur: 12,
        shadowColor: 'rgba(0, 0, 0, 0.08)',
      },
      emphasis: {
        scaleSize: 6,
        itemStyle: { shadowBlur: 18, shadowColor: 'rgba(0, 0, 0, 0.16)' },
      },
      label: { show: true, formatter: '{d}%', fontSize: 12, fontWeight: 600, color: axisTextColor.value },
      labelLine: { length: 10, length2: 12 },
      animationDuration: 700,
      animationEasing: 'cubicOut',
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
    <aside class="left-panel" :style="{ '--left-panel-width': leftPanelWidth + 'px' }">
      <h2 class="panel-title">职业画像</h2>
      <p class="panel-hint">选择行业 → 选择职位</p>

      <ul class="category-tree">
        <li v-for="cat in categories" :key="cat.category" class="category-node">
          <div
            class="category-item"
            :class="{ active: cat.category === activeCategory }"
            @click="toggleCategory(cat.category)"
          >
            <svg
              class="chevron"
              :class="{ open: cat.category === activeCategory }"
              viewBox="0 0 24 24" width="14" height="14" aria-hidden="true"
            >
              <path d="M9 6l6 6-6 6" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
            <span class="cat-name">{{ cat.category }}</span>
            <span class="cat-badge">{{ dataCount(cat) }}</span>
          </div>

          <div class="job-collapse" :class="{ open: cat.category === activeCategory }">
            <ul class="job-sublist">
              <li
                v-for="job in cat.jobs"
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
        </li>
      </ul>
      <p v-if="initError" class="init-error">{{ initError }}</p>
    </aside>

    <div
      class="resizer"
      role="separator"
      aria-orientation="vertical"
      aria-label="调整左右面板宽度"
      @mousedown="startDrag"
    ></div>

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

        <div class="stats-row stagger-in" :key="'stats-' + profile.title">
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

        <div class="charts-grid stagger-in" :key="'charts-' + profile.title">
          <ChartCard class="glow-primary" title="技能要求排行" subtitle="该岗位出现频次最高的技能">
            <v-chart v-if="profile.top_skills.length" class="echarts" :option="skillOption" autoresize />
            <EmptyState v-else />
          </ChartCard>

          <ChartCard class="glow-blue" title="城市分布" subtitle="按岗位数量统计城市需求">
            <v-chart v-if="profile.cities.length" class="echarts" :option="cityOption" autoresize />
            <EmptyState v-else />
          </ChartCard>

          <ChartCard class="glow-orange" title="学历要求" subtitle="学历占比分布">
            <v-chart v-if="profile.education.length" class="echarts" :option="eduOption" autoresize />
            <EmptyState v-else />
          </ChartCard>

          <ChartCard class="glow-purple" title="招聘公司" subtitle="近期在招企业">
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
  align-items: flex-start;
}

/* ---- left selection panel ---- */
.left-panel {
  width: var(--left-panel-width, 200px);
  flex-shrink: 0;
  background: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  padding: var(--space-5) var(--space-4);
  position: sticky;
  top: calc(var(--header-height) + 24px);
  max-height: calc(100vh - var(--header-height) - 48px);
  overflow-y: auto;
  transition: background-color var(--transition), border-color var(--transition);
}

/* ---- drag handle between the tree panel and the chart area ----
   Occupies the same 24px the old flex `gap` used, so default spacing is
   unchanged — it's just interactive now. */
.resizer {
  width: 24px;
  flex-shrink: 0;
  align-self: stretch;
  cursor: col-resize;
  position: relative;
  user-select: none;
  touch-action: none;
}
.resizer::after {
  content: '';
  position: absolute;
  left: 50%;
  top: 8px;
  bottom: 8px;
  width: 3px;
  transform: translateX(-50%);
  background: var(--border-color);
  border-radius: var(--radius-full);
  transition: background var(--transition), width var(--transition-fast);
}
.resizer:hover::after,
.resizer:active::after {
  background: var(--primary-color);
  width: 4px;
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

.category-tree {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.category-node {
  display: flex;
  flex-direction: column;
}
.category-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 10px 10px;
  border-radius: var(--radius-md);
  cursor: pointer;
  font-size: var(--font-size-base);
  color: var(--text-color);
  transition: background var(--transition), color var(--transition);
}
.category-item:hover {
  background: var(--primary-soft);
}
.category-item.active {
  color: var(--primary-hover);
  font-weight: 600;
}
.chevron {
  flex-shrink: 0;
  color: var(--text-tertiary);
  transition: transform var(--transition-spring), color var(--transition);
}
.chevron.open {
  transform: rotate(90deg);
  color: var(--primary-color);
}
.cat-name {
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.cat-badge {
  background: var(--surface-soft);
  color: var(--text-tertiary);
  padding: 1px 8px;
  border-radius: var(--radius-full);
  font-size: var(--font-size-xs);
  flex-shrink: 0;
}
.category-item.active .cat-badge {
  background: var(--primary-color);
  color: #fff;
}

/* Grid-rows collapse trick: animates open/close without measuring content
   height in JS, and jobs render directly under their own category instead
   of in a second list appended after all categories. */
.job-collapse {
  display: grid;
  grid-template-rows: 0fr;
  transition: grid-template-rows var(--transition-spring);
}
.job-collapse.open {
  grid-template-rows: 1fr;
}
.job-sublist {
  overflow: hidden;
  min-height: 0;
  display: flex;
  flex-direction: column;
  gap: 1px;
  margin: 2px 0 6px;
  padding-left: 18px;
  border-left: 1px solid var(--border-color);
  margin-left: 16px;
}
.job-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 7px 10px;
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-size: var(--font-size-sm);
  color: var(--text-secondary);
  transition: background var(--transition), color var(--transition);
}
.job-item:hover {
  background: var(--accent-blue-soft);
  color: var(--text-color);
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
  color: var(--text-tertiary);
}
.job-count {
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
  flex-shrink: 0;
  margin-left: 8px;
}

/* ---- right profile ---- */
.right-panel {
  flex: 1;
  min-width: 0;
  min-height: calc(100vh - var(--header-height) - 48px);
  background: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  padding: var(--space-6) 28px var(--space-8);
  box-sizing: border-box;
  transition: background-color var(--transition), border-color var(--transition);
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
  gap: var(--space-6);
}
/* Per-card accent glow on hover — a small spotlight instead of the same
   generic shadow on every card. Doubled-up class selector beats ChartCard's
   own scoped :hover rule on specificity. */
.chart-card.glow-primary:hover { box-shadow: var(--shadow-lg), var(--glow-primary); }
.chart-card.glow-blue:hover { box-shadow: var(--shadow-lg), var(--glow-blue); }
.chart-card.glow-orange:hover { box-shadow: var(--shadow-lg), var(--glow-orange); }
.chart-card.glow-purple:hover { box-shadow: var(--shadow-lg), 0 8px 28px rgba(139, 92, 246, 0.28); }

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
  background: var(--accent-purple-soft);
  color: var(--accent-purple);
  padding: 5px 12px;
  border-radius: var(--radius-full);
  font-size: var(--font-size-sm);
  white-space: nowrap;
  transition: transform var(--transition-fast);
}
.company-tag:hover {
  transform: translateY(-2px);
}

@media (max-width: 1280px) {
  .stats-row {
    grid-template-columns: 1fr;
  }
}
@media (max-width: 1400px) {
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
  .resizer {
    display: none;
  }
}
</style>