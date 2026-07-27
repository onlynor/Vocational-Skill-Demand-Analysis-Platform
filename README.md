## 技术栈

| 层 | 技术 |
|---|---|
| 数据采集 | Scrapy |
| 数据处理 | Pandas / Jieba 分词 |
| 数据库 | MySQL 9.x |
| 后端 | FastAPI + PyJWT |
| 前端 | Vue 3 + Vite + ECharts + Pinia |

## 环境要求

- **Python** 3.13+
- **Node.js** v22+
- **MySQL** 9.x（需提前安装并启动服务）
- 包管理器：后端 pip + venv，前端 [pnpm](https://pnpm.io/)（兼容 npm）

## 快速开始

### 1. 克隆项目

```bash
git clone <repo-url>
cd Vocational-Skill-Demand-Analysis-Platform
```

### 2. 一键导入数据库

`data/job_analysis_dump.sql` 包含所有表结构和采集好的岗位数据，但**不含 `CREATE DATABASE` / `USE` 语句**，必须指定库名：

```bash
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS job_analysis;"
mysql -u root -p job_analysis < data/job_analysis_dump.sql
```

> 导入后即拥有完整的 `job_analysis` 数据库，无需手动建表或爬数据。

### 3. 配置环境变量

复制模板并填入真实值（`.env` 已被 gitignore，不会提交）：

```bash
cp .env.example .env
# 编辑 .env，填入 DB_PASSWORD 等；生产前用 `openssl rand -hex 32` 生成强 SECRET_KEY
```

`.env` 示例：

```ini
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=job_analysis
SECRET_KEY=dev-secret-key-change-in-production   # 生产前务必替换
```

> 后端 `backend/config.py` 与爬虫 `spider/job_spider/pipelines.py` 均通过 `python-dotenv` 从**仓库根目录**的 `.env` 读取配置，仓库代码中无明文密码。

### 4. 安装后端依赖

在**仓库根目录**创建虚拟环境并安装（`load_dotenv()` 依赖 cwd 向上查找根目录 `.env`，不要进子目录运行）：

```bash
# Linux / macOS
python -m venv .venv
source .venv/bin/activate
pip install -r backend/requirements.txt
```

```bash
# Windows (PowerShell)
python -m venv .venv
.venv\Scripts\activate
pip install -r backend/requirements.txt
```

> 项目依赖锁定在 `backend/requirements.txt`，用标准 pip 即可，无需额外包管理器。

### 5. 安装前端依赖

```bash
cd frontend
pnpm install      # 推荐 pnpm（仓库已提交 pnpm-lock.yaml）
```

> 若未安装 pnpm，可改用 npm 兼容运行：`npm install` → `npm run dev`。项目本身不依赖 pnpm 专有特性。

### 6. 启动项目

**终端1 — 启动后端（端口 8000）：**

```bash
# 必须在仓库根目录、且已激活 .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
uvicorn backend.main:app --reload --port 8000
```

**终端2 — 启动前端（端口 5173）：**

```bash
cd frontend
pnpm dev          # 无 pnpm 时用 npm run dev
```

浏览器打开 `http://localhost:5173`，首次访问需注册账号或用库中已有账号登录。

> 启动前如遇端口被占用（`Errno 98 Address already in use`），请先释放：
> `lsof -ti:8000 | xargs -r kill -9`，或换端口 `--port 8001`。

## 项目结构

```
├── backend/                 # FastAPI 后端
│   ├── main.py              # 应用入口 + CORS
│   ├── config.py            # 从 .env 读取 DB / JWT 配置
│   ├── database.py          # SQLAlchemy 连接
│   ├── models.py            # ORM 模型
│   ├── schemas.py           # Pydantic 请求/响应模型
│   ├── auth.py              # bcrypt 哈希 + JWT 签发/校验
│   ├── cleaner.py           # Pandas 数据清洗（含缺失共底 + 垃圾标题剔除）
│   ├── category_rules.py    # 数据驱动职业分类规则配置（关键词权重）
│   ├── classifier.py        # 分类器：标题+要求文本 → 行业/职位 category_id
│   ├── skill_rules.py       # 技能词典 / 停用词 / 同义补充配置
│   ├── segmenter.py         # Jieba 分词 + 技能提取
│   ├── pipeline.py          # 完整数据处理流水线
│   ├── routers/             # API 路由
│   │   ├── auth_router.py   # 注册 / 登录
│   │   └── profile_router.py # 职业画像查询 / 技能匹配
│   └── requirements.txt     # Python 依赖
├── frontend/                # Vue 3 前端
│   └── src/
│       ├── views/           # 页面
│       │   ├── LoginView.vue        # 登录 / 注册
│       │   ├── JobProfileView.vue   # 职业画像仪表盘
│       │   └── MatchView.vue        # 技能匹配
│       ├── components/
│       │   ├── common/      # BrandLogo / EmptyState / Loading
│       │   └── dashboard/   # StatCard / ChartCard / Sidebar
│       ├── styles/          # 设计 token（variables.css）+ 全局样式
│       ├── api/index.js     # Axios 封装
│       ├── stores/auth.js   # Pinia 认证状态
│       └── router/index.js  # 路由 + 登录守卫
├── spider/                  # Scrapy 爬虫（读根目录 .env 连库）
│   └── job_spider/spiders/boss_spider.py
├── data/
│   └── job_analysis_dump.sql   # 完整数据库导出
└── .env.example             # 环境变量模板
```

## API 概览

路由前缀：认证 `/api/auth`，职业画像 `/api/profile`。

| 方法 | 路径 | 说明 |
|---|---|---|
| POST | `/api/auth/register` | 注册，返回 JWT |
| POST | `/api/auth/login` | 登录，返回 JWT |
| GET | `/api/profile/jobs/tree` | 行业-职位树 |
| GET | `/api/profile/jobs/{title}` | 单岗位画像（统计 + 图表数据） |
| GET | `/api/profile/skills/rank` | 技能重要度排行 |
| GET | `/api/profile/skills/salary` | 技能-薪资关系 |
| GET | `/api/profile/cities` | 城市需求量 |
| GET | `/api/profile/education` | 学历分布 |
| POST | `/api/profile/skills/match` | 技能匹配岗位 |

前端 `axios` baseURL 指向 `http://localhost:8000/api`，请求拦截器自动加 `Authorization: Bearer <token>`；登录守卫对 `requiresAuth` 路由检查 localStorage token。

## 功能概览

1. **账号系统** — 注册 / 登录（bcrypt 哈希 + JWT 认证）
2. **职业画像** — 选择行业→职位，查看岗位数量、平均薪资、薪资范围，技能排行 / 城市分布 / 学历要求 / 招聘公司（ECharts 可视化，统一 StatCard / ChartCard 组件）
3. **技能匹配** — 输入已有技能，匹配最适合的岗位，分析已匹配/需补充技能

## 数据处理管道

```bash
# 在仓库根目录、激活 .venv 后执行
python -m backend.pipeline                            # raw_jobs → 清洗 → 分类 → 分词
python -m backend.pipeline --reset                    # 先清空 cleaned_jobs/job_skill 再处理
python -m backend.pipeline --import-file data.xlsx    # Excel/CSV 直接导入后分词
```

管道做四件事：
1. **清洗去重** — 同义词统一、去重复、薪资解析、字段缺失共底与归一（学历「不限」、经验「不限经验」、城市/公司/来源「未知」）
2. **垃圾过滤** — 自动剔除广告话术/钓饵标题（「外企双休」「包吃住」「240/天」等非真实岗位），`raw_jobs` 保留原始数据
3. **数据驱动分类** — 按 `backend/category_rules.py` 的关键词权重规则，把岗位归入 18 个一级行业下的具名职位；未命中的长尾岗位按真实标题细分到「其他」行业，使 `category_id` 覆盖率达 100%
4. **技能提取** — Jieba 分词 + 技能词典匹配 + 停用词过滤 + 同义归一，写入 `job_skill`

导入文件需含列：`title, city, education, experience, requirements, company, source, salary_min, salary_max, salary_avg`。

> 新增行业/职位只需编辑 `backend/category_rules.py`，无需改代码；补技能/停用词只需编辑 `backend/skill_rules.py`。

## 爬虫

```bash
cd spider && scrapy crawl boss
```

> 爬虫 `pipelines.py` 现已从根目录 `.env` 读取 DB 配置，与后端一致。