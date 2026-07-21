"""完整流程演示：原始数据 → 清洗 → 分词 → 技能统计"""

# ============================================================
# 第一步：模拟爬虫抓取的原始数据
# ============================================================
print("=" * 60)
print("第一步：SCrapy 爬取原始数据 → 存入 raw_jobs 表")
print("=" * 60)

raw_jobs = [
    {
        "id": 1, "title": "Python开发工程师", "salary_text": "20K-30K",
        "city": "上海", "education": "本科", "experience": "3年经验",
        "requirements": "熟悉Python开发，掌握MySQL，了解Redis",
        "company": "XX科技", "source": "BOSS直聘"
    },
    {
        "id": 2, "title": "Python开发", "salary_text": "15000-20000",
        "city": "上海", "education": None, "experience": "3年经验",
        "requirements": "熟悉Python开发，掌握MySQL",
        "company": "YY软件", "source": "拉勾"
    },
    {
        "id": 3, "title": "Python开发工程师", "salary_text": "20K-30K",
        "city": "上海", "education": "本科", "experience": "3年经验",
        "requirements": "熟悉Python开发，掌握MySQL，了解Redis",
        "company": "XX科技", "source": "智联招聘"  # ← 和 id=1 重复
    },
    {
        "id": 4, "title": "Java开发", "salary_text": "25k-35k",
        "city": "北京", "education": "硕士", "experience": "5年",
        "requirements": "精通Java，熟悉Spring Boot，了解微服务架构，掌握MySQL",
        "company": "ZZ网络", "source": "BOSS直聘"
    },
]

print("\n原始数据（共 {} 条）：".format(len(raw_jobs)))
for row in raw_jobs:
    print(f"  [{row['id']}] {row['title']} | {row['salary_text']} | {row['city']} | {row['education']} | {row['company']} | {row['source']}")
    print(f"      要求: {row['requirements']}")


# ============================================================
# 第二步：Pandas 数据清洗
# ============================================================
print("\n" + "=" * 60)
print("第二步：Pandas 数据清洗 → 存入 cleaned_jobs 表")
print("=" * 60)

import pandas as pd
df = pd.DataFrame(raw_jobs)

# 2.1 同义词映射表
synonym_dict = {
    "Python开发工程师": "Python开发",
    "Java开发工程师": "Java开发",
}
print("\n① 同义词字典:", synonym_dict)

# 同义词统一
df["title"] = df["title"].replace(synonym_dict)
print("\n② 同义词统一后：")
print(df[["id", "title"]].to_string())

# 2.2 去重（title + city + company 全相同 → 保留第一条）
before = len(df)
df = df.drop_duplicates(subset=["title", "city", "company"], keep="first")
after = len(df)
removed = before - after
print(f"\n③ 去重（title + city + company 全匹配）：删除 {removed} 条重复记录")
print(f"   已删除 id=3（与 id=1 岗位名/城市/公司完全相同，去重）")

# 2.3 缺失值处理
null_before = df["education"].isna().sum()
print(f"\n④ 缺失值处理：education 有 {null_before} 处缺失（id=2），填 NULL 保留")

# 2.4 薪资格式统一（字符串 → 数字）
def parse_salary(text):
    parts = text.lower().replace("k", "000").split("-")
    lo = int(parts[0])
    hi = int(parts[1])
    return pd.Series([lo, hi, (lo + hi) // 2])

df[["salary_min", "salary_max", "salary_avg"]] = df["salary_text"].apply(parse_salary)

print("\n⑤ 薪资格式统一后：")
print(df[["id", "title", "salary_text", "salary_min", "salary_max", "salary_avg", "education"]].to_string())


# ============================================================
# 第三步：Jieba 分词 + 停用词 + 技能词典 → 技能频次
# ============================================================
print("\n" + "=" * 60)
print("第三步：Jieba 分词 + 停用词过滤 + 技能词典匹配")
print("=" * 60)

import jieba

# 将技能词典注册到 jieba（中文复合词如"微服务"需此步骤，英文带空格的由 _merge_compound_words 处理）


def _merge_compound_words(words, skill_set):
    """合并相邻 token 为复合技能词（如 'Spring'+'Boot' → 'Spring Boot'）"""
    compounds = sorted([s for s in skill_set if " " in s], key=lambda x: x.count(" "), reverse=True)
    if not compounds:
        return words
    compound_tokens = {c: tuple(c.split(" ")) for c in compounds}
    result = []
    i = 0
    while i < len(words):
        matched = False
        for compound, tokens in compound_tokens.items():
            n = len(tokens)
            if i + n <= len(words) and tuple(words[i : i + n]) == tokens:
                result.append(compound)
                i += n
                matched = True
                break
        if not matched:
            result.append(words[i])
            i += 1
    return result


stop_words = {"熟悉", "掌握", "了解", "精通", "，", "。", "、", " "}
skill_dict = {
    "Python": "编程语言",
    "MySQL": "数据库",
    "Redis": "数据库",
    "Java": "编程语言",
    "Spring Boot": "框架",
    "微服务": "架构",
}

print("停用词:", stop_words)
print("技能词典:", skill_dict)

for word in skill_dict:
    jieba.add_word(word)

print("\n逐条处理：")
for _, row in df.iterrows():
    print(f"\n  岗位「{row['title']}」(id={row['id']})")
    req = row["requirements"]
    print(f"    原文: {req}")

    # 分词
    words = jieba.lcut(req)
    print(f"    分词: {words}")

    # 去停用词
    filtered = [w for w in words if w not in stop_words]
    print(f"    去停用词: {filtered}")

    # 匹配技能词典
    merged = _merge_compound_words(filtered, set(skill_dict.keys()))
    skills = [w for w in merged if w in skill_dict]
    print(f"    命中技能: {skills}")

    # 统计频次
    if skills:
        from collections import Counter
        freq = Counter(skills)
        print(f"    频次统计 → 存入 job_skill 表:")
        for s, c in freq.items():
            print(f"      {s}({skill_dict[s]}) × {c}")
    else:
        print("    → 无匹配技能")


# ============================================================
# 汇总结果
# ============================================================
print("\n" + "=" * 60)
print("最终存入库中的数据总览")
print("=" * 60)

print(f"\nraw_jobs:      {before} 条原始数据")
print(f"cleaned_jobs:  {after} 条清洗后数据（去重 {removed} 条）")

# 模拟 job_skill 表
print("\njob_skill 表内容:")
job_skill_data = [
    (1, "Python", 1),
    (1, "MySQL", 1),
    (1, "Redis", 1),
    (2, "Python", 1),
    (2, "MySQL", 1),
    (4, "Java", 1),
    (4, "Spring Boot", 1),
    (4, "MySQL", 1),
    (4, "微服务", 1),
]
for cleaned_job_id, skill, freq in job_skill_data:
    label = "python开发" if cleaned_job_id <= 2 else "Java开发"
    print(f"  [{cleaned_job_id}] {label} → {skill} × {freq}")

print("\n以上就是从爬取到入库的完整数据流。")
