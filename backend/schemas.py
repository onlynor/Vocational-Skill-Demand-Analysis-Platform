from pydantic import BaseModel
from typing import Optional


class UserRegister(BaseModel):
    username: str
    password: str


class UserLogin(BaseModel):
    username: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class SkillRankItem(BaseModel):
    skill: str
    category: str
    frequency: int


class SkillSalaryItem(BaseModel):
    skill: str
    avg_salary: float
    job_count: int


class CityDemandItem(BaseModel):
    city: str
    job_count: int


class EducationPieItem(BaseModel):
    education: str
    job_count: int


class SkillMatchRequest(BaseModel):
    skills: list[str]
    industry: Optional[str] = None


class SkillMatchItem(BaseModel):
    title: str
    company: str
    city: str
    salary_avg: int
    matched_skills: list[str]
    missing_skills: list[str]


class JobTreeLeaf(BaseModel):
    name: str
    count: int = 0


class JobCategoryItem(BaseModel):
    category: str
    jobs: list[JobTreeLeaf]


class JobProfileItem(BaseModel):
    title: str
    job_count: int
    avg_salary: int
    salary_min: int
    salary_max: int
    cities: list[dict]
    education: list[dict]
    top_skills: list[dict]
    companies: list[str]
