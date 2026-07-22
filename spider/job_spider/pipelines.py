import os
from pathlib import Path

import pymysql
from itemadapter import ItemAdapter

# spider 运行在 spider/ 目录，.env 位于仓库根
_REPO_ROOT = Path(__file__).resolve().parents[2]
_ENV_PATH = _REPO_ROOT / ".env"

try:
    from dotenv import load_dotenv

    if _ENV_PATH.exists():
        load_dotenv(_ENV_PATH)
except ImportError:
    # 未安装 python-dotenv 时，用标准库兜底解析 .env
    if _ENV_PATH.exists():
        for _line in _ENV_PATH.read_text(encoding="utf-8").splitlines():
            _line = _line.strip()
            if _line and not _line.startswith("#") and "=" in _line:
                _k, _, _v = _line.partition("=")
                os.environ.setdefault(_k.strip(), _v.strip())


class MySQLPipeline:
    def open_spider(self, spider):
        self.conn = pymysql.connect(
            host=os.getenv("DB_HOST", "localhost"),
            port=int(os.getenv("DB_PORT", "3306")),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASSWORD", ""),
            database=os.getenv("DB_NAME", "job_analysis"),
            charset="utf8mb4",
        )
        self.cursor = self.conn.cursor()

    def close_spider(self, spider):
        self.cursor.close()
        self.conn.close()

    def process_item(self, item, spider):
        sql = """
            INSERT INTO raw_jobs (title, salary_text, city, education,
                experience, requirements, company, source, url)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        self.cursor.execute(sql, (
            item.get("title"),
            item.get("salary_text"),
            item.get("city"),
            item.get("education"),
            item.get("experience"),
            item.get("requirements"),
            item.get("company"),
            item.get("source"),
            item.get("url"),
        ))
        self.conn.commit()
        return item
