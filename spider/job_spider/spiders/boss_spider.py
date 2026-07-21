"""
BOSS 直聘爬虫

搜索条件：Python 相关岗位
爬取字段：岗位名称、薪资、城市、学历、经验、岗位要求、公司名

注意：BOSS 直聘有较强的反爬机制，本爬虫仅用于学习实验。
实际运行时可能需要 cookies / 代理 / 验证码处理。
"""
import scrapy
from job_spider.items import JobItem


class BossSpider(scrapy.Spider):
    name = "boss"
    allowed_domains = ["zhipin.com"]
    start_urls = [
        "https://www.zhipin.com/web/geek/job?query=Python&city=100010000",
    ]

    def parse(self, response):
        jobs = response.css("li.job-card-wrapper")

        if not jobs:
            self.logger.warning(
                "未匹配到岗位卡片 —— 页面可能需要登录或验证。"
                "请尝试在浏览器中打开 BOSS 直聘并复制 cookies。"
            )

        for job in jobs:
            item = JobItem()
            item["title"] = job.css("span.job-name::text").get(default="").strip()
            item["salary_text"] = job.css("span.salary::text").get(default="").strip()
            item["city"] = (
                job.css("span.job-area::text").get(default="").strip()
                or self._extract_city(job)
            )

            tags = job.css("ul.tag-list li::text").getall()
            item["education"] = self._find_in_tags(tags, ["本科", "硕士", "大专", "博士", "学历不限"])
            item["experience"] = self._find_in_tags(tags, ["经验", "年"])

            item["requirements"] = ""
            item["company"] = job.css("h3.company-name a::text").get(default="").strip()
            item["source"] = "BOSS直聘"
            item["url"] = response.urljoin(
                job.css("a.job-card-left::attr(href)").get(default="")
            )

            yield item

        next_page = response.css("a.next::attr(href)").get()
        if next_page:
            yield response.follow(next_page, self.parse)

    @staticmethod
    def _extract_city(job) -> str:
        info = job.css("span.job-info::text").get(default="")
        if "·" in info:
            return info.split("·")[0].strip()
        return ""

    @staticmethod
    def _find_in_tags(tags: list[str], keywords: list[str]) -> str:
        for tag in tags:
            for kw in keywords:
                if kw in tag:
                    return tag.strip()
        return ""
