from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..auth import get_current_username
from ..database import get_db
from ..models import User, UserProfile
from ..schemas import UserProfileIn, UserProfileOut

router = APIRouter(
    prefix="/api/account",
    tags=["个人账户"],
    dependencies=[Depends(get_current_username)],
)


def _to_out(username: str, profile: UserProfile | None) -> UserProfileOut:
    if profile is None:
        return UserProfileOut(username=username, skills=[])
    return UserProfileOut(
        username=username,
        target_title=profile.target_title,
        city=profile.city,
        education=profile.education,
        experience=profile.experience,
        salary_min=profile.salary_min,
        salary_max=profile.salary_max,
        skills=profile.skills or [],
    )


@router.get("/me", response_model=UserProfileOut)
def get_my_profile(
    username: str = Depends(get_current_username),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.username == username).first()
    profile = db.query(UserProfile).filter(UserProfile.user_id == user.id).first() if user else None
    return _to_out(username, profile)


@router.put("/profile", response_model=UserProfileOut)
def update_my_profile(
    body: UserProfileIn,
    username: str = Depends(get_current_username),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.username == username).first()
    if user is None:
        raise HTTPException(status_code=404, detail="用户不存在")
    profile = db.query(UserProfile).filter(UserProfile.user_id == user.id).first()
    if profile is None:
        profile = UserProfile(user_id=user.id)
        db.add(profile)

    profile.target_title = body.target_title
    profile.city = body.city
    profile.education = body.education
    profile.experience = body.experience
    profile.salary_min = body.salary_min
    profile.salary_max = body.salary_max
    profile.skills = body.skills

    db.commit()
    db.refresh(profile)
    return _to_out(username, profile)
