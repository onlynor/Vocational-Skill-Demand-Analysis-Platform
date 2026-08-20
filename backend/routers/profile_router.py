from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from ..auth import get_current_username
from ..database import get_db
from ..schemas import (
    SkillRankItem, SkillSalaryItem, CityDemandItem,
    EducationPieItem, SkillMatchRequest, SkillMatchItem,
    JobCategoryItem, JobTreeLeaf, JobProfileItem,
)
from ..models import CleanedJob, JobSkill, SkillDict, JobCategory

# Router-level dependency: every /api/profile/* route requires a valid JWT.
router = APIRouter(
    prefix="/api/profile",
    tags=["职业画像"],
    dependencies=[Depends(get_current_username)],
)


@router.get("/skills/rank", response_model=list[SkillRankItem])
def skill_rank(db: Session = Depends(get_db)):
    rows = (
        db.query(JobSkill.skill, func.sum(JobSkill.frequency).label("total"), SkillDict.category)
        .outerjoin(SkillDict, SkillDict.skill == JobSkill.skill)
        .group_by(JobSkill.skill, SkillDict.category)
        .order_by(func.sum(JobSkill.frequency).desc())
        .limit(20)
        .all()
    )
    return [
        SkillRankItem(skill=skill, category=cat or "", frequency=total)
        for skill, total, cat in rows
    ]


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
    user_skills = list({s.strip() for s in body.skills if s.strip()})
    if not user_skills:
        return []

    # Step 1: use the indexed `skill` column to find matching job IDs directly in
    # SQL, instead of pulling every job_skill row into memory on each request.
    # cleaned_jobs/job_skill use utf8mb4_unicode_ci, so equality is already
    # case-insensitive at the DB level.
    matching_job_ids = {
        row[0] for row in
        db.query(JobSkill.cleaned_job_id)
        .filter(JobSkill.skill.in_(user_skills))
        .distinct()
        .all()
    }
    if not matching_job_ids:
        return []

    # Step 2: fetch matching CleanedJob rows, with optional industry filter
    query = db.query(CleanedJob).filter(CleanedJob.id.in_(matching_job_ids))
    if body.industry:
        industry = db.query(JobCategory).filter(
            JobCategory.parent_id.is_(None),
            JobCategory.name == body.industry,
        ).first()
        if industry:
            titles = [
                r[0] for r in db.query(JobCategory.name)
                .filter(JobCategory.parent_id == industry.id).all()
            ]
            query = query.filter(CleanedJob.title.in_(titles))
        else:
            return []
    jobs = query.all()
    if not jobs:
        return []

    # Step 3: fetch full skill sets only for the jobs we're actually returning,
    # not the entire job_skill table.
    job_ids = [j.id for j in jobs]
    skill_rows = (
        db.query(JobSkill.cleaned_job_id, JobSkill.skill)
        .filter(JobSkill.cleaned_job_id.in_(job_ids))
        .all()
    )
    job_skills_map: dict[int, set[str]] = {}
    for job_id, skill in skill_rows:
        job_skills_map.setdefault(job_id, set()).add(skill)

    user_skills_lower = {s.lower() for s in user_skills}

    results = []
    for job in jobs:
        job_skills = job_skills_map.get(job.id, set())
        if not job_skills:
            continue
        matched = {s for s in job_skills if s.lower() in user_skills_lower}
        missing = job_skills - matched
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
    # Fetch the whole (small) category table once and build the tree in memory,
    # instead of issuing one child-lookup query per industry.
    all_categories = db.query(JobCategory).order_by(JobCategory.sort_order).all()
    title_counts = dict(
        db.query(CleanedJob.title, func.count(CleanedJob.id))
        .group_by(CleanedJob.title).all()
    )

    children_by_parent: dict[int, list[JobCategory]] = {}
    industries = []
    for cat in all_categories:
        if cat.parent_id is None:
            industries.append(cat)
        else:
            children_by_parent.setdefault(cat.parent_id, []).append(cat)

    tree = []
    for ind in industries:
        jobs = [
            JobTreeLeaf(name=ch.name, count=title_counts.get(ch.name, 0))
            for ch in children_by_parent.get(ind.id, [])
            if title_counts.get(ch.name, 0) > 0
        ]
        total = sum(j.count for j in jobs)
        if total >= 10:
            tree.append(JobCategoryItem(category=ind.name, jobs=jobs))
    return tree


@router.get("/jobs/{title}", response_model=JobProfileItem)
def job_profile(title: str, db: Session = Depends(get_db)):
    # Aggregate in SQL instead of pulling every matching row (including the
    # large `requirements` TEXT column) into Python for manual counting.
    job_count, avg_sal, sal_min, sal_max = (
        db.query(
            func.count(CleanedJob.id),
            func.avg(CleanedJob.salary_avg),
            func.min(CleanedJob.salary_min),
            func.max(CleanedJob.salary_max),
        )
        .filter(CleanedJob.title == title)
        .one()
    )
    if not job_count:
        raise HTTPException(status_code=404, detail=f"未找到职位: {title}")

    avg_salary = int(avg_sal) if avg_sal else 0
    salary_min = sal_min or 0
    salary_max = sal_max or 0

    city_rows = (
        db.query(CleanedJob.city, func.count(CleanedJob.id))
        .filter(CleanedJob.title == title, CleanedJob.city.isnot(None))
        .group_by(CleanedJob.city)
        .order_by(func.count(CleanedJob.id).desc())
        .all()
    )
    cities = [{"name": c, "value": n} for c, n in city_rows]

    edu_rows = (
        db.query(CleanedJob.education, func.count(CleanedJob.id))
        .filter(CleanedJob.title == title, CleanedJob.education.isnot(None))
        .group_by(CleanedJob.education)
        .order_by(func.count(CleanedJob.id).desc())
        .all()
    )
    education = [{"name": e, "value": n} for e, n in edu_rows]

    skills = (
        db.query(JobSkill.skill, func.sum(JobSkill.frequency).label("total"))
        .join(CleanedJob, JobSkill.cleaned_job_id == CleanedJob.id)
        .filter(CleanedJob.title == title)
        .group_by(JobSkill.skill)
        .order_by(func.sum(JobSkill.frequency).desc())
        .limit(20).all()
    )
    top_skills = [{"name": s, "value": int(f)} for s, f in skills]

    company_rows = (
        db.query(CleanedJob.company)
        .filter(CleanedJob.title == title, CleanedJob.company.isnot(None))
        .distinct()
        .order_by(CleanedJob.company)
        .all()
    )
    companies = [c for (c,) in company_rows]

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
