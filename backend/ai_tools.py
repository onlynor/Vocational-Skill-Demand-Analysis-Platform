"""Retrieval layer for the AI career advisor.

Every function here answers a question by running a real aggregate query
against the recruitment database — the model never sees free-form text it
could paraphrase numbers out of, only these results. That is what keeps
answers grounded: a figure the advisor quotes either came out of one of
these functions or it should not have been stated at all.

Exposed to the model as OpenAI-style function-calling tools (TOOL_SCHEMAS);
`run_tool` dispatches a model-requested call to the matching function.
"""

from sqlalchemy import func
from sqlalchemy.orm import Session

from .models import CleanedJob, JobCategory, JobSkill

# Caps on returned rows. The model pays for every token of tool output, and
# long tails add noise rather than insight for a "what should I learn" answer.
_MAX_TITLES = 15
_MAX_SKILLS = 15
_MAX_CITIES = 10
_MIN_JOBS_FOR_SALARY = 3


def list_industries(db: Session) -> dict:
    """All industries with how many postings sit under each.

    Mirrors the industry->title tree the rest of the app uses: postings join
    to an industry through cleaned_jobs.title == the child category's name.
    """
    categories = db.query(JobCategory).all()
    title_counts = dict(
        db.query(CleanedJob.title, func.count(CleanedJob.id))
        .group_by(CleanedJob.title)
        .all()
    )
    children_by_parent: dict[int, list[str]] = {}
    industries = []
    for cat in categories:
        if cat.parent_id is None:
            industries.append(cat)
        else:
            children_by_parent.setdefault(cat.parent_id, []).append(cat.name)

    out = []
    for ind in industries:
        total = sum(int(title_counts.get(n, 0)) for n in children_by_parent.get(ind.id, []))
        if total > 0:
            out.append({"name": ind.name, "job_count": total})
    out.sort(key=lambda x: x["job_count"], reverse=True)
    return {"industries": out}


def search_job_titles(db: Session, keyword: str) -> dict:
    """Job titles matching a keyword, with real posting counts."""
    rows = (
        db.query(CleanedJob.title, func.count(CleanedJob.id).label("cnt"))
        .filter(CleanedJob.title.like(f"%{keyword}%"))
        .group_by(CleanedJob.title)
        .order_by(func.count(CleanedJob.id).desc())
        .limit(_MAX_TITLES)
        .all()
    )
    return {
        "keyword": keyword,
        "matches": [{"title": t, "job_count": int(c)} for t, c in rows],
    }


def get_job_profile(db: Session, title: str) -> dict:
    """Salary / city / education / skill breakdown for one job title."""
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
        return {"found": False, "title": title,
                "note": "数据库中没有这个职位，请先用 search_job_titles 确认准确的职位名称"}

    cities = (
        db.query(CleanedJob.city, func.count(CleanedJob.id))
        .filter(CleanedJob.title == title, CleanedJob.city.isnot(None))
        .group_by(CleanedJob.city)
        .order_by(func.count(CleanedJob.id).desc())
        .limit(_MAX_CITIES)
        .all()
    )
    education = (
        db.query(CleanedJob.education, func.count(CleanedJob.id))
        .filter(CleanedJob.title == title, CleanedJob.education.isnot(None))
        .group_by(CleanedJob.education)
        .order_by(func.count(CleanedJob.id).desc())
        .all()
    )
    skills = (
        db.query(JobSkill.skill, func.sum(JobSkill.frequency))
        .join(CleanedJob, JobSkill.cleaned_job_id == CleanedJob.id)
        .filter(CleanedJob.title == title)
        .group_by(JobSkill.skill)
        .order_by(func.sum(JobSkill.frequency).desc())
        .limit(_MAX_SKILLS)
        .all()
    )
    return {
        "found": True,
        "title": title,
        "job_count": int(job_count),
        "avg_salary": int(avg_sal) if avg_sal else None,
        "salary_min": int(sal_min) if sal_min else None,
        "salary_max": int(sal_max) if sal_max else None,
        "top_cities": [{"city": c, "job_count": int(n)} for c, n in cities],
        "education": [{"education": e, "job_count": int(n)} for e, n in education],
        "top_skills": [{"skill": s, "frequency": int(f)} for s, f in skills],
    }


def get_top_skills(db: Session, industry: str | None = None) -> dict:
    """Most in-demand skills overall, or within one industry."""
    q = db.query(JobSkill.skill, func.sum(JobSkill.frequency).label("total"))
    if industry:
        q = q.filter(JobSkill.industry == industry)
    rows = (
        q.group_by(JobSkill.skill)
        .order_by(func.sum(JobSkill.frequency).desc())
        .limit(_MAX_SKILLS)
        .all()
    )
    return {
        "industry": industry or "全部行业",
        "top_skills": [{"skill": s, "frequency": int(f)} for s, f in rows],
    }


def get_skill_salary(db: Session, skill: str) -> dict:
    """Average salary across postings that ask for a given skill."""
    row = (
        db.query(
            func.avg(CleanedJob.salary_avg),
            func.count(func.distinct(CleanedJob.id)),
        )
        .join(JobSkill, JobSkill.cleaned_job_id == CleanedJob.id)
        .filter(JobSkill.skill == skill, CleanedJob.salary_avg.isnot(None))
        .one()
    )
    avg_sal, cnt = row
    if not cnt or int(cnt) < _MIN_JOBS_FOR_SALARY:
        return {"found": False, "skill": skill, "job_count": int(cnt or 0),
                "note": f"样本不足（少于 {_MIN_JOBS_FOR_SALARY} 条），不足以给出可信的薪资参考"}
    return {
        "found": True,
        "skill": skill,
        "avg_salary": int(avg_sal),
        "job_count": int(cnt),
    }


def get_city_demand(db: Session, title: str | None = None) -> dict:
    """Which cities have the most postings, overall or for one title."""
    q = db.query(CleanedJob.city, func.count(CleanedJob.id))
    if title:
        q = q.filter(CleanedJob.title == title)
    rows = (
        q.filter(CleanedJob.city.isnot(None))
        .group_by(CleanedJob.city)
        .order_by(func.count(CleanedJob.id).desc())
        .limit(_MAX_CITIES)
        .all()
    )
    return {
        "title": title or "全部职位",
        "cities": [{"city": c, "job_count": int(n)} for c, n in rows],
    }


# --- OpenAI-style function-calling schemas -------------------------------
# Sent to the model so it can decide which real query to run. Descriptions
# are deliberately explicit about "真实数据" so the model prefers calling a
# tool over answering from its own prior knowledge.
def _fn(name: str, desc: str, props: dict, required: list[str]) -> dict:
    return {
        "type": "function",
        "function": {
            "name": name,
            "description": desc,
            "parameters": {
                "type": "object",
                "properties": props,
                "required": required,
                "additionalProperties": False,
            },
        },
    }


TOOL_SCHEMAS = [
    _fn("list_industries",
        "列出数据库中所有行业及其真实岗位数量。当用户问“有哪些行业/哪个行业机会多”时先调用它。",
        {}, []),
    _fn("search_job_titles",
        "按关键词模糊搜索数据库中真实存在的职位名称及岗位数量。在调用 get_job_profile 之前，"
        "用它确认数据库里准确的职位名称写法。",
        {"keyword": {"type": "string", "description": "职位关键词，如 Java、测试、产品"}},
        ["keyword"]),
    _fn("get_job_profile",
        "获取某个职位的完整真实画像：岗位数量、平均/最低/最高薪资、城市分布、学历要求、最需要的技能。"
        "职位名称必须与数据库完全一致，不确定时先用 search_job_titles。",
        {"title": {"type": "string", "description": "准确的职位名称，如 Java开发"}},
        ["title"]),
    _fn("get_top_skills",
        "获取最热门技能及出现频次，可限定某个行业。回答“该学什么技术/什么技能吃香”时用它。",
        {"industry": {"type": "string",
                      "description": "可选，行业名称，如 计算机/互联网；不传则统计全部行业"}},
        []),
    _fn("get_skill_salary",
        "获取要求某项技能的岗位的真实平均薪资和样本量。样本不足时会明确返回 found=false。",
        {"skill": {"type": "string", "description": "技能名称，如 MySQL、Python"}},
        ["skill"]),
    _fn("get_city_demand",
        "获取岗位的城市分布（哪些城市需求最多），可限定某个职位。",
        {"title": {"type": "string", "description": "可选，职位名称；不传则统计全部职位"}},
        []),
]

_DISPATCH = {
    "list_industries": lambda db, a: list_industries(db),
    "search_job_titles": lambda db, a: search_job_titles(db, a.get("keyword", "")),
    "get_job_profile": lambda db, a: get_job_profile(db, a.get("title", "")),
    "get_top_skills": lambda db, a: get_top_skills(db, a.get("industry") or None),
    "get_skill_salary": lambda db, a: get_skill_salary(db, a.get("skill", "")),
    "get_city_demand": lambda db, a: get_city_demand(db, a.get("title") or None),
}


def run_tool(db: Session, name: str, args: dict) -> dict:
    """Dispatch a model-requested tool call to its query function.

    An unknown name is reported back to the model as data rather than raised,
    so a hallucinated tool name costs one wasted turn instead of failing the
    whole request.
    """
    fn = _DISPATCH.get(name)
    if fn is None:
        return {"error": f"未知的工具: {name}", "available": list(_DISPATCH)}
    try:
        return fn(db, args or {})
    except Exception as exc:  # noqa: BLE001 - surfaced to the model, not swallowed
        return {"error": f"查询失败: {exc}"}
