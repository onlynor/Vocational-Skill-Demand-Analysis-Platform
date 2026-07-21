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

## 快速开始

### 1. 克隆项目

### 2. 一键导入数据库

数据库包含所有表结构和采集好的岗位数据：

```bash
mysql -u root -p < data/job_analysis_dump.sql
```

> 导入后即拥有完整的 `job_analysis` 数据库，无需手动建表或爬数据。

### 3. 安装后端依赖

```bash
python -m venv venv
venv\Scripts\activate          # Windows
# source venv/bin/activate     # macOS/Linux
pip install -r backend/requirements.txt
```

### 4. 修改数据库密码（如需要）

编辑 `backend/config.py`，将 `DB_PASSWORD` 改为你的 MySQL root 密码：

```python
DB_PASSWORD = os.getenv("DB_PASSWORD", "你的密码")
```

### 5. 安装前端依赖

```bash
cd frontend
npm install
```

### 6. 启动项目

**终端1 — 启动后端（端口 8000）：**

```bash
venv\Scripts\activate
uvicorn backend.main:app --reload --port 8000
```

**终端2 — 启动前端（端口 5173）：**

```bash
cd frontend
npm run dev
```

浏览器打开 `http://localhost:5173` 即可使用。

## 项目结构

```
├── backend/                 # FastAPI 后端
│   ├── main.py              # 应用入口
│   ├── config.py            # 数据库 & JWT 配置
│   ├── database.py          # SQLAlchemy 连接
│   ├── models.py            # ORM 模型
│   ├── schemas.py           # Pydantic 请求/响应模型
│   ├── auth.py              # JWT 认证逻辑
│   ├── cleaner.py           # Pandas 数据清洗
│   ├── segmenter.py         # Jieba 分词 + 技能提取
│   ├── pipeline.py          # 完整数据处理流水线
│   ├── routers/             # API 路由
│   │   ├── auth_router.py   # 注册 / 登录
│   │   └── profile_router.py # 职业画像查询 / 技能匹配
│   ├── schema.sql           # 建表语句
│   └── requirements.txt     # Python 依赖
├── frontend/                # Vue 3 前端
│   └── src/
│       ├── views/           # 页面组件
│       │   ├── LoginView.vue        # 登录
│       │   ├── DashboardView.vue    # 首页仪表盘
│       │   ├── JobProfileView.vue   # 职业画像
│       │   └── MatchView.vue        # 技能匹配
│       ├── api/index.js     # Axios 封装
│       ├── stores/          # Pinia 状态管理
│       └── router/          # 路由配置
├── spider/                  # Scrapy 爬虫
│   └── job_spider/spiders/boss_spider.py
├── data/                    # 数据文件
│   ├── job_analysis_dump.sql   # 完整数据库导出
│   └── boss_jobs_*_cleaned.xlsx # 按行业分类的清洗后数据
└── demo_flow.py             # 数据处理流程演示脚本
```

## 功能概览

1. **账号系统** — 注册 / 登录（JWT 认证）
2. **职业画像** — 搜索岗位，查看技能重要度排行、技能-薪资关系、地区需求量、学历/经验分布（ECharts 可视化）
3. **技能匹配** — 输入已有技能，匹配最适合的岗位，给出技能差距建议

