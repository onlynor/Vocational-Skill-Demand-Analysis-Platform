<template>
  <div class="dashboard">
    <h2>职业画像分析</h2>

    <div class="charts-wrapper">
      <div class="chart-box">
        <h3>技能需求排行 Top 20</h3>
        <v-chart class="chart" :option="skillRankOption" autoresize />
      </div>
      <div class="chart-box">
        <h3>技能-薪资关系（散点图）</h3>
        <v-chart class="chart" :option="skillSalaryOption" autoresize />
      </div>
      <div class="chart-box">
        <h3>城市需求量</h3>
        <v-chart class="chart" :option="cityOption" autoresize />
      </div>
      <div class="chart-box">
        <h3>学历要求分布</h3>
        <v-chart class="chart" :option="educationOption" autoresize />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { BarChart, ScatterChart, PieChart } from 'echarts/charts'
import { TitleComponent, TooltipComponent, GridComponent, LegendComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import api from '@/api'

use([BarChart, ScatterChart, PieChart, TitleComponent, TooltipComponent, GridComponent, LegendComponent, CanvasRenderer])

const skillRank = ref([])
const skillSalary = ref([])
const cities = ref([])
const education = ref([])

const skillRankOption = computed(() => ({
  tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
  xAxis: { type: 'value' },
  yAxis: {
    type: 'category',
    data: skillRank.value.map(s => s.skill).reverse(),
    axisLabel: { fontSize: 11 },
  },
  series: [{
    type: 'bar',
    data: skillRank.value.map(s => s.frequency).reverse(),
    itemStyle: { color: '#4fc08d' },
  }],
  grid: { left: '20%', right: '5%', top: 10, bottom: 20 },
}))

const skillSalaryOption = computed(() => ({
  tooltip: {
    trigger: 'item',
    formatter: (p) => `${p.name}<br/>平均薪资: ¥${p.value[0]}<br/>岗位数: ${p.value[1]}`,
  },
  xAxis: { name: '平均月薪 (元)', nameLocation: 'center', nameGap: 28 },
  yAxis: {
    name: '岗位数量',
    nameLocation: 'center',
    nameGap: 36,
    nameTextStyle: { fontSize: 12 },
    nameRotate: 90,
  },
  series: [{
    type: 'scatter',
    data: skillSalary.value.map(s => [s.avg_salary, s.job_count, s.skill]),
    symbolSize: (val) => Math.max(Math.sqrt(val[1]) * 3, 8),
    label: {
      show: true,
      formatter: (p) => p.data[2],
      position: 'top',
      fontSize: 10,
      distance: 6,
    },
    labelLayout: { moveOverlap: 'shiftY' },
  }],
  grid: { left: '15%', right: '18%', top: '15%', bottom: '15%' },
}))

const cityOption = computed(() => ({
  tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
  xAxis: {
    type: 'category',
    data: cities.value.map(c => c.city),
    axisLabel: { rotate: 30, fontSize: 11 },
  },
  yAxis: { type: 'value' },
  series: [{
    type: 'bar',
    data: cities.value.map(c => c.job_count),
    itemStyle: { color: '#409EFF' },
  }],
  grid: { left: '10%', right: '5%', top: 15, bottom: '25%' },
}))

const educationOption = computed(() => ({
  tooltip: { trigger: 'item' },
  legend: { orient: 'vertical', right: '5%', top: 'center', textStyle: { fontSize: 12 } },
  series: [{
    type: 'pie',
    radius: ['0%', '65%'],
    center: ['42%', '50%'],
    data: education.value.map(e => ({ name: e.education, value: e.job_count })),
    label: {
      formatter: '{b}',
      position: 'outside',
      fontSize: 11,
    },
    labelLine: { length: 15, length2: 20 },
    emphasis: { label: { fontSize: 15 } },
  }],
}))

onMounted(async () => {
  try {
    const [sr, ss, ct, ed] = await Promise.all([
      api.get('/profile/skills/rank'),
      api.get('/profile/skills/salary'),
      api.get('/profile/cities'),
      api.get('/profile/education'),
    ])
    skillRank.value = sr.data
    skillSalary.value = ss.data
    cities.value = ct.data
    education.value = ed.data
  } catch (e) {
    console.error(e)
  }
})
</script>

<style scoped>
.dashboard {
  padding: 20px 24px;
  height: 100%;
}
h2 {
  margin-bottom: 16px;
  color: #1a1a2e;
  font-size: 20px;
}
.charts-wrapper {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: 1fr 1fr;
  gap: 16px;
  height: calc(100vh - 110px);
  min-height: 500px;
}
.chart-box {
  background: #fff;
  border-radius: 8px;
  padding: 14px 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  display: flex;
  flex-direction: column;
  min-height: 0;
}
.chart-box h3 {
  font-size: 14px;
  color: #555;
  margin-bottom: 8px;
  flex-shrink: 0;
}
.chart {
  flex: 1;
  min-height: 0;
}

/* 小屏幕单列布局 */
@media (max-width: 1100px) {
  .charts-wrapper {
    grid-template-columns: 1fr;
    grid-template-rows: repeat(4, 1fr);
    height: calc(200vh - 220px);
  }
}
</style>
