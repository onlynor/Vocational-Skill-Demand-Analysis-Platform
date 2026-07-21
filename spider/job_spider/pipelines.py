import pymysql
from itemadapter import ItemAdapter


class MySQLPipeline:
    def open_spider(self, spider):
        self.conn = pymysql.connect(
            host="localhost", port=3306, user="root", password="",
            database="job_analysis", charset="utf8mb4",
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
