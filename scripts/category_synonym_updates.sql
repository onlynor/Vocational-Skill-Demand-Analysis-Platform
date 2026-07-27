-- ==========================================
-- Category & Synonym Updates
-- Generated: 675 category inserts, 1800 synonym inserts
-- ==========================================

-- 1. New & Extended Categories
-- New industry: 法律/合规
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (323, '法律/合规', NULL, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (324, '律师', 323, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (325, '法务专员', 323, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (326, '法律顾问', 323, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (327, '合规专员', 323, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (328, '知识产权顾问', 323, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (329, '专利代理人', 323, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (330, '法务经理', 323, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (331, '法律咨询顾问', 323, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (332, '合同管理员', 323, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (333, '法诉专员', 323, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (334, '尽调专员', 323, 11);
-- New industry: 行政/人事
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (335, '行政/人事', NULL, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (336, '行政专员', 335, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (337, '行政助理', 335, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (338, '前台', 335, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (339, '人事专员', 335, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (340, '招聘专员', 335, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (341, '人事行政专员', 335, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (342, '薪酬专员', 335, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (343, '培训专员', 335, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (344, '秘书', 335, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (345, '文员', 335, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (346, '劳动关系专员', 335, 11);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (347, '人事经理', 335, 12);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (348, '行政经理', 335, 13);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (349, '招聘经理', 335, 14);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (350, '员工关系专员', 335, 15);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (351, 'HRBP', 335, 16);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (352, '人力资源主管', 335, 17);
-- New industry: 物业/安保
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (353, '物业/安保', NULL, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (354, '物业管理员', 353, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (355, '保安', 353, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (356, '消防中控员', 353, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (357, '物业客服', 353, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (358, '物业经理', 353, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (359, '安防监控员', 353, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (360, '消防安全员', 353, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (361, '保安班长', 353, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (362, '门卫', 353, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (363, '停车场管理员', 353, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (364, '物业工程维修', 353, 11);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (365, '安全主管', 353, 12);
-- New industry: 餐饮/服务
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (366, '餐饮/服务', NULL, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (367, '厨师', 366, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (368, '服务员', 366, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (369, '咖啡师', 366, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (370, '调酒师', 366, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (371, '面点师', 366, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (372, '烘焙师', 366, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (373, '帮厨', 366, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (374, '洗碗工', 366, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (375, '餐厅经理', 366, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (376, '奶茶店员', 366, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (377, '配菜员', 366, 11);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (378, '切菜员', 366, 12);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (379, '打荷', 366, 13);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (380, '前厅经理', 366, 14);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (381, '店长', 366, 15);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (382, '学徒', 366, 16);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (383, '送餐员', 366, 17);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (384, '日料厨师', 366, 18);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (385, '烧腊师傅', 366, 19);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (386, '西餐厨师', 366, 20);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (387, '中餐厨师', 366, 21);
-- New industry: 家政/生活服务
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (388, '家政/生活服务', NULL, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (389, '保洁', 388, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (390, '保姆', 388, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (391, '月嫂', 388, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (392, '护工', 388, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (393, '育儿嫂', 388, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (394, '收纳师', 388, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (395, '家电清洗师', 388, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (396, '钟点工', 388, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (397, '管家', 388, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (398, '育婴师', 388, 10);
-- New industry: 美容/养生
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (399, '美容/养生', NULL, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (400, '美容师', 399, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (401, '美发师', 399, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (402, '美甲师', 399, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (403, '化妆师', 399, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (404, '养生技师', 399, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (405, '按摩师', 399, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (406, '足疗师', 399, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (407, '采耳师', 399, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (408, 'SPA技师', 399, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (409, '皮肤管理师', 399, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (410, '医美顾问', 399, 11);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (411, '纹绣师', 399, 12);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (412, '美睫师', 399, 13);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (413, '理疗师', 399, 14);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (414, '美容顾问', 399, 15);
-- New industry: 酒店/旅游
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (415, '酒店/旅游', NULL, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (416, '酒店前台', 415, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (417, '客房服务员', 415, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (418, '导游', 415, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (419, '旅游计调', 415, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (420, '票务员', 415, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (421, '礼宾员', 415, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (422, '酒店经理', 415, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (423, '民宿管家', 415, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (424, '签证专员', 415, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (425, '门童', 415, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (426, '大堂经理', 415, 11);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (427, '行李员', 415, 12);
-- New industry: 体育/健身
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (428, '体育/健身', NULL, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (429, '健身教练', 428, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (430, '瑜伽老师', 428, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (431, '游泳教练', 428, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (432, '篮球教练', 428, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (433, '足球教练', 428, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (434, '羽毛球教练', 428, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (435, '网球教练', 428, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (436, '跆拳道教练', 428, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (437, '拳击教练', 428, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (438, '滑雪教练', 428, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (439, '潜水教练', 428, 11);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (440, '体适能教练', 428, 12);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (441, '普拉提教练', 428, 13);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (442, '高尔夫教练', 428, 14);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (443, '体育老师', 428, 15);
-- New industry: 农林牧渔
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (444, '农林牧渔', NULL, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (445, '农业技术员', 444, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (446, '种植技术员', 444, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (447, '养殖技术员', 444, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (448, '林业技术员', 444, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (449, '渔业技术员', 444, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (450, '园艺师', 444, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (451, '园林绿化', 444, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (452, '农艺师', 444, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (453, '畜牧师', 444, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (454, '农业销售', 444, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (455, '农药销售', 444, 11);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (456, '饲料销售', 444, 12);
-- New industry: 新能源
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (457, '新能源', NULL, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (458, '光伏工程师', 457, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (459, '风电工程师', 457, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (460, '储能工程师', 457, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (461, '锂电工程师', 457, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (462, '新能源销售', 457, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (463, '充电桩运维', 457, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (464, '光伏设计', 457, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (465, '光伏安装', 457, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (466, '新能源项目经理', 457, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (467, '电池研发', 457, 10);
-- New industry: 化工/日化
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (468, '化工/日化', NULL, 11);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (469, '化工工程师', 468, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (470, '化学分析员', 468, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (471, '研发工程师', 468, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (472, '化妆品研发', 468, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (473, '涂料工程师', 468, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (474, '高分子材料工程师', 468, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (475, '日化研发', 468, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (476, '实验室技术员', 468, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (477, '化学检验员', 468, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (478, '化工工艺师', 468, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (479, '试剂研发', 468, 11);
-- New industry: 影视/演艺
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (480, '影视/演艺', NULL, 12);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (481, '演员', 480, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (482, '导演', 480, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (483, '编剧', 480, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (484, '制片人', 480, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (485, '艺人助理', 480, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (486, '短视频编导', 480, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (487, '短视频运营', 480, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (488, '抖音运营', 480, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (489, '才艺主播', 480, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (490, '娱乐主播', 480, 10);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (491, '带货主播', 480, 11);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (492, '舞台监督', 480, 12);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (493, '剧组场务', 480, 13);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (494, '选角导演', 480, 14);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (495, '经纪人', 480, 15);
-- New industry: 汽车
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (496, '汽车', NULL, 13);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (497, '汽车维修工', 496, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (498, '汽车美容师', 496, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (499, '二手车评估师', 496, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (500, '4S店销售顾问', 496, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (501, '汽车检测师', 496, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (502, '钣金工', 496, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (503, '喷漆工', 496, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (504, '汽车机电维修', 496, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (505, '车险理赔', 496, 9);
-- New industry: 环保/环境
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (506, '环保/环境', NULL, 14);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (507, '环保工程师', 506, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (508, '污水处理工', 506, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (509, '环评工程师', 506, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (510, '碳排放管理员', 506, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (511, '给水工程师', 506, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (512, '环保销售', 506, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (513, '固废处理工程师', 506, 7);
-- New industry: 咨询/商务服务
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (514, '咨询/商务服务', NULL, 15);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (515, '咨询顾问', 514, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (516, '管理咨询师', 514, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (517, '猎头顾问', 514, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (518, '企业管理咨询', 514, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (519, '认证咨询师', 514, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (520, '移民顾问', 514, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (521, '婚恋顾问', 514, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (522, '理赔专员', 514, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (523, '知识产权代理', 514, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (524, '工商财税顾问', 514, 10);
-- New industry: 质检/检测
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (525, '质检/检测', NULL, 16);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (526, '化验员', 525, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (527, '检测工程师', 525, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (528, '认证审核员', 525, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (529, '品控专员', 525, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (530, '试验员', 525, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (531, '无损检测员', 525, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (532, '验货员', 525, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (533, '计量员', 525, 8);
-- New industry: 客服
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (534, '客服', NULL, 17);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (535, '电话客服', 534, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (536, '在线客服', 534, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (537, '投诉专员', 534, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (538, '呼叫中心客服', 534, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (539, 'VIP客服', 534, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (540, '客服主管', 534, 6);
-- New industry: 服装/纺织
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (541, '服装/纺织', NULL, 18);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (542, '服装设计师', 541, 1);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (543, '服装打版师', 541, 2);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (544, '样衣工', 541, 3);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (545, '缝纫工', 541, 4);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (546, '面料采购', 541, 5);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (547, '跟单员', 541, 6);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (548, '服装销售', 541, 7);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (549, '纺织工程师', 541, 8);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (550, '服装质检', 541, 9);
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (551, '裁缝', 541, 10);
-- Extend 计算机/互联网: 数据分析师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (552, '数据分析师', 1, 38);
-- Extend 计算机/互联网: 大数据工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (553, '大数据工程师', 1, 39);
-- Extend 计算机/互联网: ETL工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (554, 'ETL工程师', 1, 40);
-- Extend 计算机/互联网: 数据仓库工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (555, '数据仓库工程师', 1, 41);
-- Extend 计算机/互联网: 算法研究员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (556, '算法研究员', 1, 42);
-- Extend 计算机/互联网: 大模型算法
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (557, '大模型算法', 1, 43);
-- Extend 计算机/互联网: AIGC算法
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (558, 'AIGC算法', 1, 44);
-- Extend 计算机/互联网: 推荐算法工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (559, '推荐算法工程师', 1, 45);
-- Extend 计算机/互联网: 计算机视觉工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (560, '计算机视觉工程师', 1, 46);
-- Extend 计算机/互联网: 自然语言处理工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (561, '自然语言处理工程师', 1, 47);
-- Extend 计算机/互联网: 系统架构师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (562, '系统架构师', 1, 48);
-- Extend 计算机/互联网: 技术经理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (563, '技术经理', 1, 49);
-- Extend 计算机/互联网: 技术总监
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (564, '技术总监', 1, 50);
-- Extend 计算机/互联网: CTO
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (565, 'CTO', 1, 51);
-- Extend 计算机/互联网: 中间件工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (566, '中间件工程师', 1, 52);
-- Extend 计算机/互联网: 基础架构工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (567, '基础架构工程师', 1, 53);
-- Extend 计算机/互联网: SRE工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (568, 'SRE工程师', 1, 54);
-- Extend 计算机/互联网: 测试经理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (569, '测试经理', 1, 55);
-- Extend 计算机/互联网: 质量保证工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (570, '质量保证工程师', 1, 56);
-- Extend 计算机/互联网: 安全运维工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (571, '安全运维工程师', 1, 57);
-- Extend 计算机/互联网: IT支持
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (572, 'IT支持', 1, 58);
-- Extend 计算机/互联网: 技术支持工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (573, '技术支持工程师', 1, 59);
-- Extend 计算机/互联网: Helpdesk
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (574, 'Helpdesk', 1, 60);
-- Extend 计算机/互联网: 桌面运维
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (575, '桌面运维', 1, 61);
-- Extend 计算机/互联网: ERP实施顾问
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (576, 'ERP实施顾问', 1, 62);
-- Extend 计算机/互联网: CRM实施顾问
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (577, 'CRM实施顾问', 1, 63);
-- Extend 计算机/互联网: 信息化专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (578, '信息化专员', 1, 64);
-- Extend 计算机/互联网: 企业应用工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (579, '企业应用工程师', 1, 65);
-- Extend 计算机/互联网: RPA开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (580, 'RPA开发', 1, 66);
-- Extend 计算机/互联网: 低代码开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (581, '低代码开发', 1, 67);
-- Extend 计算机/互联网: 游戏数值策划
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (582, '游戏数值策划', 1, 68);
-- Extend 计算机/互联网: 游戏系统策划
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (583, '游戏系统策划', 1, 69);
-- Extend 计算机/互联网: 游戏运营专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (584, '游戏运营专员', 1, 70);
-- Extend 计算机/互联网: 游戏美术
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (585, '游戏美术', 1, 71);
-- Extend 计算机/互联网: 游戏特效
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (586, '游戏特效', 1, 72);
-- Extend 计算机/互联网: 游戏音效
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (587, '游戏音效', 1, 73);
-- Extend 计算机/互联网: Unity开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (588, 'Unity开发', 1, 74);
-- Extend 计算机/互联网: Unreal开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (589, 'Unreal开发', 1, 75);
-- Extend 计算机/互联网: Cocos开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (590, 'Cocos开发', 1, 76);
-- Extend 计算机/互联网: 客户端开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (591, '客户端开发', 1, 77);
-- Extend 计算机/互联网: Windows开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (592, 'Windows开发', 1, 78);
-- Extend 计算机/互联网: Mac开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (593, 'Mac开发', 1, 79);
-- Extend 计算机/互联网: 音视频开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (594, '音视频开发', 1, 80);
-- Extend 计算机/互联网: 流媒体开发
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (595, '流媒体开发', 1, 81);
-- Extend 计算机/互联网: CDN工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (596, 'CDN工程师', 1, 82);
-- Extend 计算机/互联网: 云计算工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (597, '云计算工程师', 1, 83);
-- Extend 计算机/互联网: 容器工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (598, '容器工程师', 1, 84);
-- Extend 计算机/互联网: K8S运维
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (599, 'K8S运维', 1, 85);
-- Extend 电气/自动化: 弱电工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (600, '弱电工程师', 2, 23);
-- Extend 电气/自动化: 强电工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (601, '强电工程师', 2, 24);
-- Extend 电气/自动化: 变电工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (602, '变电工程师', 2, 25);
-- Extend 电气/自动化: 输配电工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (603, '输配电工程师', 2, 26);
-- Extend 电气/自动化: 继电保护工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (604, '继电保护工程师', 2, 27);
-- Extend 电气/自动化: 自动化控制工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (605, '自动化控制工程师', 2, 28);
-- Extend 电气/自动化: DCS工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (606, 'DCS工程师', 2, 29);
-- Extend 电气/自动化: SCADA工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (607, 'SCADA工程师', 2, 30);
-- Extend 电气/自动化: 机器人工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (608, '机器人工程师', 2, 31);
-- Extend 电气/自动化: 新能源电气工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (609, '新能源电气工程师', 2, 32);
-- Extend 电气/自动化: 储能电气工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (610, '储能电气工程师', 2, 33);
-- Extend 金融/会计: 财务专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (611, '财务专员', 4, 37);
-- Extend 金融/会计: 应收会计
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (612, '应收会计', 4, 38);
-- Extend 金融/会计: 应付会计
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (613, '应付会计', 4, 39);
-- Extend 金融/会计: 财务BP
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (614, '财务BP', 4, 40);
-- Extend 金融/会计: 税务会计
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (615, '税务会计', 4, 41);
-- Extend 金融/会计: 预算管理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (616, '预算管理', 4, 42);
-- Extend 金融/会计: 内审专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (617, '内审专员', 4, 43);
-- Extend 金融/会计: 反洗钱专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (618, '反洗钱专员', 4, 44);
-- Extend 金融/会计: 贷后管理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (619, '贷后管理', 4, 45);
-- Extend 金融/会计: 催收专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (620, '催收专员', 4, 46);
-- Extend 金融/会计: 委外催收
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (621, '委外催收', 4, 47);
-- Extend 金融/会计: 按揭专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (622, '按揭专员', 4, 48);
-- Extend 金融/会计: 抵押专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (623, '抵押专员', 4, 49);
-- Extend 金融/会计: 担保专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (624, '担保专员', 4, 50);
-- Extend 教育/培训: 托管老师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (625, '托管老师', 5, 25);
-- Extend 教育/培训: 辅导老师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (626, '辅导老师', 5, 26);
-- Extend 教育/培训: 学习管理师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (627, '学习管理师', 5, 27);
-- Extend 教育/培训: 艺考老师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (628, '艺考老师', 5, 28);
-- Extend 教育/培训: 书法老师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (629, '书法老师', 5, 29);
-- Extend 教育/培训: 舞蹈老师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (630, '舞蹈老师', 5, 30);
-- Extend 教育/培训: 编程老师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (631, '编程老师', 5, 31);
-- Extend 教育/培训: 机器人老师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (632, '机器人老师', 5, 32);
-- Extend 教育/培训: 口才老师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (633, '口才老师', 5, 33);
-- Extend 教育/培训: 主持老师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (634, '主持老师', 5, 34);
-- Extend 教育/培训: 营地导师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (635, '营地导师', 5, 35);
-- Extend 教育/培训: 研学导师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (636, '研学导师', 5, 36);
-- Extend 建筑/土木: 幕墙设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (637, '幕墙设计师', 6, 24);
-- Extend 建筑/土木: 园林设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (638, '园林设计师', 6, 25);
-- Extend 建筑/土木: 景观设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (639, '景观设计师', 6, 26);
-- Extend 建筑/土木: 规划设计
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (640, '规划设计', 6, 27);
-- Extend 建筑/土木: 土地规划
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (641, '土地规划', 6, 28);
-- Extend 建筑/土木: 房产评估师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (642, '房产评估师', 6, 29);
-- Extend 建筑/土木: 房地产策划
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (643, '房地产策划', 6, 30);
-- Extend 建筑/土木: 拆迁专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (644, '拆迁专员', 6, 31);
-- Extend 建筑/土木: 报建专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (645, '报建专员', 6, 32);
-- Extend 建筑/土木: 开发报建
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (646, '开发报建', 6, 33);
-- Extend 建筑/土木: 现场管理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (647, '现场管理', 6, 34);
-- Extend 机械/制造: 数控机床操作工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (648, '数控机床操作工', 7, 28);
-- Extend 机械/制造: 磨工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (649, '磨工', 7, 29);
-- Extend 机械/制造: 铣工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (650, '铣工', 7, 30);
-- Extend 机械/制造: 车工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (651, '车工', 7, 31);
-- Extend 机械/制造: 镗工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (652, '镗工', 7, 32);
-- Extend 机械/制造: 线切割工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (653, '线切割工', 7, 33);
-- Extend 机械/制造: 电火花工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (654, '电火花工', 7, 34);
-- Extend 机械/制造: 抛光工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (655, '抛光工', 7, 35);
-- Extend 机械/制造: 喷砂工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (656, '喷砂工', 7, 36);
-- Extend 机械/制造: 铸造工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (657, '铸造工', 7, 37);
-- Extend 机械/制造: 锻造工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (658, '锻造工', 7, 38);
-- Extend 机械/制造: 冲压工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (659, '冲压工', 7, 39);
-- Extend 机械/制造: 装配工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (660, '装配工', 7, 40);
-- Extend 机械/制造: 包装工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (661, '包装工', 7, 41);
-- Extend 机械/制造: 操作工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (662, '操作工', 7, 42);
-- Extend 机械/制造: 生产计划
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (663, '生产计划', 7, 43);
-- Extend 机械/制造: 车间主任
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (664, '车间主任', 7, 44);
-- Extend 机械/制造: 班组长
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (665, '班组长', 7, 45);
-- Extend 机械/制造: 物料员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (666, '物料员', 7, 46);
-- Extend 机械/制造: 搬运工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (667, '搬运工', 7, 47);
-- Extend 机械/制造: 流水线工人
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (668, '流水线工人', 7, 48);
-- Extend 销售/市场: 地推专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (669, '地推专员', 8, 34);
-- Extend 销售/市场: BD专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (670, 'BD专员', 8, 35);
-- Extend 销售/市场: 商务专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (671, '商务专员', 8, 36);
-- Extend 销售/市场: 商务经理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (672, '商务经理', 8, 37);
-- Extend 销售/市场: 区域销售
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (673, '区域销售', 8, 38);
-- Extend 销售/市场: 城市经理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (674, '城市经理', 8, 39);
-- Extend 销售/市场: 省区经理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (675, '省区经理', 8, 40);
-- Extend 销售/市场: 大区经理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (676, '大区经理', 8, 41);
-- Extend 销售/市场: 售前工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (677, '售前工程师', 8, 42);
-- Extend 销售/市场: 解决方案工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (678, '解决方案工程师', 8, 43);
-- Extend 销售/市场: 会销讲师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (679, '会销讲师', 8, 44);
-- Extend 销售/市场: 会销专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (680, '会销专员', 8, 45);
-- Extend 销售/市场: 直销员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (681, '直销员', 8, 46);
-- Extend 销售/市场: 回访专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (682, '回访专员', 8, 47);
-- Extend 销售/市场: 续费专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (683, '续费专员', 8, 48);
-- Extend 销售/市场: 网销专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (684, '网销专员', 8, 49);
-- Extend 销售/市场: 社区团购运营
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (685, '社区团购运营', 8, 50);
-- Extend 销售/市场: 私域运营
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (686, '私域运营', 8, 51);
-- Extend 销售/市场: 社群运营
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (687, '社群运营', 8, 52);
-- Extend 物流/运输: 分拣员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (688, '分拣员', 9, 22);
-- Extend 物流/运输: 打包员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (689, '打包员', 9, 23);
-- Extend 物流/运输: 理货员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (690, '理货员', 9, 24);
-- Extend 物流/运输: 配货员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (691, '配货员', 9, 25);
-- Extend 物流/运输: 押运员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (692, '押运员', 9, 26);
-- Extend 物流/运输: 报关员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (693, '报关员', 9, 27);
-- Extend 物流/运输: 集装箱管理员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (694, '集装箱管理员', 9, 28);
-- Extend 物流/运输: 货场管理员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (695, '货场管理员', 9, 29);
-- Extend 物流/运输: 国际物流专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (696, '国际物流专员', 9, 30);
-- Extend 物流/运输: 冷链物流专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (697, '冷链物流专员', 9, 31);
-- Extend 物流/运输: 危险品运输员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (698, '危险品运输员', 9, 32);
-- Extend 物流/运输: 配送站长
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (699, '配送站长', 9, 33);
-- Extend 传媒/设计: UX设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (700, 'UX设计师', 10, 34);
-- Extend 传媒/设计: 交互设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (701, '交互设计师', 10, 35);
-- Extend 传媒/设计: 界面设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (702, '界面设计师', 10, 36);
-- Extend 传媒/设计: 电商设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (703, '电商设计师', 10, 37);
-- Extend 传媒/设计: 美工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (704, '美工', 10, 38);
-- Extend 传媒/设计: 网店美工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (705, '网店美工', 10, 39);
-- Extend 传媒/设计: 淘宝美工
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (706, '淘宝美工', 10, 40);
-- Extend 传媒/设计: 游戏UI
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (707, '游戏UI', 10, 41);
-- Extend 传媒/设计: 图标设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (708, '图标设计师', 10, 42);
-- Extend 传媒/设计: 字体设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (709, '字体设计师', 10, 43);
-- Extend 传媒/设计: 特效师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (710, '特效师', 10, 44);
-- Extend 传媒/设计: 合成师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (711, '合成师', 10, 45);
-- Extend 传媒/设计: 调色师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (712, '调色师', 10, 46);
-- Extend 传媒/设计: 录音师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (713, '录音师', 10, 47);
-- Extend 传媒/设计: 灯光师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (714, '灯光师', 10, 48);
-- Extend 传媒/设计: 舞台美术
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (715, '舞台美术', 10, 49);
-- Extend 传媒/设计: 场景设计师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (716, '场景设计师', 10, 50);
-- Extend 传媒/设计: 策展人
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (717, '策展人', 10, 51);
-- Extend 传媒/设计: 画廊助理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (718, '画廊助理', 10, 52);
-- Extend 传媒/设计: 艺术品顾问
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (719, '艺术品顾问', 10, 53);
-- Extend 医学/医疗: 医学编辑
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (720, '医学编辑', 3, 24);
-- Extend 医学/医疗: 医学经理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (721, '医学经理', 3, 25);
-- Extend 医学/医疗: 医学顾问
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (722, '医学顾问', 3, 26);
-- Extend 医学/医疗: 临床数据管理员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (723, '临床数据管理员', 3, 27);
-- Extend 医学/医疗: 药物警戒专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (724, '药物警戒专员', 3, 28);
-- Extend 医学/医疗: 药物安全专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (725, '药物安全专员', 3, 29);
-- Extend 医学/医疗: GMP专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (726, 'GMP专员', 3, 30);
-- Extend 医学/医疗: QA工程师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (727, 'QA工程师', 3, 31);
-- Extend 医学/医疗: QC分析员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (728, 'QC分析员', 3, 32);
-- Extend 医学/医疗: 注册专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (729, '注册专员', 3, 33);
-- Extend 医学/医疗: RA专员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (730, 'RA专员', 3, 34);
-- Extend 医学/医疗: 医药项目管理员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (731, '医药项目管理员', 3, 35);
-- Extend 医学/医疗: 口腔咨询师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (732, '口腔咨询师', 3, 36);
-- Extend 医学/医疗: 口腔护士
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (733, '口腔护士', 3, 37);
-- Extend 医学/医疗: 牙科助理
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (734, '牙科助理', 3, 38);
-- Extend 医学/医疗: 视光师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (735, '视光师', 3, 39);
-- Extend 医学/医疗: 听力师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (736, '听力师', 3, 40);
-- Extend 医学/医疗: 物理治疗师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (737, '物理治疗师', 3, 41);
-- Extend 医学/医疗: 作业治疗师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (738, '作业治疗师', 3, 42);
-- Extend 医学/医疗: 心理治疗师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (739, '心理治疗师', 3, 43);
-- Extend 医学/医疗: 心理医生
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (740, '心理医生', 3, 44);
-- Extend 医学/医疗: 影像技师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (741, '影像技师', 3, 45);
-- Extend 医学/医疗: 超声技师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (742, '超声技师', 3, 46);
-- Extend 医学/医疗: 放疗技师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (743, '放疗技师', 3, 47);
-- Extend 医学/医疗: 体检医生
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (744, '体检医生', 3, 48);
-- Extend 医学/医疗: 体检护士
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (745, '体检护士', 3, 49);
-- Extend 医学/医疗: 预检分诊
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (746, '预检分诊', 3, 50);
-- Extend 医学/医疗: B超医生
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (747, 'B超医生', 3, 51);
-- Extend 医学/医疗: 彩超医生
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (748, '彩超医生', 3, 52);
-- Extend 医学/医疗: 心电图技师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (749, '心电图技师', 3, 53);
-- Extend 医学/医疗: 检验技师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (750, '检验技师', 3, 54);
-- Extend 医学/医疗: 病理技师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (751, '病理技师', 3, 55);
-- Extend 医学/医疗: 输血技师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (752, '输血技师', 3, 56);
-- Extend 医学/医疗: 助产士
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (753, '助产士', 3, 57);
-- Extend 医学/医疗: 麻醉护士
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (754, '麻醉护士', 3, 58);
-- Extend 医学/医疗: 手术室护士
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (755, '手术室护士', 3, 59);
-- Extend 医学/医疗: ICU护士
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (756, 'ICU护士', 3, 60);
-- Extend 医学/医疗: 急诊科护士
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (757, '急诊科护士', 3, 61);
-- Extend 医学/医疗: 门诊护士
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (758, '门诊护士', 3, 62);
-- Extend 医学/医疗: 社区护士
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (759, '社区护士', 3, 63);
-- Extend 医学/医疗: 家庭医生
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (760, '家庭医生', 3, 64);
-- Extend 医学/医疗: 全科医生
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (761, '全科医生', 3, 65);
-- Extend 医学/医疗: 中西医结合医师
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (762, '中西医结合医师', 3, 66);
-- Extend 医学/医疗: 兽医
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (763, '兽医', 3, 67);
-- Extend 医学/医疗: 宠物医生
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (764, '宠物医生', 3, 68);
-- Extend 医学/医疗: 动物实验员
INSERT INTO job_category (id, name, parent_id, sort_order) VALUES (765, '动物实验员', 3, 69);

-- 2. Synonyms (1800 rows)
INSERT INTO synonym_dict (raw_word, std_word) VALUES
('Java', 'Java开发'),
('人力资源专员/助理', '人事专员'),
('人力资源专员', '人事专员'),
('0基础-软件开发或测试(java\\C++\\py\\go\\js)', 'Java开发'),
('java后端开发工程师', '后端开发'),
('java后端开发', '后端开发'),
('java全栈开发', '全栈开发'),
('java全栈开发工程师', '全栈开发'),
('农业/林业技术员', '农业技术员'),
('JAVA开发', 'Java开发'),
('java后端工程师', '后端开发'),
('java后端', '后端开发'),
('物业管理专员', '物业管理员'),
('行政', '行政专员'),
('python', 'Python开发'),
('软件开发（java、python、前端等）可零基础', 'Java开发'),
('java全栈工程师', '全栈开发'),
('行政专员/助理', '行政专员'),
('专注保险公司旅游（双休 ）', '保险顾问'),
('餐饮服务员', '服务员'),
('反内卷带薪休假销售岗', '销售代表'),
('董事长助理秘书', '行政专员'),
('董事会秘书', '行政专员'),
('光电仪器操作师', '仪器仪表工程师'),
('物流仓库操作员', '物流专员'),
('月入过万销售岗（无经验有师傅带教）', '销售代表'),
('小红书运营岗 双休 接受小白', '新媒体运营'),
('新媒体运营官+周末双休+不加班月入轻松过万', '新媒体运营'),
('停！恭喜你！这个销售岗 不靠资历 月入20K', '销售代表'),
('代账会计（双休）', '会计'),
('新能源汽车维修学徒', '新能源销售'),
('资深创意策划', '广告创意'),
('AI人工智能销售岗！接受应届生', '销售代表'),
('销售岗 找个徒弟 今年一起挣50万没问题', '销售代表'),
('Java 全栈', 'Java开发'),
('双休客服(国企)', '客服专员'),
('员工制保险康养顾问（星海计划）', '保险顾问'),
('高级审计员', '审计'),
('【需尽快到岗】(双休09:00–17:00)运营客服', '客服专员'),
('会计 双休', '会计'),
('【央企双休】人事助理 朝九晚五', '人事专员'),
('法律顾问（兼职可居家）月入5K-2W', '法务专员'),
('文案编辑(J21812)', '文案策划'),
('药物分析研究员（杂质研究）', '药品研发'),
('人力资源专员【可小白+高薪资，高待遇】', '薪酬专员'),
('人力资源专员/助理【接受无经验小白】', '人事专员'),
('法务诉讼专员', '法务专员'),
('全案活动专员（策划/文案/执行一体化）', '活动策划'),
('校对录入实习生 120-150元/天', '编辑'),
('助理采编专员', '编辑'),
('校对/编务', '编辑'),
('短视频/短剧/广告宣传（小白演员|有住宿）', '演员'),
('微短剧素人演员/群演/广告月入2W接受无经验', '演员'),
('古装汉服模特', '演员'),
('太极拳老师', '教师'),
('【长期兼职】上海中心艺术长廊营业员', '销售代表'),
('兼职成人艺术类老师', '教师'),
('琴行前台', '行政专员'),
('影视(传媒)演员/舞蹈无责保底8-12k/包住宿', '演员'),
('影视传媒主播素人打造【新人小白无责保底】', '主播'),
('AI影视后期剪辑（短剧/漫剧）', '视频编辑'),
('短剧演员影视剧演员签约艺人', '演员'),
('影视编剧', '编剧'),
('微电影剪辑师', '视频编辑'),
('影视推广专员', '市场专员'),
('团队计调+旅游策划师（月入1w）', '旅游计调'),
('游戏数值策划师（mmorpg）', '游戏策划'),
('行政人事/早九晚六', '行政专员'),
('车队行政', '行政专员'),
('行政前台', '行政专员'),
('物业管理专员（行政岗）', '物业管理员'),
('合规监控稽核 /双休坐班', '法务专员'),
('化学分析实习生', '化工工程师'),
('ROHS实习生（化学实验室）', '化学分析员'),
('实习生（机械/机电/电气/材料/汽车）', '电气工程师'),
('环境检测采样员', '环保工程师'),
('环境检测实验员', '环保工程师'),
('环境检测工程师', '环保工程师'),
('电气测试工程师（有倒班）', '软件测试'),
('游戏3d场景（建筑/植被/道具）', '3D设计师'),
('游戏场景地编道具建筑（写实、风格化）', '游戏美术'),
('新能源检测工程师（光伏|风电）', '光伏工程师'),
('餐饮洗碗工', '洗碗工'),
('国际国内机票操作员', '票务员'),
('行政秘书', '行政专员'),
('行政前台秘书', '行政专员'),
('首饰设计师（电影造型方向）', '化妆师'),
('俄语导游（杭州、苏州）', '导游'),
('无忧传媒招歌手艺人(不限年龄)', '演员'),
('网易云/QQ音乐 Top1公会直招线上主播', '主播'),
('舞蹈队友/艺人', '演员'),
('舞蹈工作室前台', '行政专员'),
('舞蹈演员', '演员'),
('急聘~~优秀舞蹈老师（16K-30K稳定收入）', '教师'),
('舞蹈老师无责1w起', '教师'),
('舞蹈 演员', '演员'),
('练习生/偶像招募【可小白，路费报销】', '演员'),
('月入1~3万，5休2 瑜伽舞蹈教练，健身教练', '健身教练'),
('兼职舞蹈教师', '教师'),
('接受零经验小白的短剧编剧岗位，应届生来', '编剧'),
('摄影助理（0基础+可升师）', '摄影师'),
('影楼直招 摄影师 包吃住 春节长假晋升机制', '摄影师'),
('摄影工作室摄影师 《包吃包住缴纳社保》', '摄影师'),
('二次元展会策划实习', '活动策划'),
('农业技术专员', '农业技术员'),
('农业种植技术管理经理', '农业技术员'),
('无责底薪2w 上海招主播高颜值来 接受小白', '主播'),
('招!主播!语音主播/语音直播/名额有限!', '主播'),
('重金扩招主播 稳定流水 收入轻松无压力5w+', '主播'),
('诚招主播，接受无经验，无责8k', '主播'),
('主播 无责保底8k+ 有无经验均可', '主播'),
('高保底主播', '主播'),
('主播 不露脸 日结 短期 大学生 居家', '主播'),
('硬件游戏策划｜弹珠机 / 线下娱乐设备方向', '游戏策划'),
('纺织、玩具及材料测试 客户服务协调员', '软件测试'),
('纺织品化学技术支持专家', '服装设计师'),
('客服协调员（纺织品及鞋类检测）', '客服专员'),
('纺织品高级工程师', '服装设计师'),
('纺织实验室报告主管', '服装设计师'),
('儿童乐园前台', '行政专员'),
('无人机巡检', '质检员'),
('8-13k地理编辑-小白五险一金', '编辑'),
('皮肤科仪器操作师', '仪器仪表工程师'),
('宠物主播，撸宠搞钱两不误（接受小白）', '主播'),
('船舶检验工程师', '医学检验师'),
('环境服务工程师（固废方向）', '环保工程师'),
('面 试就过 ，可长期养 老的销售岗/无责底薪', '销售代表'),
('急招（房山）双休/五险一金 销售岗接受小白', '销售代表'),
('行政销售', '销售代表'),
('早九晚五周末双休销售岗', '销售代表'),
('免费食宿 销售 开单简单 月入过万 江阴', '销售代表'),
('周末双休 早九晚六 销售', '销售代表'),
('5000底薪！+大小休！+15天年假！（销售岗）', '销售代表'),
('销售岗【无经验要求+底薪保障+免费食堂】', '销售代表'),
('周末双休+五险+无责底薪5000 电话销售员', '电话销售'),
('真双休！不加班_无责5k+阶梯提成 销售 储干', '销售代表'),
('无责5-8k精准资源销售岗', '销售代表'),
('五险一金线上酒店销售岗', '销售代表'),
('选片销售', '销售代表'),
('销售 周末双休 行政班', '销售代表'),
('6k-8k急招总账会计一名+双休+社保+不加班', '会计'),
('财务会计（稳定双休+五险一金+氛围轻松）', '会计'),
('会刷小红书 会聊天就能做的运营岗', '新媒体运营'),
('短视频运营:爆款打造+私域变现(学徒真心带)', '社群运营'),
('物业环境主管', '物业管理员'),
('工程文件编制（俄语翻译）', '翻译'),
('招中译法 英译法（互译）游戏兼职翻译', '翻译'),
('颜值前台 行政岗', '行政专员'),
('人力资源专员-26届校招(J10295)', '人事专员'),
('9k+/周末双休/央企人力资源专员', '人事专员'),
('人力资源/hr实习生', '人事专员'),
('急招人力资源专员/周末双休/无责5500', '人事专员'),
('新媒体文案（包食宿/五险一金）', '新媒体运营'),
('采编记者', '编辑'),
('资深新媒体编辑(J10048)', '新媒体运营'),
('医药PR-公关经理/高级公关经理（急）', '品牌策划'),
('上海/医疗咨询/管吃住', '咨询顾问'),
('医美市场咨询，只做上海市场，月休6天', '皮肤管理师'),
('商务通咨询（包食宿）', '咨询顾问'),
('医美网络咨询 / 网咨', '皮肤管理师'),
('口腔咨询师（商超驻点）', '口腔咨询师'),
('医美现场咨询', '皮肤管理师'),
('医美咨询（应届生版）', '皮肤管理师'),
('医美术后咨询专员', '皮肤管理师'),
('医美现场咨询助理', '皮肤管理师'),
('口腔咨询师（花木门诊）', '口腔咨询师'),
('口腔咨询助理', '牙科医生'),
('三甲公立整形/皮肤医生｜黄v IP 合规合作', '临床医师'),
('客服销售（包住/保险/银发经济/新装修环境)', '保险顾问'),
('渠道专员（保险/保健品行业优先）', '保险顾问'),
('算法实习生(P8478)', '算法工程师'),
('化学合成人员/助理研究员', '投资分析师'),
('化学测试', '软件测试'),
('QC(偏化学分析专业）', '化工工程师'),
('新媒体编辑（生物医药）', '新媒体运营'),
('HRBP(医疗大健康/生物医药)', 'HRBP'),
('生物测试工程师', '软件测试'),
('生物市场推广管培生', '市场专员'),
('小分子生物分析研究员', '投资分析师'),
('生物试剂抗体销售（周末双休五险一金）', '销售代表'),
('数据运营专员（医疗方向）', '数据分析'),
('【机械、电气类工业配件】销售工程师', '电气工程师'),
('医院网络咨询（包食宿）', '咨询顾问'),
('心理咨询顾问（兼职）', '心理咨询师'),
('兼职心理咨询师（松江店）', '心理咨询师'),
('区域董事会秘书负责人', '行政专员'),
('农业技术支持-上海', '农业技术员'),
('机加工品质检验员（QC）', 'CNC工程师'),
('8000元招美容小白 仪器为主+带薪培+就近分', '仪器仪表工程师'),
('仪器操作师', '仪器仪表工程师'),
('护工/养老院', '护士'),
('无责5000连锁药店销售岗', '销售代表'),
('宁波鄞州区外场口腔咨询师（销售岗）', '牙科医生'),
('五险一金，新人带教，销售岗不卷作息', '销售代表'),
('门店导购（门店管理岗、销售岗）', '销售代表'),
('保健品销售', '销售代表'),
('无责底薪+高提成+各类补贴销售岗', '销售代表'),
('销售专员（餐补+入职缴纳五险）', '销售代表'),
('永久无责底薪销售岗', '销售代表'),
('莱西销售员', '销售代表'),
('销售 保底6000', '销售代表'),
('销售 上班自由 接受无经验 月2W～5W', '销售代表'),
('养生馆顾问，养生馆销售', '销售代表'),
('会议销售', '销售代表'),
('天猫/淘宝客服（售前+售后）偏线上销售类', '销售代表'),
('院内销售岗（美容口腔）', '销售代表'),
('朝九晚六的销售岗/无责4k+/包餐+可住宿', '销售代表'),
('（社保/单间/食宿全包）高资源销售岗', '销售代表'),
('无责4500-运营岗-不含销售-不加班', '销售代表'),
('下沙外企直招｜非中介｜直签正式劳动合同', '劳动关系专员'),
('苏州园区国企直招-护理员', '护士'),
('国际医疗部客服（英语）', '客服专员'),
('医疗器械维修工程师', '医疗器械销售'),
('医疗实施工程师', '施工员'),
('医疗器械销售 包吃包住 周末双休', '医疗器械销售'),
('【医美私密医疗】美容顾问', '皮肤管理师'),
('医疗器械检验员/质检员', '质检员'),
('医疗客服+包吃住+六险', '客服专员'),
('物流岗（残疾人优先）', '物流专员'),
('新能源电池厂普工 质检五险包吃轻松不累', '质检员'),
('行政岗（对接外联）8000+ 双休五险，不加班', '行政专员'),
('通州北关！早9晚4行政岗！双休不加班', '行政专员'),
('人力资源专员（HR）', '人事专员'),
('Java 全栈开发工程师（Vue+SpringBoot）', 'Java开发'),
('【总部直招】26届销售岗，无责5k', '销售代表'),
('HR专员/人力资源专员（金融/商业地产方向）', '人事专员'),
('艺术公寓新媒体运营 双休！高提成！！', '新媒体运营'),
('新媒体实习岗(影视编导后期)', '新媒体运营'),
('8k无责单人宿 房产销售 月入2w 市场营销', '房地产销售'),
('8k市场营销/免费住宿', '市场专员'),
('市场营销岗（工装方向）', '市场专员'),
('豪宅投资助理-TOP年薪百万以上', '投资分析师'),
('底薪7200房产销售+提供住宿+无考核免费培训', '房地产销售'),
('房产销售+底薪一万一+小白/应届生+住宿', '房地产销售'),
('［包吃包住］房产经纪人', '经纪人'),
('房产经纪人/业务经理', '证券经纪人'),
('保利、中建/房产置业顾问', '房地产销售'),
('房产销售高薪招聘/无经验可带/收入上不封顶', '房地产销售'),
('置业顾问\\房产经纪人-1号发薪\\免费包住', '房地产销售'),
('上海top销冠房产销售门店扩招收徒-地产销售', '房地产销售'),
('房产销售 年龄没有要求', '房地产销售'),
('新媒体房产经纪人（松江大学城）', '新媒体运营'),
('无责底薪6000+2000绩效+提成，房产电话客服', '电话销售'),
('华翱 净化板 净化材料销售', '销售代表'),
('2026-围护材料销售工程师（上海）(J11867)', '销售代表'),
('网络客服+6K+包住+月休6天', '客服专员'),
('见习建筑师', '建筑设计师'),
('建筑资质销售专员', '销售代表'),
('工程质量主管（建筑施工行业）', '施工员'),
('助理建筑师', '建筑设计师'),
('建筑施工现场管理员/施工员', '施工员'),
('寻一级通信建造师', '通信工程师'),
('CEO秘书助理', '行政专员'),
('总经理助理', '行政专员'),
('前台文秘', '行政专员'),
('秘书 文员', '行政专员'),
('上海链家-房产经纪人-租赁（全上海分配）', '经纪人'),
('租赁管家销售+月薪2w+提供住宿', '销售代表'),
('商业地产销售/租赁专员', '销售代表'),
('保底6K租赁销售+50%高提', '销售代表'),
('保租房租赁销售', '销售代表'),
('薪资10k＋ 老人一对一带教 房屋租赁学徒', '薪酬专员'),
('市区住宅纯租赁销售团队寻优品伙伴倾囊相授', '销售代表'),
('底薪7000+纯租赁销售+提供宿舍+带薪培训', '销售代表'),
('测量工程师（市政）', '测绘工程师'),
('桩基技术推广经理', '土木工程师'),
('可以接送孩子上下学的房产销售岗', '房地产销售'),
('【晋升快】别墅装饰电话邀约/销售岗', '电话销售'),
('家装销售专员', '销售代表'),
('地板销售', '销售代表'),
('昌平超级合生汇楼上/月入过2万的销售岗供住', '销售代表'),
('津南靠谱销售岗稳定过万/无责底薪/师父带教', '销售代表'),
('拒绝无效加班 工作自由黄金销售岗', '销售代表'),
('二手房 新房 租赁 销售 电销 客服 中介售楼', '销售代表'),
('瑶海万达/宝业早9晚6销售岗', '销售代表'),
('销售岗7K-9K专人带教可接受无经验五险一金', '销售代表'),
('早九晚六 双休 不加班 销售岗', '销售代表'),
('带薪休假+销售岗+有社保（凤岗沃尔玛旁）', '销售代表'),
('业务员，销售员', '销售代表'),
('上4休3+周末双休销售岗', '销售代表'),
('缺 人！！面试就可以上班/高薪销售岗', '销售代表'),
('春熙路 清闲销售岗 不电销/无KPI指标', '销售代表'),
('小红书运营推广', '新媒体运营'),
('自媒体运营小红书 抖音获客｜接受小白', '新媒体运营'),
('新媒体运营/小红书运营官(周末双休不坐班)', '新媒体运营'),
('新媒体运营官+周末双休 不加班月入轻松过万', '新媒体运营'),
('小红书抖音运营官（接受新手小白应届生）', '新媒体运营'),
('新能源工程师', '新能源销售'),
('新能源光伏、风电设计总体', '光伏工程师'),
('新能源技术专家（国企）', '新能源销售'),
('高级法律顾问', '法务专员'),
('急聘行政人事岗位双休', '行政专员'),
('saas产品经理b端优先', '产品经理'),
('美术书法教师', '美术教师'),
('Kids English Teacher 少儿英语老师', '外语教师'),
('【双休/无销售/高课时费】语数英物化 教师', '教师'),
('教培法务(（持证律师 / 持律师执业证）', '法务专员'),
('中文教研｜阅读课程研发｜出版编辑经验优先', '课程设计师'),
('艺术机构前台课程老师', '教师'),
('上海斯芬克-艺术留学咨询顾问', '留学顾问'),
('早教师接受无经验', '教师'),
('留学销售顾问（艺术/音乐方向）', '留学顾问'),
('艺术机构销售主管', '销售代表'),
('幼教 助教 教师 早教老师 音乐老师', '音乐教师'),
('市场营销策划专员/市场推广（刚需课程）', '市场专员'),
('市场营销管培生-（提供专业培训+住宿）', '市场专员'),
('课程老师（行政岗）', '教师'),
('底薪8k管理咨询储备干部', '咨询顾问'),
('地铁口+企业管理咨询', '咨询顾问'),
('1v1教师-高中物理（无义务课时/课量稳定）', '物理教师'),
('初高物理老师/双休/星火教育', '物理教师'),
('化学老师（初高）', '化学教师'),
('化学老师（兼职或全职）-校区就近安排', '化学教师'),
('生物科研销售/五险一金/周末双休', '销售代表'),
('数学老师 （双休/不销售）', '数学教师'),
('小学/初中 数学教师', '数学教师'),
('中/小学数学老师', '数学教师'),
('初中数学老师（全上海就近分配）', '数学教师'),
('社招自习数学一对一教师(J59061)', '数学教师'),
('小初数学/英语教师', '外语教师'),
('高级数学老师', '数学教师'),
('周中周末兼职助教（数学 拼音 画画 书法）', '美术教师'),
('小学数学教师管培生（月入过万+双休+社保）', '数学教师'),
('初中数学老师（保底8k 双休）', '数学教师'),
('初中数学老师 | 安亭 | 生源稳定 | 氛围好', '数学教师'),
('对日高级软件开发工程师JAVA/C/Python', 'Python开发'),
('对日 高级软件开发工程师Java/C/C++/python', 'Python开发'),
('初中历史/语文/英语 教师', '外语教师'),
('学校历史/地理老师', '教师'),
('初中物理化学英语道法历史老师', '外语教师'),
('招聘全职文科老师（上海）', '教师'),
('初高中兼职授课老师急招（教资必须有）', '教师'),
('初中 语数英 物理化学 政治历史 家教老师', '物理教师'),
('国际课程 历史老师 AP/IB', '教师'),
('上海公立中小学 多学科人事代理教师招聘', '教师'),
('思政销售助理（公立义务教育）', '销售代表'),
('全职爵士街舞老师', '教师'),
('街舞老师', '教师'),
('全职中国舞老师', '教师'),
('中国舞老师', '教师'),
('戏剧表演艺术老师 招聘', '教师'),
('小学戏剧老师（表演系/排剧能力/急招）', '教师'),
('中文演讲主持/戏剧表演老师', '教师'),
('养老护理师｜接受无经验｜大平台订单稳定', '护士'),
('地质/水文数据处理分析师', '数据分析'),
('仿真工程师 急招 岩土工程师', '土木工程师'),
('招个徒弟自己带!销售岗月入2W+', '销售代表'),
('教培销售岗（底薪5000元+周休2天）', '销售代表'),
('底薪5500+八小时不坐班+月入过万销售岗', '销售代表'),
('保底7000销售岗/有销售经验欢迎投递', '销售代表'),
('周末双休销售岗-提成周发-独家项目-转化快', '销售代表'),
('工资嘎嘎高，1-3号发薪销售岗有人带可小白', '销售代表'),
('急招！不加班+氛围好的销售岗', '销售代表'),
('稳定销售岗+保底5000+月休六天+五险一金', '销售代表'),
('新开销售岗【周末双休+周期短好出单】', '销售代表'),
('高薪销售岗 六险一金 不跑外 带薪年假', '销售代表'),
('底薪还不错的销售岗', '销售代表'),
('无责底薪真实6K+销售岗', '销售代表'),
('面试就办入职的销售岗，今年最后一份工作！', '销售代表'),
('教育咨询师（销售类岗位）', '教育咨询师'),
('【爽文销售岗】月薪过万｜茶水间堪比星巴克', '销售代表'),
('不加班、接受小白、销售岗', '销售代表'),
('无责底薪6000销售岗（无试岗期）', '销售代表'),
('急招！！！新媒体运营岗【高薪+准时下班】', '新媒体运营'),
('抖音主播（民航领域）', '主播'),
('行政综合岗', '行政专员'),
('教培人力资源专员/助理', '人事专员'),
('ai智能体产品经理', '产品经理'),
('质检专员机械零件', '质检员'),
('品牌视觉设计师（Brand Visual Designer）', 'UI设计师'),
('新媒体直播', '直播运营'),
('汽车贴膜摄影剪辑跟拍师（不用写文案）', '视频编辑'),
('品牌内容与创意传播高级经理（主机厂）', '品牌策划'),
('品牌策划-Geelato工作室(A69924)', '品牌策划'),
('品牌主管/品牌策划', '品牌策划'),
('景区文创导购（上海中心）', '销售代表'),
('服装导购-上海兴业太古汇Barbour', '销售代表'),
('设计师集合店导购', '销售代表'),
('销售总监（大设备销售/英语工作语言）', '销售代表'),
('市场营销专员/主管', '市场专员'),
('食品市场营销（食品原料方向）', '市场专员'),
('市场营销策划（餐饮类）', '市场专员'),
('非车险销售（上海全区域4S店可就近安排）', '销售经理'),
('2026供应链管培生（物流方向）-上海', '物流专员'),
('供应链计划（茶瀑布）', '供应链计划'),
('供应链仓库经理/专员', '仓储管理'),
('AI算法与大模型应用工程师', 'AI算法工程师'),
('铸造技术员（材料类应届生）', '模具设计师'),
('橡胶材料销售（base上海）', '销售代表'),
('固态电池（电芯、工艺、材料、体系、仿真）', '锂电工程师'),
('高工价，包吃，住宿环境好，诚聘操作工', '操作工'),
('急招店员岗 高薪资 工作环境好', '薪酬专员'),
('桌面运维(上海)', '桌面运维'),
('装配电工/电气工程师', '电气工程师'),
('网络诊断测试工程师（双休+长期+补助）', '软件测试'),
('硬件测试技术员(J11123)', '软件测试'),
('测试工程师（行车测试/通信诊断/仿真验证）', '软件测试'),
('特斯拉新能源汽车配件厂，日结300，包吃住', '新能源销售'),
('新能源换电站站员', '新能源销售'),
('蔚来汽车 新能源汽车机电技师 张杨路', '机电工程师'),
('新能源维修技师/学徒', '新能源销售'),
('景区/博物馆导购（东方明珠）', '销售代表'),
('轻奢饰品品牌 饰品产品设计师', '产品经理'),
('Edition 女装店员/导购（做一休一）', '销售代表'),
('cosplay演员', '演员'),
('人偶演员', '演员'),
('汽车租赁销售（周休2天）', '销售代表'),
('农业机械设计', '机械工程师'),
('设计师-农业方向', '农业技术员'),
('（上海）食品包装员', '包装工'),
('食品车间操作工（燕窝挑拣/罐装/设备操作）', '操作工'),
('食品厂包装工300+/天恒温车间', '包装工'),
('食品操作工（五险一金+食宿+固定班次）', '操作工'),
('食品销售包住宿6000+', '销售代表'),
('宠物食品烘焙师', '烘焙师'),
('汽车装配工', '操作工'),
('检验员/质量员/质检员/品质员', '质检员'),
('瓜子二手车检测师', '二手车评估师'),
('来料检验 月薪8000', '质检员'),
('长白班 检验员 学生工也要 做六休一', '质检员'),
('高薪招普工/看机器/包装/检验', '质检员'),
('化工外操', '化工工程师'),
('生产管理（化工）', '化工工程师'),
('APC项目工程师/项目经理（化工）', '化工工程师'),
('化工管道施工工程师', '施工员'),
('化工技术员', '化工工程师'),
('化工生产技术员', '化工工程师'),
('硫化工/质检员', '质检员'),
('化工应用工程师', '化工工程师'),
('行业大客户经理【风机-化工/半导体行业】', '化工工程师'),
('品质管理（化工行业）', '化工工程师'),
('纺织品面料品控员（凯喜雅）', '质检员'),
('纺织品供应链负责人', '服装设计师'),
('纺织品研发员', '服装设计师'),
('供应商质量经理（纺织 / 服饰 / 家纺)', '服装设计师'),
('纺织/无纺布专业应届毕业生', '服装设计师'),
('质量经理/主管（电商/纺织品/工厂端）', '服装设计师'),
('上海洋山中集急招电工，持证就可以，380/天', '装配电工'),
('卫星装配实习生', '操作工'),
('机械装配工程师', '机械工程师'),
('招聘专家-AI方向/航空航天方向/机械方向', '招聘专员'),
('高薪诚聘服装店长+国家地理/户外品牌', '服装设计师'),
('双美店仪器操作美容师+五险一金+包住宿', '仪器仪表工程师'),
('售后工程师/实验室仪器仪表', '仪器仪表工程师'),
('船舶售后服务工程师', '售后客服'),
('船用客户服务部 服务工程师 担当（S1）', '客服专员'),
('电子厂普工/质检工/接受大龄工/活简单易学', '质检员'),
('1. 上海浦东电子厂直招普工月薪8000包吃住', '操作工'),
('制冷实习/学徒工', '暖通工程师'),
('制冷设备维修工（英语）——英国食品工厂', '暖通工程师'),
('设施机械技术员 (MJ000024)', '机械工程师'),
('制冷系统研发工程师（矿用井下）', '暖通工程师'),
('江浙沪旅游式出差（销售岗）', '销售代表'),
('不会塌房（能一直干）无收费销售岗有人教', '销售代表'),
('豆包都推荐做的销售岗', '销售代表'),
('销售岗福利拉满，网约车租售诚聘英才(鹿城)', '销售代表'),
('销售 业务员 针织面料公司', '销售代表'),
('办公室文员', '行政专员'),
('（包吃）门店销售', '销售代表'),
('新能源汽车销售-舟山（12-15K）', '销售代表'),
('跟 单 员 销售类', '销售代表'),
('不锈钢管材销售（液冷管道经验优先）', '销售代表'),
('乐道汽车销售--丽水银泰/驾照1年＋高提成', '销售代表'),
('边玩边挣16岁可小白可销售岗7q以上', '销售代表'),
('小白销售员（提供吃住 氛围嘎嘎棒）', '销售代表'),
('包住零房租+可日结！销售岗无责底薪5000', '销售代表'),
('周末双休五险一金稳定发展的高级销售岗', '销售代表'),
('今天面试明天上班！销售岗+免费住宿', '销售代表'),
('轻松微信销售岗（无业绩压力）', '销售代表'),
('豪车 销售 薪资丰厚！', '销售代表'),
('满16即可 包住 0经验入职 带薪培训 销售', '销售代表'),
('销售员38岁以下出差底薪1.5万/月+提成', '销售代表'),
('服装Sales销售', '销售代表'),
('销售岗：氛围轻松＋免费住宿+五险社保', '销售代表'),
('无经验销售岗 带薪培训 新手好上手！', '销售代表'),
('00后老板/公司氛围超好+销售岗/有师傅带', '销售代表'),
('江浙沪销售岗出差+包住', '销售代表'),
('无加班销售岗！接受小白，专人1对1带', '销售代表'),
('销售岗工资有点高 拒绝内卷 一起开心工作', '销售代表'),
('服装辅料业务员/销售员(五险一金/高收入)', '销售代表'),
('可长期养老的销售岗｜双休\\'不卷\\'福利多多', '销售代表'),
('销售岗4500加提成+氛围好+五险+免费住宿', '销售代表'),
('接受无经验销售岗-满16以上-包住', '销售代表'),
('00后旅游式销售岗9k+公费出差+提供住宿', '销售代表'),
('00后销售岗+愿意学态度好包过+包食宿', '销售代表'),
('不内耗的销售岗，小白可带，包住+公费旅游', '销售代表'),
('有嘴就行的销售岗 ~ 不会就学~欢迎自荐', '销售代表'),
('销售岗——别问 问就是包住（可日结）', '销售代表'),
('缺人！！招几个社牛小朋友销售岗', '销售代表'),
('（接受小白）无责底薪4000销售岗（包住宿）', '销售代表'),
('“薪”动不如行动！销售岗/五险一金/包吃', '销售代表'),
('搬砖不狠，地位不稳，月入1w轻轻松松销售岗', '销售代表'),
('应付会计（27届实习生）', '应付会计'),
('抖音电商运营/接受小白实习生/7.5h工作制', '新媒体运营'),
('实习生会计', '会计'),
('会计十助理', '会计'),
('外企组装岗位税后6k管吃管住六险一金', '操作工'),
('外企/八小时工作制/不体检/可带手机', '操作工'),
('塑料包装大客户销售（外企）', '包装工'),
('武汉全力南便利店招聘店员', '招聘专员'),
('外企汽配机加装配岗300/天可短期', '操作工'),
('外企LG新能源/质检月8000/入职0费用/自动化', '自动化工程师'),
('双休包吃住外企招聘', '招聘专员'),
('礼嘉外企操作工23/小时包吃住', '操作工'),
('五险一金+美资外企+管吃管住+手工组装小件', '操作工'),
('20.23/时*检验包装*带手机*不无尘服*新车间', '质检员'),
('人力资源实习生（百年外企）', '人事专员'),
('（国企海信）直招普工', '操作工'),
('国企直招产品质量检验员', '质检员'),
('北方华创 库房物流岗 可R结 可转正', '物流专员'),
('英汇科技招聘普工/操作工', '操作工'),
('北京新能源8k+免费吃住+长白+五/险一 金', '新能源销售'),
('新能源电池壳贴签包吃住230天', '锂电工程师'),
('新能源电气240/天可日给/恒温车间4-6人间', '电气工程师'),
('新能源汽车内饰高薪300一天！！', '新能源销售'),
('280/天新能源电子 长白日结管吃住 五险一金', '新能源销售'),
('新能源汽车外勤销售 | 可接受外拓优先', '销售代表'),
('威迈斯 新能源 包吃住纯工价25', '新能源销售'),
('杭州新能源大厂｜7-8k｜包吃住缴纳六险一金', '新能源销售'),
('可预支新能源500强厂吃厂住', '新能源销售'),
('萧山戴村新能源厂7500一个月 包吃包住', '新能源销售'),
('成都领克新能源男女不限保底5500', '新能源销售'),
('新能源空调车间 白班 300/天 普工可带手机', '操作工'),
('坐班包装质检，新能源厂保底 7000', '质检员'),
('新能源上市车企+260/天岗位可选+五险一金', '新能源销售'),
('新能源330/天正式工保底8K-12K+真实工资', '新能源销售'),
('新能源机械设备维护管理保底8000+接受小白', '设备工程师'),
('文员义齿翻译(笔译)', '翻译'),
('行政专员（双休）', '行政专员'),
('HRBP（业务人力资源伙伴）', 'HRBP'),
('汽车救援司机 保险救援搭电', '保险顾问'),
('保险理赔经理（比亚迪汽车4 S店）', '核保理赔'),
('无责底薪8058起+车接车送销售岗+奖金过万', '销售代表'),
('廉正合规岗（调查）', '法务专员'),
('物流园配送托盘不装不卸日结', '物流专员'),
('急招加油站跟车员/包吃住环境好/保底9000+', '搬运工'),
('c1货运司机(新能源4.2米不需要装卸)', '搬运工'),
('国际货运经理（上海）', '物流专员'),
('国际货代/物流销售', '外贸业务员'),
('国际物流高级经理', '物流专员'),
('国际物流销售主管/经理', '外贸业务员'),
('海事检验员(件杂货方向)', '质检员'),
('航运飞机包机销售', '销售代表'),
('货代/物流销售', '销售代表'),
('海运销售（件杂货）', '销售代表'),
('客户体验（英语流利，航运、国际物流行业）', '物流专员'),
('物业保安', '物业管理员'),
('主播接受无经验', '主播'),
('招3 宠物仓库猫狗粮理货 +吃住 轻松', '仓储管理'),
('日结5 8 0《宠物饲料猫粮采送》配车住', '饲料销售'),
('电子仓库 长白班 23/小时 坐班', '仓储管理'),
('松江/青浦/京东直营招聘/空调维修工程师', '招聘专员'),
('衢州聘销售助理+五险+保底6300', '销售代表'),
('【急招】丽水德邦聘区域销售8K-20K', '销售经理'),
('包住宿-java 开发（中级）-国际物流行业', 'Java开发'),
('销售员（高提成+双休）', '销售代表'),
('国际物流销售（双休外企接受浅经验有培训）', '外贸业务员'),
('双休 外企纯文职客服（13薪）', '客服专员'),
('【远程/外企/全职】国际物流跟单', '物流专员'),
('顺义物流木架工-月入1w+-(夜班）', '物流专员'),
('彩携物流 北京 人事招聘文员', '物流专员'),
('山姆 物流 （无需装卸） 兼职', '搬运工'),
('现场经理/物流调度', '公共卫生管理'),
('行政2名', '行政专员'),
('兼职法务', '法务专员'),
('（周末双休）土木工程项目助理', '土木工程师'),
('行政商务助理', '商务专员'),
('产品标签工程师（新能源/合规方向）', '法务专员'),
('工程塑料销售（汽车材料，医疗塑料耗材）', '销售代表'),
('生产文员', '生产计划PMC'),
('运维专员（上海）', '运维工程师'),
('电气公司招聘男女普工', '电气工程师'),
('装配车间主任（电气类）', '电气工程师'),
('SQE（变压器、电气类产品）', '电气工程师'),
('15K包吃住自动化装配电工', '自动化工程师'),
('自动化钳工（短期）', '自动化工程师'),
('电力通信/网络/IT/运维工程师', '运维工程师'),
('风力发电新能源操作工', '电力工程师'),
('新能源光伏+全屋定制销售专员', '销售代表'),
('部门秘书', '行政专员'),
('董事会秘书 需持董秘证 完整 IPO投融资经验', '证券经纪人'),
('电气保护与直流安全总架构师', '网络安全'),
('CMM检验员（外包+倒班）', '质检员'),
('主播周末双休接受小白', '主播'),
('安环工程师（化工/预上市企业/可落户）', '化工工程师'),
('售后技术工程师（仪器仪表）', '仪器仪表工程师'),
('资深水质仪表工程师', '仪器仪表工程师'),
('物流跟单助理（双休+六险一金）', '物流专员'),
('综合管理部主办（党建）', '行政专员'),
('大港电子厂 操作员 普工 男女包进！！！', '操作工'),
('研发设计工程师（制冷制热设备）', '暖通工程师'),
('暖通调试工程师(HVAC / 制冷 / 液冷方向)', '暖通工程师'),
('乐清 变压器销售员/销售精英', '销售代表'),
('今面试+明上班+有双休不加班的销售岗', '销售代表'),
('会开车的来+工资日结460+java', 'Java开发'),
('财务 会计(内账)', '会计'),
('外企（包装员）月入7000+包吃住', '包装工'),
('下沙外企看机器，质检两班倒包吃住月9500', '质检员'),
('「国企」非流水线-学技术好岗位', '操作工'),
('新能源微信客服（不打电话）', '电话客服'),
('新能源风电运维', '运维工程师'),
('新能源市场开发', '新能源销售'),
('新能源电池pack销售', '销售代表'),
('新能源电源硬件、嵌入式、计算机软件实习生', '嵌入式开发'),
('【月入过万】}新能源锂电池销售', '销售代表'),
('新能源项目开发经理（工商业分布式光伏）', '光伏工程师'),
('新能源业务开发经理', '新能源销售'),
('新能源汽车评估师', '资产评估师'),
('萧山新能源厂 坐班 包装白班 月7000', '包装工'),
('新能源业务员', '新能源销售'),
('招新能源汽车维修业务专员', '新能源销售'),
('新能源工厂操作员｜上一休一｜5500-8500/月', '新能源销售'),
('新能源厂区质检包装操作工｜综合 6000月薪', '质检员'),
('新能源厂区聘！包装 / 质检，月薪6000左右', '质检员'),
('新能源销售岗（新能源）(J11880)', '销售代表'),
('新能源学徒工', '新能源销售'),
('新能源光伏技术员岗位', '光伏工程师'),
('综合翻译（off shore)', '翻译'),
('高级审计员（制造业内审）', '审计'),
('保险顾问（朝九晚六 ，午休2小时，有社保）', '保险顾问'),
('电商APP/小程序产品经理', '产品经理'),
('网文作者/编辑/主编/总编（长篇/短篇）', '编辑'),
('小说责编/编辑', '编辑'),
('作者签约编辑（线上居家、双休、五险一金）', '编辑'),
('女频小说编辑（可接受26年应届生）', '编辑'),
('高级内容编辑', '编辑'),
('Translator 翻译 （AMMA）', '翻译'),
('总经理助理兼翻译（韩语）-合资公司社招', '翻译'),
('食品研究员(J25095)', '投资分析师'),
('【2026春招】战略研究员', '投资分析师'),
('Java开发（接受无经验+2-4个月年终奖）', 'Java开发'),
('Java开发工程师（JSP，Java Web）', 'Java开发'),
('Java开发（上海工行-年度奖金-足额社保）', 'Java开发'),
('应届生优先（销售岗）实习新人保底8k＋住宿', '销售代表'),
('市中心高薪销售岗（接受小白｜纯坐班）', '销售代表'),
('无业绩考核+上海社保+包住宿销售岗', '销售代表'),
('上海赚钱销售岗之一', '销售代表'),
('新手友好销售岗7.5k起薪有住宿有人带不踩坑', '销售代表'),
('销售 无责6000 周末休息', '销售代表'),
('面试直接定薪！可长期养老销售岗', '销售代表'),
('试用期20000起 包住宿 五险一金 销售', '销售代表'),
('红果短视频（推流销售岗）无责9000/包食宿', '销售代表'),
('急招 无责8K AI 销售 风口行业 高额提成', '销售代表'),
('红果 短 剧（销售岗）底薪8000', '销售代表'),
('人力资源专员(偏招聘)', '招聘专员'),
('人力资源-HR', '人事专员'),
('AI产品设计（智能硬件 or工业/交互设计类）', '产品经理'),
('Al视觉数据标注（设计类）', 'UI设计师'),
('诉讼法务助理', '法务专员'),
('8小时双休8K法务主管', '法务专员'),
('法务助理', '法务专员'),
('商务法务专员', '商务专员'),
('机械 电气 计算机 土木工程类理工科写材料', '电气工程师'),
('底盘测试工程师（上海）', '软件测试'),
('【外贸AI Agent】销售管理岗', '外贸业务员'),
('上海自媒体文案编辑/小白号运营（包吃住）', '新媒体运营'),
('游戏剧情文案', '文案策划'),
('公关（舆情）', '品牌策划'),
('自媒体写手兼职（数码3C）', '新媒体运营'),
('财经编辑（财经记者优先）', '编辑'),
('记者采编/编辑-汽车商业评论', '编辑'),
('导购/店员（就近分配）', '销售代表'),
('AI研究院-学科教研员（语数英化学）-合肥', '课程设计师'),
('AI教研实习生（汉语言背景，沪学习App）', '课程设计师'),
('互联网广告销售（港股上市+双休+五险一金）', '销售代表'),
('（13薪）无责6-10高级广告销售', '销售代表'),
('外包游戏广告买量素材设计师', '广告创意'),
('MCN机构广告销售', '销售代表'),
('语音主播，单人单间，免费住宿配套齐全', '主播'),
('英语可作为工作语言/销售主管/海外销售', '销售代表'),
('通用开发（不限编程语言），测试工程师', '软件测试'),
('语音大模型语言专家（语音理解方向）', 'AI算法工程师'),
('双休语言行业B端销售，接受翻译转型', '销售代表'),
('大厂/游戏系统策划/双休', '游戏策划'),
('游戏系统策划（本地化方向）', '游戏系统策划'),
('内容运营市场营销（slg达人brief输出）', '市场专员'),
('上市公司-高级营销顾问-高薪', '证券经纪人'),
('市场营销实习生（上海）', '市场专员'),
('市场营销经理 （工业机器人 / 具身智能）', '市场专员'),
('市场营销（朝十晚七）', '市场专员'),
('纯客服不销售+双休+包住宿', '销售代表'),
('纯客服+6000(无试岗)', '客服专员'),
('穿衣自由 纯客服岗位 无责7500底薪', '客服专员'),
('无责7q+纯客服+早九晚六+可小白', '客服专员'),
('无责6000纯客服 无绩效0压力', '客服专员'),
('纯客服岗，到点下班，不销售，月薪8000起', '销售代表'),
('早九晚六+8K+纯客服专员+缴纳上海五险一金', '客服专员'),
('纯客服+双休+月薪8000+到点下班', '客服专员'),
('无责8000 早九晚六客服岗', '客服专员'),
('机器人过滤名单 客服 入职五险一金', '客服专员'),
('纯客服专员+五险一金+带薪休假 不加班', '客服专员'),
('客服 双休', '客服专员'),
('纯客服无责底薪7000不含销售提供房源', '销售代表'),
('腾讯纯客服（月休8天不加班）通过率高', '客服专员'),
('纯客服助理 无销售性质 无经验可带', '销售代表'),
('星巴克随便喝 客服 底薪9k+提成 有住宿', '客服专员'),
('6000-9000想做纯客服的来工资不高', '客服专员'),
('办公室文员/客服岗/不加班', '客服专员'),
('接受无经验（行政人事文员）', '行政专员'),
('行政文员', '行政专员'),
('长宁区 五险一金 坐班行政岗', '行政专员'),
('行政岗客服保底7000+', '客服专员'),
('人才行政岗', '行政专员'),
('行政后勤助理', '行政专员'),
('人事行政', '行政专员'),
('综合行政', '行政专员'),
('咨询顾问|不加班|交上海社保|', '咨询顾问'),
('深耕头部客群年薪60W可落户 合规可持续赛道', '法务专员'),
('所有女生衣橱产品合规（成人服装/纺织）', '法务专员'),
('账号安全合规工程师（紧急、长期稳定）', '网络安全'),
('法务专员（隐私合规）', '法务专员'),
('合规专员(001653)', '合规专员'),
('对外联络（监管合规）', '法务专员'),
('股票投资助理（高提成/接受无证从）', '投资分析师'),
('证券投资助理+五险一金', '投资分析师'),
('证券投资助理【精准客源+住宿+五险一金】', '投资分析师'),
('理赔BA（驻场友邦保险）', '核保理赔'),
('央企 急聘销售（保险代理）+双休 +透明晋升', '保险顾问'),
('商务拓展经理（保险方向）', '保险顾问'),
('H89254岗保险方案 AI 提示词', '保险顾问'),
('双休五险一金保险客服', '保险顾问'),
('算法工程师（大模型nlp搜广推infra等）', '算法工程师'),
('移动操作规划算法/运控算法', '算法工程师'),
('纺织物理测试/组长', '软件测试'),
('物/理老师 兼职', '教师'),
('SQE工程师-必须化工行业，化学相关专业', '化工工程师'),
('上位机后端开发【生工生物】', '后端开发'),
('环境工程实习生(长期招聘）', '招聘专员'),
('高端小区保洁 工作环境干净舒适', '保洁'),
('游戏执行策划（数学类专业优先，应届生可）', '游戏策划'),
('汽车行业-数据测试（python，base南京）', 'Python开发'),
('python大模型', 'AI算法工程师'),
('python测试工程师', '软件测试'),
('AI 应用工程师（Python/Dify方向）', 'Python开发'),
('Python/C++/C 上海 双休 业务稳定 线上面试', 'Python开发'),
('数据治理开发工程师-Python开发（理想外包)', '数据开发'),
('python 大模型/agent 开发实习生', 'Python开发'),
('机器人软件工程师（Python 26年毕业）', 'Python开发'),
('python开发', 'Python开发'),
('C++/python/java/js/开发/测试接受考研失败', 'Java开发'),
('数据治理开发工程师（Python开发方向）', '数据开发'),
('python后端开发', '后端开发'),
('包住 前端接待 无责9000 无绩效', '前端开发'),
('前端接待 无责8k 当天包住宿（社保）', '前端开发'),
('红果短剧推流 前端客服', '前端开发'),
('15k前端开发工程师/包吃/双休', '前端开发'),
('双休前端接待12K 早九晚五点半 氛围福利好', '前端开发'),
('前端开发工程师+朝九晚六+周末双休', '前端开发'),
('前端接待 无责8000 当天宿舍', '前端开发'),
('前端接待 无责9000（0绩效）当天住宿', '前端开发'),
('资深前端架构师', '前端开发'),
('前端接待 审核员 底薪9000', '前端开发'),
('react移动端前端开发-驻场京东', '前端开发'),
('前端开发工程师（react）', '前端开发'),
('前端接待 底薪九千（五险一金）', '前端开发'),
('车身测试（雷克萨斯）', '软件测试'),
('运维工程师【上海】', '运维工程师'),
('中级电气装配工程师', '电气工程师'),
('电气装配工（要到上海到面）', '电气工程师'),
('智驾/智舱测试开发工程师（自动化）', '测试开发'),
('解决方案售前经理（模具工厂自动化）', '自动化工程师'),
('10点上班，包吃两顿！网络销售', '销售代表'),
('网络销售-五险一金', '销售代表'),
('硬件测试-射频-上海', '软件测试'),
('米哈游——3D场景（建筑组件/道具/贴图）', '3D设计师'),
('3D场景模型师（建筑+植物）', '3D设计师'),
('通信实习生（26届/27届）可转正', '通信工程师'),
('应届通信实习生（包住+实习证明+转正机会）', '通信工程师'),
('诚聘通讯地推人员，包免费住宿', '市场专员'),
('通信基站维护员（供食宿）', '通信工程师'),
('通信施工领班', '通信工程师'),
('通信技术工程师 包住 可就近分配', '通信工程师'),
('通信排管，放线 小工', '通信工程师'),
('外勤通信技术维护员', '通信工程师'),
('无线通讯测试工程师（FAE）', '软件测试'),
('AI产品实习生（心理学方向）', '产品经理'),
('上海新能源包装工280一天包吃住！不收学生', '包装工'),
('新能源急招社会工月薪8000不限经验包吃住', '新能源销售'),
('新能源企业急招社会工280/天不限经验包吃住', '新能源销售'),
('新能源智能企业/质检/操作员/8000+', '质检员'),
('《学生勿扰》新能源厂包装简单300一天', '包装工'),
('学生不招】新能源厂简单组装300一天有宿舍', '操作工'),
('【学生勿扰】+新能源质检300一天＋包吃住', '质检员'),
('新能源/传统汽车金融服务岗-2位-招满即止', '新能源销售'),
('国际关系研究员', '投资分析师'),
('董办秘书', '行政专员'),
('行政(A192768)', '行政专员'),
('项目经理（内河航运/智能制造/学信网可查）', '项目经理'),
('高中历史/政治老师', '教师'),
('西语短篇作者/翻译', '翻译'),
('音乐内容创作（作词/作曲/演唱或全能型）', '新媒体运营'),
('团播成员｜零基础可培 全套形象包装扶持', '包装工'),
('团播主播 接受小白-边跳舞边减肥边赚钱', '主播'),
('（免费舞蹈教学）抖音团播艺人练习生', '演员'),
('急招舞蹈老师', '教师'),
('cosplay团/古风团/流量舞蹈团/团播艺人', '演员'),
('恺英官方直播间舞蹈才艺主播', '主播'),
('男、女团舞蹈艺人【保底一万】单人住宿', '演员'),
('短剧编辑', '编辑'),
('摄影助理（可小白+可升师）', '摄影师'),
('摄影助理（不限专业+接受0基础）', '摄影师'),
('摄影师（全职/兼职）-上海就近分配-海马体', '摄影师'),
('初中级layout/maya动画', '3D设计师'),
('【急招】2D动画设计师（无测试+反馈快）', '软件测试'),
('Maya/layout动画师', '3D设计师'),
('高级游戏3d动画师', '3D设计师'),
('资深3d动画师', '3D设计师'),
('游戏PV动画/2D买量后期', '游戏美术'),
('3D动画大招/局内/3c(二次元/古风/射击）', '3D设计师'),
('动画3Dmax/maya-双休免测', '3D设计师'),
('高级maya动画师', '3D设计师'),
('【外派岗】初级3D动画师', '3D设计师'),
('游戏动作动捕精修（3Dmax二次元动画向）', '3D设计师'),
('游戏MAYA/mb动画', '3D设计师'),
('2D游戏 动作/动画 设计师', '游戏美术'),
('游戏动画师(maya/max)', '3D设计师'),
('外企会展实习生170元每天，可开实习证明', '活动策划'),
('展会玉石打磨抛光（兼职）', 'CNC工程师'),
('电商平面模特', '演员'),
('外贸销售/外贸专员/外贸员', '外贸业务员'),
('AI 外贸掘金销售', '外贸业务员'),
('手机租赁地推（全国招）', '市场专员'),
('农业种植生产专员', '农业技术员'),
('激光除草机器人 驻场技术客服', '客服专员'),
('农业销售BD（内部岗）', '销售代表'),
('普工/检验员/上海社保/月综合8000以上', '质检员'),
('银都西路 检验员 23/小时', '质检员'),
('qc检验员', '质检员'),
('主播 可在家播 可先打款', '主播'),
('招！主播！语音直播/语音主播/名额有限!', '主播'),
('游戏策划（方向较多，可发送简历详聊！）', '游戏策划'),
('游戏关卡策划(外包)', '游戏策划'),
('游戏策划 | 独立游戏 | 动作RPG | 全栈策划', '全栈开发'),
('游戏系统策划（3年经验，线上面试，mmo）', '游戏系统策划'),
('精细化工操作岗', '化工工程师'),
('大厂外包：实验室助理（化学化工药学方向）', '药剂师'),
('化工制药设备设计师', '化工工程师'),
('商品合规专员（儿童/纺织方向）(J12513)', '法务专员'),
('纺织品图形设计', '服装设计师'),
('交付运维（自动驾驶）', '运维工程师'),
('课程编辑（船舶海洋｜自动化）', '自动化工程师'),
('无人机集装箱检验员', '质检员'),
('人事专员（航空领域央企985）', '人事专员'),
('人事-校招相关-知名航空集团社招', '人事专员'),
('质量管理工程师（航天航空体系）', '质检员'),
('测绘实习生（27届）', '测绘工程师'),
('测量员（实习）', '测绘工程师'),
('测绘软件销售（入职五险一金+周末双休）', '测绘工程师'),
('海外销售（俄语）', '销售代表'),
('全栈工程师（GIS）南京', '全栈开发'),
('宠物爱好者优先 底薪8500 销售', '销售代表'),
('宠物上门洗护师', '护士'),
('Unity游戏美术（3D虚拟人社交平台）', '游戏开发'),
('人事招聘专员', '招聘专员'),
('党建行政实习生', '行政专员'),
('AI矿产勘查工程师', '算法工程师'),
('芯片QC质检岗位/4休2/包吃住', '质检员'),
('芯片测试（线上面试）', '软件测试'),
('【上海】芯片销售工程师', '销售代表'),
('芯片销售管培生', '销售代表'),
('IC元器件/芯片外贸销售双休', '外贸业务员'),
('芯片测试（岗位多+周末双休+五险一金）', '软件测试'),
('（容阻感&芯片）上海销售', '销售代表'),
('芯片测试（IC测试验证）', '软件测试'),
('智能电子厂280元/天包吃住上六休一质检岗', '质检员'),
('电子厂普工/操作工', '操作工'),
('机房暖通主管—周末双休+高低压证+线上面试', '暖通工程师'),
('制冷系统仿真工程师（数据建模方向）', '暖通工程师'),
('制冷系统工程师(上海宝山)(J11260)', '暖通工程师'),
('Java*采购/erp/srm', 'Java开发'),
('初 创 公司 （面完 上班）销售岗永久15000+', '销售代表'),
('底薪7000 入职五险 周末作息销售岗', '销售代表'),
('新人6k+小白直接冲 福利多多销售岗', '销售代表'),
('找当过兵的！销售岗月入3万起！军人优先！', '销售代表'),
('月入过万销售岗(无经验接受小白)', '销售代表'),
('销售员+底薪5000+提成+流水', '销售代表'),
('java开发实施工程师', '施工员'),
('Java-双休/全额社保公积金', 'Java开发'),
('Java（线上面试，急招！）', 'Java开发'),
('银行-宁波-java', 'Java开发'),
('上班可以迟到 下班必须准时销售岗', '销售代表'),
('初 创 公 司（面完 上班）销售岗永久15000+', '销售代表'),
('面试走过场 0业绩也有6000销售岗', '销售代表'),
('销售岗（朝九晚六/高提成/五险', '销售代表'),
('JAVA 后端', 'Java开发'),
('Java 达梦 人大金仓经验优先', 'Java开发'),
('急招大厂直招销售岗五险一金小白可入', '销售代表'),
('销售岗无经验可投 无责5000+高提成', '销售代表'),
('Java开发（线上面试+银行+国际结算方向）', 'Java开发'),
('工资有点高 工作有些枯燥 稳定销售岗', '销售代表'),
('Java开发(宁波上班-项目稳定-公积金全额)', 'Java开发'),
('客户化开发（Java）实习生', 'Java开发'),
('红果/番茄审核 销售岗 无责6000+五险', '销售代表'),
('0业绩也给6000 销售岗早九晚六', '销售代表'),
('销售岗-月薪过万/双休-六险一金【J15034】', '销售代表'),
('销售岗直招|能力决定收入公司提供资源', '销售代表'),
('豆包首推接受无经验的销售岗位', '销售代表'),
('双休！电话销售 朝九晚六+高提成', '电话销售'),
('java后台开发工程师', '后端开发'),
('大数据java开发工程师', '数据开发'),
('丽水莲都区高薪销售团队氛围嘎嘎好', '销售代表'),
('Java（线上面！周末双休！）', 'Java开发'),
('Java物联网后端开发工程师（Python+Java）', 'Java开发'),
('今天面试明天上岗 销售岗 接受小白', '销售代表'),
('会开车最好 外勤安装 无硬性考核要求销售岗', '销售代表'),
('销售岗接受小白', '销售代表'),
('线上面试+底薪6000+提供住宿销售岗', '销售代表'),
('双休早九晚六销售岗', '销售代表'),
('双休+八千底薪销售岗 （面 试 包 过）', '销售代表'),
('双休 早9.30晚6.30下 不加班 销售岗 真实的', '销售代表'),
('无责7500/提供住宿/（销售岗）', '销售代表'),
('试用期20000/单人间宿舍/无责9000/销售岗', '销售代表'),
('试用期20000/单间宿舍/底薪8000/销售岗', '销售代表'),
('初中级测试（短期到元旦）', '软件测试'),
('新一年给自己找个好班吧！正规销售岗', '销售代表'),
('【天津】销售岗+高提成收入+入职缴五险一金', '销售代表'),
('金融助贷销售岗+无责5500+零经验也可', '销售代表'),
('可接受小白的高薪销售岗+双休六险', '销售代表'),
('有点辛苦 但月入一万五（销售岗+接受无经验', '销售代表'),
('java程序员招聘', '招聘专员'),
('免费住宿！面试易过！公司急招1W＋销售岗', '销售代表'),
('双休 销售岗', '销售代表'),
('可接受小白的高薪销售岗', '销售代表'),
('缺人！销售岗直聘，入职交五险一金', '销售代表'),
('入职就7000 公司上下三层（销售岗）', '销售代表'),
('双休/朝九晚五/行业稳定的销售岗', '销售代表'),
('8000+早九晚六 销售岗 不加班', '销售代表'),
('尊贵的梅赛德斯车主 请上车（销售岗）', '销售代表'),
('双休不加班的销售岗！！！', '销售代表'),
('新人都能拿1.5万销售岗+无试用期+国企待遇', '销售代表'),
('急招销售岗【底薪6K不打折+提成】', '销售代表'),
('灰常缺 人/沟通能力没问题就行 销售岗！！', '销售代表'),
('销售岗无责底薪提成高，月休6天起五险一金', '销售代表'),
('灰常缺人【底薪6000+提成】——销售岗', '销售代表'),
('出差销售', '销售代表'),
('中惠-精准开单销售岗！', '销售代表'),
('软件开发工程师(Java/Python/C/C++/JS)', 'Java开发'),
('高转化销售岗——你只管谈单，客源我们包了', '销售代表'),
('AI新风口（五险+午餐+有双休)销售岗', '销售代表'),
('销售岗缺3人！！事少，面 试就过有双休', '销售代表'),
('【高薪正编】京东Mall销售组长/销售岗', '销售代表'),
('Java/Python/C/C++软件开发 接受无经验', 'Java开发'),
('工资嘎嘎高 ，10号发，销售岗一带一管住宿', '销售代表'),
('周末双休+无责底薪+客户精准销售岗', '销售代表'),
('周末双休的销售岗', '销售代表'),
('西安收银机收银系统地推销售员 双休', '销售代表'),
('无责底薪销售岗/氛围超好/包住+高提成', '销售代表'),
('安卓开发工程师', 'Android开发'),
('2027校招-客开后端实习生（大连）(J14788)', '后端开发'),
('全栈工程师 (Java+Vue) |核心开发|技术驱动', 'Java开发'),
('工资有点高，今天面试明天上岗+无责销售岗', '销售代表'),
('沈阳-java-线上面试', 'Java开发'),
('底薪8500销售岗+五险一金，保真正规不虚假', '销售代表'),
('无责4500＋不加班无考核的销售岗', '销售代表'),
('Golang/NodeJS/Java后端开发', 'Golang开发'),
('纯无责6000 销售岗+五险', '销售代表'),
('真实无责底薪4500！！！销售岗接受小白', '销售代表'),
('到点下班销售岗(无责6K+30-70%提成)', '销售代表'),
('月收入2w+ 销售岗', '销售代表'),
('接受小白/应届生 坐班吹空调 前端销售岗', '前端开发'),
('热爱money优先/销售岗', '销售代表'),
('咖啡免费喝 带薪培训＋包住【销售岗】', '销售代表'),
('办公室吹空调/早9晚6+无责4000（销售岗）', '销售代表'),
('阿里高级商家销售岗 周末双休福利多多~', '销售代表'),
('南京销售岗（双休）固发薪日', '销售代表'),
('Java开发（线上面+包食宿+零售/商城经验）', 'Java开发'),
('招徒弟/销冠亲自带/无责6000销售岗', '销售代表'),
('早九晚六底薪4000销售岗', '销售代表'),
('销售岗（无经验可培养）', '销售代表'),
('销售岗 缺人才 可带朋友 今天面试明天上班', '销售代表'),
('提供资源！无责6500销售岗！接受小白', '销售代表'),
('双休销售岗 不用外出 室内办公压力小', '销售代表'),
('无责5000 销售 （可带朋友）', '销售代表'),
('android应用工程师', 'Android开发'),
('java测试开发工程师', '测试开发'),
('H90586岗 前端开发工程师（react/vue）', '前端开发'),
('Java+vue(2-3个月，hr系统优先)', 'Java开发'),
('豆包首推-月薪8000+年假带薪15天 销售岗', '销售代表'),
('Java【线上面试】双休，稳定，五险一金', 'Java开发'),
('H92044岗 java（大厂+双休）', 'Java开发'),
('Java开发（乙方+常州驻场+cursor经验）', 'Java开发'),
('后端开发java', '后端开发'),
('周末双休、早九晚六的销售岗', '销售代表'),
('双休销售岗～知识产权顾问', '销售代表'),
('急招销售岗双休法休', '销售代表'),
('一天只用5小时联系客户的销售岗', '销售代表'),
('急招客服销售岗无责4K+带薪培训法休', '销售代表'),
('无责4500-5500 双休 五险一金 销售岗', '销售代表'),
('薪资高福利好的销售岗', '销售代表'),
('Java丨3年+ 大专 愿意学ai python', 'Python开发'),
('底薪6500 面试完就可以上班无要求销售岗', '销售代表'),
('开心销售岗，周末固定双休，享受自由人生', '销售代表'),
('今面试/明上班/早九晚六销售岗', '销售代表'),
('面试直接通过！诚招高薪销售岗', '销售代表'),
('福州月薪破3万销售岗，生活有品质追求的来', '销售代表'),
('朝九晚六+大小周！挑战百万销售岗', '销售代表'),
('销售岗公费出差支援莆田 包住宿路费可报销', '销售代表'),
('销售 可跨行业（双休+行业资源+无责底薪）', '销售代表'),
('java开发（反馈快~全额公积金~现场面试）', 'Java开发'),
('（紧急）java-保险/金融行业相关经验优先', 'Java开发'),
('周末双休销售岗', '销售代表'),
('无责6k+五险+提成额外奖励苹果手机销售岗', '销售代表'),
('老板说《不准加班》底薪8K加永久无责销售员', '销售代表'),
('销售 无责底薪4500+包住（免水电）', '销售代表'),
('底薪4800+不加班的销售岗', '销售代表'),
('蛋蛋都在冲的销售岗（6000+）', '销售代表'),
('接受无经验｜综合8k-15k｜销售岗', '销售代表'),
('双休月薪8K销售岗/近地铁/精准资源', '销售代表'),
('急聘年薪35W+销售岗/精准客源/社保双休', '销售代表'),
('java开发运维工程师', '运维工程师'),
('喜欢旅游的来 销售岗月薪过w，', '销售代表'),
('【前端销售岗】接受小白+不加班', '前端开发'),
('银行-佛山-java', 'Java开发'),
('【急聘】Java软件开发工程师（后端）', '后端开发'),
('一个让你快速拿高薪改变人生的销售岗', '销售代表'),
('销售 底薪6000/房补+高提成（接受小白）', '销售代表'),
('想赚钱的来(销售岗)', '销售代表'),
('java后端实习生', '后端开发'),
('java培养生（Android&鸿蒙方向）', 'Android开发'),
('底薪8200！销售岗（无 kpi考核）', '销售代表'),
('销售岗 大小休有社保 底薪5000+包住 8-12K', '销售代表'),
('六险一金有双休的销售岗！', '销售代表'),
('六险一金销售岗+固定无责+双休13薪', '销售代表'),
('底薪6k销售岗+八小时工作制不加班+可小白', '操作工'),
('底薪8200 销售岗（无kpi考核）', '销售代表'),
('多半员工薪资过万--可培养小白（销售岗）', '销售代表'),
('无责5300综合7300销售岗', '销售代表'),
('双休 早9晚6 不加班 销售岗', '销售代表'),
('高底薪7500＋低提成仅限两月销售岗', '销售代表'),
('朝九晚六双休1 W+销售岗', '销售代表'),
('拒绝疯狂打电话！我们销售岗精准资源+包吃', '电话销售'),
('全职坐班销售岗5000', '销售代表'),
('早九晚六接受小白应届生不加班销售岗', '销售代表'),
('Java/Python/C/C++/JS软件开发 接受无经验', 'Java开发'),
('Java开发（外企+早9晚18+线上面试）', 'Java开发'),
('java后端招聘（5000-6000）', '后端开发'),
('Java - API开发-外企双休', 'Java开发'),
('Auto Sales Telemarketer无5000月休8天客服', '客服专员'),
('销售岗 包住宿！', '销售代表'),
('招聘两个人事 接受无经验 欢迎销售岗转行', '销售代表'),
('成都SKP销售岗+无责6千/月入3w+', '销售代表'),
('周末双休 销售 月入3w起', '销售代表'),
('想双休的来/销售岗（0经验无考核）', '销售代表'),
('六险一金+无责底薪+有双休年假22天 销售岗', '销售代表'),
('医美嘎嘎 做~（来就过）销售岗试用期14000', '销售代表'),
('牵手app【销售岗】【接受跨行+文字沟通】', '销售代表'),
('抖音精准引流（销售岗）纯无责6000-五险', '销售代表'),
('来就过 纯无责7000 月均3W 无考核销售岗', '销售代表'),
('观音桥 销售岗 6500+', '销售代表'),
('江北嘴销售岗+底薪无责底薪6000', '销售代表'),
('中国联通 市场调查专员（非销售岗）', '销售代表'),
('全新风口赛道 + AI销售岗（GEO）', '销售代表'),
('养老岗位/虽然枯燥 但是月入3w+稳定销售岗', '销售代表'),
('居家社群运营岗+不限城市地点', '社群运营'),
('人事岗运营岗/事少活轻松！', '人事专员'),
('大小休 早9晚6 运营推广专员', '市场专员'),
('早十晚六抖音恋爱运营官', '新媒体运营'),
('周末双休(09:00-17:00)准点下班·运营客服', '客服专员'),
('早九晚六+周末双休+网站内容运营专员', '新媒体运营'),
('会计/会计助理/主办会计（公司氛围好不加班', '会计'),
('招聘【舟山-美团直聘运营销售-六险一金】', '销售代表'),
('舟山-总账会计+双休五险一金(J14493)', '会计'),
('台州！急招“六险一金”双休不加班社区运营', '社群运营'),
('抖音运营/短视频运营专员', '新媒体运营'),
('上班打游戏，准时下班轻松运营', '游戏运营'),
('沟通会计（9-6双休）', '会计'),
('记账会计+五险一金+周末双休', '会计'),
('资深代账会计（有经验优先）', '会计'),
('【济南】总账会计+周末双休（J16433）', '会计'),
('会计支持+月薪6000', '会计'),
('金四会计 双休五险一金', '会计'),
('会计支持＋接受小白', '会计'),
('双休+五险 +高额提成+代帐会计', '会计'),
('代账会计+双休', '会计'),
('平台运营登记员 ·薪资6K · 急招', '薪酬专员'),
('友好广场！急招！官方后台运营 无销售/通宵', '销售代表'),
('急聘会计（周末双休）', '会计'),
('双休：主办会计 8:30-17.30 大行宫地铁口', '会计'),
('代理记账会计（双休）', '会计'),
('会计顾问 周末双休', '会计'),
('抖音运营助理（无责4k+提成）接受小白', '新媒体运营'),
('旅游小红书抖音运营专员（招有经验）', '新媒体运营'),
('轻松会计师/钱多事少/10点上班7000', '会计'),
('无责4200纯文职（初级会计师）即可', '会计'),
('招聘 经验会计', '会计'),
('【双休】 主办会计', '会计'),
('​小红书/抖音房产博主流量运营官', '新媒体运营'),
('不销售+不加班+不打电话的业务运营岗！', '电话销售'),
('6K自媒体运营', '新媒体运营'),
('贷后双休数据运营岗急招一名', '数据分析'),
('核算会计(J10165) 双休 不加班', '会计'),
('人事前台运营主持中控场控助播舞蹈化妆老师', '教师'),
('央企售后客服～双休不加班～6000+', '售后客服'),
('北京外企 总助 14薪 朝九晚五 双休法休', '行政专员'),
('央企 客服 双休 16.30准时下班', '客服专员'),
('电信营业员', '销售代表'),
('外企15薪 综合管理（双休）', '行政专员'),
('央企双休 客服 17.30准时下班', '客服专员'),
('国企 客服 17.30准时下班 双休', '客服专员'),
('双休可居家-外企深夜班粤英客服MJ004213', '客服专员'),
('（客服）四点半下班+周末双休+无需加班', '客服专员'),
('人事助理（央企双休）', '人事专员'),
('6000+售后岗位+央企+双休不坐班', '售后客服'),
('松下东芝史陶比尔等10家外企所为员工聘保姆', '保姆'),
('外企14薪 ——综合管理 接受跨行', '行政专员'),
('外企金融客服', '客服专员'),
('央企客户服务维护 朝九晚五！不加班！', '客服专员'),
('（央企）资料录入文员/无责6200', '资料员'),
('外企！招几个轻松小客服（不销售）', '销售代表'),
('外企955制 协助综合管理 （急招）', '行政专员'),
('外企急招数控操机员 月薪7000', 'CNC工程师'),
('国企后勤岗[9:00-16:00]周末双休-月薪7-8k', '行政专员'),
('外企坐班客服+月薪7K+五险一金+作息稳定', '客服专员'),
('装配操作工 （外企/五险/长期/稳定）', '操作工'),
('外企（综合管理）', '行政专员'),
('外企后勤专员 | 双休社保', '行政专员'),
('六险一金/13薪/双休外企订单文员', '行政专员'),
('外企双休客服/13薪+超多带薪假期', '客服专员'),
('国企 车险续保', '车险理赔'),
('【重庆外企直聘】银行信控员(非销售)', '销售代表'),
('当天给offer 国企央企待遇 双休法休销售', '销售代表'),
('国企半导体+组装工长白班240/天+六险一金', '操作工'),
('比不上国企，但月入过万不是问题的客服岗', '客服专员'),
('【央企双休】人事助理 朝九 晚五 4-7K', '人事专员'),
('【中国太保】直招西安电销车险+六险+8K-20K', '电话销售'),
('知名外企大厂售后岗世界末日也双休', '售后客服'),
('外企14薪双休五险一金+国产新能源汽车顾问', '新能源销售'),
('外企双休 8小时文职客服', '客服专员'),
('8号发薪 心动offer通知客服', '客服专员'),
('外企销售 六险一金 周末双休', '销售代表'),
('【外企招聘】14薪，汽车/无人机客服专员', '客服专员'),
('国企后台文员+周末双休', '行政专员'),
('央企售后专员', '售后客服'),
('直招中国电信热线客服 纯接听', '客服专员'),
('5.5K外企双休+运营客服+住宿', '客服专员'),
('AI医疗影像标注质检（临床专业）', '医学影像师'),
('【住宿】医疗售后技术支持岗-双休5000+', '售后客服'),
('银行正编信贷客服/六险二金/周末双休/内勤', '信贷管理'),
('金融风控客服（可安排住宿）有班车食堂', '风控专员'),
('招两个小朋友录资料', '资料员'),
('银行双休柜员，小白可教，五险一金6000+', '银行柜员'),
('奔驰/宝马电话回访客服', '电话销售'),
('到点就走！8K售后岗', '售后客服'),
('1w起银行坐班催收专员（接受无经-I8502S', '信贷管理'),
('准点下班(9:00-18:00)运营客服/周末双休', '客服专员'),
('无责7000贷款+周末双休+不加班', '信贷管理'),
('月薪11000 信贷抵押 实时数据 提成22-42', '信贷管理'),
('还款提醒客服/银行正编/内勤（10k-15k）', '客服专员'),
('近大运地铁+电话客服+节假节日放假', '电话销售'),
('银行金融资产合规专员（杭州）', '融资经理'),
('10K银行电话客服+周末双休+五险一金', '电话销售'),
('萧山！双休+六险一金+不加班不内卷社区运营', '社群运营'),
('工商银行招聘 双休', '招聘专员'),
('16%公积金/正编银行M1提醒客服/无销售', '销售代表'),
('正规银行信贷专员1W+双休无考核', '信贷管理'),
('信用卡催收专员（非外包派遣+五险一金）', '信贷管理'),
('【双休客服】不加班+朝九晚六+接受小白', '客服专员'),
('后端催收｜安全合规｜高提成最晚 7 点下班', '后端开发'),
('京东物流-平谷马坊-正式工&周期工&兼职', '物流专员'),
('交通运输与物流业AI 真实工作任务评测专家', '物流专员'),
('物流调度-大宗商品-干线物流(J14436)', '公共卫生管理'),
('退款物流 双休', '物流专员'),
('电商物流退款（双休）', '物流专员'),
('薪资5000双休（物流信息查询录入员）不加班', '物流专员'),
('物流退款文员（到点下班4500+）', '物流专员'),
('发展前景好，支持物流跨行', '物流专员'),
('上海新能源300一天+包吃住+人走账清+全坐班', '新能源销售'),
('招聘（能源类、光伏类、互联网）', '招聘专员'),
('新能源电力行业销售工程师【不固定工作地】', '电力工程师'),
('新能源实习生', '新能源销售'),
('新能源汽车分期岗（特斯拉&小米&蔚来）', '新能源销售'),
('新能源驻店面销+稳定客源+一档社保', '新能源销售'),
('新能源技术开发实习生', '新能源销售'),
('杭州新能源包装工280一天包吃住！不收学生', '包装工'),
('新能源280/天包吃住可预支岗位轻松', '新能源销售'),
('新能源月7500+全新车间可带手机', '新能源销售'),
('新能源厂/23一小时/包吃住/可接受小白', '新能源销售'),
('成都本地新能源汽车厂保底6000', '新能源销售'),
('月保底8.5k新能源汽车厂机械臂维护员', '新能源销售'),
('英文翻译（需出差）', '翻译'),
('英语核查顾问（翻译）', '翻译'),
('海外小说作者/翻译/本地化编辑', '编辑'),
('兼职多语种翻译（远程 | 月结 | 书面翻译）', '翻译'),
('海外短剧翻译（英语）', '翻译'),
('小语种翻译及标注长期兼职/实习岗位', '翻译'),
('小语种翻译-AI方向（上市外企+双休）', '翻译'),
('AE特效（游戏类）', '视频编辑'),
('周末双休+不加班高级法律顾问', '法务专员'),
('法律主播（优质主播，有无行业经验均可）', '主播'),
('【AI出题专家】法律与合规领域', '法务专员'),
('法律RAG实习生', '法务专员'),
('政府法律专员', '法务专员'),
('法律标注专家（线上兼职）', '法务专员'),
('法律顾问 / 无责底薪 5000 / 精准资源', '法务专员'),
('法律助理/接受无经验', '法务专员'),
('资料行政岗(业务方向)', '资料员'),
('行政运营专员', '行政专员'),
('行政管理', '行政专员'),
('人事行政岗+双休+接孩子方便+奖金', '行政专员'),
('近地铁～行政岗（双休）', '行政专员'),
('7600 行政单位 无试用期', '行政专员'),
('周末双休 朝九晚六 行政订单岗', '行政专员'),
('和行政岗一样轻松！工作还有趣+五险一金', '行政专员'),
('朝九晚六 周末双休 行政订单岗', '行政专员'),
('成都总部上班 行政坐班5000+入职五险一金', '行政专员'),
('中坝/后台中心 行政班次', '行政专员'),
('综合行政助理（可实习）', '行政专员'),
('成都鹏瑞利青羊广场~行政客服岗7000+不试岗', '客服专员'),
('行政班/内勤助理/无责底薪4000', '行政专员'),
('行政岗-接听(五险一金/双休)', '行政专员'),
('字节跳动【行政岗】', '行政专员'),
('人力资源专员 招聘方向 8-12K 快速晋升', '招聘专员'),
('人力资源实习生', '人事专员'),
('人力资源hr', '人事专员'),
('人力资源 招聘', '招聘专员'),
('经理助理/人力资源（双休氛围好）', '人事专员'),
('人力资源助理【可晋升+有人带】', '人事专员'),
('人力资源专员/助理（三方+五险一金）', '人事专员'),
('京东人力实习生招聘', '招聘专员'),
('员工关系 /人力资源部 入职买社保10号发薪', '人事专员'),
('实习生（财务、审计）', '审计'),
('初级审计员', '审计'),
('税务所12366客服（朝九晚六+双休+无销售）', '税务专员'),
('内控/审计/风险管理-腾讯游戏投资公司随乐', '审计'),
('审计专员/助理 双休 五险一金', '审计'),
('审计专员+周末双休', '审计'),
('超级稳定保险信创为主测试（学信本到面）', '软件测试'),
('深圳-Java（要有保险开发经验）', 'Java开发'),
('Youth Manager – 保险客户经理', '保险顾问'),
('保险顾问【老客户】—双休', '保险顾问'),
('平安保险康养高级顾问', '保险顾问'),
('保险理赔（宠物险）|大厂双休入职五险一金', '核保理赔'),
('双流保险顾问.理赔售后.周末双休', '核保理赔'),
('政企保险服务岗（劳动合同制）', '保险顾问'),
('入职买保险 美团专送骑手火热招募', '保险顾问'),
('太平洋保险理赔专员/双休/6-10K', '核保理赔'),
('股票研究员（二级市场-私募证券投资基金）', '投资分析师'),
('今天面试明天上班+月月50000起+销售岗包住', '销售代表'),
('销售岗+不开单也是7K+免费住宿', '销售代表'),
('00后必看岗 月入3W+ 销售岗', '销售代表'),
('AI新风口/30000+/提供住宿-销售岗', '销售代表'),
('行政文员纯客服（保底9000）', '客服专员'),
('办公室文职客服', '客服专员'),
('纯客服【无压力】纯底薪9000', '客服专员'),
('银行纯客服 平均7600-8000 五险一金', '客服专员'),
('纯客服岗，不销售，午休两小时', '销售代表'),
('纯客服，不销售，无责6000', '销售代表'),
('包住 包住纯客服岗位+ 双休双休 只差3位', '客服专员'),
('综合行政专员', '行政专员'),
('网络客服咨询', '客服专员'),
('证券咨询顾问（可接受小白）', '证券经纪人'),
('证券合规专员（文职）', '证券经纪人'),
('不做AB贷合规贷款公司+月入8w+无责底薪电销', '信贷管理'),
('VIP做账会计（合规账/财务外包方向）', '会计'),
('不做AB贷合规贷款公司+无责底薪电销', '信贷管理'),
('合规稽查（打假）', '法务专员'),
('执业注册会计师／会计师／审计师', '会计'),
('证券投资助理1.0（可接受小白）', '投资分析师'),
('证券投资助理（无责6000/无kpi）', '投资分析师'),
('FA投资（高级）经理', '基金经理'),
('兼职-明亚保险经纪人', '保险顾问'),
('需求分析-保险行业', '保险顾问'),
('8K无责正编直签劳动合同员工制保险康养顾问', '保险顾问'),
('高级保险经纪人', '保险顾问'),
('上海急招国企岗位/车辆保险 包吃三餐 双休', '保险顾问'),
('保险理赔案源合伙人（高分成零成本）​​', '核保理赔'),
('数学助教/初高中各科老师', '数学教师'),
('前端接待 底薪八千 接受小白应届生', '前端开发'),
('9k 前端客服/上海社保/氛围超好~', '前端开发'),
('网络销售+双休+朝九晚六（无责5000）', '销售代表'),
('网络销售/无考核/无责8k', '销售代表'),
('精神心理科医生（急招）', '临床医师'),
('车险理赔专员', '车险理赔'),
('企业服务(新能源 人工智能 航空航天)', '新能源销售'),
('投资经理（航空航天方向）', '基金经理'),
('门店销售顾问/宠物用品（双休）', '销售代表'),
('保险公估师/海事检验员', '保险顾问'),
('党建综合管理岗', '行政专员'),
('7k底薪（有嘴就行）销售岗+五险一金', '销售代表'),
('底薪8500的审核销售岗 月入3-5W', '销售代表'),
('应届生可投/近地铁口/五险/年薪30W/销售岗', '销售代表'),
('销售 +五险+双休 氛围好', '销售代表'),
('销售岗无经验 不社恐可投 无责5000', '销售代表'),
('红果/番茄 短剧审核 销售岗 2W', '销售代表'),
('前景好,刚需行业带双休的销售岗', '销售代表'),
('双休法假-销售顾问-好开单', '销售代表'),
('销售底薪6k', '销售代表'),
('销售助理（工作轻松坐班不外出）', '销售代表'),
('招两个有能力想拿 超高薪 的（央企销售岗）', '销售代表'),
('双休销售岗', '销售代表'),
('双休 坐班销售岗/国企待遇 紧邻地铁口', '销售代表'),
('准时下班销售岗', '销售代表'),
('双休 市北优选销售岗 底薪8500', '销售代表'),
('月入2-3W销售岗＋精准客户+缴纳社保', '销售代表'),
('周末双休 销售 4500+', '销售代表'),
('B端销售岗 高提成 交六险 近地铁', '销售代表'),
('无责9000/读稿子轻松拿捏销售岗/早九晚六', '销售代表'),
('双休 销售 50%提成/精准数据', '销售代表'),
('纯坐班半销售岗！无业绩压力！来想挣快钱的', '销售代表'),
('00后公司 不请假/没业绩也是6000 销售', '销售代表'),
('高级财税顾问（销售岗双休+五险+不加班）', '销售代表'),
('销售 社保 早九晚六', '销售代表'),
('底薪 8500 销售岗+高提成', '销售代表'),
('销售岗急招（薪资透明+不压薪+高提成', '销售代表'),
('入职 iphone 18 (1TB)顶配版 销售岗', '销售代表'),
('保证 周末双休9-18点不加班 销售岗', '销售代表'),
('4.6w福田销售岗_行业头等舱（成就感）', '销售代表'),
('新手友好销售岗，不用经验有人带', '销售代表'),
('当天面试当天出结果 不加班 销售岗', '销售代表'),
('五险一金朝九晚五周末双休资深运营销售岗', '销售代表'),
('底薪6000+直接提成50% 销售', '销售代表'),
('Finacial Sales(销售)', '销售代表'),
('万家丽附近周末双休无责四千不加班销售岗！', '销售代表'),
('双休 早九晚六不加班 销售岗', '销售代表'),
('急招 销售岗 没有KPI', '销售代表'),
('拒绝疯狂打电话！销售岗精准资源到点下班', '电话销售'),
('朝九晚六/周末双休 无责5k+五险一金 销售', '销售代表'),
('豆包首推销售岗 可带朋友 无责4500周末双休', '销售代表'),
('真实无责底薪5500！！！销售岗接受小白', '销售代表'),
('做销售不如做贷款+新赛道（不打电话）', '信贷管理'),
('双休早九晚六/轻松办公销售岗', '销售代表'),
('租机销售员', '销售代表'),
('安宁销售岗+每月可升级+五险一金+薪资高', '销售代表'),
('代账公司会计', '会计'),
('需尽快到岗+固定双休+不加班+社区运营岗', '社群运营'),
('主办会计+入职缴纳社保+周末双休', '会计'),
('北仑会计', '会计'),
('7500-8500招代账会计（双休/包午餐）', '会计'),
('会计相关多个岗位', '会计'),
('嘉兴实习会计', '会计'),
('双休运营客服[需尽快到岗](09:00-17:00)', '客服专员'),
('嵊州代理记账会计', '会计'),
('双休[需尽快到岗](早9.00-晚5.00)运营客服', '客服专员'),
('辅助会计+单双休+法定休息', '会计'),
('专职会计 出纳', '会计'),
('记账报税会计', '会计'),
('代理记账会计/五险一金双休法休', '会计'),
('会计主管、会计学员、助理', '会计'),
('6-8k双休+朝九晚五+代理记账会计/总账会计', '会计'),
('【济南】周末双休！高薪会计（J16887）', '会计'),
('双休—代理记账会计', '会计'),
('高薪+主账会计+双休', '会计'),
('代账会计-双休', '会计'),
('双休 会计', '会计'),
('早九晚六/周末双休/六险一金 社区运营岗', '社群运营'),
('急招高薪外账会计', '会计'),
('做账会计+双休+六险', '会计'),
('代账会计+双休+社保', '会计'),
('短视频抖音运营', '新媒体运营'),
('企业代账会计+薪资5K-8K+社保', '会计'),
('基础代账会计（双休+社保）', '会计'),
('周末双休财税行业会计/基础会计', '会计'),
('代理记账会计(五险一金·双休·福利完善)', '会计'),
('记账会计（双休工作稳定）', '会计'),
('代账会计（双休 五险一金）', '会计'),
('代账会计（双休！法休！五险！稳定）', '会计'),
('代账会计+双休法休', '会计'),
('Corporate Services Accountant - 企业会计', '会计'),
('代账会计/工作轻松/双休！', '会计'),
('核算会计', '会计'),
('主办会计 双休 不加班 五险一金 有经验优先', '会计'),
('代账会计+双休+8000', '会计'),
('会计周末双休', '会计'),
('急招财务会计！！固定双休不加班', '会计'),
('财务公司代账会计', '会计'),
('高薪急聘会计', '会计'),
('财税顾问/专员（会计类岗位&代账行业）', '会计'),
('账务会计 高提成五险', '会计'),
('做账会计 双休', '会计'),
('维护会计（五险一金/双休）', '会计'),
('会计 周末双休 工资上不封顶', '会计'),
('全职代账会计 朝九晚六双休', '会计'),
('周末双休高财会计', '会计'),
('会计助理3000无责，周末双休 +五险', '会计'),
('官渡区做账会计（4800+周末节假日休+五险）', '会计'),
('央企-双休-早9晚6-接受小白无经验-高薪资', '薪酬专员'),
('只缺一名人力发展专员（央企诚聘）', '人事专员'),
('朝九晚六双休~央企~销售', '销售代表'),
('央企干到退休（双休 +保底5000）续费客服', '客服专员'),
('宝安社区新能源车辆标注员 五险一金/大小周', '新能源销售'),
('人保车险续保员深圳9500+五险一金+国企食堂', '车险理赔'),
('人事专员/朝九晚五/央企', '人事专员'),
('9k央企包住+车险续保', '车险理赔'),
('街道资料登记员。早九晚五', '资料员'),
('广州国企车险续费/五险一金 年终奖', '车险理赔'),
('外企综合管理 接受跨行 双休', '行政专员'),
('周末双休 央企保险理赔专员', '核保理赔'),
('央企HR文员—周末双休—7k（不加班）', '行政专员'),
('临安央企直招售后服务专员', '售后客服'),
('行政助理 周末双休 五险', '行政专员'),
('(央企）资料录入员8000/周末双休/不加班', '资料员'),
('海昌路地铁站|早九晚五双休|售后服务6000+', '售后客服'),
('央企-招募人事专员', '人事专员'),
('央企 + 客户售后服务 + 周末双休', '售后客服'),
('双休 车险续保/五险一金', '车险理赔'),
('央企直招5:30下班（免费2餐+双休）续费客服', '客服专员'),
('央企车险客服武汉江夏区8000+免费中餐', '客服专员'),
('央企客服早九晚五不加班！', '客服专员'),
('国企直招/人保车险续保专员/包餐', '车险理赔'),
('双休后勤(国企)', '行政专员'),
('央企售后档案管理员，双休（社区工作）', '售后客服'),
('双休，包三餐，国企，室内办公，8000销售', '销售代表'),
('【国企】车险续保专员', '车险理赔'),
('国企/包吃 车险续保', '车险理赔'),
('资料管理专员（周末双休）', '资料员'),
('双休！社保！免费三餐！国企办公室销售', '销售代表'),
('国企（资料录入文员）周末双休不加班', '资料员'),
('渝中区招聘两名。街道资料文员双休！！', '资料员'),
('【人保直招 车险续保】包吃 双休', '车险理赔'),
('4-7K国企银行接听客服（五险一金/双休）', '客服专员'),
('国企后勤+双休+朝九晚五+不加班', '行政专员'),
('人保车险续保专员+西安8500+五险+央企福利', '车险理赔'),
('保险招聘助理', '保险顾问'),
('2027届秋招金融管培生（财富管理方向）', '理财顾问'),
('央企可三点半下班有五险一金行政售后助理', '售后客服'),
('上五休二 央企档案售后管理$6K-8K 13薪', '售后客服'),
('国企双休+办公司坐席9k+五险一金', '电话销售'),
('人民检察院旁/车险内勤（双休+五险一金）', '车险理赔'),
('双休行政专员、 售后专员', '售后客服'),
('【央企招募】人事/业务助理（周末双休）', '人事专员'),
('央企财产保险公司个人综合金融电子商务专员', '保险顾问'),
('宠物医疗审核薪资1万', '兽医'),
('上海银行客服/可招26届实习生应届生', '客服专员'),
('国有银行逾期提醒客服', '客服专员'),
('上海虹桥支付宝商户地推 包住宿', '市场专员'),
('工资有点高+零经验也可客服+入职培训专人带', '客服专员'),
('【需尽快到岗】双休(早9:00晚5:00)运营客服', '客服专员'),
('银行市场推广', '市场专员'),
('银行编制！10K英文翻译客服+双休', '客服专员'),
('中信银行信用卡销售（五险一金）', '销售代表'),
('回访客服（双休 不加班）', '客服专员'),
('银行私行中心前台', '行政专员'),
('双休包住宿五险一金的银行渠道销售', '渠道销售'),
('光大银行催收员', '信贷管理'),
('双休文员/内容审核/真实底薪6500', '行政专员'),
('金融助贷顾问+新人不打折+50%高提成', '咨询顾问'),
('新能源光伏风电项目技术总监', '光伏工程师'),
('游戏市场营销策划', '游戏策划'),
('房产销售，金融销售，法律销售', '房地产销售'),
('总部内勤-行政岗管培生（不涉及销售）', '销售代表'),
('行政管家', '行政专员'),
('双休！行政助理！朝九晚五！！', '行政专员'),
('周末双休行政人事HR接受小白', '行政专员'),
('四点可提前下班！行政专员（档案管理）', '行政专员'),
('行政专员+早九晚六+入职社保6-8k', '行政专员'),
('人事行政助理', '行政专员'),
('总部-人力资源中心-管培生', '人事专员'),
('人事（人力资源） 早九晚5.30入职交社保！', '人事专员'),
('人力资源经理/主管', '人事专员'),
('财务审计助理——2026春招-北京(J11530)', '审计'),
('审计员-北京分所(J10380)', '审计'),
('审计总监助理', '审计'),
('会计 和 审计', '会计'),
('审计或代理记账会计', '会计'),
('财税咨询师/审计师', '审计'),
('周末双休保险金融顾问', '保险顾问'),
('金融保险专员', '保险顾问'),
('明亚全国保险经纪（专/兼职）', '保险顾问'),
('推销勿扰–保险销售（月入1.5w+双休!）', '保险顾问'),
('健康保险事业部管培生', '保险顾问'),
('保险同业主管(直接给主管身份和待遇)', '保险顾问'),
('中国人寿“新星计划-保险规划师（储备主管', '保险顾问'),
('保险代理人', '保险顾问'),
('明亚保险经纪人销售咨询顾问代理人合伙人', '保险顾问'),
('Youth Manager – 保险代理人', '保险顾问'),
('明亚保险经纪人（深圳兼职/全职）', '保险顾问'),
('房车保险', '保险顾问'),
('大童保险服务合伙人', '保险顾问'),
('中国人寿保险售后服务经理', '保险顾问'),
('周末双休保险理赔专员', '核保理赔'),
('保险续保专员', '保险顾问'),
('央企优秀保险顾问 | 年薪20万双休', '保险顾问'),
('保险博主/保险经纪人（可兼职）', '保险顾问'),
('保险理赔内勤', '核保理赔'),
('明亚保险经纪人-全/兼职/止于至善杭州团队', '保险顾问'),
('双休有底薪 保险销售业务员', '保险顾问'),
('公司分配高净值客源 保险规划师', '保险顾问'),
('中国人寿保险.早九晚五/周末双休/主管助理', '保险顾问'),
('金融销售专员（非保险，非贷款）', '信贷管理'),
('高级保险理财经理/入职六险一金', '保险顾问'),
('明亚四川保险经纪（专/兼职）', '保险顾问'),
('产品经理--校招【无责9.5k+】', '产品经理'),
('nlp产品经理（全额社保公积金-现场复试）', 'NLP工程师'),
('用户研究员', '投资分析师'),
('机械外贸销售', '外贸业务员'),
('机械设计工程师', '机械工程师'),
('兼职人力资源', '人事专员'),
('人力资源销售', '销售代表'),
('财务bp', '财务BP'),
('三维设计师/Motion Designer', '3D设计师'),
('童装设计师', '服装设计师'),
('氛围超好的英语老师岗，快来加入我们吧！', '外语教师'),
('法务顾问', '法务专员'),
('法务专员/助理', '法务专员'),
('大厂/周末双休/法务专员', '法务专员'),
('医疗耗材销售（骨科）', '销售代表'),
('兼职文案写手', '文案策划'),
('文案内容优化兼职', '文案策划'),
('简介文案写手', '文案策划'),
('广告文案实习生', '文案策划'),
('social文案', '文案策划'),
('新能源车与辅助驾驶领域深度报道记者', '新能源销售'),
('针织设计师', '服装设计师'),
('户外广告销售（九亭）周末双休', '销售代表'),
('小红书广告销售-周末双休-五险一金', '销售代表'),
('上海小红书广告销售｜周末双休｜五险一金', '销售代表'),
('广告制作普工', '操作工'),
('广告销售（上海）', '销售代表'),
('电商品牌营销策划', '品牌策划'),
('非遗文化传承单位/上海社保/氛围好销售', '销售代表'),
('高客单地毯主播（站播/高提成/上大附近）', '主播'),
('非遗文创艺术品/月入过万/销售顾问', '销售代表'),
('艺术品销售', '销售代表'),
('艺术类杂志新媒体编辑', '新媒体运营'),
('艺术空间销售接待实习生（销售/新媒体）', '销售代表'),
('艺术品牌 · 时尚眼镜导购 | Gentle Monster', '销售代表'),
('奢侈品门店导购', '销售代表'),
('情感咨询师/策划师', '咨询顾问'),
('市场营销实习生(暑假）', '市场专员'),
('品牌市场营销经理', '市场专员'),
('超级香 照着念 （不加班） 客服', '客服专员'),
('无责8q+纯客服+早九晚六-包住', '客服专员'),
('纯客服/周末双休/到点下班', '客服专员'),
('客服岗 无责8000 包住', '客服专员'),
('无责9000/纯客服/早九晚六', '客服专员'),
('纯客服助理/无销售性质/早九晚六双休', '销售代表'),
('客服双休', '客服专员'),
('客服岗 做五休二 工作8小时 工作简单好上手', '客服专员'),
('无责底薪8000 纯客服 15号发工资！！', '客服专员'),
('后台客服', '客服专员'),
('行政人事文员 朝九晚六 双休', '行政专员'),
('行政采购', '采购专员'),
('行政专员/助理-早九晚六-周末双休-五险一金', '行政专员'),
('公司行政', '行政专员'),
('医疗器械售后咨询客服', '医疗器械销售'),
('国际项目咨询专员', '咨询顾问'),
('票据审核/合规审计专员', '审计'),
('合规素材审核（证券金融行业）', '证券经纪人'),
('上海-风险管理与合规咨询实习生(MJ006701)', '风控专员'),
('房产中介经纪人', '房地产销售'),
('急招10人线上销售金桥/ 非贷款 房地产 保险', '信贷管理'),
('外贸采购员', '外贸业务员'),
('采购文员', '采购专员'),
('食品采购员', '采购专员'),
('数据分析/供应链助理/PMC跨境电商/计划员', '数据分析'),
('跨境供应链销售顾问｜外贸赛道', '外贸业务员'),
('26届AI无人车 算法工程师（包吃住+单休）', '算法工程师'),
('资深算法专家', '算法工程师'),
('实验室技术员\\化学工程师', '化学分析员'),
('生物基可降解塑料制品销售', '销售代表'),
('化工原材料销售专员', '销售代表'),
('碳纤维复合材料制品销售', '销售代表'),
('园区环境保洁服务主管 (MJ002397)', '保洁'),
('数据统计分析岗，做六休一、会用Excel', '数据分析'),
('公司前端文员', '前端开发'),
('自动化装配电工/钳工500-600一天/可带手机', '自动化工程师'),
('网络邀约客服', '客服专员'),
('心理学家教老师', '教师'),
('心理咨询分析师', '心理咨询师'),
('心理咨询顾问intern', '心理咨询师'),
('新能源汽车维修', '新能源销售'),
('新能源二手车销售', '销售代表'),
('国际货代销售（base上海+六险一金+双休）', '外贸业务员'),
('国际物流东南亚分公司总监', '物流专员'),
('国际部销售专员', '外贸业务员'),
('董事长助理/秘书', '行政专员'),
('新娘秘书', '行政专员'),
('总经理助理/秘书', '行政专员'),
('总经理秘书/助理', '行政专员'),
('船员人事（船东方）', '人事专员'),
('船舶备件销售', '销售代表'),
('航运咨询项目助理', '咨询顾问'),
('兼职英语导游（近代史/历史）', '导游'),
('浦东新区招收门店导购 入职缴纳五险一金', '销售代表'),
('产品总监', '产品经理'),
('音乐Bar服务员', '服务员'),
('摄影修图师', '摄影师'),
('会展 展台搭建 销售', '销售代表'),
('展会主场项目专员', '活动策划'),
('展会展台搭建业务员5名，实习生3名要求文科', '活动策划'),
('展会拍摄兼职（上海）', '活动策划'),
('会展营销专员', '活动策划'),
('会议/会展/展览 展位销售经理', '销售代表'),
('展会模特/接待', '活动策划'),
('会展活动执行', '活动策划'),
('会展运营 包吃住 有年假 有通勤', '活动策划'),
('会展操作实习生', '活动策划'),
('展会展位销售', '销售代表'),
('会展活动销售', '销售代表'),
('展会兼职人员', '活动策划'),
('月薪8k-1.5w家装展会邀约电销、双休、交金', '电话销售'),
('峰会销售/会展销售', '销售代表'),
('展会业务销售/展台业务销售/展览设计业务', '销售代表'),
('会展销售专员', '销售代表'),
('会展项目助理', '活动策划'),
('展会搭建销售', '销售代表'),
('电商客服双休', '客服专员'),
('电商文员', '行政专员'),
('电商推广专员（隐形眼镜品牌）', '市场专员'),
('电商库房打包', '包装工'),
('销售专员/电商办公家具类目/无需拓客', '销售代表'),
('电商直播', '主播'),
('英语外贸员｜自有工厂｜展会资源多', '外贸业务员'),
('周浦直招外贸招商专员', '外贸业务员'),
('外贸销售助理', '外贸业务员'),
('外贸助理', '外贸业务员'),
('毛衫外贸跟单', '外贸业务员'),
('外贸会计', '会计'),
('外贸报关员', '外贸业务员'),
('外贸员（北欧ZARA）', '外贸业务员'),
('物业运营专员', '物业管理员'),
('智慧农业 智能农机 总经理助理', '行政专员'),
('农业种植技术员', '农业技术员'),
('美菜大厂招聘管培生应届生入职五险一金', '招聘专员'),
('种植基地运营经理（农业）', '农业技术员'),
('京东直招-生鲜食品仓品控员（上海）', '质检员'),
('大宗食品采购（米面粮油/蛋）', '采购专员'),
('泡面/食品/包装7500k', '包装工'),
('汽车新媒体主播', '新媒体运营'),
('汽车机修工', '汽车维修工'),
('无责7000+ 主播 有住宿！', '主播'),
('小米汽车主播', '主播'),
('拆卡主播', '主播'),
('化工技术销售（徐家汇）', '销售代表'),
('业务跟单（出口 纺织类 英语口语好）', '跟单员'),
('产品开发助理/商品开发助理【纺织品】', '服装设计师'),
('纺织品业务跟单', '跟单员'),
('纺织品销售助理销售跟单', '销售代表'),
('纺织品品质控制员(QC)', '质检员'),
('进出口纺织品销售', '销售代表'),
('文创产品开发(纺织类）', '服装设计师'),
('纺织面料开发/跟单/工程师', '跟单员'),
('纺织/材料研究负责人', '服装设计师'),
('产品开发专员（家居纺织品及装饰品）', '服装设计师'),
('航空票务专员（操作+销售）', '销售代表'),
('外业测量员（铁路钢轨）', '测绘工程师'),
('仪器维修工程师（工作地点 上海及全国）', '仪器仪表工程师'),
('萌宠宠物直播主播助播副播电商淘宝抖音小白', '主播'),
('养老咨询顾问', '咨询顾问'),
('船舶安全服务工程师', '网络安全'),
('船代销售助理', '销售代表'),
('上海 政府关系销售', '销售代表'),
('芯片/半导体销售（无责底薪8-12K）', '销售代表'),
('小白可做｜底薪7500销售岗｜面试当天出结果', '销售代表'),
('红果百度 推流获客销售岗+无经验+保底15000', '销售代表'),
('销售 穿版模特', '销售代表'),
('酒水销售专员', '销售代表'),
('专柜导购销售员/营业员 上一休一', '销售代表'),
('加油站销售员/白班+包住', '销售代表'),
('面试当天出结果（电话销售岗）包住宿下午茶', '电话销售'),
('团队主管及销售员', '销售代表'),
('珠宝销售专员', '销售代表'),
('舟山定海 店内销售6k+5点下班不加班！', '销售代表'),
('会议活动销售+包住', '销售代表'),
('4S店汽车原厂延保销售（舟山兼职）', '销售代表'),
('奔驰二手车销售-舟山利星 (MJ005966)', '销售代表'),
('温岭销售', '销售代表'),
('六险一金+周末双休+电销/软件销售/外贸销售', '外贸业务员'),
('服装销售员', '销售代表'),
('接受小白的销售岗 和00后同事一起拼搏', '销售代表'),
('药企急招/社群销售岗 应届实习优先', '销售代表'),
('氛围超好 周末双休 上9下6 销售岗', '销售代表'),
('超绝6小时销售岗，不加班！！！', '销售代表'),
('电商自动化程序员', '自动化工程师'),
('全栈程序员Java+vue+若依框架', '全栈开发'),
('销售岗+到点下班+包住宿', '销售代表'),
('周末双休＋不加班/底薪5000/销售岗', '销售代表'),
('20k 躺赚级亲子教育销售岗，速来面试！', '销售代表'),
('今天面试 明天上班+销售岗', '销售代表'),
('华山片区销售岗 有新人保护期', '销售代表'),
('父母听了都觉得稳定的工作 （销售岗）', '销售代表'),
('强制五点下班！！不加班销售岗', '销售代表'),
('00后也能干，销售岗自由高薪', '销售代表'),
('高薪坐班销售岗~钱多事少', '销售代表'),
('豆包都建议你做的销售岗', '销售代表'),
('(不喜欢打电话的来)销售岗均薪9k+不加班', '电话销售'),
('无责5k+单双休+不打卡+不加班+社保 销售岗', '销售代表'),
('超简单的销售岗/大小周/保底6K+', '销售代表'),
('朝九晚六 双休 底薪4500 销售', '销售代表'),
('坐班岗位（7个半小时）销售岗', '销售代表'),
('销售岗 氛围嘎嘎好 底薪加提成', '销售代表'),
('赚钱小天才（销售岗）', '销售代表'),
('双休早九晚五销售岗', '销售代表'),
('ai软件开发工程师 无责底薪6-8 小白勿扰', '算法工程师'),
('无责6000+早9晚6+需5人到岗+方案销售岗', '销售代表'),
('轻松坐班（0经验也可）精准客资销售岗', '销售代表'),
('新手友好销售岗+不内卷+免费住宿', '销售代表'),
('10号发薪！苏州N o.1销售岗 包精准资源', '销售代表'),
('今天面试 明天入职/底薪8000销售岗', '销售代表'),
('广告销售岗/百度平台/AI---GEO', '销售代表'),
('Java 应届毕业生', 'Java开发'),
('底薪7000+不含绩效+需5人+方案销售岗', '销售代表'),
('周末双休高薪销售岗', '销售代表'),
('接受小白+老人带+无压力销售岗无责底薪4K', '销售代表'),
('电话量不多/招两个玩狼人杀的销售岗', '电话销售'),
('后端java', '后端开发'),
('展厅销售', '销售代表'),
('厦门京东Mall惠普电脑销售员', '销售代表'),
('java全栈软件工程师', '全栈开发'),
('销售sales', '销售代表'),
('电动车销售员', '销售代表'),
('今天面明天就入职+无责5K底薪销售岗新资源', '销售代表'),
('销售岗｜工作简单，氛围轻松，不用跑外', '销售代表'),
('外贸销售员（接受小白，双休）', '外贸业务员'),
('销售 1W元/月 （事少 关系简单 出单快）', '销售代表'),
('无责4800+包住+销售储备干部', '销售代表'),
('吹着空调轻轻松松把钱赚的销售岗+不加班', '销售代表'),
('月入过万招聘店员（销售类营业员）', '销售代表'),
('急招门店销售员（海珠区）', '销售代表'),
('销售员（虎门店）', '销售代表'),
('周末双休 销售岗 无责4K', '销售代表'),
('双休/朝九晚六/办公室纯销售岗', '销售代表'),
('后端 Java 开发管培生（2024-2026届）', 'Java开发'),
('周末双休 销售岗8k+ 朝九晚六', '销售代表'),
('接受小白+无责5k+没有电话量要求的销售岗', '电话销售'),
('做销售为什么有人月薪两万？秘诀在这', '销售代表'),
('私域销售（接受无经验+五险+不加班！！！）', '销售代表'),
('无责9000底薪（真实）+不一样的“销售”岗', '销售代表'),
('接受实习生~外贸电商销售岗，综合薪资8K起', '外贸业务员'),
('销售岗-无责5100+社保', '销售代表'),
('月入1万＋销售岗早10晚5双休', '销售代表'),
('销售岗｜五险一金 + 下午茶不断，多重福利', '销售代表'),
('不耽误接送孩子销售岗', '销售代表'),
('微信视频号运营', '社群运营'),
('运营销售', '销售代表'),
('会计专员(Accounting Specialist)', '会计'),
('全职毛纱门市部会计', '会计'),
('短视频拍摄剪辑运营', '视频编辑'),
('电商客服 主播 运营 打包', '包装工'),
('抖音运营负责人', '新媒体运营'),
('电商财务会计', '会计'),
('拼多多运营（薪资8000-20000）', '薪酬专员'),
('家电销售/新媒体运营 0基础可学', '销售代表'),
('亚马逊运营/高级运营【丽水/双休】', '外贸业务员'),
('【财务会计】双休不加班+五险一金', '会计'),
('会计 财务', '会计'),
('晚5点下班，不加班+双休 会计', '会计'),
('餐饮会计', '会计'),
('金州工厂会计', '会计'),
('成手会计', '会计'),
('电商私域运营', '社群运营'),
('微信运营岗 双休 免费下午茶', '社群运营'),
('全盘会计 大小周', '会计'),
('总帐会计', '会计'),
('抖音本地生活运营', '新媒体运营'),
('小红书图文运营', '新媒体运营'),
('会计核算', '会计'),
('普通会计1名', '会计'),
('财税会计', '会计'),
('抖音运营岗--接受实习/小白', '新媒体运营'),
('品牌运营(无责底薪3500＋免费培训)', '品牌策划'),
('迎宾员（26应届）', '服务员'),
('13薪外企销售岗 早九晚六双休 节假日休', '销售代表'),
('外企广州及周边服装采购', '采购专员'),
('外企电话客服年薪12万+年终奖', '电话销售'),
('澳洲低奢英文导购（外企）', '销售代表'),
('民族大学附近同学广场仓储【招店员半天班】', '仓储管理'),
('外企急招打包员7000/月 班次自选秦淮仓', '包装工'),
('双休外企直签 订单处理文员 （带薪培训）', '行政专员'),
('6k+【外企正编】单证文员 朝九晚六+双休', '报关员'),
('外企正编双休/稳定文职/接受小白(不销售)', '销售代表'),
('外企+超多福利+高端新能源汽车文员', '行政专员'),
('4500双休 淘宝客服', '客服专员'),
('五百强外企2026届实习生招聘', '招聘专员'),
('外贸销售（外企急聘 周末双休）', '外贸业务员'),
('门店销售外企/做一休一/五险一金', '销售代表'),
('外贸业务经理', '外贸业务员'),
('DCC电销员（宝马4S店)', '电话销售'),
('央国企就业主播', '主播'),
('物流岗-运输', '物流专员'),
('物流管培生', '物流专员'),
('物流退款审核', '物流专员'),
('物流经理', '物流专员'),
('新能源外贸业务（电池、汽配）', '外贸业务员'),
('海外销售（新能源）+包吃住', '销售代表'),
('新能源储能 外贸业务员 双休入职五险一金', '外贸业务员'),
('双休 新能源 内贸销售', '销售代表'),
('英语配音翻译', '翻译'),
('西语翻译', '翻译'),
('马来西亚语翻译', '翻译'),
('游戏俱乐部运营', '游戏运营'),
('法律执行专员', '法务专员'),
('律所案源销售（网推）', '销售代表'),
('上班自由+五险一金+法律+继承顾问+接受度高', '法务专员'),
('法律顾问（可居家）深圳月入5K-2W', '法务专员'),
('法律顾问0费用给案源纯分成', '法务专员'),
('社区法律顾问助理', '法务专员'),
('早九晚六 打字回复的线上法律顾问', '法务专员'),
('十点上班/保底6000法律助理', '法务专员'),
('底薪6000法律专员+五险', '法务专员'),
('仓储全国行政岗', '仓储管理'),
('行政专员 地铁周边', '行政专员'),
('HR//人力资源//总助//双休//地铁口//年假', '行政专员'),
('人力资源实习生-招聘方向', '招聘专员'),
('人力资源招聘专员（双休+包住）', '招聘专员'),
('人力资源经理', '人事专员'),
('人力兼职/招聘兼职', '招聘专员'),
('高级人力资源咨询师', '人事专员'),
('好想来店员 + 日薪300 + 包食宿 + 有保险', '保险顾问'),
('保险客服实习生/京东直招/27年毕业生', '保险顾问');
