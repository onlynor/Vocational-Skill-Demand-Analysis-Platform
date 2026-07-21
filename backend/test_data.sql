-- ============================================================
-- 测试数据：模拟 12 条招聘信息
-- ============================================================
USE job_analysis;

INSERT INTO raw_jobs (title, salary_text, city, education, experience, requirements, company, source) VALUES
('Python开发工程师', '15K-25K', '北京', '本科', '3年经验', '熟悉Python开发，掌握Django框架，了解MySQL、Redis，具备Linux操作能力', '字节跳动', 'BOSS直聘'),
('Python高级开发', '25K-35K', '上海', '本科', '5年经验', '精通Python，熟悉微服务架构，掌握Docker、Kubernetes，了解分布式系统', '拼多多', 'BOSS直聘'),
('Python后端开发', '20K-30K', '深圳', '本科', '3年经验', '熟悉Python和FastAPI框架，掌握MySQL、MongoDB，了解Elasticsearch', '腾讯', 'BOSS直聘'),
('Python开发', '12K-20K', '杭州', '大专', '1年经验', '熟悉Python开发，掌握Flask框架，了解MySQL、Git', '网易', 'BOSS直聘'),
('Java开发工程师', '18K-28K', '北京', '本科', '3年经验', '精通Java，掌握Spring Boot框架，熟悉MySQL、Redis、RabbitMQ', '阿里巴巴', 'BOSS直聘'),
('高级Java开发', '30K-40K', '上海', '硕士', '5年经验', '精通Java和Spring Cloud微服务，掌握Kubernetes、Docker，熟悉高并发编程', '美团', 'BOSS直聘'),
('Java后端开发', '20K-30K', '深圳', '本科', '3年经验', '熟悉Java和MyBatis框架，掌握MySQL、Oracle，了解分布式系统', '华为', 'BOSS直聘'),
('前端开发工程师', '15K-25K', '北京', '本科', '2年经验', '精通JavaScript和TypeScript，掌握Vue和React框架，了解Webpack、Node.js', '字节跳动', 'BOSS直聘'),
('Web前端开发', '18K-28K', '上海', '本科', '3年经验', '熟悉React和Vue框架，掌握JavaScript和TypeScript，了解Node.js、Nginx', '小红书', 'BOSS直聘'),
('前端开发', '12K-18K', '杭州', '大专', '1年经验', '熟悉Vue框架和JavaScript，掌握HTML、CSS，了解Git和Webpack', '蚂蚁集团', 'BOSS直聘'),
('数据分析师', '15K-25K', '北京', '本科', '2年经验', '精通Python和SQL，熟悉Pandas和NumPy，掌握数据挖掘和机器学习，了解Hadoop、Spark', '京东', 'BOSS直聘'),
('大数据开发工程师', '25K-35K', '上海', '本科', '3年经验', '精通Java和Python，掌握Hadoop和Spark，熟悉Flink和Hive，了解Kafka和Elasticsearch', '百度', 'BOSS直聘');

-- 删除测试数据的命令（保留以备后用）：
-- DELETE FROM raw_jobs WHERE source = 'BOSS直聘';
-- 上面的命令会删除所有 BOSS直聘 来源的数据。
-- 如果只想删除测试数据，用下面这个（根据 id 精确删除）：
-- DELETE FROM job_skill;
-- DELETE FROM cleaned_jobs;
-- DELETE FROM raw_jobs WHERE id BETWEEN 1 AND 12;
