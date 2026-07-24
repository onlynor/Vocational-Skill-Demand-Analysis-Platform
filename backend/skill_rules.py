"""技能词典 / 停用词 / 技能同义词的补充配置（数据驱动）。

由 segmenter.ensure_skill_lexicon() 在 pipeline 启动时幂等 upsert（INSERT IGNORE）
入 stop_words / skill_dict / skill_synonym 表。仅 DML 数据行，不改表结构。

来源：真实 raw_jobs.requirements 分词后未命中技能词典的高频 token 分析
（见 docs/DATA_AUDIT_REPORT.md §3）。
- NOISE 噪声词 → stop_words（泛指/无技能含义）
- SKILLS 真技能 → skill_dict（计算机/互联网为主，按真实 requirements 出现补漏）
- SYNONYMS 同义归一 → skill_synonym
"""

# 噪声词（加入停用词，过滤分词噪声）
NOISE = [
    "框架", "开发", "服务", "操作能力", "架构", "并发", "编程",
    "系统", "平台", "岗位", "优秀", "以上", "以下", "相关",
    "业务", "能力", "技术", "工具", "方法", "团队", "项目",
    "熟悉", "掌握", "了解", "精通", "能够", "负责", "参与",
    "具备", "具有", "良好", "较强", "优先", "经验", "要求",
]

# 真技能补漏（出现在真实 requirements 但未纳入 skill_dict）
SKILLS = [
    # 前端基础
    ("HTML", "计算机/互联网"),
    ("CSS", "计算机/互联网"),
    ("jQuery", "计算机/互联网"),
    ("Bootstrap", "计算机/互联网"),
    ("Sass", "计算机/互联网"),
    ("Less", "计算机/互联网"),
    # 数据分析
    ("Pandas", "计算机/互联网"),
    ("NumPy", "计算机/互联网"),
    ("Matplotlib", "计算机/互联网"),
    ("Scikit-learn", "计算机/互联网"),
    ("Sklearn", "计算机/互联网"),
    ("Seaborn", "计算机/互联网"),
    ("Jupyter", "计算机/互联网"),
    # 数据库 / 大数据补充
    ("Doris", "计算机/互联网"),
    ("StarRocks", "计算机/互联网"),
    ("Iceberg", "计算机/互联网"),
    ("Pulsar", "计算机/互联网"),
    ("Presto", "计算机/互联网"),
    ("Trino", "计算机/互联网"),
    # 工程 / 其他语言
    ("Rust", "计算机/互联网"),
    ("Lua", "计算机/互联网"),
    ("Perl", "计算机/互联网"),
    ("Erlang", "计算机/互联网"),
    ("Elixir", "计算机/互联网"),
    ("Haskell", "计算机/互联网"),
    # DevOps / 云
    ("Jenkins", "计算机/互联网"),
    ("ArgoCD", "计算机/互联网"),
    ("Helm", "计算机/互联网"),
    ("Istio", "计算机/互联网"),
    ("Envoy", "计算机/互联网"),
    ("Consul", "计算机/互联网"),
    ("Vault", "计算机/互联网"),
    # 框架补充
    ("Spring", "计算机/互联网"),
    ("SpringMVC", "计算机/互联网"),
    ("Redux", "计算机/互联网"),
    ("Pinia", "计算机/互联网"),
    ("Vuex", "计算机/互联网"),
    ("ElementUI", "计算机/互联网"),
    ("Ant Design", "计算机/互联网"),
    # AI / 算法补充
    ("LangChain", "计算机/互联网"),
    ("LlamaIndex", "计算机/互联网"),
    ("HuggingFace", "计算机/互联网"),
    ("Transformer", "计算机/互联网"),
]

# 技能同义归一（raw -> std）
SYNONYMS = [
    ("js", "JavaScript"),
    ("jquery", "jQuery"),
    ("spring cloud", "Spring Cloud"),
    ("springcloud", "Spring Cloud"),
    ("scikit-learn", "Scikit-learn"),
    ("sklearn", "Scikit-learn"),
    ("matplotlib", "Matplotlib"),
    ("seaborn", "Seaborn"),
    ("jupyter", "Jupyter"),
    ("pandas", "Pandas"),
    ("numpy", "NumPy"),
    ("trino", "Trino"),
    ("helm", "Helm"),
    ("istio", "Istio"),
    ("consul", "Consul"),
    ("vault", "Vault"),
    ("langchain", "LangChain"),
    ("huggingface", "HuggingFace"),
]