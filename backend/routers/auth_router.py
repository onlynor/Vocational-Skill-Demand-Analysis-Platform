from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..models import User
from ..schemas import UserRegister, UserLogin, TokenResponse
from ..auth import hash_password, verify_password, create_access_token

router = APIRouter(prefix="/api/auth", tags=["认证"])


@router.post("/register", response_model=TokenResponse)
def register(body: UserRegister, db: Session = Depends(get_db)):
    if db.query(User).filter(User.username == body.username).first():
        raise HTTPException(status_code=409, detail="该用户名已被注册，请换一个用户名，或直接登录")
    user = User(username=body.username, password_hash=hash_password(body.password))
    db.add(user)
    db.commit()
    token = create_access_token(body.username)
    return TokenResponse(access_token=token)


@router.post("/login", response_model=TokenResponse)
def login(body: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == body.username).first()
    # Distinguishing "no such account" from "wrong password" is what the UI
    # asked for. Note the tradeoff: it also lets someone probe which
    # usernames exist. Acceptable here (small teaching project, and the
    # register endpoint already reveals the same thing via its 409); if this
    # ever faces the open internet, collapse both back into one message and
    # add rate limiting.
    if not user:
        raise HTTPException(status_code=404, detail="该用户名尚未注册，请先注册账号")
    if not verify_password(body.password, user.password_hash):
        raise HTTPException(status_code=401, detail="密码错误，请重新输入")
    token = create_access_token(body.username)
    return TokenResponse(access_token=token)
