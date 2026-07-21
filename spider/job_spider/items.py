import scrapy


class JobItem(scrapy.Item):
    title = scrapy.Field()
    salary_text = scrapy.Field()
    city = scrapy.Field()
    education = scrapy.Field()
    experience = scrapy.Field()
    requirements = scrapy.Field()
    company = scrapy.Field()
    source = scrapy.Field()
    url = scrapy.Field()
