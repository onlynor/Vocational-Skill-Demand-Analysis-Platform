"""数据质量审计脚本：直接读取 MySQL 真实数据，输出第一阶段分析报告。
不修改任何数据。"""
import os
import sys
from collections import Counter

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from dotenv import load_dotenv
from sqlalchemy import create_engine, text
import pandas as pd

load_dotenv(os.path.join(os.path.dirname(__file__), "..", ".env"))

DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_NAME = os.getenv("DB_NAME", "job_analysis")
from urllib.parse import quote_plus
url = f"mysql+pymysql://{DB_USER}:{quote_plus(DB_PASSWORD)}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(url)


def q(sql):
    with engine.connect() as c:
        return pd.read_sql(text(sql), c)


def banner(title):
    print("\n" + "=" * 70)
    print(title)
    print("=" * 70)


def main():
    pd.set_option("display.unicode.east_asian_width", True)
    pd.set_option("display.max_rows", 200)
    pd.set_option("display.width", 200)

    raw = q("SELECT * FROM raw_jobs")
    cleaned = q("SELECT * FROM cleaned_jobs")
    skill = q("SELECT * FROM job_skill")
    cat = q("SELECT * FROM job_category")
    syn = q("SELECT * FROM synonym_dict")

    # ---------- 1. 职业分类分析 ----------
    banner("1. 职业分类分析")
    total = len(cleaned)
    classified = cleaned["category_id"].notna().sum()
    unclassified = total - classified
    print(f"总岗位数量(cleaned_jobs): {total}")
    print(f"已分类数量: {classified}")
    print(f"未分类数量: {unclassified}")
    print(f"分类覆盖率: {classified/total*100:.1f}%" if total else "N/A")

    print("\n--- 当前分类逻辑定位 ---")
    print("backend/cleaner.py::save_cleaned 与 backend/pipeline.py::import_from_excel")
    print("逻辑：cleaned.title 先经 synonym_dict 归一化，再与 job_category(二级节点) name 精确相等匹配。")
    print("硬编码规则不存在 if/else，但等价硬编码集中在两张表：")
    print(f"  - synonym_dict 标题同义词：{len(syn)} 条（手工维护，覆盖即分类前提）")
    print(f"  - job_category 二级职位节点：{len(cat[cat.parent_id.notna()])} 个（精确匹配词典）")

    print("\n--- raw 原始标题分类链路追踪 ---")
    cat2 = cat[cat.parent_id.notna()].set_index("name")
    cat1 = cat[cat.parent_id.isna()].set_index("id")
    rows = []
    for _, r in raw.iterrows():
        std = syn.set_index("raw_word")["std_word"].to_dict().get(r["title"], r["title"])
        cid = None
        ind = ""
        if std in cat2.index:
            cid = int(cat2.loc[std, "id"])
            pid = int(cat2.loc[std, "parent_id"])
            ind = cat1.loc[pid, "name"]
        rows.append((r["title"], std, std in cat2.index, ind))
    trace = pd.DataFrame(rows, columns=["原始标题", "归一化标题", "是否命中分类", "所属行业"])
    print(trace.to_string(index=False))

    print("\n--- 未分类岗位（cleaned_jobs.category_id IS NULL）---")
    uc = cleaned[cleaned.category_id.isna()]
    if uc.empty:
        print("（无未分类岗位，当前 dump 命中率 100%）")
    print("\n未分类岗位 TOP:")
    cnt = uc["title"].value_counts()
    if cnt.empty:
        print("（无）")
    else:
        for name, n in cnt.items():
            print(f"  {name} | {n}")

    # 行业维度潜在缺口（SQL 真实数据里没有，但分类树缺失的人员/行政/法律等）
    print("\n--- 分类树覆盖的行业（一级）---")
    for cid, r in cat1.iterrows():
        n2 = len(cat[cat.parent_id == cid])
        print(f"  {r['name']}  : {n2} 个职位")

    # ---------- 2. 数据缺失分析 ----------
    banner("2. 数据缺失分析 (raw_jobs)")
    miss_rate = {}
    for col in ["title", "salary_text", "city", "education", "experience",
                "requirements", "company", "source"]:
        miss = raw[col].isna().sum() + (raw[col].astype(str).str.strip() == "").sum()
        miss_rate[col] = miss / len(raw) * 100
    print(f"{'字段':<14}{'缺失率':<10}{'缺失数':<8}{'总数'}")
    for k, v in miss_rate.items():
        print(f"{k:<14}{v:>6.1f}%  {int(v/100*len(raw)):<6}{len(raw)}")

    banner("2b. 数据缺失分析 (cleaned_jobs)")
    for col in ["title", "salary_min", "salary_max", "salary_avg", "city",
                "education", "experience", "requirements", "company", "source", "category_id"]:
        miss = cleaned[col].isna().sum()
        print(f"{col:<14}{miss/len(cleaned)*100:>6.1f}%  缺失 {miss}/{len(cleaned)}")

    print("\n--- cleaned_jobs 各字段取值分布（用于设计默认值）---")
    for col in ["education", "experience", "city", "source"]:
        print(f"\n[{col}]")
        print(cleaned[col].value_counts(dropna=False).to_string())

    # ---------- 3. 技能提取质量 ----------
    banner("3. 技能提取质量分析 (job_skill)")
    print(f"job_skill 关联总条数: {len(skill)}")
    print(f"去重技能数: {skill['skill'].nunique()}")
    print("\n--- job_skill TOP 技能（按频次）---")
    top = skill.groupby("skill")["frequency"].sum().sort_values(ascending=False)
    print(top.to_string())

    print("\n--- 停用词表当前内容 ---")
    sw = q("SELECT word FROM stop_words ORDER BY word")
    print(", ".join(sw["word"].tolist()))

    print("\n--- 技能词典规模与潜在噪声检查 ---")
    print(f"skill_dict 数量: {len(q('SELECT * FROM skill_dict'))}")
    # 以 jieba 对 requirements 分词，列出不命中技能词典的高频 token，作为潜在噪声/补漏
    import jieba
    all_text = " ".join(raw["requirements"].fillna(""))
    toks = [w.strip() for w in jieba.lcut(all_text) if len(w.strip()) >= 2]
    swset = set(sw["word"].tolist())
    skillset = set(q("SELECT skill FROM skill_dict")["skill"].tolist())
    # 注册技能词到 jieba 以免误切
    for s in skillset:
        jieba.add_word(s)
    not_skill = Counter(t for t in toks if t not in skillset)
    print("\n未命中技能词典的高频 token TOP30（候选噪声 / 待补充技能 / 待加入停用词）:")
    for w, n in not_skill.most_common(30):
        in_sw = "停用" if w in swset else ""
        print(f"  {w:<10}{n:>3}  {in_sw}")


if __name__ == "__main__":
    main()