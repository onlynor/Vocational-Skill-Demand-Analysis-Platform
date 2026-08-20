<script setup>
import { ref, nextTick, computed } from 'vue'
import { RouterLink } from 'vue-router'
import api from '@/api'
import Loading from '@/components/common/Loading.vue'
import { renderMarkdown } from '@/utils/markdown'

const SUGGESTIONS = [
  '计算机/互联网行业现在最缺什么技能？',
  'Java开发的薪资和城市分布怎么样？',
  '我想做数据分析，应该学哪些技术？',
  '前端和后端，哪个岗位机会更多？',
]

// {role: 'user'|'assistant', content, citations?}
const messages = ref([])
const input = ref('')
const sending = ref(false)
const error = ref('')
const configured = ref(true)
const checking = ref(true)
const scroller = ref(null)

const canSend = computed(() => input.value.trim() && !sending.value && configured.value)

async function checkStatus() {
  try {
    const { data } = await api.get('/advisor/status')
    configured.value = data.configured
  } catch (e) {
    console.error(e)
  } finally {
    checking.value = false
  }
}

async function scrollToBottom() {
  await nextTick()
  const el = scroller.value
  if (el) el.scrollTop = el.scrollHeight
}

async function send(text) {
  const content = (text ?? input.value).trim()
  if (!content || sending.value) return
  input.value = ''
  error.value = ''
  messages.value.push({ role: 'user', content })
  sending.value = true
  scrollToBottom()

  try {
    // Send the whole visible history so follow-up questions keep context.
    // Override the client's default 10s timeout: one answer costs at least
    // two sequential model calls (tool request -> tool result -> answer),
    // which routinely exceeds 10s and would otherwise abort in the browser
    // while the backend was still working.
    const { data } = await api.post(
      '/advisor/chat',
      { messages: messages.value.map(m => ({ role: m.role, content: m.content })) },
      { timeout: 180000 },
    )
    messages.value.push({
      role: 'assistant',
      content: data.reply,
      citations: data.citations || [],
    })
  } catch (e) {
    if (e.code === 'ECONNABORTED') {
      error.value = '等待模型回复超时。可以换个更具体的问题，或改用响应更快的模型。'
    } else {
      error.value = e.response?.data?.detail || 'AI 顾问暂时无法回答，请稍后重试'
    }
    console.error(e)
  } finally {
    sending.value = false
    scrollToBottom()
  }
}

function clearChat() {
  messages.value = []
  error.value = ''
}

checkStatus()
</script>

<template>
  <div class="advisor-page">
    <Loading v-if="checking" message="正在检查 AI 配置..." />

    <!-- Not configured: explain instead of failing on first question -->
    <section v-else-if="!configured" class="panel card-surface setup-hint">
      <h2 class="section-title">还没有配置 AI 模型</h2>
      <p class="section-desc">
        AI 职业顾问需要你自己的模型服务（任何 OpenAI 兼容接口都可以，例如 DeepSeek、通义千问、
        Moonshot，或自建的 vLLM / Ollama 网关）。请先到「个人中心」填写 API 地址、模型名称和 API Key。
      </p>
      <RouterLink to="/account" class="setup-btn">去个人中心配置</RouterLink>
    </section>

    <template v-else>
      <section class="panel card-surface chat-card">
        <header class="chat-header">
          <div>
            <h2 class="section-title">AI 职业顾问</h2>
            <p class="section-desc">
              回答基于平台约 4.7 万条真实招聘数据，涉及数字时会实时查询数据库后再作答
            </p>
          </div>
          <button v-if="messages.length" class="ghost-btn" @click="clearChat">清空对话</button>
        </header>

        <div class="chat-body" ref="scroller">
          <div v-if="!messages.length" class="empty-chat">
            <p class="empty-title">你可以这样问我：</p>
            <div class="suggestions">
              <button
                v-for="s in SUGGESTIONS"
                :key="s"
                class="suggestion"
                @click="send(s)"
              >{{ s }}</button>
            </div>
          </div>

          <div
            v-for="(m, i) in messages"
            :key="i"
            class="msg"
            :class="m.role"
          >
            <div class="bubble">
              <!-- Only model replies are rendered as Markdown. User text stays
                   plain so nothing a user types is ever treated as markup. -->
              <div
                v-if="m.role === 'assistant'"
                class="bubble-text markdown"
                v-html="renderMarkdown(m.content)"
              />
              <p v-else class="bubble-text">{{ m.content }}</p>
              <p v-if="m.citations && m.citations.length" class="cites">
                <span class="cite-label">已查询平台数据：</span>
                <span v-for="(c, ci) in m.citations" :key="ci" class="cite">{{ c.tool }}</span>
              </p>
            </div>
          </div>

          <div v-if="sending" class="msg assistant">
            <div class="bubble thinking">
              <span class="dot" /><span class="dot" /><span class="dot" />
              <span class="thinking-text">正在查询平台数据…</span>
            </div>
          </div>
        </div>

        <p v-if="error" class="error">{{ error }}</p>

        <div class="input-row">
          <input
            v-model="input"
            placeholder="问我岗位、技能、薪资、行业趋势或学习建议…"
            :disabled="sending"
            @keydown.enter.prevent="send()"
          />
          <button class="send-btn" :disabled="!canSend" @click="send()">
            {{ sending ? '思考中…' : '发送' }}
          </button>
        </div>
      </section>
    </template>
  </div>
</template>

<style scoped>
.advisor-page {
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

/* ---- setup hint ---- */
.setup-hint .section-desc { max-width: 640px; line-height: 1.7; }
.setup-btn {
  display: inline-block;
  margin-top: var(--space-5);
  padding: 10px 24px;
  border-radius: var(--radius-full);
  background: var(--gradient-primary);
  color: #fff;
  font-size: var(--font-size-base);
  font-weight: 600;
  box-shadow: var(--glow-primary);
  transition: filter var(--transition), transform var(--transition-fast);
}
.setup-btn:hover { filter: brightness(1.06); }
.setup-btn:active { transform: scale(0.98); }

/* ---- chat ---- */
.chat-card { display: flex; flex-direction: column; }
.chat-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: var(--space-4);
  margin-bottom: var(--space-4);
}
.chat-body {
  flex: 1;
  min-height: 380px;
  max-height: calc(100vh - var(--header-height) - 300px);
  overflow-y: auto;
  padding: var(--space-2) 2px;
}

.empty-chat { padding: var(--space-6) 0; }
.empty-title {
  font-size: var(--font-size-sm);
  color: var(--text-tertiary);
  margin-bottom: var(--space-3);
}
.suggestions { display: flex; flex-direction: column; gap: var(--space-2); align-items: flex-start; }
.suggestion {
  padding: 9px 16px;
  border-radius: var(--radius-full);
  border: 1px solid var(--border-color-strong);
  background: var(--surface-color);
  color: var(--text-secondary);
  font-size: var(--font-size-sm);
  text-align: left;
  transition: border-color var(--transition), color var(--transition);
}
.suggestion:hover { border-color: var(--primary-color); color: var(--primary-hover); }

.msg { display: flex; margin-bottom: var(--space-4); }
.msg.user { justify-content: flex-end; }
.msg.assistant { justify-content: flex-start; }
.bubble {
  max-width: 82%;
  padding: 12px 16px;
  border-radius: var(--radius-lg);
  font-size: var(--font-size-base);
  line-height: 1.7;
}
.msg.user .bubble {
  background: var(--gradient-primary);
  color: #fff;
  border-bottom-right-radius: var(--radius-sm);
}
.msg.assistant .bubble {
  background: var(--surface-soft);
  border: 1px solid var(--border-color);
  color: var(--text-color);
  border-bottom-left-radius: var(--radius-sm);
}
/* Plain (user) text keeps its newlines; rendered Markdown manages its own. */
.bubble-text { white-space: pre-wrap; word-break: break-word; }
.bubble-text.markdown { white-space: normal; }

/* ---- rendered Markdown ---- */
.markdown :deep(p) { margin: 0 0 var(--space-3); }
.markdown :deep(p:last-child) { margin-bottom: 0; }
.markdown :deep(h3),
.markdown :deep(h4),
.markdown :deep(h5),
.markdown :deep(h6) {
  margin: var(--space-4) 0 var(--space-2);
  font-size: var(--font-size-md);
  font-weight: 700;
  color: var(--text-color);
}
.markdown :deep(h3:first-child),
.markdown :deep(h4:first-child) { margin-top: 0; }
.markdown :deep(ul),
.markdown :deep(ol) { margin: 0 0 var(--space-3); padding-left: 1.4em; }
.markdown :deep(li) { margin: 3px 0; }
.markdown :deep(ul) { list-style: disc; }
.markdown :deep(ol) { list-style: decimal; }
.markdown :deep(strong) { font-weight: 700; color: var(--text-color); }
.markdown :deep(em) { font-style: italic; }
.markdown :deep(a) { color: var(--accent-blue); text-decoration: underline; }
.markdown :deep(code) {
  padding: 1px 6px;
  border-radius: var(--radius-sm);
  background: var(--surface-color);
  border: 1px solid var(--border-color);
  font-family: var(--font-mono);
  font-size: 0.92em;
  word-break: break-word;
}
.markdown :deep(pre) {
  margin: 0 0 var(--space-3);
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
  background: var(--surface-color);
  border: 1px solid var(--border-color);
  overflow-x: auto;
}
.markdown :deep(pre code) {
  padding: 0; border: none; background: none;
  font-size: var(--font-size-sm); line-height: 1.6;
}
.markdown :deep(blockquote) {
  margin: 0 0 var(--space-3);
  padding: 6px 0 6px var(--space-4);
  border-left: 3px solid var(--primary-color);
  color: var(--text-secondary);
}
.markdown :deep(hr) {
  margin: var(--space-4) 0;
  border: none;
  border-top: 1px solid var(--border-color);
}
/* Wide tables scroll inside the bubble rather than stretching it. */
.markdown :deep(table) {
  display: block;
  width: max-content;
  max-width: 100%;
  overflow-x: auto;
  margin: 0 0 var(--space-3);
  border-collapse: collapse;
  font-size: var(--font-size-sm);
}
.markdown :deep(th),
.markdown :deep(td) {
  padding: 7px 12px;
  border: 1px solid var(--border-color);
  text-align: left;
  white-space: nowrap;
}
.markdown :deep(th) { background: var(--surface-color); font-weight: 600; }

.cites {
  margin-top: var(--space-3);
  padding-top: var(--space-2);
  border-top: 1px dashed var(--border-color);
  font-size: var(--font-size-xs);
  color: var(--text-tertiary);
}
.cite-label { margin-right: 4px; }
.cite {
  display: inline-block;
  margin: 2px 4px 0 0;
  padding: 2px 8px;
  border-radius: var(--radius-full);
  background: var(--accent-blue-soft);
  color: var(--accent-blue);
  font-family: var(--font-mono);
}

.thinking { display: flex; align-items: center; gap: 5px; }
.thinking-text { margin-left: 6px; font-size: var(--font-size-sm); color: var(--text-secondary); }
.dot {
  width: 6px; height: 6px; border-radius: 50%;
  background: var(--text-tertiary);
  animation: blink 1.3s infinite ease-in-out;
}
.dot:nth-child(2) { animation-delay: 0.18s; }
.dot:nth-child(3) { animation-delay: 0.36s; }
@keyframes blink {
  0%, 80%, 100% { opacity: 0.25; }
  40% { opacity: 1; }
}

.input-row { display: flex; gap: 10px; margin-top: var(--space-4); }
.input-row input {
  flex: 1;
  height: 44px;
  padding: 0 16px;
  border: 1px solid var(--border-color-strong);
  border-radius: var(--radius-full);
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
.send-btn {
  height: 44px;
  padding: 0 28px;
  border: none;
  border-radius: var(--radius-full);
  background: var(--gradient-primary);
  color: #fff;
  font-size: var(--font-size-base);
  font-weight: 600;
  box-shadow: var(--glow-primary);
  transition: filter var(--transition), transform var(--transition-fast);
}
.send-btn:hover:not(:disabled) { filter: brightness(1.06); }
.send-btn:active:not(:disabled) { transform: scale(0.98); }
.send-btn:disabled { opacity: 0.5; cursor: not-allowed; }

.ghost-btn {
  height: 34px;
  padding: 0 16px;
  flex-shrink: 0;
  background: var(--surface-soft);
  color: var(--text-secondary);
  border: 1px solid var(--border-color-strong);
  border-radius: var(--radius-full);
  font-size: var(--font-size-sm);
  transition: border-color var(--transition), color var(--transition);
}
.ghost-btn:hover { border-color: var(--primary-color); color: var(--primary-hover); }

.error {
  margin-top: var(--space-3);
  color: #e74c3c;
  font-size: var(--font-size-sm);
}
</style>
