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
from ..models import CleanedJob, JobSkill, SkillDict, JobCategory

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

    user_skills_lower = {s.lower() for s in body.skills}

    # Step 1: find which job_skill entries match user input (case-insensitive)
    all_skill_rows = db.query(JobSkill.cleaned_job_id, JobSkill.skill).all()
    # Build per-job skill sets and collect matching job IDs
    job_skills_map: dict[int, set[str]] = {}
    matching_job_ids: set[int] = set()

    for job_id, skill in all_skill_rows:
        job_skills_map.setdefault(job_id, set()).add(skill)

    for job_id, skills in job_skills_map.items():
        if {s.lower() for s in skills} & user_skills_lower:
            matching_job_ids.add(job_id)

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

    # Step 3: build results
    results = []
    for job in jobs:
        job_skills = job_skills_map.get(job.id, set())
        if not job_skills:
            continue
        job_skills_lower = {s.lower() for s in job_skills}
        matched_lower = user_skills_lower & job_skills_lower
        matched = {s for s in job_skills if s.lower() in matched_lower}
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
    industries = (
        db.query(JobCategory)
        .filter(JobCategory.parent_id.is_(None))
        .order_by(JobCategory.sort_order)
        .all()
    )
    title_counts = dict(
        db.query(CleanedJob.title, func.count(CleanedJob.id))
        .group_by(CleanedJob.title).all()
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
            JobTreeLeaf(name=ch.name, count=title_counts.get(ch.name, 0))
            for ch in children
            if title_counts.get(ch.name, 0) > 0
        ]
        total = sum(j.count for j in jobs)
        if total >= 10:
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
