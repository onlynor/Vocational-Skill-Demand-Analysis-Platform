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
    df["title"] = df["title"].replace(synonyms)

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


def save_cleaned(db: Session, df: pd.DataFrame):
    """将清洗结果写入 cleaned_jobs 表，自动匹配 job_category 获取 category_id"""
    titles = set(df["title"].dropna().unique())
    cat_map = {
        r.name: r.id
        for r in db.query(JobCategory).filter(JobCategory.parent_id.isnot(None), JobCategory.name.in_(titles)).all()
    }

    for _, row in df.iterrows():
        job = CleanedJob(
            raw_id=row.get("raw_id"),
            title=row["title"],
            category_id=cat_map.get(row["title"]),
            salary_min=row.get("salary_min"),
            salary_max=row.get("salary_max"),
            salary_avg=row.get("salary_avg"),
            city=row.get("city"),
            education=row.get("education"),
            experience=row.get("experience"),
            requirements=row.get("requirements"),
            company=row.get("company"),
            source=row.get("source"),
        )
        db.add(job)
    db.commit()
