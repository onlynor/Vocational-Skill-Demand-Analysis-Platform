/**
 * Minimal Markdown renderer for AI advisor replies.
 *
 * Hand-rolled on purpose: the npm registry was not reachable from the
 * environment this was written in, and shipping an unverifiable dependency
 * was worse than a focused renderer covering what an LLM actually emits
 * (headings, bold/italic, code, lists, tables, links, quotes).
 *
 * SECURITY — the ordering below is the whole safety argument:
 * every character of model output is HTML-escaped FIRST, and only after
 * that are known-safe tags inserted. A `<script>` in the model's reply has
 * already become `&lt;script&gt;` before any tag is generated, so it can
 * never re-enter the DOM as markup. Link hrefs are additionally restricted
 * to http/https/mailto so `javascript:` URLs cannot slip through.
 * If you extend this, keep escaping first — do not move it later.
 */

const CODE_TOKEN = 'CODE'

function escapeHtml(s) {
  return s
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;')
}

function safeHref(url) {
  const trimmed = url.trim()
  if (/^(https?:|mailto:)/i.test(trimmed)) return trimmed
  return null
}

// Inline pass: code spans first (so their contents are not further
// transformed), then links, bold, italic.
function inline(text) {
  const codes = []
  let out = text.replace(/`([^`]+)`/g, (_, c) => {
    codes.push(c)
    return CODE_TOKEN + (codes.length - 1) + ''
  })

  out = out.replace(/\[([^\]]+)\]\(([^)\s]+)\)/g, (_, label, url) => {
    const href = safeHref(url)
    if (!href) return label
    return '<a href="' + href + '" target="_blank" rel="noopener noreferrer">' + label + '</a>'
  })

  out = out.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
  out = out.replace(/(^|[^*])\*([^*\n]+)\*/g, '$1<em>$2</em>')

  return out.replace(new RegExp(CODE_TOKEN + '(\\d+)', 'g'), (_, i) => '<code>' + codes[i] + '</code>')
}

function isTableSep(line) {
  return /^\s*\|?[\s:-]*-[\s:|-]*\|?\s*$/.test(line) && line.includes('-')
}

function splitRow(line) {
  return line.replace(/^\s*\|/, '').replace(/\|\s*$/, '').split('|').map(c => c.trim())
}

export function renderMarkdown(src) {
  if (!src) return ''
  const text = escapeHtml(String(src)) // <-- escape before anything else
  const lines = text.split(/\r?\n/)
  const html = []
  let i = 0

  const ul = /^\s*[-*+]\s+/
  const ol = /^\s*\d+\.\s+/
  const quote = /^\s*&gt;\s?/
  const hr = /^\s*(---+|\*\*\*+)\s*$/

  while (i < lines.length) {
    const line = lines[i]

    // fenced code block
    if (/^\s*```/.test(line)) {
      const body = []
      i++
      while (i < lines.length && !/^\s*```\s*$/.test(lines[i])) body.push(lines[i++])
      i++ // closing fence
      html.push('<pre><code>' + body.join('\n') + '</code></pre>')
      continue
    }

    if (!line.trim()) { i++; continue }

    if (hr.test(line)) { html.push('<hr />'); i++; continue }

    const h = line.match(/^\s*(#{1,4})\s+(.*)$/)
    if (h) {
      const lv = Math.min(h[1].length + 2, 6) // start at h3 so it never outranks the page title
      html.push('<h' + lv + '>' + inline(h[2]) + '</h' + lv + '>')
      i++
      continue
    }

    // table: header row + separator row + body rows
    if (line.includes('|') && i + 1 < lines.length && isTableSep(lines[i + 1])) {
      const head = splitRow(line)
      i += 2
      const rows = []
      while (i < lines.length && lines[i].includes('|') && lines[i].trim()) {
        rows.push(splitRow(lines[i])); i++
      }
      html.push(
        '<table><thead><tr>' +
        head.map(c => '<th>' + inline(c) + '</th>').join('') +
        '</tr></thead><tbody>' +
        rows.map(r => '<tr>' + r.map(c => '<td>' + inline(c) + '</td>').join('') + '</tr>').join('') +
        '</tbody></table>'
      )
      continue
    }

    if (quote.test(line)) {
      const body = []
      while (i < lines.length && quote.test(lines[i])) {
        body.push(lines[i].replace(quote, '')); i++
      }
      html.push('<blockquote>' + inline(body.join(' ')) + '</blockquote>')
      continue
    }

    if (ul.test(line) || ol.test(line)) {
      const ordered = ol.test(line) && !ul.test(line)
      const re = ordered ? ol : ul
      const items = []
      while (i < lines.length && re.test(lines[i])) {
        items.push(inline(lines[i].replace(re, ''))); i++
      }
      const tag = ordered ? 'ol' : 'ul'
      html.push('<' + tag + '>' + items.map(t => '<li>' + t + '</li>').join('') + '</' + tag + '>')
      continue
    }

    // paragraph — consume until a blank line or the start of another block
    const para = []
    while (
      i < lines.length && lines[i].trim() &&
      !/^\s*```/.test(lines[i]) && !/^\s*#{1,4}\s/.test(lines[i]) &&
      !ul.test(lines[i]) && !ol.test(lines[i]) &&
      !quote.test(lines[i]) && !hr.test(lines[i])
    ) {
      para.push(lines[i]); i++
    }
    html.push('<p>' + inline(para.join('<br />')) + '</p>')
  }

  return html.join('')
}
