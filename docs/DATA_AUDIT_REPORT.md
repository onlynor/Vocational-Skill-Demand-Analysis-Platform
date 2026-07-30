# 第一阶段：数据质量审计报告

> 数据来源：`data/job_analysis_dump.sql`（唯一真实数据源）
> 审计方式：导入 MySQL 9.x → `scripts/audit.py` 直连读真实表 → 同时用 `python -m backend.pipeline --reset` 跑了一次真实管道，得到 pipeline 实际产物与 dump 内手工数据两份基线对比。
> 本阶段只分析，不修改任何代码与数据。

---

## 0. 真实数据规模

| 表 | 行数 | 说明 |
|---|---|---|
| raw_jobs | 12 | 爬虫真实原始数据（最真实来源）|
| cleaned_jobs | 12 | dump 内为手工精简数据；pipeline 重跑后为真实产物 |
| job_skill | 45 / 65 | dump 手工 45 条；pipeline 真实跑出 65 条 |
| job_category | 206 | 10 个一级行业 + 196 个二级职位 |
| synonym_dict | 30 | 标题同义词（手写）|
| skill_dict | 88 | 技能词典 |
| stop_words | 33 | 停用词 |
| skill_synonym | 34 | 技能同义词 |

**重要事实**：dump 里的 `cleaned_jobs.requirements` 与 `job_skill` 是**人工 INSERT 的精简版**，并非 pipeline 真实产物。例如 `raw_jobs.id=1` 的 requirements 含「Django 框架」「Linux 操作能力」，但 dump 的 `cleaned_jobs.id=1` 把它们丢掉了。因此本报告同时给出两种基线：**dump 手工数据** 与 **pipeline 真实输出**，以 pipeline 真实输出为准。

---

## 1. 职业分类分析

### 1.1 当前分类逻辑（硬编码定位）

代码中**没有 if/else 硬编码分类**（已 grep 确认），但存在**等效硬编码**，集中体现在两条手工维护的 DB 规则链：

```
raw_jobs.title
  → synonym_dict  (30 条：把"Python开发工程师"→"Python开发")    [手写规则 1]
  → job_category.name (parent_id 非空) 精确相等匹配               [手写规则 2]
  → 命中即得 category_id
```

位置：
- `backend/cleaner.py::save_cleaned`（raw → cleaned 路径，`cat_map = {name: id for ... name.in_(titles)}`）
- `backend/pipeline.py::import_from_excel`（Excel → cleaned 路径，同样精确相等）
- 规则数据：`backend/seed_data.sql` / `backend/category_seed.sql` / `data/job_analysis_dump.sql` 中的 `synonym_dict`、`job_category` 表

**本质问题**：分类能力 = `synonym_dict` 覆盖度 × `job_category.name` 词表覆盖度。任意一个未在 synonym_dict 里登记的标题（如「C++ 后台开发」「资深产品经理」「行政专员」「HRBP」「法务专员」）就会落到 `category_id IS NULL`。这正是用户描述的"大量岗位未归类"的根因——每加一种新写法都要手写一条 synonym，不可维护。

无 if/else 但效果等于：
```python
if normalized_title == "Python开发":   category = Python开发
elif normalized_title == "Java开发":    category = Java开发
...
```

### 1.2 分类覆盖率统计（真实数据）

| 指标 | 值 |
|---|---|
| 总岗位数量 (cleaned_jobs) | 12 |
| 已分类数量 | 12 |
| 未分类数量 | 0 |
| **分类覆盖率** | **100.0%** |

### 1.3 raw 原始标题 → 归一化 → 分类 链路追踪

| 原始标题 | 归一化标题 | 命中分类 | 所属行业 |
|---|---|---|---|
| Python开发工程师 | Python开发 | ✓ | 计算机/互联网 |
| Python高级开发 | Python开发 | ✓ | 计算机/互联网 |
| Python后端开发 | 后端开发 | ✓ | 计算机/互联网 |
| Python开发 | Python开发 | ✓ | 计算机/互联网 |
| Java开发工程师 | Java开发 | ✓ | 计算机/互联网 |
| 高级Java开发 | Java开发 | ✓ | 计算机/互联网 |
| Java后端开发 | 后端开发 | ✓ | 计算机/互联网 |
| 前端开发工程师 | 前端开发 | ✓ | 计算机/互联网 |
| Web前端开发 | 前端开发 | ✓ | 计算机/互联网 |
| 前端开发 | 前端开发 | ✓ | 计算机/互联网 |
| 数据分析师 | 数据分析 | ✓ | 计算机/互联网 |
| 大数据开发工程师 | 数据开发 | ✓ | 计算机/互联网 |

### 1.4 未分类岗位 TOP

| 岗位名称 | 数量 |
|---|---|
| （无未分类岗位） | — |

**结论修正**：用户问题单中提到「47% → 90%+」「大量岗位未归类」，与真实 dump 数据**不符**——当前 12 条真实数据全部命中，覆盖率 100%。未归类问题只会在**未来爬取到 synonym_dict 未登记的新写法 / 当前分类树未覆盖的新行业**时才暴露。因此第一阶段的分类改造目标是**鲁棒性**（让覆盖率在数据扩张后仍保持 ≥90%），而非提升当前的 100%。

### 1.5 分类树现有行业（一级，10 个）

| 行业 | 二级职位数 |
|---|---|
| 计算机/互联网 | 26 |
| 电气/自动化 | 20 |
| 医学/医疗 | 20 |
| 金融/会计 | 20 |
| 教育/培训 | 15 |
| 建筑/土木 | 20 |
| 机械/制造 | 20 |
| 销售/市场 | 20 |
| 物流/运输 | 15 |
| 传媒/设计 | 20 |

### 1.6 是否需要新增「人力资源 / 行政 / 法律 / 招商 / 销售 / 运营」等行业

按用户优先级「根据 SQL 真实岗位数据发现，不要凭空添加」检查：
- 真实 `raw_jobs.title` 中**没有** 人力资源、行政、法律、招商、专职运营等岗位（12 条全部是计算机/互联网技术岗）。
- 因此**第一阶段不新增这些一级行业**，避免凭空添加空分类污染前端 `jobs/tree` 树（前端会展示空行业）。
- 备注：`销售/市场` 已含运营类二级节点（电商运营、新媒体运营、直播运营、内容运营、品类运营、活动策划、客服）。运营需求已被覆盖。

> 改造方案将设计为**配置驱动**，未来真实爬到新行业岗位时，只需在配置文件加规则即可，无需改代码、无需手写 synonym_dict。

---

## 2. 数据缺失分析

### 2.1 raw_jobs 字段缺失率

| 字段 | 缺失率 | 缺失数 | 总数 |
|---|---|---|---|
| title | 0.0% | 0 | 12 |
| salary_text | 0.0% | 0 | 12 |
| city | 0.0% | 0 | 12 |
| education | 0.0% | 0 | 12 |
| experience | 0.0% | 0 | 12 |
| requirements | 0.0% | 0 | 12 |
| company | 0.0% | 0 | 12 |
| source | 0.0% | 0 | 12 |

### 2.2 cleaned_jobs 字段缺失率（pipeline 真实产物）

| 字段 | 缺失率 |
|---|---|
| title | 0.0% |
| salary_min / max / avg | 0.0% |
| city | 0.0% |
| education | 0.0% |
| experience | 0.0% |
| requirements | 0.0% |
| company | 0.0% |
| source | 0.0% |
| category_id | 0.0% |

**结论**：当前真实数据**无任何缺失**。但 `backend/cleaner.py` **完全没有缺失值兜底逻辑**，一旦爬虫抓到空字段就会写入 NULL，污染下游统计（`profile_router` 的 `cities` / `education` 接口已用 `isnot(None)` 过滤，但缺失会降低统计基数、且无默认值展示）。需补充默认值兜底。

### 2.3 字段取值分布（用于设计默认值）

| education | 次数 | experience | 次数 | city | 次数 | source | 次数 |
|---|---|---|---|---|---|---|---|
| 本科 | 9 | 3年经验 | 6 | 北京 | 4 | BOSS直聘 | 12 |
| 大专 | 2 | 5年经验 | 2 | 上海 | 4 | 拉勾 | 2* |
| 硕士 | 1 | 1年经验 | 2 | 深圳 | 2 | 智联招聘 | 2* |
| | | 2年经验 | 2 | 杭州 | 2 | | |

*\*拉勾/智联仅出现在 dump 手工数据，pipeline 真实跑时 source 全为 BOSS直聘（因为 raw 全部来自 BOSS）。*

### 2.4 发现的规整性问题（虽非"缺失"但是数据质量问题）

1. **experience 未归一**：raw 是「3年经验」，dump 手工 cleaned 是「3年」，pipeline 真实产物保留「3年经验」——两种格式同时存在，`/api/profile/education` 等 group-by 会被打散。应统一为「3年」。
2. **education 未归一**：可能出现「本科」「大学本科」「统招本科」「大专」「专科」等异写，应归一并统一。
3. **薪资解析** `_parse_salary`：对 `15K-25K` / `150-200` / `20K-30K` 处理 OK，但对「面议」「薪资面议」「100元/天」无兜底，会返回 NULL。需默认值兜底。

### 2.5 拟定默认值方案（不删除数据，仅缺失/异常时填充）

| 字段 | 缺失/异常默认值 | 理由 |
|---|---|---|
| education | `不限` | 招聘常见写法，统计可保留独立饼图块且不误导 |
| experience | `不限经验` | 同上 |
| city | `未知` | 保持计数但与真实城市区分 |
| company | `未知` | 保持不可空 |
| source | `未知` | 保持不可空 |
| salary_min/max/avg | `NULL`（保留为空） | 薪资为空时不能编造数值，否则污染 `skills/salary` 接口的 `avg_salary`；统计接口已 `isnot(None)` 过滤 |
| requirements | `` (空串) | 分词返回空列表，不产生噪声技能 |
| category_id | 按 §3 的新分类器尽量归类，仍归不上的保留 `NULL` + title 记 `其他` 兜底（可选） | 保证覆盖率 |

---

## 3. 技能提取质量分析

检查对象：`backend/segmenter.py`（jieba 分词 + skill_dict 词典匹配 + stop_words 停用 + skill_synonym 同义归一）。

### 3.1 job_skill 真实输出统计（pipeline 重跑后）

| 指标 | dump 手工 | pipeline 真实 |
|---|---|---|
| job_skill 关联条数 | 45 | **65** |
| 去重技能数 | 27 | **35** |

pipeline 真实产物比手工 dump **多识别**：`Django`、`Linux`、`Nginx`、`HTML?`(漏)、`机器学习`、`高并发`、`Webpack`、`Git`、`Kafka` 等——证明手工 dump 数据本身不完整，应以 pipeline 真实输出为准。

### 3.2 job_skill TOP 技能（pipeline 真实输出，无噪声）

| skill | freq | | skill | freq |
|---|---|---|---|---|
| Python | 6 | | React | 2 |
| MySQL | 5 | | Spark | 2 |
| Java | 4 | | Hadoop | 2 |
| Vue | 3 | | 微服务 | 2 |
| JavaScript | 3 | | Kubernetes | 2 |
| Docker | 2 | | Node.js | 2 |
| Elasticsearch | 2 | | Git | 2 |
| 分布式 | 2 | | TypeScript | 2 |
| Redis | 2 | | Webpack | 2 |
| Spring Boot | 2 | | 其他 13 项各 1 次 | |

**job_skill 当前无显式噪声**（因 skill_dict 88 词全部为真技能，匹配阶段天然过滤）。问题在分词**入口层**未命中词典的高频 token。

### 3.3 现有停用词表（33 条）

`，、；。（）` 等标点 + 动词/助词类：`熟悉、掌握、了解、精通、具备、具有、参与、能够、负责、相关、经验、能力、优先、以上、良好、较强`（已较好覆盖用户列的"负责/岗位/经验/能力/优秀"中除「岗位/优秀」外的项）。

### 3.4 未命中技能词典的高频 token（噪声 / 漏技能 诊断）

对全部 raw `requirements` 用 jieba 分词后，统计不在 skill_dict 中的 TOP token：

| token | 频次 | 性质判定 | 处理建议 |
|---|---|---|---|
| 框架 | 8 | **噪声**（泛指词，无具体技能含义）| 加入 stop_words |
| 开发 | 2 | **噪声** | 加入 stop_words |
| 服务 | 2 | **噪声**（"服务"单拎无意义，"微服务"已单独成词）| 加入 stop_words |
| 分布式系统 | 2 | **漏技能/同义** | skill_synonym → `分布式`（已收）|
| 操作能力 | 1 | **噪声** | 加入 stop_words |
| 架构 | 1 | **噪声**（泛指，"架构"单字与真实技能无关）| 加入 stop_words |
| 并发 | 1 | 边界 | "高并发"已收；"并发"建议停用防止单拎 |
| 编程 | 1 | **噪声** | 加入 stop_words |
| 机器 / 学习 | 各 1 | **切分问题** | "机器学习"已在 skill_dict，jieba 偶尔切散；已通过 `_register_skill_words` 处理，pipeline 实际产物中"机器学习"已正确识别，无需额外处理 |
| Spring / Boot / Cloud | 2 / 1 / 1 | **切分残留**（audit 独立进程未做复合合并）| pipeline 内已有 `_merge_compound_words` 合并为 `Spring Boot` / `Spring Cloud`，job_skill 实际正确；保留 |
| Node / js | 2 / 2 | **切分残留 + 同义** | 已有 skill_synonym `Node`→`Node.js`、`js` 应补 `js`→`JavaScript` |
| HTML / CSS | 1 / 1 | **漏技能（真技能）** | **加入 skill_dict** |
| Pandas / NumPy | 1 / 1 | **漏技能（真技能）** | **加入 skill_dict** |

### 3.5 技能提取优化清单

**A. 噪声过滤（加入 stop_words）**：`框架`、`开发`、`服务`、`操作能力`、`架构`、`并发`、`编程`、`系统`、`平台`、`岗位`、`优秀`（补齐用户提到的剩余噪声词）。

**B. 真技能补漏（加入 skill_dict.category='计算机/互联网'）**：`HTML`、`CSS`、`Pandas`、`NumPy`、`Django`(已在，确认)、`Scikit-learn`、`Pandas`、`Matplotlib`（这些是数据分析岗常出现的真实技能，当前数据已出现 HTML/CSS/Pandas/NumPy）。

**C. 同义归一再补**：`js` → `JavaScript`；`jq`→`jQuery`（如出现）。

**D. 分词防切散**：现有 `_register_skill_words` + `_merge_compound_words` 已能正确合并 `Spring Boot`、`Spring Cloud`、`Node.js`、`GitHub Actions`、`GitLab CI`、`ELK Stack` 等复合词，架构合理，保留不动。

### 3.6 数据库结构约束

不修改任何表结构（`skill_dict` / `stop_words` / `skill_synonym` 表结构不变），仅向这些已有表**插入/补充数据行**，且通过配置文件管理，避免散落在 .sql 中。

---

## 4. 第二阶段改造方案设计（预告，待确认后实施）

### 4.1 分类逻辑数据驱动重构

新增纯配置文件 `backend/classifier.py`（或 `data/config/category_rules.yaml`），把"标题文本 → 类别"做成**关键词权重打分**：

```
岗位文本(title + requirements)
 ↓
正则匹配/子串匹配  config 中每个职位附带 (keywords, weights)
 ↓
按职位累加权值得分
 ↓
取最高分职位（>阈值）→ category_id；否则兜底「其他/NULL」
```

- 配置由 `job_category` 现有二级节点 + 每节点配置关键词自动生成初始规则（如 `Python开发` ← keywords: [python, django]）。
- 不再依赖 `synonym_dict` 精确相等，保留 synonym_dict 仅作标题展示归一（前端显示用）。
- 影响：`cleaner.save_cleaned`、`pipeline.import_from_excel` 改调分类器；`job_tree` 接口语义不变（仍按 cleaned.title 分组计数）；`skills/match` 的 industry 过滤仍用 category_id 父级，不受影响。

### 4.2 默认值兜底

`cleaner.clean()` 与 `save_cleaned` 增加缺失/异常值归一与默认填充（见 §2.5），同时把 experience「3年经验」→「3年」、education 异写归一。

### 4.3 技能词典与停用词补全

通过配置文件驱动，向 `skill_dict` / `stop_words` / `skill_synonym` upsert 补充行（§3.5 清单）。

### 4.4 约束

- 不破坏现有 8 个 API 接口（`/api/auth/*`、`/api/profile/*`）。
- 不改前端。
- 不改 DB 核心表结构（仅 DML 数据行补充）。
- 保持 `python -m backend.pipeline` 运行方式不变。

---

## 5. 修改前基线指标（用于第三阶段对比）

| 指标 | 修改前（pipeline 真实跑） |
|---|---|
| 岗位总数 | 12 |
| 分类数量 | 12 |
| 未分类数量 | 0 |
| 分类覆盖率 | 100.0% |
| 技能关联条数 | 65 |
| 去重技能数 | 35 |
| 字段缺失率 | 0.0%（但无兜底） |
| 漏识真技能 | HTML / CSS / Pandas / NumPy（≥4 项被丢弃） |
| 分词噪声 token（≥2 次） | 框架(8) / 开发(2) / 服务(2) |

> 提示：因真实数据分类覆盖率已 100%，第三阶段「修改后覆盖率」预期仍为 100%，改造价值体现在「鲁棒性」与「漏技能补全 / 噪声清理」上。前端 jobs/tree 树展示与现有 API 输出不变。