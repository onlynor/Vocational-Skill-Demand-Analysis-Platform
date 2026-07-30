# coding: utf-8
"""Fix synonym_dict: delete wrong entries, then re-run pipeline"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from backend.database import SessionLocal
from backend.models import SynonymDict, CleanedJob, JobSkill, JobCategory

db = SessionLocal()

# ============================================================
# WRONG ENTRIES TO DELETE
# ============================================================
wrong_raw_words = set()

# Group 1: Non-finance "研究员" → 投资分析师 (from audit)
wrong_raw_words.update([
    "化学合成人员/助理研究员",
    "小分子生物分析研究员",
    "食品研究员(J25095)",
    "国际关系研究员",
    "用户研究员",
    "行业助理研究员",
    "【2026春招】战略研究员",
    "心理学研究员",  # mapped to 康复治疗师, also wrong
    "游戏大模型研究员",  # → 游戏策划, not accurate either
])

# Group 2: ORPHAN entries — target std_word doesn't exist in job_category
# Find them by checking
std_titles = {r[0] for r in db.query(JobCategory.name).filter(JobCategory.parent_id.isnot(None)).all()}
orphan_raws = []
for s in db.query(SynonymDict).all():
    if s.std_word not in std_titles:
        orphan_raws.append(s.raw_word)
print(f"Orphans found: {len(orphan_raws)}")
for r in orphan_raws:
    print(f"  ORPHAN: \"{r}\"")
wrong_raw_words.update(orphan_raws)

# Group 3: Clearly wrong cross-industry mappings
cross_industry_wrong = [
    "全屋定制设计师",       # furniture → UI设计师
    "深化设计师",            # construction → UI设计师
    "工装设计师",            # construction → UI设计师
    "方案设计师",            # architecture → UI设计师
    "首饰设计师（电影造型方向）",  # jewelry → 化妆师
    "音乐设计师",            # sound design → 音乐教师
    "轻奢饰品品牌 饰品产品设计师",  # jewelry → 产品经理
    "游戏客服推广",          # customer service → 游戏策划
    "会计事务所审计项目经理",  # accounting → 项目经理(建筑)
    "会计事务所审计项目经理（CPA）",  # accounting → 项目经理(建筑)
    "电商设计师",            # e-commerce design → UI设计师
    "品牌视觉设计师（Brand Visual Designer）",  # visual design → UI设计师
    "建筑设计安全员",        # → 安全员(机械) — should be construction
]
wrong_raw_words.update(cross_industry_wrong)

# Group 4: Dangerously SHORT & too generic (3 chars or fewer, only delete the worst)
# These are ≤3 chars and map to specific things; they'll cause false matches
dangerous_shorts_to_delete = [
    "测试",    # → 硬件测试工程师 — way too broad, matches 软件测试/测试开发 etc.
    "工程师",  # → 嵌入式软件工程师 — absurdly broad
    "销售",    # → 医疗器械销售 — too broad
    "设计",    # → 平面设计师 — too broad
    "运营",    # → 新媒体运营 — too broad
    "商务",    # → 市场专员 — too broad
    "检测",    # → 质检员 — too broad
    "顾问",    # → 客服专员 — too broad
    "正式工",  # → 电子工程师 — flat out wrong
    "专员",    # → 物流调度专员 — meaningless
    "小学",    # → 数学教师 — absurd
    "生会计",  # → 会计 — typo that would match anything with "会计"
    "电子厂",  # → 电子工程师 — wrong
]
wrong_raw_words.update(dangerous_shorts_to_delete)

# ============================================================
# EXECUTE DELETION
# ============================================================
total_deleted = 0
for raw_word in sorted(wrong_raw_words):
    result = db.query(SynonymDict).filter(SynonymDict.raw_word == raw_word).delete()
    if result:
        total_deleted += result
        print(f"DELETED: \"{raw_word}\"")

db.commit()
print(f"\nTotal synonym entries deleted: {total_deleted}")

# ============================================================
# CLEAN affected cleaned_jobs and job_skill
# ============================================================

# The issue: some cleaned_jobs got wrong titles due to these synonyms.
# The simplest fix: delete those cleaned_jobs and re-pipeline from raw.
# But we should also handle the case where data was imported from Excel.
#
# Approach: delete all cleaned_jobs + job_skill, then re-run pipeline.
# The pipeline will re-read raw_jobs and re-clean with corrected synonyms.

# Count current state
from sqlalchemy import func
job_count = db.query(func.count(CleanedJob.id)).scalar()
skill_count = db.query(func.count(JobSkill.id)).scalar()
print(f"\nBefore cleanup: {job_count} cleaned_jobs, {skill_count} job_skills")

# Delete all job_skill and cleaned_jobs
db.query(JobSkill).delete()
db.query(CleanedJob).delete()
db.commit()
print("Cleared cleaned_jobs and job_skill tables")

db.close()
print("\nCleanup complete. Ready to re-run pipeline.")
