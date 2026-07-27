"""
完整数据处理管道：raw_jobs → cleaned_jobs → job_skill
或 Excel 直接导入 → 分词

用法：
  python -m backend.pipeline                           # 从 raw_jobs 走完整清洗流程
  python -m backend.pipeline --reset --industry "计算机/互联网"
  python -m backend.pipeline --import-file data.xlsx   # Excel 直接导入 + 分词
  python -m backend.pipeline --import-file data.xlsx --reset
"""
import argparse
import sys
import os
import pandas as pd

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from .database import SessionLocal
from .models import CleanedJob, JobSkill
from .cleaner import load_raw_jobs, load_synonyms, clean, save_cleaned
from .segmenter import process_all_jobs


REQUIRED_COLUMNS = [
    "title",
    "city", "education", "experience", "requirements",
    "company", "source",
    "salary_min", "salary_max", "salary_avg",
]


def reset_tables(db):
    db.query(JobSkill).delete()
    db.query(CleanedJob).delete()
    db.commit()
    print("已清空 cleaned_jobs / job_skill 表")


def import_from_excel(db, filepath: str):
    """从 Excel/CSV 直接导入 cleaned_jobs，跳过 raw_jobs 和清洗步骤"""
    if filepath.endswith(".csv"):
        df = pd.read_csv(filepath)
    else:
        df = pd.read_excel(filepath)

    missing = [c for c in REQUIRED_COLUMNS if c not in df.columns]
    if missing:
        print(f"错误：缺少列 {missing}")
        print(f"需要的列：{REQUIRED_COLUMNS}")
        return 0

    # 构建 title → category_id 映射
    from .models import JobCategory
    titles = set(df["title"].dropna().unique())
    cat_map = {
        r.name: r.id
        for r in db.query(JobCategory).filter(JobCategory.parent_id.isnot(None), JobCategory.name.in_(titles)).all()
    }

    count = 0
    for _, row in df.iterrows():
        job = CleanedJob(
            title=row["title"],
            category_id=cat_map.get(row["title"]),
            city=row.get("city"),
            education=row.get("education"),
            experience=row.get("experience"),
            requirements=row.get("requirements"),
            company=row.get("company"),
            source=row.get("source"),
            salary_min=_to_int(row.get("salary_min")),
            salary_max=_to_int(row.get("salary_max")),
            salary_avg=_to_int(row.get("salary_avg")),
        )
        db.add(job)
        count += 1

    db.commit()
    print(f"从 {os.path.basename(filepath)} 导入 {count} 条数据到 cleaned_jobs")
    return count


def _to_int(val):
    if val is None or (isinstance(val, float) and pd.isna(val)):
        return None
    try:
        return int(val)
    except (ValueError, TypeError):
        return None


def run():
    parser = argparse.ArgumentParser(description="招聘数据处理管道")
    parser.add_argument("--reset", action="store_true", help="清空清洗表后重新处理")
    parser.add_argument("--import-file", type=str, default=None, help="从 Excel/CSV 直接导入（跳过 raw_jobs）")
    args = parser.parse_args()

    db = SessionLocal()

    try:
        if args.import_file:
            if args.reset:
                reset_tables(db)
            n = import_from_excel(db, args.import_file)
            if n > 0:
                total = process_all_jobs(db)
                print(f"分词完成，共提取 {total} 条技能关联")
            print("\n导入完毕。")

        else:
            # 原有流程：raw_jobs → 清洗 → 分词
            if args.reset:
                reset_tables(db)

            df = load_raw_jobs(db)
            print(f"① 从 raw_jobs 读取 {len(df)} 条原始数据")

            if df.empty:
                print("无原始数据，管道结束。")
                return

            synonyms = load_synonyms(db)
            print(f"② 加载 {len(synonyms)} 条同义词规则")
            cleaned_df = clean(df, synonyms)
            print(f"③ 清洗完成，剩余 {len(cleaned_df)} 条（去重 {len(df) - len(cleaned_df)} 条）")

            save_cleaned(db, cleaned_df)
            print("④ 清洗数据已写入 cleaned_jobs 表")

            total = process_all_jobs(db)
            print(f"⑤ 分词完成，共提取 {total} 条技能关联")

            print("\n管道执行完毕。")
    finally:
        db.close()


if __name__ == "__main__":
    run()
