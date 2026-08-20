from sqlalchemy import (
    Column, Integer, String, Text, DateTime, ForeignKey, JSON, func,
)
from sqlalchemy.orm import relationship
from .database import Base


class RawJob(Base):
    __tablename__ = "raw_jobs"

    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(128), nullable=False)
    salary_text = Column(String(64))
    city = Column(String(32))
    education = Column(String(16))
    experience = Column(String(32))
    requirements = Column(Text)
    company = Column(String(128))
    source = Column(String(32))


class SynonymDict(Base):
    __tablename__ = "synonym_dict"

    id = Column(Integer, primary_key=True, autoincrement=True)
    raw_word = Column(String(64), unique=True, nullable=False)
    std_word = Column(String(64), nullable=False)


class CleanedJob(Base):
    __tablename__ = "cleaned_jobs"

    id = Column(Integer, primary_key=True, autoincrement=True)
    raw_id = Column(Integer, ForeignKey("raw_jobs.id", ondelete="SET NULL"))
    title = Column(String(128), nullable=False)
    category_id = Column(Integer, ForeignKey("job_category.id", ondelete="SET NULL"))
    salary_min = Column(Integer)
    salary_max = Column(Integer)
    salary_avg = Column(Integer)
    city = Column(String(32))
    education = Column(String(16))
    experience = Column(String(32))
    requirements = Column(Text)
    company = Column(String(128))
    source = Column(String(32))


class StopWord(Base):
    __tablename__ = "stop_words"

    id = Column(Integer, primary_key=True, autoincrement=True)
    word = Column(String(32), unique=True, nullable=False)


class SkillDict(Base):
    __tablename__ = "skill_dict"

    id = Column(Integer, primary_key=True, autoincrement=True)
    skill = Column(String(64), unique=True, nullable=False)
    category = Column(String(32))


class JobSkill(Base):
    __tablename__ = "job_skill"

    id = Column(Integer, primary_key=True, autoincrement=True)
    cleaned_job_id = Column(Integer, ForeignKey("cleaned_jobs.id", ondelete="CASCADE"), nullable=False)
    skill = Column(String(64), nullable=False)
    industry = Column(String(64))
    frequency = Column(Integer, default=1)


class SkillSynonym(Base):
    __tablename__ = "skill_synonym"

    id = Column(Integer, primary_key=True, autoincrement=True)
    raw_word = Column(String(64), unique=True, nullable=False)
    std_word = Column(String(64), nullable=False)


class JobCategory(Base):
    __tablename__ = "job_category"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(64), nullable=False)
    parent_id = Column(Integer, ForeignKey("job_category.id", ondelete="CASCADE"))
    sort_order = Column(Integer, default=0)


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(32), unique=True, nullable=False)
    password_hash = Column(String(256), nullable=False)
    created_at = Column(DateTime, server_default=func.now())


class UserProfile(Base):
    """A user's self-reported job-seeking profile (skills/target city/etc.),
    separate from job-market aggregate data in CleanedJob/JobSkill. One row
    per user; used to prefill the skill-match page."""
    __tablename__ = "user_profile"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    target_title = Column(String(128))
    city = Column(String(32))
    education = Column(String(16))
    experience = Column(String(32))
    salary_min = Column(Integer)
    salary_max = Column(Integer)
    skills = Column(JSON)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())


class UserAIConfig(Base):
    """Per-user OpenAI-compatible endpoint settings for the AI advisor.

    Kept in its own table rather than on UserProfile so the API key never
    rides along in the career-profile response. The key is stored as-is
    because the server must replay it to the user's chosen endpoint; it is
    never returned to the browser (the API reports only `has_api_key`).
    """
    __tablename__ = "user_ai_config"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    api_base_url = Column(String(255))
    api_key = Column(String(255))
    model = Column(String(128))
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
