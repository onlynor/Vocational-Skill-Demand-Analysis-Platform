mysqldump: [Warning] Using a password on the command line interface can be insecure.
-- MySQL dump 10.13  Distrib 9.3.0, for Win64 (x86_64)
--
-- Host: localhost    Database: job_analysis
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cleaned_jobs`
--

DROP TABLE IF EXISTS `cleaned_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cleaned_jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `raw_id` int DEFAULT NULL COMMENT '对应 raw_jobs.id',
  `title` varchar(128) NOT NULL COMMENT '岗位名称（已统一）',
  `category_id` int DEFAULT NULL,
  `salary_min` int DEFAULT NULL COMMENT '最低月薪',
  `salary_max` int DEFAULT NULL COMMENT '最高月薪',
  `salary_avg` int DEFAULT NULL COMMENT '平均月薪',
  `city` varchar(32) DEFAULT NULL,
  `education` varchar(16) DEFAULT NULL,
  `experience` varchar(32) DEFAULT NULL,
  `requirements` text COMMENT '岗位要求原文',
  `company` varchar(128) DEFAULT NULL,
  `source` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_title` (`title`),
  KEY `idx_city` (`city`),
  KEY `raw_id` (`raw_id`),
  KEY `fk_category` (`category_id`),
  CONSTRAINT `cleaned_jobs_ibfk_1` FOREIGN KEY (`raw_id`) REFERENCES `raw_jobs` (`id`) ON DELETE SET NULL,
  CONSTRAINT `cleaned_jobs_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `job_category` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='清洗后数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cleaned_jobs`
--

LOCK TABLES `cleaned_jobs` WRITE;
/*!40000 ALTER TABLE `cleaned_jobs` DISABLE KEYS */;
INSERT INTO `cleaned_jobs` VALUES (1,NULL,'Python开发',11,20000,30000,25000,'北京','本科','3年','熟悉Python开发，掌握MySQL，了解Redis','字节跳动','BOSS直聘'),(2,NULL,'Python开发',11,25000,35000,30000,'上海','硕士','5年','精通Python，掌握Docker和Kubernetes','拼多多','BOSS直聘'),(3,NULL,'后端开发',14,20000,30000,25000,'深圳','本科','3年','熟悉Python，掌握FastAPI、MongoDB、Elasticsearch','腾讯','拉勾'),(4,NULL,'Python开发',11,12000,20000,16000,'杭州','本科','2年','熟悉Python，掌握Flask、Git','网易','智联招聘'),(5,NULL,'Java开发',12,18000,28000,23000,'北京','本科','3年','精通Java开发，掌握MySQL、Redis、RabbitMQ','阿里巴巴','BOSS直聘'),(6,NULL,'Java开发',12,20000,30000,25000,'上海','本科','3年','精通Java，熟悉Spring Boot、MySQL、微服务架构','美团','BOSS直聘'),(7,NULL,'后端开发',14,20000,30000,25000,'深圳','硕士','5年','精通Java，熟悉MyBatis、Oracle数据库','华为','拉勾'),(8,NULL,'前端开发',13,15000,25000,20000,'北京','本科','2年','精通JavaScript，掌握Vue和React','字节跳动','BOSS直聘'),(9,NULL,'前端开发',13,15000,25000,20000,'上海','本科','2年','精通JavaScript，掌握React，了解Node.js','小红书','BOSS直聘'),(10,NULL,'前端开发',13,12000,20000,16000,'杭州','本科','2年','熟悉JavaScript，掌握Vue，了解TypeScript','蚂蚁集团','智联招聘'),(11,NULL,'数据分析',31,15000,25000,20000,'北京','本科','2年','掌握Python、SQL，了解数据挖掘、Hadoop、Spark','京东','BOSS直聘'),(12,NULL,'数据开发',32,25000,35000,30000,'上海','硕士','3年','精通Java、Python，掌握Hadoop、Hive、Spark、Flink、Kafka、Elasticsearch','百度','BOSS直聘');
/*!40000 ALTER TABLE `cleaned_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_category`
--

DROP TABLE IF EXISTS `job_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL COMMENT '分类名称',
  `parent_id` int DEFAULT NULL COMMENT '父级ID，NULL=一级行业',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  CONSTRAINT `job_category_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `job_category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='职位分类（二级树）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_category`
--

LOCK TABLES `job_category` WRITE;
/*!40000 ALTER TABLE `job_category` DISABLE KEYS */;
INSERT INTO `job_category` VALUES (1,'计算机/互联网',NULL,1),(2,'电气/自动化',NULL,2),(3,'医学/医疗',NULL,3),(4,'金融/会计',NULL,4),(5,'教育/培训',NULL,5),(6,'建筑/土木',NULL,6),(7,'机械/制造',NULL,7),(8,'销售/市场',NULL,8),(9,'物流/运输',NULL,9),(10,'传媒/设计',NULL,10),(11,'Python开发',1,1),(12,'Java开发',1,2),(13,'前端开发',1,3),(14,'后端开发',1,4),(15,'全栈开发',1,5),(16,'C++开发',1,6),(17,'Golang开发',1,7),(18,'PHP开发',1,8),(19,'.NET开发',1,9),(20,'Node.js开发',1,10),(21,'Android开发',1,11),(22,'iOS开发',1,12),(23,'鸿蒙开发',1,13),(24,'软件测试',1,14),(25,'测试开发',1,15),(26,'运维工程师',1,16),(27,'DBA',1,17),(28,'网络安全',1,18),(29,'算法工程师',1,19),(30,'NLP工程师',1,20),(31,'数据分析',1,21),(32,'数据开发',1,22),(33,'产品经理',1,23),(34,'UI设计师',1,24),(35,'游戏开发',1,25),(36,'区块链工程师',1,26),(37,'电气工程师',2,1),(38,'自动化工程师',2,2),(39,'PLC工程师',2,3),(40,'嵌入式开发',2,4),(41,'硬件工程师',2,5),(42,'电子工程师',2,6),(43,'FPGA开发',2,7),(44,'单片机工程师',2,8),(45,'驱动开发',2,9),(46,'PCB工程师',2,10),(47,'射频工程师',2,11),(48,'集成电路IC设计',2,12),(49,'电源工程师',2,13),(50,'机电工程师',2,14),(51,'电力工程师',2,15),(52,'通信工程师',2,16),(53,'网络工程师',2,17),(54,'FAE工程师',2,18),(55,'仪器仪表工程师',2,19),(56,'无线通信工程师',2,20),(57,'临床医师',3,1),(58,'内科医生',3,2),(59,'外科医生',3,3),(60,'儿科医生',3,4),(61,'牙科医生',3,5),(62,'眼科医生',3,6),(63,'麻醉医生',3,7),(64,'中医师',3,8),(65,'康复治疗师',3,9),(66,'针灸推拿师',3,10),(67,'护士',3,11),(68,'药剂师',3,12),(69,'医学检验师',3,13),(70,'医学影像师',3,14),(71,'公共卫生管理',3,15),(72,'医药代表',3,16),(73,'药品研发',3,17),(74,'临床研究员',3,18),(75,'医疗器械销售',3,19),(76,'验光师',3,20),(77,'会计',4,1),(78,'出纳',4,2),(79,'审计',4,3),(80,'税务专员',4,4),(81,'风控专员',4,5),(82,'财务分析',4,6),(83,'财务经理',4,7),(84,'投资分析师',4,8),(85,'基金经理',4,9),(86,'证券经纪人',4,10),(87,'交易员',4,11),(88,'信贷管理',4,12),(89,'保险精算师',4,13),(90,'保险顾问',4,14),(91,'核保理赔',4,15),(92,'银行柜员',4,16),(93,'客户经理',4,17),(94,'资产评估师',4,18),(95,'融资经理',4,19),(96,'理财顾问',4,20),(97,'教师',5,1),(98,'幼教',5,2),(99,'外语教师',5,3),(100,'数学教师',5,4),(101,'语文教师',5,5),(102,'物理教师',5,6),(103,'化学教师',5,7),(104,'美术教师',5,8),(105,'音乐教师',5,9),(106,'体育教师',5,10),(107,'培训讲师',5,11),(108,'教务管理',5,12),(109,'班主任',5,13),(110,'留学顾问',5,14),(111,'课程设计师',5,15),(112,'建筑设计师',6,1),(113,'土木工程师',6,2),(114,'结构工程师',6,3),(115,'工程造价师',6,4),(116,'项目经理',6,5),(117,'室内设计师',6,6),(118,'施工员',6,7),(119,'测绘工程师',6,8),(120,'监理工程师',6,9),(121,'给排水工程师',6,10),(122,'暖通工程师',6,11),(123,'园林景观设计',6,12),(124,'BIM工程师',6,13),(125,'幕墙工程师',6,14),(126,'消防工程师',6,15),(127,'城乡规划设计',6,16),(128,'资料员',6,17),(129,'安全员',6,18),(130,'装修项目经理',6,19),(131,'置业顾问',6,20),(132,'机械工程师',7,1),(133,'制造工程师',7,2),(134,'质量工程师',7,3),(135,'模具设计师',7,4),(136,'工艺工程师',7,5),(137,'结构工程师',7,6),(138,'CNC工程师',7,7),(139,'材料工程师',7,8),(140,'焊接工程师',7,9),(141,'注塑工程师',7,10),(142,'设备工程师',7,11),(143,'生产主管',7,12),(144,'质检员',7,13),(145,'安全员',7,14),(146,'电工',7,15),(147,'钳工',7,16),(148,'焊工',7,17),(149,'叉车工',7,18),(150,'普工',7,19),(151,'生产计划PMC',7,20),(152,'销售代表',8,1),(153,'电话销售',8,2),(154,'渠道销售',8,3),(155,'大客户代表',8,4),(156,'销售经理',8,5),(157,'外贸业务员',8,6),(158,'汽车销售',8,7),(159,'房地产销售',8,8),(160,'市场专员',8,9),(161,'品牌策划',8,10),(162,'电商运营',8,11),(163,'新媒体运营',8,12),(164,'直播运营',8,13),(165,'内容运营',8,14),(166,'品类运营',8,15),(167,'活动策划',8,16),(168,'客服专员',8,17),(169,'售后客服',8,18),(170,'售前客服',8,19),(171,'广告投放',8,20),(172,'物流专员',9,1),(173,'供应链管理',9,2),(174,'仓储管理',9,3),(175,'采购专员',9,4),(176,'货运代理',9,5),(177,'快递员',9,6),(178,'物料管理',9,7),(179,'单证员',9,8),(180,'调度员',9,9),(181,'配送经理',9,10),(182,'进出口报关',9,11),(183,'货车司机',9,12),(184,'空运操作',9,13),(185,'海运操作',9,14),(186,'供应链分析师',9,15),(187,'平面设计师',10,1),(188,'视频编辑',10,2),(189,'文案策划',10,3),(190,'摄影师',10,4),(191,'UI/UX设计师',10,5),(192,'视觉设计师',10,6),(193,'插画师',10,7),(194,'3D设计师',10,8),(195,'动画设计',10,9),(196,'原画师',10,10),(197,'记者/采编',10,11),(198,'编辑',10,12),(199,'导演/编导',10,13),(200,'后期制作',10,14),(201,'广告创意',10,15),(202,'服装设计',10,16),(203,'工业设计',10,17),(204,'游戏原画',10,18),(205,'包装设计',10,19),(206,'陈列设计',10,20);
/*!40000 ALTER TABLE `job_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_skill`
--

DROP TABLE IF EXISTS `job_skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_skill` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cleaned_job_id` int NOT NULL COMMENT '关联 cleaned_jobs.id',
  `skill` varchar(64) NOT NULL COMMENT '技能名称',
  `industry` varchar(64) DEFAULT NULL COMMENT '所属行业',
  `frequency` int DEFAULT '1' COMMENT '出现次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_job_skill` (`cleaned_job_id`,`skill`),
  KEY `idx_skill` (`skill`),
  KEY `idx_job` (`cleaned_job_id`),
  CONSTRAINT `job_skill_ibfk_1` FOREIGN KEY (`cleaned_job_id`) REFERENCES `cleaned_jobs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位技能频次';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_skill`
--

LOCK TABLES `job_skill` WRITE;
/*!40000 ALTER TABLE `job_skill` DISABLE KEYS */;
INSERT INTO `job_skill` VALUES (1,1,'Python','计算机/互联网',1),(2,1,'MySQL','计算机/互联网',1),(3,1,'Redis','计算机/互联网',1),(4,2,'Python','计算机/互联网',1),(5,2,'Docker','计算机/互联网',1),(6,2,'Kubernetes','计算机/互联网',1),(7,3,'Python','计算机/互联网',1),(8,3,'FastAPI','计算机/互联网',1),(9,3,'MongoDB','计算机/互联网',1),(10,3,'Elasticsearch','计算机/互联网',1),(11,4,'Python','计算机/互联网',1),(12,4,'Flask','计算机/互联网',1),(13,4,'Git','计算机/互联网',1),(14,5,'Java','计算机/互联网',1),(15,5,'MySQL','计算机/互联网',1),(16,5,'Redis','计算机/互联网',1),(17,5,'RabbitMQ','计算机/互联网',1),(18,6,'Java','计算机/互联网',1),(19,6,'Spring Boot','计算机/互联网',1),(20,6,'MySQL','计算机/互联网',1),(21,6,'微服务','计算机/互联网',1),(22,7,'Java','计算机/互联网',1),(23,7,'MyBatis','计算机/互联网',1),(24,7,'Oracle','计算机/互联网',1),(25,8,'JavaScript','计算机/互联网',1),(26,8,'Vue','计算机/互联网',1),(27,8,'React','计算机/互联网',1),(28,9,'JavaScript','计算机/互联网',1),(29,9,'React','计算机/互联网',1),(30,10,'JavaScript','计算机/互联网',1),(31,10,'Vue','计算机/互联网',1),(32,10,'TypeScript','计算机/互联网',1),(33,11,'Python','计算机/互联网',1),(34,11,'SQL','计算机/互联网',1),(35,11,'数据挖掘','计算机/互联网',1),(36,11,'Hadoop','计算机/互联网',1),(37,11,'Spark','计算机/互联网',1),(38,12,'Java','计算机/互联网',1),(39,12,'Python','计算机/互联网',1),(40,12,'Hadoop','计算机/互联网',1),(41,12,'Hive','计算机/互联网',1),(42,12,'Spark','计算机/互联网',1),(43,12,'Flink','计算机/互联网',1),(44,12,'Kafka','计算机/互联网',1),(45,12,'Elasticsearch','计算机/互联网',1);
/*!40000 ALTER TABLE `job_skill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `raw_jobs`
--

DROP TABLE IF EXISTS `raw_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `raw_jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL COMMENT '岗位名称',
  `salary_text` varchar(64) DEFAULT NULL COMMENT '薪资原文，如 20K-30K',
  `city` varchar(32) DEFAULT NULL COMMENT '工作城市',
  `education` varchar(16) DEFAULT NULL COMMENT '学历要求',
  `experience` varchar(32) DEFAULT NULL COMMENT '经验要求',
  `requirements` text COMMENT '岗位要求原文',
  `company` varchar(128) DEFAULT NULL COMMENT '公司名称',
  `source` varchar(32) DEFAULT NULL COMMENT '来源网站',
  PRIMARY KEY (`id`),
  KEY `idx_city` (`city`),
  KEY `idx_title_city` (`title`,`city`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='原始招聘数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `raw_jobs`
--

LOCK TABLES `raw_jobs` WRITE;
/*!40000 ALTER TABLE `raw_jobs` DISABLE KEYS */;
INSERT INTO `raw_jobs` VALUES (1,'Python开发工程师','15K-25K','北京','本科','3年经验','熟悉Python开发，掌握Django框架，了解MySQL、Redis，具备Linux操作能力','字节跳动','BOSS直聘'),(2,'Python高级开发','25K-35K','上海','本科','5年经验','精通Python，熟悉微服务架构，掌握Docker、Kubernetes，了解分布式系统','拼多多','BOSS直聘'),(3,'Python后端开发','20K-30K','深圳','本科','3年经验','熟悉Python和FastAPI框架，掌握MySQL、MongoDB，了解Elasticsearch','腾讯','BOSS直聘'),(4,'Python开发','12K-20K','杭州','大专','1年经验','熟悉Python开发，掌握Flask框架，了解MySQL、Git','网易','BOSS直聘'),(5,'Java开发工程师','18K-28K','北京','本科','3年经验','精通Java，掌握Spring Boot框架，熟悉MySQL、Redis、RabbitMQ','阿里巴巴','BOSS直聘'),(6,'高级Java开发','30K-40K','上海','硕士','5年经验','精通Java和Spring Cloud微服务，掌握Kubernetes、Docker，熟悉高并发编程','美团','BOSS直聘'),(7,'Java后端开发','20K-30K','深圳','本科','3年经验','熟悉Java和MyBatis框架，掌握MySQL、Oracle，了解分布式系统','华为','BOSS直聘'),(8,'前端开发工程师','15K-25K','北京','本科','2年经验','精通JavaScript和TypeScript，掌握Vue和React框架，了解Webpack、Node.js','字节跳动','BOSS直聘'),(9,'Web前端开发','18K-28K','上海','本科','3年经验','熟悉React和Vue框架，掌握JavaScript和TypeScript，了解Node.js、Nginx','小红书','BOSS直聘'),(10,'前端开发','12K-18K','杭州','大专','1年经验','熟悉Vue框架和JavaScript，掌握HTML、CSS，了解Git和Webpack','蚂蚁集团','BOSS直聘'),(11,'数据分析师','15K-25K','北京','本科','2年经验','精通Python和SQL，熟悉Pandas和NumPy，掌握数据挖掘和机器学习，了解Hadoop、Spark','京东','BOSS直聘'),(12,'大数据开发工程师','25K-35K','上海','本科','3年经验','精通Java和Python，掌握Hadoop和Spark，熟悉Flink和Hive，了解Kafka和Elasticsearch','百度','BOSS直聘');
/*!40000 ALTER TABLE `raw_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill_dict`
--

DROP TABLE IF EXISTS `skill_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skill_dict` (
  `id` int NOT NULL AUTO_INCREMENT,
  `skill` varchar(64) NOT NULL COMMENT '技能名称',
  `category` varchar(32) DEFAULT NULL COMMENT '技能分类（编程语言/数据库/框架/架构等）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_skill` (`skill`)
) ENGINE=InnoDB AUTO_INCREMENT=3001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='技能词典';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_dict`
--

LOCK TABLES `skill_dict` WRITE;
/*!40000 ALTER TABLE `skill_dict` DISABLE KEYS */;
INSERT INTO `skill_dict` VALUES (1,'Python','计算机/互联网'),(2,'Java','计算机/互联网'),(3,'JavaScript','计算机/互联网'),(4,'TypeScript','计算机/互联网'),(5,'Go','计算机/互联网'),(6,'C++','计算机/互联网'),(7,'C','计算机/互联网'),(8,'Rust','计算机/互联网'),(9,'Scala','计算机/互联网'),(10,'Kotlin','计算机/互联网'),(11,'Swift','计算机/互联网'),(12,'PHP','计算机/互联网'),(13,'Ruby','计算机/互联网'),(14,'Shell','计算机/互联网'),(15,'SQL','计算机/互联网'),(16,'MySQL','计算机/互联网'),(17,'PostgreSQL','计算机/互联网'),(18,'MongoDB','计算机/互联网'),(19,'Redis','计算机/互联网'),(20,'Elasticsearch','计算机/互联网'),(21,'Oracle','计算机/互联网'),(22,'SQL Server','计算机/互联网'),(23,'SQLite','计算机/互联网'),(24,'HBase','计算机/互联网'),(25,'ClickHouse','计算机/互联网'),(26,'TiDB','计算机/互联网'),(27,'Django','计算机/互联网'),(28,'Flask','计算机/互联网'),(29,'FastAPI','计算机/互联网'),(30,'Spring Boot','计算机/互联网'),(31,'Spring Cloud','计算机/互联网'),(32,'MyBatis','计算机/互联网'),(33,'Hibernate','计算机/互联网'),(34,'Vue','计算机/互联网'),(35,'React','计算机/互联网'),(36,'Angular','计算机/互联网'),(37,'Node.js','计算机/互联网'),(38,'Express','计算机/互联网'),(39,'Koa','计算机/互联网'),(40,'Next.js','计算机/互联网'),(41,'Nuxt','计算机/互联网'),(42,'Flutter','计算机/互联网'),(43,'PyTorch','计算机/互联网'),(44,'TensorFlow','计算机/互联网'),(45,'Docker','计算机/互联网'),(46,'Kubernetes','计算机/互联网'),(47,'Jenkins','计算机/互联网'),(48,'GitLab CI','计算机/互联网'),(49,'GitHub Actions','计算机/互联网'),(50,'Ansible','计算机/互联网'),(51,'Terraform','计算机/互联网'),(52,'Prometheus','计算机/互联网'),(53,'Grafana','计算机/互联网'),(54,'ELK','计算机/互联网'),(55,'Nginx','计算机/互联网'),(56,'Linux','计算机/互联网'),(57,'微服务','计算机/互联网'),(58,'分布式','计算机/互联网'),(59,'高并发','计算机/互联网'),(60,'RESTful','计算机/互联网'),(61,'GraphQL','计算机/互联网'),(62,'gRPC','计算机/互联网'),(63,'消息队列','计算机/互联网'),(64,'Kafka','计算机/互联网'),(65,'RabbitMQ','计算机/互联网'),(66,'RocketMQ','计算机/互联网'),(67,'ZooKeeper','计算机/互联网'),(68,'ETCD','计算机/互联网'),(69,'Hadoop','计算机/互联网'),(70,'Spark','计算机/互联网'),(71,'Flink','计算机/互联网'),(72,'Hive','计算机/互联网'),(73,'HDFS','计算机/互联网'),(74,'数据仓库','计算机/互联网'),(75,'ETL','计算机/互联网'),(76,'数据挖掘','计算机/互联网'),(77,'机器学习','计算机/互联网'),(78,'深度学习','计算机/互联网'),(79,'NLP','计算机/互联网'),(80,'CV','计算机/互联网'),(81,'Git','计算机/互联网'),(82,'SVN','计算机/互联网'),(83,'Maven','计算机/互联网'),(84,'Gradle','计算机/互联网'),(85,'Webpack','计算机/互联网'),(86,'Vite','计算机/互联网'),(87,'JIRA','计算机/互联网'),(88,'Confluence','计算机/互联网');
/*!40000 ALTER TABLE `skill_dict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skill_synonym`
--

DROP TABLE IF EXISTS `skill_synonym`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skill_synonym` (
  `id` int NOT NULL AUTO_INCREMENT,
  `raw_word` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `std_word` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `raw_word` (`raw_word`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_synonym`
--

LOCK TABLES `skill_synonym` WRITE;
/*!40000 ALTER TABLE `skill_synonym` DISABLE KEYS */;
INSERT INTO `skill_synonym` VALUES (84,'K8s','Kubernetes'),(85,'Vue.js','Vue'),(86,'vuejs','Vue'),(87,'Node','Node.js'),(88,'nodejs','Node.js'),(89,'React.js','React'),(90,'reactjs','React'),(91,'Spring','Spring Boot'),(92,'SpringMVC','Spring Boot'),(93,'Tensorflow','TensorFlow'),(94,'Pytorch','PyTorch'),(95,'Postgres','PostgreSQL'),(96,'Mongo','MongoDB'),(97,'ES','Elasticsearch'),(98,'Linux系统','Linux'),(99,'linux服务器','Linux'),(100,'Nginx服务器','Nginx'),(101,'ELK Stack','ELK'),(102,'消息中间件','消息队列'),(103,'分布式系统','分布式'),(104,'分布式架构','分布式'),(105,'高并发系统','高并发'),(106,'REST','RESTful'),(107,'restful api','RESTful'),(108,'Restful','RESTful'),(109,'gRPC协议','gRPC'),(110,'grpc','gRPC'),(111,'MQ','消息队列'),(112,'CI/CD','Jenkins'),(113,'Github Actions','GitHub Actions'),(114,'GH Actions','GitHub Actions'),(115,'gitlab ci','GitLab CI'),(116,'gitlab-ci','GitLab CI'),(117,'Mybatis','MyBatis');
/*!40000 ALTER TABLE `skill_synonym` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stop_words`
--

DROP TABLE IF EXISTS `stop_words`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stop_words` (
  `id` int NOT NULL AUTO_INCREMENT,
  `word` varchar(32) NOT NULL COMMENT '停用词',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_word` (`word`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='停用词表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stop_words`
--

LOCK TABLES `stop_words` WRITE;
/*!40000 ALTER TABLE `stop_words` DISABLE KEYS */;
INSERT INTO `stop_words` VALUES (24,'，'),(26,'、'),(27,'；'),(25,'。'),(28,'（'),(29,'）'),(17,'一定'),(20,'与'),(33,'为'),(3,'了解'),(11,'以上'),(12,'优先'),(5,'具备'),(6,'具有'),(8,'参与'),(22,'及'),(19,'和'),(32,'在'),(31,'对'),(23,'或'),(2,'掌握'),(30,'有'),(1,'熟悉'),(18,'的'),(10,'相关'),(21,'等'),(4,'精通'),(13,'经验'),(14,'能力'),(9,'能够'),(15,'良好'),(7,'负责'),(16,'较强');
/*!40000 ALTER TABLE `stop_words` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `synonym_dict`
--

DROP TABLE IF EXISTS `synonym_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `synonym_dict` (
  `id` int NOT NULL AUTO_INCREMENT,
  `raw_word` varchar(64) NOT NULL COMMENT '原始写法',
  `std_word` varchar(64) NOT NULL COMMENT '标准写法',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_raw` (`raw_word`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='同义词字典';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `synonym_dict`
--

LOCK TABLES `synonym_dict` WRITE;
/*!40000 ALTER TABLE `synonym_dict` DISABLE KEYS */;
INSERT INTO `synonym_dict` VALUES (1,'Python开发工程师','Python开发'),(2,'Python开发','Python开发'),(3,'python工程师','Python开发'),(4,'Python高级开发','Python开发'),(5,'Java开发工程师','Java开发'),(6,'Java软件工程师','Java开发'),(7,'java开发','Java开发'),(8,'JAVA工程师','Java开发'),(9,'前端开发工程师','前端开发'),(10,'前端工程师','前端开发'),(11,'web前端','前端开发'),(12,'Web前端开发','前端开发'),(13,'后端开发工程师','后端开发'),(14,'后端工程师','后端开发'),(15,'服务端开发','后端开发'),(16,'全栈工程师','全栈开发'),(17,'全栈开发工程师','全栈开发'),(18,'数据分析师','数据分析'),(19,'数据分析工程师','数据分析'),(20,'大数据开发工程师','数据开发'),(21,'大数据工程师','数据开发'),(22,'测试工程师','软件测试'),(23,'软件测试工程师','软件测试'),(24,'运维工程师','运维'),(25,'运维开发工程师','运维'),(26,'DevOps工程师','运维'),(27,'Python后端开发','后端开发'),(28,'Java后端开发','后端开发'),(29,'高级Java开发','Java开发'),(30,'大数据开发','数据开发');
/*!40000 ALTER TABLE `synonym_dict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL COMMENT '用户名',
  `password_hash` varchar(256) NOT NULL COMMENT '密码哈希',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'test','$2b$12$8dvny34DcUSRHPNt9cQ6HusywqnutOsOkRW.lKA707ayV.j20R0Nm','2026-07-13 17:24:29'),(2,'test3','$2b$12$/3hm2SsBHdqT/qRQ3q..FO8Cwk9aXbWJVM6DWE4xE1ORkcitqf1tm','2026-07-13 17:26:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'job_analysis'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-21 23:20:22
