BOT_NAME = "job_spider"
SPIDER_MODULES = ["job_spider.spiders"]
NEWSPIDER_MODULE = "job_spider.spiders"

ROBOTSTXT_OBEY = False
CONCURRENT_REQUESTS = 8
DOWNLOAD_DELAY = 2
RANDOMIZE_DOWNLOAD_DELAY = True

DEFAULT_REQUEST_HEADERS = {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "zh-CN,zh;q=0.9",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
}

ITEM_PIPELINES = {
    "job_spider.pipelines.MySQLPipeline": 300,
}

LOG_LEVEL = "INFO"
