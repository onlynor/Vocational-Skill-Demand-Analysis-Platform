from pydantic import BaseModel, Field
from typing import Optional


class UserRegister(BaseModel):
    # max_length matches users.username VARCHAR(32) — without this, an
    # over-long value hit MySQL's own length error instead of a clean 422.
    username: str = Field(min_length=3, max_length=32)
    password: str = Field(min_length=6, max_length=128)


class UserLogin(BaseModel):
    username: str = Field(min_length=1, max_length=32)
    password: str = Field(min_length=1, max_length=128)


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


class UserProfileIn(BaseModel):
    target_title: Optional[str] = Field(default=None, max_length=128)
    city: Optional[str] = Field(default=None, max_length=32)
    education: Optional[str] = Field(default=None, max_length=16)
    experience: Optional[str] = Field(default=None, max_length=32)
    salary_min: Optional[int] = None
    salary_max: Optional[int] = None
    skills: list[str] = Field(default_factory=list)


class UserProfileOut(UserProfileIn):
    username: str


class SkillTreeSkill(BaseModel):
    name: str
    value: int


class SkillTreeDirection(BaseModel):
    name: str
    job_count: int
    core_skills: list[SkillTreeSkill]
    extended_skills: list[SkillTreeSkill]


class SkillTreeResponse(BaseModel):
    industry: str
    supported: bool
    directions: list[SkillTreeDirection]


class AIConfigIn(BaseModel):
    api_base_url: str = Field(min_length=1, max_length=255)
    model: str = Field(min_length=1, max_length=128)
    # Optional on update: omitting it keeps the stored key, so the UI can
    # show "已配置" without ever holding the real key client-side.
    api_key: Optional[str] = Field(default=None, max_length=255)


class AIConfigOut(BaseModel):
    api_base_url: Optional[str] = None
    model: Optional[str] = None
    has_api_key: bool = False


class AdvisorMessage(BaseModel):
    role: str
    content: str


class AdvisorChatRequest(BaseModel):
    messages: list[AdvisorMessage] = Field(min_length=1)


class AdvisorCitation(BaseModel):
    tool: str
    args: dict


class AdvisorChatResponse(BaseModel):
    reply: str
    citations: list[AdvisorCitation] = Field(default_factory=list)


class AIProbeRequest(BaseModel):
    """Optional overrides for connection test / model listing.

    Any field left out falls back to what's already stored, so the user can
    probe an endpoint before saving it, or re-probe a saved one without
    re-typing the key.
    """
    api_base_url: Optional[str] = Field(default=None, max_length=255)
    api_key: Optional[str] = Field(default=None, max_length=255)
    model: Optional[str] = Field(default=None, max_length=128)


class AIModelsResponse(BaseModel):
    models: list[str]


class AITestResponse(BaseModel):
    ok: bool
    model: Optional[str] = None
    latency_ms: Optional[int] = None
    supports_tools: bool = False
    message: str
