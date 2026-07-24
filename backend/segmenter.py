"""Jieba 分词 + 技能匹配模块"""
import re
from collections import Counter
import jieba
from sqlalchemy.orm import Session
from .models import CleanedJob, JobSkill, StopWord, SkillDict, SkillSynonym, JobCategory
from . import skill_rules as SR


def ensure_skill_lexicon(db: Session):
    """幂等补充 skill_dict / stop_words / skill_synonym 表数据（仅 INSERT IGNORE）。"""
    # 停用词
    existing_sw = {r.word for r in db.query(StopWord).all()}
    for w in SR.NOISE:
        if w not in existing_sw:
            db.add(StopWord(word=w))
            existing_sw.add(w)
    # 技能词典
    existing_sk = {r.skill for r in db.query(SkillDict).all()}
    for skill, cat in SR.SKILLS:
        if skill not in existing_sk:
            db.add(SkillDict(skill=skill, category=cat))
            existing_sk.add(skill)
    # 技能同义词
    existing_syn = {r.raw_word.lower() for r in db.query(SkillSynonym).all()}
    for raw, std in SR.SYNONYMS:
        if raw.lower() not in existing_syn:
            db.add(SkillSynonym(raw_word=raw, std_word=std))
            existing_syn.add(raw.lower())
    db.commit()


def load_stop_words(db: Session) -> set[str]:
    return {r.word for r in db.query(StopWord).all()}


def load_skill_set(db: Session) -> set[str]:
    return {r.skill for r in db.query(SkillDict).all()}


def load_skill_synonyms(db: Session) -> dict[str, str]:
    """返回小写 key 的同义词映射，实现大小写不敏感匹配"""
    mapping = {}
    for r in db.query(SkillSynonym).all():
        mapping[r.raw_word.lower()] = r.std_word
    return mapping


def _normalize(word: str, synonyms: dict[str, str]) -> str:
    return synonyms.get(word.lower(), word)


def segment_requirements(text: str) -> list[str]:
    """分词，返回筛选后的关键词"""
    if not text:
        return []

    text = re.sub(r"[\n\r\t]+", " ", text)
    text = re.sub(r"[，。、；：！？（）《》【】「」""''…—\\-,.()\[\]{}]", " ", text)

    words = jieba.lcut(text)
    return [w.strip() for w in words if len(w.strip()) >= 2]


def _merge_compound_words(words: list[str], skill_set: set[str]) -> list[str]:
    """合并相邻 token 为复合技能词（如 'Spring'+'Boot' → 'Spring Boot'）"""
    compounds = sorted(
        [s for s in skill_set if " " in s],
        key=lambda x: x.count(" "), reverse=True
    )
    if not compounds:
        return words

    compound_tokens = {c: tuple(c.split(" ")) for c in compounds}
    result = []
    i = 0
    while i < len(words):
        matched = False
        for compound, tokens in compound_tokens.items():
            n = len(tokens)
            if i + n <= len(words) and tuple(words[i:i + n]) == tokens:
                result.append(compound)
                i += n
                matched = True
                break
        if not matched:
            result.append(words[i])
            i += 1
    return result


def extract_skills(words: list[str], stop_words: set[str], skill_set: set[str],
                   skill_synonyms: dict[str, str] | None = None) -> Counter:
    """去停用词 → 同义词归一化 → 合并相邻复合词 → 匹配技能词典 → 返回频次"""
    filtered = [w for w in words if w not in stop_words]
    if skill_synonyms:
        filtered = [_normalize(w, skill_synonyms) for w in filtered]
    merged = _merge_compound_words(filtered, skill_set)
    skills = [w for w in merged if w in skill_set]
    return Counter(skills)


def _register_skill_words(skill_set: set[str]):
    """将技能词典中的复合词注册到 jieba，防止被切分"""
    for word in skill_set:
        jieba.add_word(word)


def process_all_jobs(db: Session):
    """对所有 cleaned_jobs 做分词 + 技能匹配，结果写入 job_skill 表"""
    stop_words = load_stop_words(db)
    skill_set = load_skill_set(db)
    skill_synonyms = load_skill_synonyms(db)
    _register_skill_words(skill_set)

    # 构建 category_id → industry 映射
    cats = db.query(JobCategory).all()
    cat_map = {c.id: c for c in cats}
    industry_map = {}
    for c in cats:
        if c.parent_id and c.parent_id in cat_map:
            industry_map[c.id] = cat_map[c.parent_id].name

    # 清空旧的关联数据（配合唯一约束，避免重复）
    db.query(JobSkill).delete()
    jobs = db.query(CleanedJob).all()

    total = 0
    for job in jobs:
        words = segment_requirements(job.requirements)
        skill_freq = extract_skills(words, stop_words, skill_set, skill_synonyms)

        industry = industry_map.get(job.category_id)
        for skill, freq in skill_freq.items():
            js = JobSkill(cleaned_job_id=job.id, skill=skill, industry=industry, frequency=freq)
            db.add(js)
            total += 1

    db.commit()
    return total
