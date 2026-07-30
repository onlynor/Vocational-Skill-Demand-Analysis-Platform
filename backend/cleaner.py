"""Pandas 数据清洗模块"""
import pandas as pd
from sqlalchemy.orm import Session
from .models import RawJob, CleanedJob, SynonymDict, JobCategory


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


def clean(df: pd.DataFrame, synonyms: dict[str, str]) -> pd.DataFrame:
    if df.empty:
        return df

    df = df.copy()

    # 1. 同义词统一
    df["title"] = df["title"].str.strip()
    # Use exact matching first
    df["title"] = df["title"].replace(synonyms)
    # Then case-insensitive: check every title against every synonym manually
    # (pandas .map + .str.lower seemed to have issues with CJK characters)
    ci_lookup = {raw.lower(): std for raw, std in synonyms.items()}
    for i, title in enumerate(df["title"]):
        if isinstance(title, str) and title.lower() in ci_lookup:
            df.at[i, "title"] = ci_lookup[title.lower()]

    # Fallback: for titles that weren't replaced, try finding
    # a standard title as substring (longest match wins).
    # This handles "9k+/周末双休/五险人力资源专员" → "人事专员"
    standard_titles = set(ci_lookup.values())
    unmapped = ~df["title"].str.lower().isin({s.lower() for s in standard_titles})

    def _fuzzy_match(title):
        if not isinstance(title, str):
            return title
        t = title.lower()
        best_std, best_len = None, 0
        for raw_lower, std in ci_lookup.items():
            if len(raw_lower) >= 4 and raw_lower in t and len(raw_lower) > best_len:
                best_std = std
                best_len = len(raw_lower)
        return best_std if best_std else title

    if unmapped.any():
        df.loc[unmapped, "title"] = df.loc[unmapped, "title"].apply(_fuzzy_match)

    # 2. 去重（title + city + company 完全相同 → 只保留第一条）
    df = df.drop_duplicates(subset=["title", "city", "company"], keep="first")

    # 3. 薪资格式统一：字符串 → 数字
    salary_df = df["salary_text"].apply(_parse_salary)
    df[["salary_min", "salary_max", "salary_avg"]] = salary_df

    # 4. 标记来源
    df["raw_id"] = df["id"]
    df = df.drop(columns=["id"])

    return df


def _parse_salary(text: str | None):
    """将 '20K-30K' 或 '15000-20000' 解析为 (min, max, avg)"""
    if pd.isna(text) or not text or not isinstance(text, str):
        return pd.Series([None, None, None])
    try:
        t = text.lower().replace("k", "000").replace("万", "0000").strip()
        parts = t.split("-")
        if len(parts) != 2:
            return pd.Series([None, None, None])
        lo = int(float(parts[0]))
        hi = int(float(parts[1]))
        return pd.Series([lo, hi, (lo + hi) // 2])
    except (ValueError, AttributeError):
        return pd.Series([None, None, None])


def _none_if_nan(val):
    if val is None:
        return None
    if isinstance(val, float) and pd.isna(val):
        return None
    return val


def save_cleaned(db: Session, df: pd.DataFrame):
    """将清洗结果写入 cleaned_jobs 表，自动匹配 job_category 获取 category_id"""
    # Build bidirectional maps for case-insensitive matching
    titles_set = set(df["title"].dropna().unique())
    title_lower_to_original = {t.lower(): t for t in titles_set}

    all_cats = db.query(JobCategory).filter(JobCategory.parent_id.isnot(None)).all()
    # cat_map: original category name -> id
    cat_map = {}
    for r in all_cats:
        cat_map[r.name] = r.id
        # Also map lowercased name for case-insensitive lookup
        if r.name.lower() != r.name:
            cat_map[r.name.lower()] = r.id

    # Build lookup: for each job title (lowercased), find matching category
    title_to_cat = {}
    for t in titles_set:
        tl = t.lower()
        if t in cat_map:
            title_to_cat[t] = cat_map[t]
        elif tl in cat_map:
            title_to_cat[t] = cat_map[tl]

    for _, row in df.iterrows():
        job = CleanedJob(
            raw_id=_none_if_nan(row.get("raw_id")),
            title=row["title"],
            category_id=title_to_cat.get(row["title"]),
            salary_min=_none_if_nan(row.get("salary_min")),
            salary_max=_none_if_nan(row.get("salary_max")),
            salary_avg=_none_if_nan(row.get("salary_avg")),
            city=row.get("city"),
            education=row.get("education"),
            experience=row.get("experience"),
            requirements=row.get("requirements"),
            company=row.get("company"),
            source=row.get("source"),
        )
        db.add(job)
    db.commit()
