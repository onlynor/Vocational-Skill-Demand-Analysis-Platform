"""Pandas 数据清洗模块"""
import re
import pandas as pd
from sqlalchemy.orm import Session
from .models import RawJob, CleanedJob, SynonymDict, JobCategory

# ---------- 垃圾标题识别（BOSS 直聘广告话术/钓饵，非真实岗位）----------
# 判定为垃圾 → 从 cleaned_jobs 剔除（raw_jobs 保留作原始记录）。
# 依据 raw_jobs 真实数据中「其他」行业下标题的人工分析。
_GARBAGE_KEYWORDS = [
    # 薪资诱惑/日结/时薪
    "月入", "月底薪", "起薪", "保底", "无责底薪", "日结", "管吃住", "包吃住",
    "包食宿", "包吃", "包住", "包餐", "免费住宿", "提供住宿", "提供食宿",
    "日薪", "元/天", "/天", "元/时", "包四人间", "可带手机", "不体检",
    "不穿无尘服", "坐班", "坐岗", "长白班", "两班倒", "穿无尘服", "可调岗",
    "五险一金", "六险一金", "六险", "七险二金", "13薪", "14薪", "15薪",
    "16薪", "年底双薪", "节假日全休", "法休", "带薪假", "带薪培", "带薪培训",
    "干到退休", "可以做到养老", "可干到退休", "到点走", "到点就走",
    "可预支", "人走账清", "下班就清账", "不加班", "不卡人", "不收学生",
    "无经验可", "接受小白", "可小白", "小白可", "接受应届", "应届生小白",
    "勿扰", "学生勿扰", "非中介", "厂区直签", "直签", "官方认证",
    "加微信", "面试就上", "免费培训", "起航文化", "学生勿扰",
    # 宣传情绪词
    "超轻松", "轻松坐岗", "轻松无压力", "稳定岗", "高薪", "急招双休",
    "底薪", "试用期", "实习岗", "永久", "找徒弟", "一起挣",
    "小时制", "养老", "保底", "十点上班", "二点下班", "四点下班",
]
# 纯薪资/数字开头（如「240/天...」「8K外企...」「7000+...」「8000/月...」）
_GARBAGE_NUM_PREFIX = re.compile(
    r"^[\s\W]*([0-9]+\s*[kK元/]|几K|[0-9]+\+|底薪[0-9]|月薪[0-9]|月薪[0-9])"
)
# 全是话术标志词/括号/数字，无任何真实职能词的强信号
_GARBAGE_FORCE = re.compile(
    r"(外企|双休|国企|央企|体制|上市|五百强|500强|厂直招|电子厂|食品厂|新能源厂|"
    r"不加班|不体检|包吃住|包吃|包住|坐岗|坐班|长白班|月入|无责|底薪|五险|六险|"
    r"13薪|14薪|朝九晚|早九晚|接受应届|接受小白|可带手机|可跨行)"
)


def _is_garbage_title(title: str) -> bool:
    if not title or not str(title).strip():
        return True
    t = str(title).strip()
    # 1. 纯数字/薪资开头 + 任何诱惑词 → 垃圾
    if _GARBAGE_NUM_PREFIX.match(t):
        return True
    # 2. 同时出现「强力话术标志」+「薪资/待遇诱惑词」→ 垃圾
    has_force = bool(_GARBAGE_FORCE.search(t))
    if has_force and any(k in t for k in _GARBAGE_KEYWORDS):
        return True
    # 3. 开头是括号/方括号营销引导（如「【xx】...」「（周末双休）...」）且含强话术 → 垃圾
    if re.match(r"^[（(【\[‼️]", t) and has_force:
        return True
    # 4. 含 3 种以上话术词 → 垃圾（降低阈值，覆盖专营话术标题）
    cnt = sum(1 for k in _GARBAGE_KEYWORDS if k in t)
    if cnt >= 3:
        return True
    # 5. 标题主体就是营销组合：开头/结尾是外企/双休/国企单独成词或叠加 → 垃圾
    if _GARBAGE_FORCE.search(t) and any(k in t for k in (
        "双休", "955", "早九晚", "朝九晚", "五险", "六险", "底薪", "300", "280", "260", "8k", "9k", "9K", "7k", "6k", "7500", "7000", "8000", "6000", "8K", "7K", "6K"
    )):
        return True
    # 6. 试用期 + 数字 / X小时制（纯薪资话术）→ 垃圾
    if re.search(r"试用期\s*[0-9]+", t) or "小时制" in t:
        return True
    # 7. 以「外企」「双休」「国企」开头且 ñ标点/数字叠加 → 垃圾
    if re.match(r"^(外企|双休|国企|央企|体制|上市|五百强|500强|AI机器人外企)\W", t) and any(
        k in t for k in ("双休", "薪", "休", "养老", "底薪", "955", "小时", "朝九晚", "早九晚")
    ):
        return True
    # 8. 保底/免费培训等单独话术 → 垃圾
    if any(k in t for k in ("保底", "免费培训", "起航文化", "十点上班", "可转正编")):
        return True
    return False


def load_raw_jobs(db: Session) -> pd.DataFrame:
    rows = db.query(RawJob).all()
    if not rows:
        return pd.DataFrame()
    return pd.DataFrame([{
        "id": r.id, "title": r.title, "salary_text": r.salary_text,
        "city": r.city, "education": r.education,
        "experience": r.experience, "requirements": r.requirements,
        "company": r.company, "source": r.source,
    } for r in rows])


def load_synonyms(db: Session) -> dict[str, str]:
    rows = db.query(SynonymDict).all()
    return {r.raw_word: r.std_word for r in rows}


# 经验原文归一映射："3年经验" -> "3年"，"经验不限" -> "不限经验"
_EXP_SUFFIX = re.compile(r"经验$")
_EXP_NORMALIZE = {
    "经验不限": "不限经验", "不限": "不限经验",
    "无经验": "不限经验", "应届生": "不限经验",
}
# 学历原文归一
_EDU_NORMALIZE = {
    "大学本科": "本科", "统招本科": "本科", "本科及以上": "本科",
    "大专及以上": "大专", "专科": "大专", "中专": "中专/中技",
    "中技": "中专/中技", "硕士及以上": "硕士", "研究生": "硕士",
    "学历不限": "不限", "不限学历": "不限",
}


def _normalize_experience(val):
    if val is None or (isinstance(val, float) and pd.isna(val)) or not str(val).strip():
        return "不限经验"
    s = str(val).strip()
    s = _EXP_NORMALIZE.get(s, s)
    s = _EXP_SUFFIX.sub("", s).strip() or s
    return s or "不限经验"


def _normalize_education(val):
    if val is None or (isinstance(val, float) and pd.isna(val)) or not str(val).strip():
        return "不限"
    s = str(val).strip()
    return _EDU_NORMALIZE.get(s, s)


def _default_or(val, default):
    if val is None or (isinstance(val, float) and pd.isna(val)) or not str(val).strip():
        return default
    return val


def clean(df: pd.DataFrame, synonyms: dict[str, str]) -> pd.DataFrame:
    if df.empty:
        return df

    df = df.copy()

    # 1. 同义词统一（用于标题展示对齐，分类不再依赖它）
    df["title"] = df["title"].replace(synonyms)

    # 2. 剔除垃圾标题（广告话术/钓饵，非真实岗位）——raw_jobs 保留，仅从 cleaned 剔除
    before = len(df)
    df = df[~df["title"].apply(_is_garbage_title)].copy()
    removed_garbage = before - len(df)

    # 3. 去重（title + city + company 完全相同 → 只保留第一条）
    df = df.drop_duplicates(subset=["title", "city", "company"], keep="first")

    # 3. 字段归一 + 缺失默认值（不删除数据，仅缺失/异写时填充）
    df["education"] = df["education"].apply(_normalize_education)
    df["experience"] = df["experience"].apply(_normalize_experience)
    df["city"] = df["city"].apply(lambda v: _default_or(v, "未知"))
    df["company"] = df["company"].apply(lambda v: _default_or(v, "未知"))
    df["source"] = df["source"].apply(lambda v: _default_or(v, "未知"))
    df["requirements"] = df["requirements"].apply(lambda v: _default_or(v, ""))

    # 4. 薪资格式统一：字符串 → 数字（解析失败保留 None，不写 NaN）
    salary_df = df["salary_text"].apply(_parse_salary)
    df[["salary_min", "salary_max", "salary_avg"]] = salary_df

    # 5. 标记来源
    df["raw_id"] = df["id"]
    df = df.drop(columns=["id"])

    df.attrs["garbage_removed"] = int(removed_garbage)
    return df


def _parse_salary(text: str | None):
    """将 '20K-30K' 或 '15000-20000' 解析为 (min, max, avg)"""
    if pd.isna(text) or not text or not isinstance(text, str):
        return pd.Series([None, None, None])
    try:
        t = str(text).lower().replace("k", "000").replace("万", "0000").strip()
        # 面议 / 元天 / 元时等异常薪资 → 返回 None（不编造数值，避免污染薪资统计）
        if any(kw in t for kw in ("面议", "面谈", "元/天", "元/时", "元/小时", "元/月")):
            return pd.Series([None, None, None])
        parts = re.split(r"[-~至]", t)
        if len(parts) != 2:
            return pd.Series([None, None, None])
        lo = int(float(parts[0]))
        hi = int(float(parts[1]))
        return pd.Series([lo, hi, (lo + hi) // 2])
    except (ValueError, AttributeError):
        return pd.Series([None, None, None])


def _other_fallback_factory(db: Session, classifier):
    """返回 (title -> category_id) 函数：未命中规则时，在「其他」行业下按 title
    具名 get-or-create 二级节点，使每个未分类职业都有独立细分节点。"""
    other_id = classifier.other_industry_id
    cache: dict[str, int] = {}
    if other_id is None:
        def _no_fallback(title, req):
            return None
        return _no_fallback

    def _max_sort(pid):
        rows = db.query(JobCategory.sort_order).filter(JobCategory.parent_id == pid).all()
        return max([r[0] for r in rows] + [0]) + 1

    def _fallback(title, req):
        title = (title or "").strip() or "未命名岗位"
        if title in cache:
            return cache[title]
        node = db.query(JobCategory).filter(
            JobCategory.parent_id == other_id, JobCategory.name == title
        ).first()
        if node is None:
            node = JobCategory(name=title, parent_id=other_id, sort_order=_max_sort(other_id))
            db.add(node); db.flush()
        cache[title] = node.id
        return node.id
    return _fallback


def save_cleaned(db: Session, df: pd.DataFrame, classifier):
    """将清洗结果写入 cleaned_jobs 表，用数据驱动分类器赋 category_id。
    未命中规则的岗位按细分为「其他」行业下以原始标题命名的二级节点。"""
    fallback = _other_fallback_factory(db, classifier)
    for _, row in df.iterrows():
        title = row["title"]
        cid = classifier.classify(title, row.get("requirements"))
        if cid is None:
            cid = fallback(title, row.get("requirements"))
        job = CleanedJob(
            raw_id=row.get("raw_id"),
            title=title,
            category_id=cid,
            salary_min=_to_int(row.get("salary_min")),
            salary_max=_to_int(row.get("salary_max")),
            salary_avg=_to_int(row.get("salary_avg")),
            city=row.get("city"),
            education=row.get("education"),
            experience=row.get("experience"),
            requirements=row.get("requirements"),
            company=row.get("company"),
            source=row.get("source"),
        )
        db.add(job)
    db.commit()


def _to_int(val):
    if val is None or (isinstance(val, float) and pd.isna(val)):
        return None
    try:
        return int(val)
    except (ValueError, TypeError):
        return None
