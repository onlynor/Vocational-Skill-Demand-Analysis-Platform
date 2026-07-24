"""数据驱动的职业分类器。

职责：
1. ensure_categories(db)：按 category_rules 幂等创建缺失的一级行业 / 二级职位节点（仅 DML，不改表结构）。
2. CategoryClassifier.classify(title, requirements) -> category_id | None：
   按"标题文本 + 要求文本"做关键词权重打分，取最高分二级类别。

打分规则（见 backend/category_rules.py）：
- 每个 job_category 二级节点自动叠加：
    基础：title == 节点名 → 10；节点名 ∈ title → 6。
    额外：KEYWORD_RULES[节点名] 中的 (kw, w, field)；title 命中加 w，req 命中加 w。
- 取总分最高且 >= THRESHOLD(3)；否则未分类（NULL）。
- 平局：优先有 title 命中者，其次 sort_order 靠前。
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional

from sqlalchemy.orm import Session

from .models import JobCategory
from . import category_rules as R


@dataclass
class _SubRule:
    category_id: int
    name: str
    parent_name: str
    sort_order: int
    extra: list = field(default_factory=list)  # [(kw, w, field)]


def ensure_categories(db: Session) -> dict[str, int]:
    """幂等创建 category_rules 中声明的新行业 / 新二级职位。返回 name->id 映射。"""
    # 1. 现有一级行业索引（name -> id）
    industries = db.query(JobCategory).filter(JobCategory.parent_id.is_(None)).all()
    ind_by_name = {c.name: c for c in industries}

    def _next_ind_sort():
        rows = db.query(JobCategory.sort_order).filter(JobCategory.parent_id.is_(None)).all()
        return max([r[0] for r in rows] + [0]) + 1

    def _next_sub_sort(parent_id):
        rows = db.query(JobCategory.sort_order).filter(JobCategory.parent_id == parent_id).all()
        return max([r[0] for r in rows] + [0]) + 1

    def _get_or_create_industry(name):
        c = ind_by_name.get(name)
        if c:
            return c
        c = JobCategory(name=name, parent_id=None, sort_order=_next_ind_sort())
        db.add(c); db.flush()
        ind_by_name[name] = c
        return c

    def _get_or_create_sub(ind_obj, name):
        existing = db.query(JobCategory).filter(
            JobCategory.parent_id == ind_obj.id, JobCategory.name == name
        ).first()
        if existing:
            return existing
        c = JobCategory(name=name, parent_id=ind_obj.id, sort_order=_next_sub_sort(ind_obj.id))
        db.add(c); db.flush()
        return c

    # 2. 创建新一级行业 + 其二级职位
    for ind_name, sub_names in R.NEW_INDUSTRIES:
        ind = _get_or_create_industry(ind_name)
        for sub_name in sub_names:
            _get_or_create_sub(ind, sub_name)

    # 3. 在现有一级行业下补充二级职位
    for ind_name, sub_names in R.NEW_SUBS_EXISTING:
        ind = ind_by_name.get(ind_name)
        if not ind:
            # 现有行业不存在则跳过（保守，不凭空创建）
            continue
        for sub_name in sub_names:
            _get_or_create_sub(ind, sub_name)

    db.commit()
    return {c.name: c.id for c in db.query(JobCategory).filter(JobCategory.parent_id.isnot(None)).all()}


class CategoryClassifier:
    def __init__(self, db: Session):
        # 一级行业索引
        industries = {c.id: c for c in db.query(JobCategory).filter(JobCategory.parent_id.is_(None)).all()}
        subs = db.query(JobCategory).filter(JobCategory.parent_id.isnot(None)).all()
        self.rules: list[_SubRule] = []
        # 「其他」一级行业 id，用于未命中时按 title 具名细分
        self.other_industry_id = None
        for cid, c in industries.items():
            if c.name == "其他":
                self.other_industry_id = cid
        for c in subs:
            parent = industries.get(c.parent_id)
            if parent is None:
                p = db.query(JobCategory).filter(JobCategory.id == c.parent_id).first()
                parent_name = p.name if p else ""
            else:
                parent_name = parent.name
            extras = R.KEYWORD_RULES.get(c.name, [])
            self.rules.append(_SubRule(c.id, c.name, parent_name, c.sort_order, list(extras)))

    @staticmethod
    def _has(field: str, kw: str) -> bool:
        # ascii 大小写不敏感；中文 lower 无副作用
        return kw.lower() in field.lower()

    def classify(self, title: str | None, requirements: str | None) -> Optional[int]:
        title = (title or "").strip()
        req = (requirements or "").strip()
        if not title and not req:
            return None

        best_id = None
        best_key = (-1, -1, 0)  # (score, title_match_strength, -sort_order)
        for r in self.rules:
            score = 0
            title_strength = 0
            # 基础规则
            if title:
                if title == r.name:
                    score += 10; title_strength = 3
                elif r.name and r.name in title:
                    score += 6; title_strength = 2
            # 额外规则
            for kw, w, fld in r.extra:
                fld = fld or "both"
                if fld in ("title", "both") and title and self._has(title, kw):
                    score += w
                    if title_strength < 1:
                        title_strength = 1
                if fld in ("req", "both") and req and self._has(req, kw):
                    score += w
            if score < R.THRESHOLD:
                continue
            key = (score, title_strength, -r.sort_order)
            if key > best_key:
                best_key = key
                best_id = r.category_id
        return best_id  # 可能为 None，由调用方按 title 具名细分到「其他」