from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import CORS_ORIGINS
from .routers import auth_router, profile_router, account_router

app = FastAPI(title="职业画像分析平台", version="1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["Content-Type", "Authorization", "Accept"],
)

app.include_router(auth_router.router)
app.include_router(profile_router.router)
app.include_router(account_router.router)


@app.get("/api/health")
def health():
    return {"status": "ok"}
