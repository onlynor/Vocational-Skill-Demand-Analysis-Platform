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
