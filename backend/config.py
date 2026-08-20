import os
from urllib.parse import quote_plus

from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "3306"))
DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")
DB_NAME = os.getenv("DB_NAME", "job_analysis")

DATABASE_URL = f"mysql+pymysql://{DB_USER}:{quote_plus(DB_PASSWORD)}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

_DEV_SECRET_KEY = "dev-secret-key-change-in-production"
SECRET_KEY = os.getenv("SECRET_KEY", _DEV_SECRET_KEY)
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24

# ENV controls which safety checks apply. Default to "production" so a missing
# .env value fails safe (blocks startup) instead of silently running insecure.
ENV = os.getenv("ENV", "production")

# Comma-separated list of allowed browser origins for CORS, e.g.
# "https://example.com,https://www.example.com". Falls back to the local Vite
# dev server so `ENV=development` keeps working out of the box.
_default_origins = "http://localhost:5173,http://127.0.0.1:5173"
CORS_ORIGINS = [
    o.strip() for o in os.getenv("CORS_ORIGINS", _default_origins).split(",") if o.strip()
]

if ENV == "production" and (not SECRET_KEY or "change-in-production" in SECRET_KEY):
    raise RuntimeError(
        "SECRET_KEY is missing or still a placeholder. Set a real SECRET_KEY "
        "in .env (e.g. `openssl rand -hex 32`), or set ENV=development for local use."
    )
