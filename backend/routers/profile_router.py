from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from collections import Counter
from ..database import get_db
from ..schemas import (
    SkillRankItem, SkillSalaryItem, CityDemandItem,
    EducationPieItem, SkillMatchRequest, SkillMatchItem,
    JobCategoryItem, JobTreeLeaf, JobProfileItem,
)
from ..models import CleanedJob, JobSkill, SkillDict, JobCategory, SkillSynonym

router = APIRouter(prefix="/api/profile", tags=["职业画像"])


@router.get("/skills/rank", response_model=list[SkillRankItem])
def skill_rank(db: Session = Depends(get_db)):
    rows = (
        db.query(JobSkill.skill, func.sum(JobSkill.frequency).label("total"))
        .group_by(JobSkill.skill)
        .order_by(func.sum(JobSkill.frequency).desc())
        .limit(20)
        .all()
    )
    result = []
    for skill, total in rows:
        cat = db.query(SkillDict.category).filter(SkillDict.skill == skill).scalar()
        result.append(SkillRankItem(skill=skill, category=cat or "", frequency=total))
    return result


@router.get("/skills/salary", response_model=list[SkillSalaryItem])
def skill_salary(db: Session = Depends(get_db)):
    rows = (
        db.query(
            JobSkill.skill,
            func.avg(CleanedJob.salary_avg).label("avg_sal"),
            func.count(func.distinct(CleanedJob.id)).label("cnt"),
        )
        .join(CleanedJob, JobSkill.cleaned_job_id == CleanedJob.id)
        .filter(CleanedJob.salary_avg.isnot(None))
        .group_by(JobSkill.skill)
        .having(func.count(func.distinct(CleanedJob.id)) >= 3)
        .order_by(func.avg(CleanedJob.salary_avg).desc())
        .all()
    )
    return [
        SkillSalaryItem(skill=s, avg_salary=round(float(a), 0), job_count=c)
        for s, a, c in rows
    ]


@router.get("/cities", response_model=list[CityDemandItem])
def city_demand(db: Session = Depends(get_db)):
    rows = (
        db.query(CleanedJob.city, func.count(CleanedJob.id))
        .filter(CleanedJob.city.isnot(None))
        .group_by(CleanedJob.city)
        .order_by(func.count(CleanedJob.id).desc())
        .all()
    )
    return [CityDemandItem(city=c, job_count=n) for c, n in rows]


@router.get("/education", response_model=list[EducationPieItem])
def education_distribution(db: Session = Depends(get_db)):
    rows = (
        db.query(CleanedJob.education, func.count(CleanedJob.id))
        .filter(CleanedJob.education.isnot(None))
        .group_by(CleanedJob.education)
        .all()
    )
    return [EducationPieItem(education=e, job_count=n) for e, n in rows]


@router.post("/skills/match", response_model=list[SkillMatchItem])
def skill_match(body: SkillMatchRequest, db: Session = Depends(get_db)):
    if not body.skills:
        return []

    # 1. 收集用户技能的标准名（走 skill_synonym 归一），在 skill_dict 中的才是真技能
    user_raw = {s.strip() for s in body.skills if s.strip()}
    if not user_raw:
        return []
    syn_pairs = db.query(SkillSynonym).all()
    syn_map = {r.raw_word.lower(): r.std_word for r in syn_pairs}
    user_std = set()
    for s in user_raw:
        user_std.add(syn_map.get(s.lower(), s))
    user_std_lower = {s.lower() for s in user_std}

    # 2. 行业过滤：若指定 industry，收集该行业下所有 category_id
    cat_ids = None
    if body.industry:
        industry = db.query(JobCategory).filter(
            JobCategory.parent_id.is_(None),
            JobCategory.name == body.industry,
        ).first()
        if not industry:
            return []
        cat_ids = {r[0] for r in db.query(JobCategory.id)
                             .filter(JobCategory.parent_id == industry.id).all()}

    # 3. 从 job_skill 反查命中用户技能的岗位（不再用 limit(200) 截断全表）
    skill_rows = db.query(JobSkill).filter(JobSkill.skill.in_(list(user_std))).all()
    job_skill_map: dict[int, set[str]] = {}
    for r in skill_rows:
        if r.skill.lower() not in user_std_lower:
            continue  # 同义词归一后只保留用户输入的真技能（大小写不敏感）
        job_skill_map.setdefault(r.cleaned_job_id, set()).add(r.skill)
    if not job_skill_map:
        return []

    # 4. 关联 cleaned_jobs 取详情，并拉取每个岗位全部技能做完整交集/差集
    job_ids = list(job_skill_map.keys())
    jobs = db.query(CleanedJob).filter(CleanedJob.id.in_(job_ids)).all()
    if cat_ids is not None:
        jobs = [j for j in jobs if j.category_id in cat_ids]
    if not jobs:
        return []
    full_job_ids = [j.id for j in jobs]
    all_skill_rows = db.query(JobSkill).filter(JobSkill.cleaned_job_id.in_(full_job_ids)).all()
    full_skills: dict[int, set[str]] = {}
    for r in all_skill_rows:
        full_skills.setdefault(r.cleaned_job_id, set()).add(r.skill)

    results = []
    for job in jobs:
        all_set = full_skills.get(job.id, set())
        if not all_set:
            continue
        all_lower = {s.lower() for s in all_set}
        matched_lower = user_std_lower & all_lower
        if not matched_lower:
            continue
        matched = {s for s in all_set if s.lower() in matched_lower}
        missing = all_set - matched
        results.append({
            "title": job.title,
            "company": job.company or "",
            "city": job.city or "",
            "salary_avg": job.salary_avg or 0,
            "matched_count": len(matched),
            "matched_skills": sorted(matched),
            "missing_skills": sorted(missing),
        })

    results.sort(key=lambda x: x["matched_count"], reverse=True)
    return [
        SkillMatchItem(
            title=r["title"], company=r["company"], city=r["city"],
            salary_avg=r["salary_avg"], matched_skills=r["matched_skills"],
            missing_skills=r["missing_skills"],
         )
        for r in results[:20]
    ]


@router.get("/jobs/tree", response_model=list[JobCategoryItem])
def job_tree(db: Session = Depends(get_db)):
    industries = (
        db.query(JobCategory)
        .filter(JobCategory.parent_id.is_(None))
        .order_by(JobCategory.sort_order)
        .all()
    )
    # 按 category_id 计数（数据驱动分类后真实落点），而非标题字符串相等
    cat_counts = dict(
        db.query(CleanedJob.category_id, func.count(CleanedJob.id))
        .filter(CleanedJob.category_id.isnot(None))
        .group_by(CleanedJob.category_id).all()
    )
    tree = []
    for ind in industries:
        children = (
            db.query(JobCategory)
            .filter(JobCategory.parent_id == ind.id)
            .order_by(JobCategory.sort_order)
            .all()
        )
        jobs = [
            JobTreeLeaf(name=ch.name, count=cat_counts.get(ch.id, 0))
            for ch in children
        ]
        tree.append(JobCategoryItem(category=ind.name, jobs=jobs))
    return tree


@router.get("/jobs/{title}", response_model=JobProfileItem)
def job_profile(title: str, db: Session = Depends(get_db)):
    jobs = db.query(CleanedJob).filter(CleanedJob.title == title).all()
    if not jobs:
        raise HTTPException(status_code=404, detail=f"未找到职位: {title}")

    job_ids = [j.id for j in jobs]
    job_count = len(jobs)

    salaries = [j.salary_avg for j in jobs if j.salary_avg]
    avg_salary = int(sum(salaries) / len(salaries)) if salaries else 0
    salary_min = min((j.salary_min for j in jobs if j.salary_min), default=0)
    salary_max = max((j.salary_max for j in jobs if j.salary_max), default=0)

    city_counter = Counter(j.city for j in jobs if j.city)
    cities = [{"name": c, "value": n} for c, n in city_counter.most_common()]

    edu_counter = Counter(j.education for j in jobs if j.education)
    education = [{"name": e, "value": n} for e, n in edu_counter.most_common()]

    skills = (
        db.query(JobSkill.skill, func.sum(JobSkill.frequency).label("total"))
        .filter(JobSkill.cleaned_job_id.in_(job_ids))
        .group_by(JobSkill.skill)
        .order_by(func.sum(JobSkill.frequency).desc())
        .limit(20).all()
    )
    top_skills = [{"name": s, "value": int(f)} for s, f in skills]

    companies = sorted({j.company for j in jobs if j.company})

    return JobProfileItem(
        title=title,
        job_count=job_count,
        avg_salary=avg_salary,
        salary_min=salary_min,
        salary_max=salary_max,
        cities=cities,
        education=education,
        top_skills=top_skills,
        companies=companies,
    )
