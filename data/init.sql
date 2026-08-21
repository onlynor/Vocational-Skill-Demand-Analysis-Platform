-- ============================================================
-- 招聘数据采集与职业画像分析平台 —— 数据库建表
-- ============================================================

CREATE DATABASE IF NOT EXISTS job_analysis
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE job_analysis;

-- -----------------------------------------------------------
-- 1. 原始招聘数据表
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS raw_jobs (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  title         VARCHAR(128)  NOT NULL COMMENT '岗位名称',
  salary_text   VARCHAR(64)   DEFAULT NULL COMMENT '薪资原文，如 20K-30K',
  city          VARCHAR(32)   DEFAULT NULL COMMENT '工作城市',
  education     VARCHAR(16)   DEFAULT NULL COMMENT '学历要求',
  experience    VARCHAR(32)   DEFAULT NULL COMMENT '经验要求',
  requirements  TEXT          DEFAULT NULL COMMENT '岗位要求原文',
  company       VARCHAR(128)  DEFAULT NULL COMMENT '公司名称',
  source        VARCHAR(32)   DEFAULT NULL COMMENT '来源网站',
  INDEX idx_city (city),
  INDEX idx_title_city (title, city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='原始招聘数据';

-- -----------------------------------------------------------
-- 2. 同义词字典表
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS synonym_dict (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  raw_word  VARCHAR(64) NOT NULL COMMENT '原始写法',
  std_word  VARCHAR(64) NOT NULL COMMENT '标准写法',
  UNIQUE KEY uk_raw (raw_word)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='同义词字典';

-- 3.5 技能同义词表
CREATE TABLE IF NOT EXISTS skill_synonym (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  raw_word  VARCHAR(64) NOT NULL COMMENT '原始写法（如 K8s）',
  std_word  VARCHAR(64) NOT NULL COMMENT '标准写法（如 Kubernetes）',
  UNIQUE KEY uk_skill_raw (raw_word)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='技能同义词';

-- -----------------------------------------------------------
-- 3. 清洗后数据表
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS cleaned_jobs (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  raw_id        INT           DEFAULT NULL COMMENT '对应 raw_jobs.id',
  title         VARCHAR(128)  NOT NULL COMMENT '岗位名称（已统一）',
  category_id   INT           DEFAULT NULL COMMENT '关联 job_category.id',
  salary_min    INT           DEFAULT NULL COMMENT '最低月薪',
  salary_max    INT           DEFAULT NULL COMMENT '最高月薪',
  salary_avg    INT           DEFAULT NULL COMMENT '平均月薪',
  city          VARCHAR(32)   DEFAULT NULL,
  education     VARCHAR(16)   DEFAULT NULL,
  experience    VARCHAR(32)   DEFAULT NULL,
  requirements  TEXT          DEFAULT NULL COMMENT '岗位要求原文',
  company       VARCHAR(128)  DEFAULT NULL,
  source        VARCHAR(32)   DEFAULT NULL,
  INDEX idx_title (title),
  INDEX idx_city (city),
  FOREIGN KEY (raw_id) REFERENCES raw_jobs(id) ON DELETE SET NULL,
  FOREIGN KEY (category_id) REFERENCES job_category(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='清洗后数据';

-- -----------------------------------------------------------
-- 4. 停用词表
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS stop_words (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  word  VARCHAR(32) NOT NULL COMMENT '停用词',
  UNIQUE KEY uk_word (word)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='停用词表';

-- -----------------------------------------------------------
-- 5. 技能词典表
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS skill_dict (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  skill     VARCHAR(64) NOT NULL COMMENT '技能名称',
  category  VARCHAR(32) DEFAULT NULL COMMENT '技能分类（编程语言/数据库/框架/架构等）',
  UNIQUE KEY uk_skill (skill)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='技能词典';

-- -----------------------------------------------------------
-- 6. 岗位-技能关联表
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS job_skill (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  cleaned_job_id INT NOT NULL COMMENT '关联 cleaned_jobs.id',
  skill         VARCHAR(64) NOT NULL COMMENT '技能名称',
  industry      VARCHAR(64)   DEFAULT NULL COMMENT '所属行业',
  frequency     INT DEFAULT 1 COMMENT '出现次数',
  FOREIGN KEY (cleaned_job_id) REFERENCES cleaned_jobs(id) ON DELETE CASCADE,
  UNIQUE KEY uk_job_skill (cleaned_job_id, skill),
  INDEX idx_skill (skill),
  INDEX idx_job (cleaned_job_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='岗位技能频次';

-- -----------------------------------------------------------
-- 7. 用户表
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(32)  NOT NULL COMMENT '用户名',
  password_hash VARCHAR(256) NOT NULL COMMENT '密码哈希',
  created_at    DATETIME     DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- -----------------------------------------------------------
-- 8. 职位分类表（二级：行业 → 职位）
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS job_category (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(64) NOT NULL COMMENT '分类名称',
  parent_id INT DEFAULT NULL COMMENT '父级ID，NULL=一级行业',
  sort_order INT DEFAULT 0 COMMENT '排序',
  FOREIGN KEY (parent_id) REFERENCES job_category(id) ON DELETE CASCADE,
  INDEX idx_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='职位分类（二级树）';

-- -----------------------------------------------------------
-- 9. 用户个人求职画像（手动填写，区别于岗位市场统计数据）
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_profile (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  user_id       INT           NOT NULL COMMENT '关联 users.id',
  target_title  VARCHAR(128)  DEFAULT NULL COMMENT '期望职位名称',
  city          VARCHAR(32)   DEFAULT NULL COMMENT '期望城市',
  education     VARCHAR(16)   DEFAULT NULL COMMENT '学历',
  experience    VARCHAR(32)   DEFAULT NULL COMMENT '工作经验',
  salary_min    INT           DEFAULT NULL COMMENT '期望最低月薪',
  salary_max    INT           DEFAULT NULL COMMENT '期望最高月薪',
  skills        JSON          DEFAULT NULL COMMENT '技能列表，字符串数组',
  updated_at    DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_user (user_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户个人求职画像';

-- -----------------------------------------------------------
-- 10. 用户 AI 顾问配置（OpenAI 兼容接口，用户自带 key）
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_ai_config (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  user_id       INT           NOT NULL COMMENT '关联 users.id',
  api_base_url  VARCHAR(255)  DEFAULT NULL COMMENT 'OpenAI 兼容接口地址，如 https://api.deepseek.com/v1',
  api_key       VARCHAR(255)  DEFAULT NULL COMMENT '用户自己的 API Key，仅服务端使用，不返回前端',
  model         VARCHAR(128)  DEFAULT NULL COMMENT '模型名称',
  updated_at    DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_ai_user (user_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户 AI 顾问配置';
-- ============================================================
-- 职位分类种子数据 v2（二级：行业 → 职位，扩展版）
-- ============================================================

USE job_analysis;

-- 一级：行业
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES
(1,  '计算机/互联网',  NULL, 1),
(2,  '电气/自动化',   NULL, 2),
(3,  '医学/医疗',     NULL, 3),
(4,  '金融/会计',     NULL, 4),
(5,  '教育/培训',     NULL, 5),
(6,  '建筑/土木',     NULL, 6),
(7,  '机械/制造',     NULL, 7),
(8,  '销售/市场',     NULL, 8),
(9,  '物流/运输',     NULL, 9),
(10, '传媒/设计',     NULL, 10);

-- ============================================================
-- 1. 计算机/互联网（26 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('Python开发',      1, 1),
('Java开发',        1, 2),
('前端开发',        1, 3),
('后端开发',        1, 4),
('全栈开发',        1, 5),
('C++开发',         1, 6),
('Golang开发',      1, 7),
('PHP开发',         1, 8),
('.NET开发',        1, 9),
('Node.js开发',     1, 10),
('Android开发',     1, 11),
('iOS开发',         1, 12),
('鸿蒙开发',        1, 13),
('软件测试',        1, 14),
('测试开发',        1, 15),
('运维工程师',      1, 16),
('DBA',             1, 17),
('网络安全',        1, 18),
('算法工程师',      1, 19),
('NLP工程师',       1, 20),
('数据分析',        1, 21),
('数据开发',        1, 22),
('产品经理',        1, 23),
('UI设计师',        1, 24),
('游戏开发',        1, 25),
('区块链工程师',    1, 26);

-- ============================================================
-- 2. 电气/自动化（20 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('电气工程师',      2, 1),
('自动化工程师',    2, 2),
('PLC工程师',       2, 3),
('嵌入式开发',      2, 4),
('硬件工程师',      2, 5),
('电子工程师',      2, 6),
('FPGA开发',        2, 7),
('单片机工程师',    2, 8),
('驱动开发',        2, 9),
('PCB工程师',       2, 10),
('射频工程师',      2, 11),
('集成电路IC设计',  2, 12),
('电源工程师',      2, 13),
('机电工程师',      2, 14),
('电力工程师',      2, 15),
('通信工程师',      2, 16),
('网络工程师',      2, 17),
('FAE工程师',       2, 18),
('仪器仪表工程师',  2, 19),
('无线通信工程师',  2, 20);

-- ============================================================
-- 3. 医学/医疗（20 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('临床医师',        3, 1),
('内科医生',        3, 2),
('外科医生',        3, 3),
('儿科医生',        3, 4),
('牙科医生',        3, 5),
('眼科医生',        3, 6),
('麻醉医生',        3, 7),
('中医师',          3, 8),
('康复治疗师',      3, 9),
('针灸推拿师',      3, 10),
('护士',            3, 11),
('药剂师',          3, 12),
('医学检验师',      3, 13),
('医学影像师',      3, 14),
('公共卫生管理',    3, 15),
('医药代表',        3, 16),
('药品研发',        3, 17),
('临床研究员',      3, 18),
('医疗器械销售',    3, 19),
('验光师',          3, 20);

-- ============================================================
-- 4. 金融/会计（20 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('会计',            4, 1),
('出纳',            4, 2),
('审计',            4, 3),
('税务专员',        4, 4),
('风控专员',        4, 5),
('财务分析',        4, 6),
('财务经理',        4, 7),
('投资分析师',      4, 8),
('基金经理',        4, 9),
('证券经纪人',      4, 10),
('交易员',          4, 11),
('信贷管理',        4, 12),
('保险精算师',      4, 13),
('保险顾问',        4, 14),
('核保理赔',        4, 15),
('银行柜员',        4, 16),
('客户经理',        4, 17),
('资产评估师',      4, 18),
('融资经理',        4, 19),
('理财顾问',        4, 20);

-- ============================================================
-- 5. 教育/培训（15 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('教师',            5, 1),
('幼教',            5, 2),
('外语教师',        5, 3),
('数学教师',        5, 4),
('语文教师',        5, 5),
('物理教师',        5, 6),
('化学教师',        5, 7),
('美术教师',        5, 8),
('音乐教师',        5, 9),
('体育教师',        5, 10),
('培训讲师',        5, 11),
('教务管理',        5, 12),
('班主任',          5, 13),
('留学顾问',        5, 14),
('课程设计师',      5, 15);

-- ============================================================
-- 6. 建筑/土木（20 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('建筑设计师',      6, 1),
('土木工程师',      6, 2),
('结构工程师',      6, 3),
('工程造价师',      6, 4),
('项目经理',        6, 5),
('室内设计师',      6, 6),
('施工员',          6, 7),
('测绘工程师',      6, 8),
('监理工程师',      6, 9),
('给排水工程师',    6, 10),
('暖通工程师',      6, 11),
('园林景观设计',    6, 12),
('BIM工程师',       6, 13),
('幕墙工程师',      6, 14),
('消防工程师',      6, 15),
('城乡规划设计',    6, 16),
('资料员',          6, 17),
('安全员',          6, 18),
('装修项目经理',    6, 19),
('置业顾问',        6, 20);

-- ============================================================
-- 7. 机械/制造（20 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('机械工程师',      7, 1),
('制造工程师',      7, 2),
('质量工程师',      7, 3),
('模具设计师',      7, 4),
('工艺工程师',      7, 5),
('结构工程师',      7, 6),
('CNC工程师',       7, 7),
('材料工程师',      7, 8),
('焊接工程师',      7, 9),
('注塑工程师',      7, 10),
('设备工程师',      7, 11),
('生产主管',        7, 12),
('质检员',          7, 13),
('安全员',          7, 14),
('电工',            7, 15),
('钳工',            7, 16),
('焊工',            7, 17),
('叉车工',          7, 18),
('普工',            7, 19),
('生产计划PMC',     7, 20);

-- ============================================================
-- 8. 销售/市场（20 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('销售代表',        8, 1),
('电话销售',        8, 2),
('渠道销售',        8, 3),
('大客户代表',      8, 4),
('销售经理',        8, 5),
('外贸业务员',      8, 6),
('汽车销售',        8, 7),
('房地产销售',      8, 8),
('市场专员',        8, 9),
('品牌策划',        8, 10),
('电商运营',        8, 11),
('新媒体运营',      8, 12),
('直播运营',        8, 13),
('内容运营',        8, 14),
('品类运营',        8, 15),
('活动策划',        8, 16),
('客服专员',        8, 17),
('售后客服',        8, 18),
('售前客服',        8, 19),
('广告投放',        8, 20);

-- ============================================================
-- 9. 物流/运输（15 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('物流专员',        9, 1),
('供应链管理',      9, 2),
('仓储管理',        9, 3),
('采购专员',        9, 4),
('货运代理',        9, 5),
('快递员',          9, 6),
('物料管理',        9, 7),
('单证员',          9, 8),
('调度员',          9, 9),
('配送经理',        9, 10),
('进出口报关',      9, 11),
('货车司机',        9, 12),
('空运操作',        9, 13),
('海运操作',        9, 14),
('供应链分析师',    9, 15);

-- ============================================================
-- 10. 传媒/设计（20 个职位）
-- ============================================================
INSERT INTO job_category (name, parent_id, sort_order) VALUES
('平面设计师',     10, 1),
('视频编辑',       10, 2),
('文案策划',       10, 3),
('摄影师',         10, 4),
('UI/UX设计师',    10, 5),
('视觉设计师',     10, 6),
('插画师',         10, 7),
('3D设计师',       10, 8),
('动画设计',       10, 9),
('原画师',         10, 10),
('记者/采编',      10, 11),
('编辑',           10, 12),
('导演/编导',      10, 13),
('后期制作',       10, 14),
('广告创意',       10, 15),
('服装设计',       10, 16),
('工业设计',       10, 17),
('游戏原画',       10, 18),
('包装设计',       10, 19),
('陈列设计',       10, 20);
-- ============================================================
-- 词典种子数据
-- ============================================================

USE job_analysis;

-- 停用词（通用，所有行业共用）
INSERT INTO stop_words (word) VALUES
('熟悉'), ('掌握'), ('了解'), ('精通'), ('具备'), ('具有'),
('负责'), ('参与'), ('能够'), ('相关'), ('以上'), ('优先'),
('经验'), ('能力'), ('良好'), ('较强'), ('一定'),
('的'), ('和'), ('与'), ('等'), ('及'), ('或'),
('，'), ('。'), ('、'), ('；'), ('（'), ('）'),
('有'), ('对'), ('在'), ('为');

-- ============================================================
-- 技能词典（按行业分段，每个行业预留 300 个 ID）
--
-- ID 段说明：
--      1 ~   300  计算机/互联网
--    301 ~   600  电气/自动化
--    601 ~   900  医学/医疗
--    901 ~  1200  金融/会计
--   1201 ~  1500  教育/培训
--   1501 ~  1800  建筑/土木
--   1801 ~  2100  机械/制造
--   2101 ~  2400  销售/市场
--   2401 ~  2700  物流/运输
--   2701 ~  3000  传媒/设计
-- ============================================================

-- ---------- 1 ~ 300：计算机/互联网 ----------
INSERT INTO skill_dict (id, skill, category) VALUES
(1,  'Python',           '计算机/互联网'),
(2,  'Java',             '计算机/互联网'),
(3,  'JavaScript',       '计算机/互联网'),
(4,  'TypeScript',       '计算机/互联网'),
(5,  'Go',               '计算机/互联网'),
(6,  'C++',              '计算机/互联网'),
(7,  'C',                '计算机/互联网'),
(8,  'Rust',             '计算机/互联网'),
(9,  'Scala',            '计算机/互联网'),
(10, 'Kotlin',           '计算机/互联网'),
(11, 'Swift',            '计算机/互联网'),
(12, 'PHP',              '计算机/互联网'),
(13, 'Ruby',             '计算机/互联网'),
(14, 'Shell',            '计算机/互联网'),
(15, 'SQL',              '计算机/互联网'),
(16, 'MySQL',            '计算机/互联网'),
(17, 'PostgreSQL',       '计算机/互联网'),
(18, 'MongoDB',          '计算机/互联网'),
(19, 'Redis',            '计算机/互联网'),
(20, 'Elasticsearch',    '计算机/互联网'),
(21, 'Oracle',           '计算机/互联网'),
(22, 'SQL Server',       '计算机/互联网'),
(23, 'SQLite',           '计算机/互联网'),
(24, 'HBase',            '计算机/互联网'),
(25, 'ClickHouse',       '计算机/互联网'),
(26, 'TiDB',             '计算机/互联网'),
(27, 'Django',           '计算机/互联网'),
(28, 'Flask',            '计算机/互联网'),
(29, 'FastAPI',          '计算机/互联网'),
(30, 'Spring Boot',      '计算机/互联网'),
(31, 'Spring Cloud',     '计算机/互联网'),
(32, 'MyBatis',          '计算机/互联网'),
(33, 'Hibernate',        '计算机/互联网'),
(34, 'Vue',              '计算机/互联网'),
(35, 'React',            '计算机/互联网'),
(36, 'Angular',          '计算机/互联网'),
(37, 'Node.js',          '计算机/互联网'),
(38, 'Express',          '计算机/互联网'),
(39, 'Koa',              '计算机/互联网'),
(40, 'Next.js',          '计算机/互联网'),
(41, 'Nuxt',             '计算机/互联网'),
(42, 'Flutter',          '计算机/互联网'),
(43, 'PyTorch',          '计算机/互联网'),
(44, 'TensorFlow',       '计算机/互联网'),
(45, 'Docker',           '计算机/互联网'),
(46, 'Kubernetes',       '计算机/互联网'),
(47, 'Jenkins',          '计算机/互联网'),
(48, 'GitLab CI',        '计算机/互联网'),
(49, 'GitHub Actions',   '计算机/互联网'),
(50, 'Ansible',          '计算机/互联网'),
(51, 'Terraform',        '计算机/互联网'),
(52, 'Prometheus',       '计算机/互联网'),
(53, 'Grafana',          '计算机/互联网'),
(54, 'ELK',              '计算机/互联网'),
(55, 'Nginx',            '计算机/互联网'),
(56, 'Linux',            '计算机/互联网'),
(57, '微服务',           '计算机/互联网'),
(58, '分布式',           '计算机/互联网'),
(59, '高并发',           '计算机/互联网'),
(60, 'RESTful',          '计算机/互联网'),
(61, 'GraphQL',          '计算机/互联网'),
(62, 'gRPC',             '计算机/互联网'),
(63, '消息队列',         '计算机/互联网'),
(64, 'Kafka',            '计算机/互联网'),
(65, 'RabbitMQ',         '计算机/互联网'),
(66, 'RocketMQ',         '计算机/互联网'),
(67, 'ZooKeeper',        '计算机/互联网'),
(68, 'ETCD',             '计算机/互联网'),
(69, 'Hadoop',           '计算机/互联网'),
(70, 'Spark',            '计算机/互联网'),
(71, 'Flink',            '计算机/互联网'),
(72, 'Hive',             '计算机/互联网'),
(73, 'HDFS',             '计算机/互联网'),
(74, '数据仓库',         '计算机/互联网'),
(75, 'ETL',              '计算机/互联网'),
(76, '数据挖掘',         '计算机/互联网'),
(77, '机器学习',         '计算机/互联网'),
(78, '深度学习',         '计算机/互联网'),
(79, 'NLP',              '计算机/互联网'),
(80, 'CV',               '计算机/互联网'),
(81, 'Git',              '计算机/互联网'),
(82, 'SVN',              '计算机/互联网'),
(83, 'Maven',            '计算机/互联网'),
(84, 'Gradle',           '计算机/互联网'),
(85, 'Webpack',          '计算机/互联网'),
(86, 'Vite',             '计算机/互联网'),
(87, 'JIRA',             '计算机/互联网'),
(88, 'Confluence',       '计算机/互联网');

-- ---------- 301 ~ 600：电气/自动化 ----------
-- INSERT INTO skill_dict (id, skill, category) VALUES
-- (301, '', '电气/自动化'),
-- (302, '', '电气/自动化'),
-- ...

-- ---------- 601 ~ 900：医学/医疗 ----------
-- INSERT INTO skill_dict (id, skill, category) VALUES
-- (601, '', '医学/医疗'),
-- ...

-- ---------- 901 ~ 1200：金融/会计 ----------
-- INSERT INTO skill_dict (id, skill, category) VALUES
-- (901, '', '金融/会计'),
-- ...

-- ---------- 1201 ~ 1500：教育/培训 ----------
-- INSERT INTO skill_dict (id, skill, category) VALUES
-- (1201, '', '教育/培训'),
-- ...

-- ---------- 1501 ~ 1800：建筑/土木 ----------
-- INSERT INTO skill_dict (id, skill, category) VALUES
-- (1501, '', '建筑/土木'),
-- ...

-- ---------- 1801 ~ 2100：机械/制造 ----------
-- INSERT INTO skill_dict (id, skill, category) VALUES
-- (1801, '', '机械/制造'),
-- ...

-- ---------- 2101 ~ 2400：销售/市场 ----------
-- INSERT INTO skill_dict (id, skill, category) VALUES
-- (2101, '', '销售/市场'),
-- ...

-- ---------- 2401 ~ 2700：物流/运输 ----------
-- INSERT INTO skill_dict (id, skill, category) VALUES
-- (2401, '', '物流/运输'),
-- ...

-- ---------- 2701 ~ 3000：传媒/设计 ----------
-- INSERT INTO skill_dict (id, skill, category) VALUES
-- (2701, '', '传媒/设计'),
-- ...

-- ============================================================
-- 技能同义词（std_word 必须在 skill_dict 中存在）
-- ============================================================
INSERT INTO skill_synonym (raw_word, std_word) VALUES
('K8s',           'Kubernetes'),
('Vue.js',        'Vue'),
('vuejs',         'Vue'),
('Node',          'Node.js'),
('nodejs',        'Node.js'),
('React.js',      'React'),
('reactjs',       'React'),
('Spring',        'Spring Boot'),
('SpringMVC',     'Spring Boot'),
('Tensorflow',    'TensorFlow'),
('Pytorch',       'PyTorch'),
('Postgres',      'PostgreSQL'),
('Mongo',         'MongoDB'),
('ES',            'Elasticsearch'),
('Linux系统',     'Linux'),
('linux服务器',   'Linux'),
('Nginx服务器',   'Nginx'),
('ELK Stack',     'ELK'),
('消息中间件',    '消息队列'),
('分布式系统',    '分布式'),
('分布式架构',    '分布式'),
('高并发系统',    '高并发'),
('REST',          'RESTful'),
('restful api',   'RESTful'),
('Restful',       'RESTful'),
('gRPC协议',      'gRPC'),
('grpc',          'gRPC'),
('MQ',            '消息队列'),
('CI/CD',         'Jenkins'),
('Github Actions','GitHub Actions'),
('GH Actions',    'GitHub Actions'),
('gitlab ci',     'GitLab CI'),
('gitlab-ci',     'GitLab CI'),
('Mybatis',       'MyBatis');
INSERT INTO synonym_dict (raw_word, std_word) VALUES
('Python开发工程师',  'Python开发'),
('Python开发',        'Python开发'),
('python工程师',      'Python开发'),
('Python高级开发',    'Python开发'),
('Java开发工程师',    'Java开发'),
('Java软件工程师',    'Java开发'),
('java开发',          'Java开发'),
('JAVA工程师',        'Java开发'),
('前端开发工程师',    '前端开发'),
('前端工程师',        '前端开发'),
('web前端',           '前端开发'),
('Web前端开发',       '前端开发'),
('后端开发工程师',    '后端开发'),
('后端工程师',        '后端开发'),
('服务端开发',        '后端开发'),
('全栈工程师',        '全栈开发'),
('全栈开发工程师',    '全栈开发'),
('数据分析师',        '数据分析'),
('数据分析工程师',    '数据分析'),
('大数据开发工程师',  '数据开发'),
('大数据工程师',      '数据开发'),
('大数据开发',        '数据开发'),
('高级Java开发',      'Java开发'),
('Python后端开发',    '后端开发'),
('Java后端开发',      '后端开发'),
('测试工程师',        '软件测试'),
('软件测试工程师',    '软件测试'),
('运维工程师',        '运维'),
('运维开发工程师',    '运维'),
('DevOps工程师',      '运维');
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
