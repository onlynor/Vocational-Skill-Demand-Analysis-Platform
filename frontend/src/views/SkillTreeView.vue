<script setup>
import { ref, computed } from 'vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { TreeChart } from 'echarts/charts'
import { TooltipComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import api from '@/api'
import { useThemeStore } from '@/stores/theme'
import EmptyState from '@/components/common/EmptyState.vue'
import Loading from '@/components/common/Loading.vue'

use([TreeChart, TooltipComponent, CanvasRenderer])

// ECharts renders to canvas and can't read CSS variables — same pattern as
// JobProfileView.vue's chart theming, resolved here off the theme store.
// Four depths get four distinct looks so "职位方向" reads as a clearly
// different tier from the skill nodes underneath it:
//   0 industry root (green) · 1 职位方向 (bold blue) · 2 核心技能/具体技术栈
//   group headers (small, muted text, orange/purple dot) · 3 skill leaves
//   (orange/purple dot, full-contrast text).
// Node dots carry the color coding; label TEXT stays at high-contrast
// label/muted colors rather than being tinted, since tinted small text was
// itself a major source of the poor dark-mode readability.
const themeStore = useThemeStore()
const isDark = computed(() => themeStore.theme === 'dark')
const labelColor = computed(() => (isDark.value ? '#f5f5f7' : '#374151'))
const mutedLabelColor = computed(() => (isDark.value ? '#c7c7cc' : '#6b7280'))
const lineColor = computed(() => (isDark.value ? 'rgba(255,255,255,0.14)' : '#c7cdd6'))
const nodeBorderColor = computed(() => (isDark.value ? '#1c1c1e' : '#ffffff'))
// Every label gets an opaque backdrop chip behind its text — regardless of
// exactly where a connector line runs, it can never visually cross a letter
// if the label paints over it first. Matches the card surface tone so it
// still reads as "part of the card", not a floating box.
const labelBg = computed(() => (isDark.value ? 'rgba(28,28,30,0.94)' : 'rgba(255,255,255,0.94)'))
// ECharts can't consume var(--accent-blue) etc. directly (canvas, not CSS),
// so these are the same literal light/dark pairs as --accent-blue/orange/
// purple in variables.css — kept in sync manually, and the legend below
// uses the real CSS vars so it can't drift out of sync visually.
const rootColor = '#4fc08d'
const directionColor = computed(() => (isDark.value ? '#8bbcff' : '#2f7ad4'))
const coreSkillColor = computed(() => (isDark.value ? '#ffb454' : '#e6a23c'))
const stackSkillColor = computed(() => (isDark.value ? '#b199fb' : '#8b5cf6'))

// NOTE: the tree series has NO `levels` option (that's treemap/sunburst) —
// it silently ignores it, which is why an earlier attempt at per-depth
// styling had no effect at all and labels fell back to ECharts' default
// black text. Per-node `label`/`itemStyle`/`emphasis` on the data items
// (TreeSeriesNodeItemOption) is the supported way to style by depth, so all
// of it is applied while building the tree in treeRoot below.
function labelStyle(extra) {
  return {
    backgroundColor: labelBg.value,
    padding: [3, 7],
    borderRadius: 5,
    ...extra,
  }
}

// Hover/selected state: keep each level's own color rather than falling
// back to ECharts' default emphasis look (which brightens toward white and,
// on a dark near-white label right next to it, the two blend together).
// A colored glow (bigger border + soft shadow in the same hue) stays
// legible against the label instead.
function emphasisStyle(color) {
  return { itemStyle: { borderWidth: 3, shadowBlur: 10, shadowColor: color } }
}

const industry = ref('')
const supported = ref(true)
const directions = ref([])
const industries = ref([])
const loading = ref(true)
const error = ref('')

async function loadIndustries() {
  try {
    const { data } = await api.get('/profile/jobs/tree')
    industries.value = data.map(c => c.category)
  } catch (e) {
    console.error(e)
  }
}

async function loadSkillTree(ind) {
  loading.value = true
  error.value = ''
  try {
    const { data } = await api.get('/profile/skills/tree', { params: { industry: ind } })
    industry.value = data.industry
    supported.value = data.supported
    directions.value = data.directions
  } catch (e) {
    error.value = '技能图谱加载失败，请刷新重试'
    console.error(e)
  } finally {
    loading.value = false
  }
}

function selectIndustry(ind) {
  if (ind === industry.value) return
  loadSkillTree(ind)
}

function nodeSize(value, baseline = 16) {
  if (!value) return baseline
  return Math.min(46, Math.max(18, 12 + Math.sqrt(value) * 1.1))
}

// Labels on nodes that HAVE children must sit on the node's left (backward)
// side: in LR orient the connector to their children leaves the node
// rightward, so a right-side label would be drawn straight over that line.
// Leaves have no outgoing line, so theirs go right.
const LABEL_LEFT = { position: 'left', align: 'right', verticalAlign: 'middle', distance: 12 }
const LABEL_RIGHT = { position: 'right', align: 'left', verticalAlign: 'middle', distance: 12 }

// Skill text stays at full-contrast label color rather than being tinted
// core-orange / stack-purple — the node dot already carries that color
// coding, and tinted small text was a big part of what read as low-contrast.
function skillLeaf(s, color) {
  return {
    name: `${s.name} ${s.value}`,
    value: s.value,
    itemStyle: { color, borderColor: nodeBorderColor.value, borderWidth: 2 },
    emphasis: emphasisStyle(color),
    label: labelStyle({ ...LABEL_RIGHT, fontSize: 12, color: labelColor.value }),
  }
}

const treeRoot = computed(() => {
  if (!directions.value.length) return null
  return {
    name: industry.value,
    symbolSize: 24,
    itemStyle: { color: rootColor, borderColor: nodeBorderColor.value, borderWidth: 2 },
    emphasis: emphasisStyle(rootColor),
    label: labelStyle({ ...LABEL_LEFT, fontSize: 15, fontWeight: 700, color: labelColor.value }),
    children: directions.value.map(d => {
      const groups = []
      if (d.core_skills.length) {
        groups.push({
          name: '核心技能',
          symbolSize: 13,
          itemStyle: { color: coreSkillColor.value, borderColor: nodeBorderColor.value, borderWidth: 2 },
          emphasis: emphasisStyle(coreSkillColor.value),
          label: labelStyle({ ...LABEL_LEFT, fontSize: 12, fontWeight: 600, color: mutedLabelColor.value }),
          children: d.core_skills.map(s => skillLeaf(s, coreSkillColor.value)),
        })
      }
      if (d.extended_skills.length) {
        groups.push({
          name: '具体技术栈',
          symbolSize: 13,
          itemStyle: { color: stackSkillColor.value, borderColor: nodeBorderColor.value, borderWidth: 2 },
          emphasis: emphasisStyle(stackSkillColor.value),
          label: labelStyle({ ...LABEL_LEFT, fontSize: 12, fontWeight: 600, color: mutedLabelColor.value }),
          children: d.extended_skills.map(s => skillLeaf(s, stackSkillColor.value)),
        })
      }
      return {
        name: `${d.name} · ${d.job_count}条`,
        value: d.job_count,
        itemStyle: { color: directionColor.value, borderColor: nodeBorderColor.value, borderWidth: 2 },
        emphasis: emphasisStyle(directionColor.value),
        label: labelStyle({ ...LABEL_LEFT, fontSize: 14, fontWeight: 700, color: directionColor.value }),
        children: groups,
      }
    }),
  }
})

// LR (left-to-right) keeps the (now just 9) direction branches stacked
// vertically, reading better in a typical browser width than a top-down
// layout that would spread them out sideways instead.
const treeOption = computed(() => {
  if (!treeRoot.value) return {}
  return {
    // ECharts' default tooltip ignores the page theme entirely (fixed
    // colors regardless of dark/light) — without this it was the one
    // remaining unthemed text left in the chart.
    tooltip: {
      trigger: 'item',
      triggerOn: 'mousemove',
      backgroundColor: isDark.value ? 'rgba(44,44,46,0.96)' : 'rgba(255,255,255,0.96)',
      borderColor: lineColor.value,
      borderWidth: 1,
      textStyle: { color: labelColor.value, fontSize: 12 },
      extraCssText: 'box-shadow: 0 4px 16px rgba(0,0,0,0.12);',
    },
    series: [{
      type: 'tree',
      data: [treeRoot.value],
      orient: 'LR',
      left: '14%',
      right: '20%',
      top: '4%',
      bottom: '4%',
      initialTreeDepth: 1,
      expandAndCollapse: true,
      roam: 'move',
      symbolSize: nodeSize,
      lineStyle: { color: lineColor.value, curveness: 0.5, width: 1.5 },
      // Series-level label default. This matters even though every node sets
      // its own label: without it, anything not covered falls back to
      // ECharts' built-in black text, which is invisible in dark mode.
      label: labelStyle({ ...LABEL_RIGHT, fontSize: 12, color: labelColor.value }),
      leaves: {
        label: labelStyle({ ...LABEL_RIGHT, fontSize: 12, color: labelColor.value }),
      },
      // `focus: 'descendant'` dims unrelated nodes on hover; keep the dim
      // gentle so the faded labels stay readable rather than vanishing.
      emphasis: { focus: 'descendant' },
      blur: { itemStyle: { opacity: 0.45 }, label: { opacity: 0.45 } },
      animationDuration: 500,
      animationDurationUpdate: 600,
    }],
  }
})

// 9 direction branches (down from the previous 32 job-title branches) still
// need enough vertical room that an expanded branch's skill leaves don't
// crowd its neighbors — scales with data instead of a fixed guess.
const chartHeight = computed(() => {
  const branchCount = treeRoot.value?.children?.length || 0
  return Math.max(560, branchCount * 60) + 'px'
})

loadIndustries()
loadSkillTree('计算机/互联网')
</script>

<template>
  <div class="skill-tree-page">
    <div v-if="industries.length" class="industry-tabs">
      <button
        v-for="ind in industries"
        :key="ind"
        class="industry-tab"
        :class="{ active: ind === industry }"
        @click="selectIndustry(ind)"
      >
        {{ ind }}
      </button>
    </div>

    <Loading v-if="loading" message="正在加载技能图谱..." />
    <p v-else-if="error" class="error">{{ error }}</p>
    <EmptyState
      v-else-if="!supported"
      :message="`「${industry}」技能图谱暂时没有加，先看看计算机/互联网吧`"
    />
    <EmptyState v-else-if="!directions.length" message="暂无技能图谱数据" />

    <section v-else class="tree-card card-surface">
      <header class="tree-header">
        <h2 class="section-title">{{ industry }} · 技能图谱</h2>
        <p class="section-desc">
          职业方向 → 核心技能 → 具体技术栈，逐层点击展开 · 数据来自真实招聘信息统计，节点越大代表出现频次/岗位数越高
        </p>
        <p class="legend">
          <span class="legend-item"><i class="dot dot-direction" />职位方向</span>
          <span class="legend-item"><i class="dot dot-core" />核心技能</span>
          <span class="legend-item"><i class="dot dot-stack" />具体技术栈</span>
        </p>
      </header>
      <div class="tree-body" :style="{ height: chartHeight }">
        <v-chart class="echarts" :option="treeOption" autoresize />
      </div>
    </section>
  </div>
</template>

<style scoped>
.skill-tree-page {
  max-width: 1280px;
}
.industry-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-2);
  margin-bottom: var(--space-5);
}
.industry-tab {
  padding: 7px 16px;
  border-radius: var(--radius-full);
  border: 1px solid var(--border-color-strong);
  background: var(--surface-color);
  color: var(--text-secondary);
  font-size: var(--font-size-sm);
  transition: border-color var(--transition), color var(--transition), background var(--transition);
}
.industry-tab:hover {
  border-color: var(--primary-color);
  color: var(--primary-hover);
}
.industry-tab.active {
  background: var(--gradient-primary);
  border-color: transparent;
  color: #fff;
  font-weight: 600;
  box-shadow: var(--glow-primary);
}
.tree-card {
  padding: var(--space-6) 28px var(--space-8);
}
.tree-header {
  margin-bottom: var(--space-4);
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
.legend {
  display: flex;
  gap: var(--space-4);
  margin-top: var(--space-3);
}
.legend-item {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: var(--font-size-xs);
  color: var(--text-secondary);
}
.dot {
  width: 9px;
  height: 9px;
  border-radius: var(--radius-full);
  display: inline-block;
}
.dot-direction { background: var(--accent-blue); }
.dot-core { background: var(--accent-orange); }
.dot-stack { background: var(--accent-purple); }
.tree-body {
  width: 100%;
  overflow-y: auto;
}
.echarts {
  width: 100%;
  height: 100%;
}
.error {
  color: #e74c3c;
  padding: 8px 0;
}
</style>
