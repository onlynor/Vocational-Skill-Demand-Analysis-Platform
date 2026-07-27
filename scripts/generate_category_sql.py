# coding: utf-8
"""
Generate comprehensive SQL for:
1. New industry categories (job_category parent rows)
2. Standard job titles under new industries (job_category child rows)
3. Synonym mappings for all unclassified titles
"""
import pymysql, os, re
from collections import defaultdict, Counter

with open('D:/study/实验_提交版/.env', encoding='utf-8') as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith('#') and '=' in line:
            k, v = line.split('=', 1)
            os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))

conn = pymysql.connect(
    host=os.environ['DB_HOST'], port=int(os.environ['DB_PORT']),
    user=os.environ['DB_USER'], password=os.environ['DB_PASSWORD'],
    database=os.environ['DB_NAME'], charset='utf8mb4'
)
cur = conn.cursor()

cur.execute('SELECT id, name, parent_id FROM job_category ORDER BY id')
cats = cur.fetchall()
existing_titles = {r[1] for r in cats}
max_id = max(r[0] for r in cats)

cur.execute('SELECT raw_word, std_word FROM synonym_dict')
existing_syns = {r[0]: r[1] for r in cur.fetchall()}

cur.execute("SELECT title, COUNT(*) as cnt FROM cleaned_jobs WHERE category_id IS NULL GROUP BY title ORDER BY cnt DESC")
unclassified = cur.fetchall()

# -----------------------------------------------------------
# NEW INDUSTRIES DEFINITION
# Each entry: (industry_name, [list_of_standard_job_titles])
# These titles are "canonical" names that should appear in the UI
# -----------------------------------------------------------
new_industries = {
    '法律/合规': [
        '律师', '法务专员', '法律顾问', '合规专员', '知识产权顾问',
        '专利代理人', '法务经理', '法律咨询顾问', '合同管理员', '法诉专员',
        '尽调专员',
    ],
    '行政/人事': [
        '行政专员', '行政助理', '前台', '人事专员', '招聘专员',
        '人事行政专员', '薪酬专员', '培训专员', '秘书', '文员',
        '劳动关系专员', '人事经理', '行政经理', '招聘经理',
        '员工关系专员', 'HRBP', '人力资源主管',
    ],
    '物业/安保': [
        '物业管理员', '保安', '消防中控员', '物业客服', '物业经理',
        '安防监控员', '消防安全员', '保安班长', '门卫', '停车场管理员',
        '物业工程维修', '安全主管',
    ],
    '餐饮/服务': [
        '厨师', '服务员', '咖啡师', '调酒师', '面点师', '烘焙师',
        '帮厨', '洗碗工', '餐厅经理', '奶茶店员', '配菜员',
        '切菜员', '打荷', '前厅经理', '店长', '学徒', '送餐员',
        '日料厨师', '烧腊师傅', '西餐厨师', '中餐厨师',
    ],
    '家政/生活服务': [
        '保洁', '保姆', '月嫂', '护工', '育儿嫂', '养老护理员',
        '收纳师', '家电清洗师', '钟点工', '管家', '育婴师',
    ],
    '美容/养生': [
        '美容师', '美发师', '美甲师', '化妆师', '养生技师',
        '按摩师', '足疗师', '采耳师', 'SPA技师', '皮肤管理师',
        '医美顾问', '纹绣师', '美睫师', '理疗师', '美容顾问',
    ],
    '酒店/旅游': [
        '酒店前台', '客房服务员', '导游', '旅游计调', '票务员',
        '礼宾员', '酒店经理', '民宿管家', '签证专员', '门童',
        '大堂经理', '行李员',
    ],
    '体育/健身': [
        '健身教练', '瑜伽老师', '游泳教练', '篮球教练', '足球教练',
        '羽毛球教练', '网球教练', '跆拳道教练', '拳击教练', '滑雪教练',
        '潜水教练', '体适能教练', '普拉提教练', '高尔夫教练',
        '体育老师',
    ],
    '农林牧渔': [
        '农业技术员', '种植技术员', '养殖技术员', '林业技术员',
        '渔业技术员', '园艺师', '园林绿化', '农艺师', '畜牧师',
        '农业销售', '农药销售', '饲料销售',
    ],
    '新能源': [
        '光伏工程师', '风电工程师', '储能工程师', '锂电工程师',
        '新能源销售', '充电桩运维', '光伏设计', '光伏安装',
        '新能源项目经理', '电池研发',
    ],
    '化工/日化': [
        '化工工程师', '化学分析员', '研发工程师', '化妆品研发',
        '涂料工程师', '高分子材料工程师', '日化研发', '实验室技术员',
        '化学检验员', '化工工艺师', '试剂研发',
    ],
    '影视/演艺': [
        '演员', '导演', '编剧', '制片人', '艺人助理',
        '主播', '短视频编导', '直播运营', '短视频运营',
        '抖音运营', '才艺主播', '娱乐主播', '带货主播',
        '舞台监督', '剧组场务', '选角导演', '经纪人',
        '新媒体运营',
    ],
    '汽车': [
        '汽车销售', '汽车维修工', '汽车美容师', '二手车评估师',
        '4S店销售顾问', '汽车检测师', '钣金工', '喷漆工',
        '汽车机电维修', '车险理赔',
    ],
    '环保/环境': [
        '环保工程师', '污水处理工', '环境检测员', '环评工程师',
        '碳排放管理员', '给水工程师', '环保销售', '固废处理工程师',
    ],
    '咨询/商务服务': [
        '咨询顾问', '管理咨询师', '猎头顾问', '企业管理咨询',
        '认证咨询师', '移民顾问', '婚恋顾问', '保险顾问',
        '理赔专员', '知识产权代理', '工商财税顾问',
    ],
    '质检/检测': [
        '质检员', '化验员', '检测工程师', '认证审核员', '品控专员',
        '试验员', '无损检测员', '质量工程师', '验货员', '计量员',
    ],
    '客服': [
        '客服专员', '售前客服', '售后客服', '电话客服',
        '在线客服', '投诉专员', '呼叫中心客服', 'VIP客服',
        '客服主管',
    ],
    '服装/纺织': [
        '服装设计师', '服装打版师', '样衣工', '缝纫工',
        '面料采购', '跟单员', '服装销售', '纺织工程师',
        '服装质检', '裁缝',
    ],
}

# We'll also extend some EXISTING categories with new job titles
extend_existing = {
    '计算机/互联网': [
        '数据分析师', '大数据工程师', 'ETL工程师', '数据仓库工程师',
        '算法研究员', 'AI算法工程师', '大模型算法', 'AIGC算法',
        '推荐算法工程师', '计算机视觉工程师', '自然语言处理工程师',
        '系统架构师', '技术经理', '技术总监', 'CTO',
        '中间件工程师', '基础架构工程师', 'SRE工程师',
        '测试经理', '质量保证工程师', '安全运维工程师',
        'IT支持', '技术支持工程师', 'Helpdesk', '桌面运维',
        'ERP实施顾问', 'CRM实施顾问', '信息化专员', '企业应用工程师',
        'RPA开发', '低代码开发', '游戏数值策划', '游戏系统策划',
        '游戏运营专员', '游戏美术', '游戏特效', '游戏音效',
        'Unity开发', 'Unreal开发', 'Cocos开发',
        '客户端开发', 'Windows开发', 'Mac开发',
        '音视频开发', '流媒体开发', 'CDN工程师',
        '云计算工程师', '容器工程师', 'K8S运维',
    ],
    '电气/自动化': [
        '弱电工程师', '强电工程师', '变电工程师',
        '输配电工程师', '继电保护工程师', '自动化控制工程师',
        'DCS工程师', 'SCADA工程师', '机器人工程师',
        '新能源电气工程师', '储能电气工程师',
    ],
    '金融/会计': [
        '财务助理', '财务专员', '应收会计', '应付会计',
        '财务BP', '税务会计', '预算管理', '内审专员',
        '反洗钱专员', '贷后管理', '催收专员', '委外催收',
        '按揭专员', '抵押专员', '担保专员',
    ],
    '教育/培训': [
        '托管老师', '辅导老师', '学习管理师', '艺考老师',
        '书法老师', '舞蹈老师', '编程老师', '机器人老师',
        '口才老师', '主持老师', '营地导师', '研学导师',
    ],
    '建筑/土木': [
        'BIM工程师', '幕墙设计师', '园林设计师', '景观设计师',
        '规划设计', '土地规划', '房产评估师', '房地产策划',
        '拆迁专员', '报建专员', '开发报建', '现场管理',
    ],
    '机械/制造': [
        '数控机床操作工', '磨工', '铣工', '车工', '镗工',
        '线切割工', '电火花工', '抛光工', '喷砂工',
        '铸造工', '锻造工', '冲压工', '钣金工',
        '装配工', '包装工', '普工', '操作工',
        '生产主管', '生产计划', '车间主任', '班组长',
        '物料员', '搬运工', '流水线工人',
    ],
    '销售/市场': [
        '地推专员', 'BD专员', '商务专员', '商务经理',
        '区域销售', '城市经理', '省区经理', '大区经理',
        '销售工程师', '售前工程师', '解决方案工程师',
        '会销讲师', '会销专员', '直销员',
        '回访专员', '续费专员', '网销专员',
        '社区团购运营', '私域运营', '社群运营',
    ],
    '物流/运输': [
        '分拣员', '打包员', '理货员', '配货员',
        '调度员', '押运员', '跟单员', '报关员',
        '集装箱管理员', '货场管理员', '国际物流专员',
        '冷链物流专员', '危险品运输员', '配送站长',
    ],
    '传媒/设计': [
        'UI设计师', 'UX设计师', '交互设计师', '界面设计师',
        '电商设计师', '美工', '网店美工', '淘宝美工',
        '游戏UI', '图标设计师', '字体设计师',
        '特效师', '合成师', '调色师', '录音师',
        '灯光师', '舞台美术', '场景设计师',
        '策展人', '画廊助理', '艺术品顾问',
    ],
    '医学/医疗': [
        '医学编辑', '医学经理', '医学顾问',
        '临床数据管理员', '药物警戒专员', '药物安全专员',
        'GMP专员', 'QA工程师', 'QC分析员',
        '注册专员', 'RA专员', '医药项目管理员',
        '口腔咨询师', '口腔护士', '牙科助理',
        '验光师', '视光师', '听力师',
        '康复治疗师', '物理治疗师', '作业治疗师',
        '心理治疗师', '心理咨询师', '心理医生',
        '影像技师', '超声技师', '放疗技师',
        '体检医生', '体检护士', '预检分诊',
        'B超医生', '彩超医生', '心电图技师',
        '检验技师', '病理技师', '输血技师',
        '助产士', '麻醉护士', '手术室护士',
        'ICU护士', '急诊科护士', '门诊护士',
        '社区护士', '家庭医生', '全科医生',
        '中医师', '中西医结合医师', '针灸推拿师',
        '兽医', '宠物医生', '动物实验员',
    ],
}

# -----------------------------------------------------------
# Generate SQL
# -----------------------------------------------------------
all_sql = []

# 1. New industry categories
next_id = max_id + 1
industry_id_map = {}
sort_order = 1

for industry_name, job_titles in new_industries.items():
    parent_id = next_id
    industry_id_map[industry_name] = parent_id
    # Escape single quotes
    safe_name = industry_name.replace("'", "\\'")
    all_sql.append(f"-- New industry: {industry_name}")
    all_sql.append(f"INSERT INTO job_category (id, name, parent_id, sort_order) VALUES ({parent_id}, '{safe_name}', NULL, {sort_order});")
    sort_order += 1
    next_id += 1

    child_sort = 1
    for title in job_titles:
        if title in existing_titles:
            continue
        safe_title = title.replace("'", "\\'")
        all_sql.append(f"INSERT INTO job_category (id, name, parent_id, sort_order) VALUES ({next_id}, '{safe_title}', {parent_id}, {child_sort});")
        existing_titles.add(title)
        child_sort += 1
        next_id += 1

# 2. Extend existing categories
parent_name_to_id = {}
for industry_name, _ in new_industries.items():
    parent_name_to_id[industry_name] = industry_id_map[industry_name]

# Get existing industry IDs
cur.execute("SELECT id, name FROM job_category WHERE parent_id IS NULL")
for rid, rname in cur.fetchall():
    parent_name_to_id[rname] = rid

for industry_name, job_titles in extend_existing.items():
    pid = parent_name_to_id.get(industry_name)
    if pid is None:
        continue
    # Get current max sort_order for this industry
    cur.execute("SELECT MAX(sort_order) FROM job_category WHERE parent_id=%s", (pid,))
    max_sort = cur.fetchone()[0] or 0
    child_sort = max_sort + 1

    added = 0
    for title in job_titles:
        if title in existing_titles:
            continue
        safe_title = title.replace("'", "\\'")
        all_sql.append(f"-- Extend {industry_name}: {title}")
        all_sql.append(f"INSERT INTO job_category (id, name, parent_id, sort_order) VALUES ({next_id}, '{safe_title}', {pid}, {child_sort});")
        existing_titles.add(title)
        child_sort += 1
        next_id += 1
        added += 1
    if added:
        print(f"Extended {industry_name} with {added} new titles")

# -----------------------------------------------------------
# 3. Build improved synonym mapping
# -----------------------------------------------------------
all_synonyms = {}  # raw_title -> standard_title

# First, build keyword-to-standard lookup from all categories
cur.execute("SELECT name, parent_id FROM job_category WHERE parent_id IS NOT NULL")
title_to_industry = {}
for rname, rpid in cur.fetchall():
    title_to_industry[rname] = rpid

# Build reverse: parent_id -> industry_name
cur.execute("SELECT id, name FROM job_category WHERE parent_id IS NULL")
pid_to_ind = {r[0]: r[1] for r in cur.fetchall()}

# Keyword-based matching for each unclassified title
# This is the comprehensive rule engine
def match_title(title: str) -> str | None:
    """Try to match a raw title to a standard category name."""
    t = title.strip()

    # First try exact match (case insensitive)
    t_lower = t.lower()
    for std_name in existing_titles:
        if t_lower == std_name.lower():
            return std_name

    # Remove common suffixes
    clean = t_lower
    clean = re.sub(r'[\s]*[（(][^)）]*[)）]', '', clean)  # remove (xxx)
    clean = re.sub(r'[-_/]\s*$', '', clean)  # trailing symbols
    clean = re.sub(r'[,，、]\s*$', '', clean)

    # Try again after cleaning
    for std_name in existing_titles:
        if clean == std_name.lower():
            return std_name

    # Check if it's in existing synonyms already
    if title in existing_syns:
        std = existing_syns[title]
        if std in existing_titles:
            return std

    # Keyword-based matching
    # Computer/Internet
    if re.search(r'\bjava\b', t_lower): return 'Java开发'
    if re.search(r'\bpython\b', t_lower) and not re.search(r'非.*python|python.*非', t_lower): return 'Python开发'
    if re.search(r'\b(c\+\+|cpp)\b', t_lower): return 'C++开发'
    if re.search(r'\bgolang\b|\bgo[-\s]*语言\b', t_lower): return 'Golang开发'
    if re.search(r'\bphp\b', t_lower) and not re.search(r'php.*框架|框架.*php', t_lower): return 'PHP开发'
    if re.search(r'前端|web前端|h5.*开发|html5.*开发|小程序开发|flutter.*开发|react.*native', t_lower):
        return '前端开发'
    if re.search(r'后端|后台开发|服务端开发|接口开发', t_lower):
        return '后端开发'
    if re.search(r'全栈|full\s*stack', t_lower):
        return '全栈开发'
    if re.search(r'\.net|net.*开发|c#.*开发|asp\.net', t_lower):
        return '.NET开发'
    if re.search(r'\bnode\.*js\b|nodejs', t_lower):
        return 'Node.js开发'
    if re.search(r'android|安卓.*开发|android.*开发', t_lower):
        return 'Android开发'
    if re.search(r'\bios\b|苹果.*开发|ios.*开发', t_lower):
        return 'iOS开发'
    if re.search(r'鸿蒙|harmonyos', t_lower):
        return '鸿蒙开发'
    if re.search(r'测试.*开发|自动化.*测试|测试.*自动化', t_lower):
        return '测试开发'
    if re.search(r'测试|qa.*工程师|软件质量|功能.*测试|软件.*测试|测试员|游戏测试|性能测试|接口测试|app.*测试|web.*测试|移动端.*测试|客户端.*测试|系统测试|集成测试|白盒.*测试|黑盒.*测试|压力测试', t_lower):
        return '软件测试'
    if re.search(r'运维|sre|devops|linux.*管理|系统管理|k8s|kubernetes|docker.*运维|云平台.*运维|服务器.*管理', t_lower):
        return '运维工程师'
    if re.search(r'dba|数据库.*管理|数据库.*运维|数据库.*dba|mysql.*dba', t_lower):
        return 'DBA'
    if re.search(r'网络安全|信息安全|安全.*工程|渗透测试|安全.*运维|安全.*开发|数据安全|隐私.*安全|安全.*合规|安全.*分析|安全.*架构|安全.*审计|安全.*运营|安全.*测试|代码.*审计|安全.*专家', t_lower):
        return '网络安全'
    if re.search(r'算法|机器学习|深度学习|nlp|自然语言|计算机.*视觉|推荐.*算法|搜索.*算法|强化.*学习|aigc|大模型|llm|chatgpt|gpt|bert|transformer|ai.*算法|ai.*工程', t_lower):
        if 'nlp' in t_lower or '自然语言' in t_lower:
            return 'NLP工程师'
        if 'aigc' in t_lower or '大模型' in t_lower or 'llm' in t_lower:
            return 'AI算法工程师'
        return '算法工程师'
    if re.search(r'数据分析|数据.*分析|商业.*分析|bi.*分析|经营.*分析|策略.*分析|业务.*分析|数据.*运营', t_lower):
        return '数据分析'
    if re.search(r'数据.*开发|大数据.*开发|数据.*工程|etl|数仓|数据.*仓库|hadoop|spark.*开发|flink.*开发|数据.*平台|数据.*架构', t_lower):
        return '数据开发'
    if re.search(r'产品经理|产品.*负责人|产品.*主管|产品.*总监|产品.*规划|ai.*产品|产品.*设计|互联网.*产品|b端.*产品|c端.*产品|平台.*产品|增长.*产品|策略.*产品', t_lower):
        return '产品经理'
    if re.search(r'ui.*设计|ui.*设计师|用户.*界面|gui.*设计|视觉.*设计|ui/ux|ux.*设计|交互.*设计|人机.*交互', t_lower):
        return 'UI设计师'
    if re.search(r'游戏.*开发|游戏.*程序|游戏.*服务端|游戏.*客户端|游戏.*引擎|unity|unreal|ue4|ue5|unreal.*engine|cocos.*creator|游戏.*前端|游戏.*后端|游戏.*服务端', t_lower):
        return '游戏开发'
    if re.search(r'游戏.*策划|游戏.*系统策划|游戏.*数值策划|游戏.*关卡策划|游戏.*文案策划|游戏.*战斗策划|游戏.*玩法策划', t_lower):
        return '游戏策划'
    if re.search(r'游戏.*运营|游戏.*社区|游戏.*客服|游戏.*gm|游戏.*活动.*运营|游戏.*版本.*运营|游戏.*用户.*运营', t_lower):
        return '游戏运营'
    if re.search(r'游戏.*原画|游戏.*场景.*设计|游戏.*角色.*设计|游戏.*概念.*设计|游戏.*美术|游戏.*2d|游戏.*3d.*模型|游戏.*动作.*设计|游戏.*特效.*设计|游戏.*材质|游戏.*地编|游戏.*gui.*设计|游戏.*道具.*设计', t_lower):
        return '游戏美术'
    if re.search(r'游戏.*主播|陪玩|游戏.*直播|电竞|电子竞技', t_lower):
        return '游戏主播'
    if re.search(r'游戏.*测试|游戏.*qa|游戏.*质量', t_lower):
        return '软件测试'
    if re.search(r'区块链|web3|智能合约|solidity|defi|nft|链上.*开发|web3.*开发|dapp', t_lower):
        return '区块链工程师'
    if re.search(r'产品.*运营|产品.*推广', t_lower):
        return '产品运营'
    if re.search(r'嵌入式.*软件|单片机|arm.*开发|stm32|freertos|rtos|mcu.*开发|linux.*驱动|底层.*开发|bios|firmware|固件.*开发|bootloader', t_lower):
        return '嵌入式开发'
    if re.search(r'自动化.*测试|测试.*自动化|自动化.*qa|selenium|appium|ui.*自动化|接口.*自动化|自动化.*测试.*开发', t_lower):
        return '自动化测试'
    if re.search(r'硬件.*测试|硬件.*qa|硬件.*质量|可靠性.*测试|emc.*测试|硬件.*验证|信号.*完整性', t_lower):
        return '硬件测试工程师'

    # Electrical/Automation
    if re.search(r'电气|电气.*工程|电气.*设计|电气.*工程师|电气.*技术', t_lower):
        return '电气工程师'
    if re.search(r'自动化|自动.*控制|自动.*化.*工程|自动化.*系统', t_lower):
        if 'plc' in t_lower: return 'PLC工程师'
        if '嵌入式' in t_lower or '单片机' in t_lower: return '嵌入式开发'
        return '自动化工程师'
    if re.search(r'plc|可编程.*逻辑|西门子|codesys|梯形图|scada|dcs|组态|工控.*软件', t_lower):
        return 'PLC工程师'
    if re.search(r'硬件|pcb|电路.*设计|pcb.*layout|电路板|电子.*硬件|fpga|cadence|altium|pads|cad.*电子|模拟.*电路|射频.*电路', t_lower):
        if 'fpga' in t_lower: return 'FPGA开发'
        return '硬件工程师'
    if re.search(r'电子.*工程|电子.*研发|电子.*技术|电子.*硬件', t_lower):
        return '电子工程师'
    if re.search(r'电力|变电|输电|配电|继电保护|发电|电网', t_lower):
        return '电力工程师'
    if re.search(r'通信|5g|射频|天线|基带|移动.*通信|无线.*通信|光通信|网络.*通信|通信.*协议', t_lower):
        return '通信工程师'
    if re.search(r'网络.*工程|网络.*运维|网络.*管理|网络.*安全|网络.*设备|交换机|路由器|防火墙|ccna|ccnp|ccie|hcie|网络.*配置', t_lower):
        if '安全' in t_lower: return '网络安全'
        return '网络工程师'
    if re.search(r'仪表|仪器|检测.*仪器|测量.*仪器|仪器.*仪表', t_lower):
        return '仪器仪表工程师'
    if re.search(r'机电|机电.*一体|机电.*工程', t_lower):
        return '机电工程师'
    if re.search(r'电工|装配.*电工|维修.*电工|弱电.*工程|强电.*工程|接线|电器.*维修|电气.*维修', t_lower):
        return '装配电工'

    # Medical
    if re.search(r'护士|护理|护师|护理.*主管|护士长|临床.*护理|专科.*护士|护工|陪护.*护士', t_lower):
        return '护士'
    if re.search(r'药剂|药师|药学|执业药师|药房|司药|调剂|药品.*管理|药学.*服务', t_lower):
        return '药剂师'
    if re.search(r'医药.*代表|医药.*销售|医药.*推广|医药.*信息|医药.*学术|药品.*推广|药品.*销售|otc.*代表|处方.*代表', t_lower):
        return '医药代表'
    if re.search(r'药品.*研发|药品.*注册|药品.*开发|制药.*研发|仿制药.*研发|新药.*研发|制剂.*研发|药物.*研发|药物.*分析|药物.*合成', t_lower):
        return '药品研发'
    if re.search(r'临床.*研究|临床.*试验|临床.*监察|cra|临床.*协调|crc|医学.*顾问|临床.*数据|医学.*支持|医学.*事务|上市.*后.*研究|临床.*项目|pv.*专员|药物.*警戒|药物.*安全', t_lower):
        return '临床研究员'
    if re.search(r'医疗器械.*销售|医疗器械.*推广|医疗器械.*代表|医疗器械.*维修|医疗器械.*售后|医疗设备.*销售|牙科.*设备|口腔.*设备|影像.*设备|ivd.*销售|ivd.*研发', t_lower):
        return '医疗器械销售'
    if re.search(r'健康.*管理|健康.*顾问|健康.*咨询|体检.*医生|体检.*护士|体检.*销售|健康.*讲师|健康.*培训|健康.*服务|慢病.*管理|健康.*管理师', t_lower):
        return '健康管理师'
    if re.search(r'医学.*检验|检验.*技师|医学.*实验|病理.*技师|检验.*科|临床.*检验|检验.*师', t_lower):
        return '医学检验师'
    if re.search(r'影像|超声|b超|彩超|放射|ct.*技师|mri.*技师|x.*光|放疗|核医学|pet.*ct', t_lower):
        return '医学影像师'
    if re.search(r'临床.*医师|医生|医师|内.*科.*医生|外.*科.*医生|儿科.*医生|妇产.*科.*医生|麻醉.*医生|急诊.*科.*医生|全科.*医生|家庭.*医生|住院.*医生|主治.*医师|副主任.*医师|主任.*医师', t_lower):
        return '临床医师'
    if re.search(r'中医|中医师|中医.*医生|中医.*内科|中医.*妇科|中医.*儿科|中医.*推拿|中医.*正骨|中医.*骨伤|中西医.*结合|中医.*理疗', t_lower):
        return '中医师'
    if re.search(r'针灸|推拿|推拿.*治疗|推拿.*技师|理疗|艾灸|拔罐|刮痧|正骨', t_lower):
        return '针灸推拿师'
    if re.search(r'康复|康复.*治疗|康复.*技师|康复.*训练|康复.*医学|运动.*康复|pt.*治疗|ot.*治疗|st.*治疗', t_lower):
        return '康复治疗师'
    if re.search(r'口腔.*护士|口腔.*助理|口腔.*医生|口腔.*医师|牙科.*护士|牙科.*助理|牙科.*医生|牙齿.*矫正|种植.*牙|口腔.*咨询', t_lower):
        if '护士' in t_lower: return '护士'
        if '医生' in t_lower or '医师' in t_lower: return '牙科医生'
        return '牙科医生'
    if re.search(r'验光|视光|眼镜.*店|配镜|眼科.*技师|视力.*矫正', t_lower):
        return '验光师'
    if re.search(r'兽医|宠物.*医生|宠物.*医院|动物.*医院|动物.*诊所|宠物.*医师|宠物.*医疗', t_lower):
        return '兽医'
    if re.search(r'公共卫生|预防.*医学|流调|流行病|疾控|防疫|卫生.*监督|院感', t_lower):
        return '公共卫生管理'

    # Finance/Accounting
    if re.search(r'会计|记账|财务.*核算|总账|成本.*会计|税务.*会计|应收.*会计|应付.*会计|费用.*会计|收入.*会计|结算.*会计|主办.*会计|会计.*助理|会计.*员|会计.*师|核算|记账.*员|代理.*记账|财务.*记账|会计.*文员', t_lower):
        return '会计'
    if re.search(r'出纳|资金.*管理|现金.*管理|资金.*专员', t_lower):
        return '出纳'
    if re.search(r'审计|内审|外审|审计.*助理|审计.*员|审计.*师|审计.*专员', t_lower):
        return '审计'
    if re.search(r'税务|税筹|税务.*专员|税务.*顾|税政|保税|申报.*税务|税务.*助理|税务.*经理', t_lower):
        return '税务专员'
    if re.search(r'风控|风险.*控制|风险.*管理|内控|内控.*管理|合规.*风控|操作.*风险|信用.*风险|市场.*风险|风险.*分析', t_lower):
        return '风控专员'
    if re.search(r'财务.*分析|财务.*管理|财务.*bp|资金.*分析|财务.*计划|fpa|fp&a', t_lower):
        return '财务分析'
    if re.search(r'财务.*经理|财务.*主管|财务.*总监|cfo|财务.*负责人', t_lower):
        return '财务经理'
    if re.search(r'投资.*分析|投资.*研究|行业.*研究|行业.*分析|证券.*分析|投资.*助理|投研|买方.*研究|卖方.*研究|研究员', t_lower):
        return '投资分析师'
    if re.search(r'基金.*经理|基金.*管理|投资.*经理|资产.*管理|私募|公募|基金.*投资|基金.*研究', t_lower):
        return '基金经理'
    if re.search(r'证券|券商|经纪.*业务|投行|投行业务|投行.*部|abs|债券|承销|承揽|保荐|ipo|上市.*顾问', t_lower):
        return '证券经纪人'
    if re.search(r'信贷|贷款|小微.*贷款|个贷|对公.*贷款|消费.*金融|授信|房贷|车贷|信用.*贷款|抵押.*贷款|担保.*贷款|贷前|贷中|贷后', t_lower):
        return '信贷管理'
    if re.search(r'保险|保险.*顾问|保险.*销售|保险.*经纪人|保险.*代理人|保险.*客服|保险.*理赔|保险.*产品|保险.*承保|保险.*核保|保险.*渠道|保险.*电销', t_lower):
        if '理赔' in t_lower or '核保' in t_lower: return '核保理赔'
        if '精算' in t_lower: return '保险精算师'
        return '保险顾问'
    if re.search(r'银行.*柜员|储蓄.*柜员|综合.*柜员|对公.*柜员', t_lower):
        return '银行柜员'
    if re.search(r'资产.*评估|估价|评估.*师|土地.*估价|房产.*估价|珠宝.*鉴定|珠宝.*评估|二手车.*评估|艺术品.*鉴定', t_lower):
        return '资产评估师'
    if re.search(r'融资|融资.*经理|融资.*专员|资金.*经理|资金.*主管|投后.*管理|投资.*关系', t_lower):
        return '融资经理'
    if re.search(r'理财|理财.*顾问|理财.*规划|理财.*经理|财富.*管理|财富.*顾问|私人.*银行|高净值|资产.*配置', t_lower):
        return '理财顾问'
    if re.search(r'催收|委外.*催收|电话.*催收|逾期.*催收|资产.*保全|贷后.*催收|账款.*催收', t_lower):
        return '信贷管理'

    # Education
    if re.search(r'教师|老师|任教|班主任|学科.*教师|校本.*教师|任课', t_lower):
        if '英语' in t_lower or '外语' in t_lower or '雅思' in t_lower or '托福' in t_lower or '外教' in t_lower: return '外语教师'
        if '数学' in t_lower: return '数学教师'
        if '语文' in t_lower: return '语文教师'
        if '物理' in t_lower: return '物理教师'
        if '化学' in t_lower: return '化学教师'
        if '美术' in t_lower or '绘画' in t_lower: return '美术教师'
        if '音乐' in t_lower or '钢琴' in t_lower or '乐器' in t_lower or '声乐' in t_lower: return '音乐教师'
        if '体育' in t_lower: return '体育教师'
        return '教师'
    if re.search(r'幼教|幼师|幼儿园.*老师|保育|早教|托班.*老师|蒙氏|蒙台梭利|学前教育', t_lower):
        return '幼教'
    if re.search(r'培训.*讲师|培训.*老师|企业.*培训|企业.*讲师|内训|培训导师|培训员|技能.*培训|认证.*培训', t_lower):
        return '培训讲师'
    if re.search(r'教务|教学.*管理|学习.*管理|学管师|学管|班主任|排课|教育.*管理|校区.*管理|教学.*督导', t_lower):
        return '教务管理'
    if re.search(r'课程.*顾问|招生.*顾问|教育.*咨询|学习.*规划|学业.*规划|升学.*规划|课程.*销售|续费.*顾问|电话.*招生', t_lower):
        return '课程顾问'
    if re.search(r'留学.*顾问|留学.*申请|留学.*文案|留学.*服务|海外.*留学|签证.*留学|留学.*规划|留学生.*服务|出国.*留学', t_lower):
        return '留学顾问'
    if re.search(r'托管|课后.*辅导|晚托|暑托|寒假.*托管|作业.*辅导|家庭.*辅导|家教|家庭.*教师|住家.*家教|家教.*老师', t_lower):
        if '家教' in t_lower or '住家' in t_lower: return '家教'
        return '教务管理'
    if re.search(r'课程.*设计|课程.*研发|教研|教学.*研发|课程.*开发|教学.*设计|课程.*内容|教案.*编写', t_lower):
        return '课程设计师'
    if re.search(r'心理.*咨询|心理.*医生|心理.*治疗|心理.*辅导|心理健康|心理.*顾问|心理健康.*老师', t_lower):
        return '心理咨询师'
    if re.search(r'书法|毛笔|硬笔|国画.*教学', t_lower):
        return '美术教师'
    if re.search(r'舞蹈.*老师|舞蹈.*教师|舞蹈.*培训|芭蕾|拉丁.*舞|街舞|现代.*舞|中国.*舞|民族.*舞', t_lower):
        return '音乐教师'

    # Architecture/Construction
    if re.search(r'建筑.*设计|建筑.*师|建筑.*方案|建筑.*设计师', t_lower):
        return '建筑设计师'
    if re.search(r'土木|土建|结构.*设计|结构.*工程师|结构.*分析|岩土|地基|桩基', t_lower):
        return '土木工程师'
    if re.search(r'室内.*设计|室内.*装饰|装修.*设计|装饰.*设计|软装|硬装|家装.*设计|全屋.*定制.*设计|衣柜.*设计|橱柜.*设计|家具.*设计|装潢', t_lower):
        return '室内设计师'
    if re.search(r'暖通|采暖|通风|空调.*设计|制冷|暖通.*设计', t_lower):
        return '暖通工程师'
    if re.search(r'给排水|给水|排水|水暖', t_lower):
        return '给排水工程师'
    if re.search(r'施工|施工.*管理|施工.*员|施工.*队长|施工现场|土建.*施工|装修.*施工|水.*施工|电.*施工|木工.*施工|瓦工', t_lower):
        return '施工员'
    if re.search(r'安全员|安全.*管理|安全.*工程|安全.*主管|安全.*总监|hse|ehs|安全.*监督|安全.*检查', t_lower):
        return '安全员'
    if re.search(r'监理|工程.*监理|监理.*员|监理.*工程师|专业.*监理', t_lower):
        return '工程监理'
    if re.search(r'预算|造价|造价.*员|造价.*工程师|工程量.*计算|工程.*造价|概预算|工程.*预算|投标.*预算|预结算|结算', t_lower):
        return '预算员'
    if re.search(r'资料|资料.*员|资料.*管理|工程.*资料|竣工.*资料|档案.*管理.*工程', t_lower):
        return '资料员'
    if re.search(r'测绘|测量|测量.*员|测量.*工程师|地籍.*测量|工程.*测量|地形.*测量|航测|遥感', t_lower):
        return '测绘工程师'
    if re.search(r'bim|revit|bim.*建模|bim.*工程师|bim.*经理', t_lower):
        return 'BIM工程师'
    if re.search(r'园林|景观|绿化|园建|园景|园艺.*设计|绿化.*养护|园艺.*师|花艺|绿植|庭院.*设计', t_lower):
        return '园林设计师'
    if re.search(r'房地产.*策划|房地产.*销售|置业.*顾问|房产.*销售|房产.*中介|楼盘.*销售|售楼.*顾问|案场.*销售', t_lower):
        return '房地产销售'
    if re.search(r'物业|物业.*管理|物业.*客服|物业.*经理|物业.*专员|物业.*主管|物业.*维修|写字楼.*管理|商场.*管理|园区.*管理', t_lower):
        return '物业管理员'

    # Manufacturing
    if re.search(r'机械.*设计|机械.*工程师|机械.*研发|机械.*结构|非标.*设计|非标.*机械|机械.*制图|机械.*技术', t_lower):
        return '机械工程师'
    if re.search(r'cnc|数控|加工.*中心|数控.*编程|数控.*加工|fanuc|三菱.*加工|精密.*加工|机加工', t_lower):
        return 'CNC工程师'
    if re.search(r'焊接|焊工|电焊|氩弧焊|二保焊|气保焊|激光.*焊|焊接.*技师', t_lower):
        return '焊接'
    if re.search(r'质检|检验|品管|品控|qc.*质检|质量.*检验|质量.*管理|来料.*检验|成品.*检验|巡检|首件.*检验|抽样.*检验|质量.*检测', t_lower):
        return '质检员'
    if re.search(r'设备.*维修|设备.*维护|设备.*管理|设备.*保养|生产.*设备|工厂.*设备|机械.*维修|动力.*设备', t_lower):
        return '设备工程师'
    if re.search(r'钳工|装配.*钳|工具.*钳|模具.*钳|修模.*钳', t_lower):
        return '钳工'
    if re.search(r'车工|铣工|磨工|镗工|刨工|线切割|电火花|抛光|研磨', t_lower):
        return 'CNC工程师'
    if re.search(r'冲压|铸造|锻造|模具.*设计|模具.*制造|注塑|压铸', t_lower):
        return '模具设计师'
    if re.search(r'装配|组装|流水线|操作工|普工|生产.*操作|车间.*操作|生产.*工人|技术.*工人|临时工|小时工', t_lower):
        return '操作工'
    if re.search(r'叉车|叉车.*司机|叉车.*工|铲车', t_lower):
        return '叉车工'
    if re.search(r'包装|打包|封箱|贴标|包装.*工|包装.*员', t_lower):
        return '包装工'
    if re.search(r'生产.*计划|pmc|物控|生产.*调度|排产|生产.*跟单|生产.*文员|生产.*助理', t_lower):
        return '生产计划PMC'
    if re.search(r'车间.*主任|生产.*主管|生产.*经理|班组长|厂长|生产.*总监|生产线.*长', t_lower):
        return '车间主任'
    if re.search(r'搬运|装卸|送货.*员|搬运.*工|装卸.*工|跟车|押货', t_lower):
        return '搬运工'

    # Sales/Marketing
    if re.search(r'销售|销售.*代表|销售.*专员|销售.*经理|销售.*总监|销售.*主管|销售.*助理|销售.*顾问|销售.*员|销售.*业务|销售.*营业员|导购|营业员|客户.*代表', t_lower):
        if '电话' in t_lower: return '电话销售'
        if '大客户' in t_lower or 'ka' in t_lower or 'tob' in t_lower or 'to b' in t_lower: return '大客户销售'
        if '外贸' in t_lower or '国际' in t_lower: return '外贸业务员'
        if '渠道' in t_lower: return '渠道销售'
        if '招商' in t_lower: return '招商'
        if '区域' in t_lower or '城市' in t_lower or '省区' in t_lower: return '销售经理'
        if '门店' in t_lower or '店面' in t_lower or '专柜' in t_lower or '柜台' in t_lower: return '销售代表'
        return '销售代表'
    if re.search(r'电话.*销售|电销|电话.*业务|电话.*客服|外呼|电话.*营销|电话.*邀约|坐席', t_lower):
        return '电话销售'
    if re.search(r'市场.*专员|市场.*推广|市场.*助理|市场营销|市场.*拓展|地推|市场.*督导|线下.*推广|推广.*专员', t_lower):
        return '市场专员'
    if re.search(r'商务.*专员|商务.*经理|商务.*助理|商务.*拓展|bd.*专员|bd.*经理|商务.*代表|商务.*谈判|bd.*销售', t_lower):
        return '商务专员'
    if re.search(r'外贸|外贸.*业务|外贸.*跟单|国际贸易|国贸|海外.*销售|海外.*业务|外销|跨境电商.*销售|amazon|亚马逊.*运营|速卖通|ebay|lazada|shopee|独立站.*运营|跨境.*运营', t_lower):
        return '外贸业务员'
    if re.search(r'品牌.*策划|品牌.*推广|品牌.*宣传|品牌.*营销|品牌.*运营|品牌.*管理|品牌.*专员|公关|pr.*专员|媒体.*关系|品牌.*经理', t_lower):
        return '品牌策划'
    if re.search(r'活动.*策划|活动.*执行|活动.*运营|会展|展会|会议.*策划|庆典|路演|发布会|活动.*专员', t_lower):
        return '活动策划'
    if re.search(r'新媒体|自媒体|公众号|内容.*运营|小红书.*运营|抖音.*运营|快手.*运营|知乎.*运营|微博.*运营|b站.*运营|内容.*创作', t_lower):
        if '直播' in t_lower: return '直播运营'
        return '新媒体运营'
    if re.search(r'社群.*运营|社区.*运营|微信.*运营|私域|私域.*运营|粉丝.*运营', t_lower):
        return '社群运营'
    if re.search(r'直播|主播|带货|直播.*带货|才艺.*直播|娱乐.*直播|电商.*直播|直播.*运营|直播.*场控', t_lower):
        if '运营' in t_lower or '场控' in t_lower: return '直播运营'
        if '带货' in t_lower: return '带货主播'
        return '主播'
    if re.search(r'客服|客户.*服务|售后|售前|咨询.*热线|呼叫.*中心|热线.*客服|在线.*客服|电话.*客服|投诉.*处理|工单.*处理|客服.*主管|客服.*经理', t_lower):
        if '售前' in t_lower: return '售前客服'
        if '售后' in t_lower: return '售后客服'
        if '电话' in t_lower: return '电话客服'
        return '客服专员'

    # Logistics
    if re.search(r'物流|物流.*专员|物流.*操作|物流.*助理|物流.*管理|物流.*文员|运输.*管理|货运.*代理|货代|国际.*货运', t_lower):
        return '物流专员'
    if re.search(r'仓库|仓储|库管|库房|仓库.*管理|仓库.*员|仓管.*员|库存.*管理|理货|货架.*管理|出入库|盘点', t_lower):
        return '仓储管理'
    if re.search(r'采购|采购.*员|采购.*助理|采购.*工程师|采购.*管理|供应链.*采购|sourcing|buyer|procurement|战略.*采购', t_lower):
        return '采购专员'
    if re.search(r'司机|驾驶员|司机.*师傅|货运.*司机|货车.*司机|班车.*司机|行政.*司机|网约车|出租车|代驾|c1.*司机|b2.*司机|大货车|集装箱.*司机|危化品.*司机', t_lower):
        return '物流司机'
    if re.search(r'快递|快递.*员|配送.*员|外卖.*员|骑手|送餐.*员|配送.*骑手|即时.*配送|闪送|跑腿', t_lower):
        return '快递员'
    if re.search(r'分拣|分拣.*员|打包.*员|拣货.*员|复核.*员|扫描.*员|理货.*员|配货.*员|发货.*员', t_lower):
        return '仓库管理员'
    if re.search(r'调度|调度.*员|车辆.*调度|运输.*调度|物流.*调度|派单', t_lower):
        return '调度员'
    if re.search(r'单证|单证.*员|报关|报关.*员|报检|报检.*员|信用证|原产地证|通关', t_lower):
        return '报关员'

    # Media/Design
    if re.search(r'平面.*设计|平面.*设计师|海报.*设计|画册.*设计|vi.*设计|logo.*设计|品牌.*设计|版式.*设计|书籍.*设计|印前|排版.*设计', t_lower):
        return '平面设计师'
    if re.search(r'视频.*剪辑|视频.*编辑|视频.*制作|短视频.*剪辑|后期.*剪辑|影视.*剪辑|视频.*后期|剪辑.*师|剪辑.*员|视频.*处理|视频.*包装|ae.*特效|pr.*剪辑|final.*cut|达芬奇|剪映', t_lower):
        return '视频编辑'
    if re.search(r'文案|文案.*编辑|文案.*策划|文案.*写作|文案.*专员|公众号.*文案|广告.*文案|创意.*文案|内容.*文案|小红书.*文案|品牌.*文案|新媒体.*文案', t_lower):
        return '文案策划'
    if re.search(r'摄影|摄像|摄影师|摄像师|拍照|棚拍|外景.*拍摄|产品.*拍摄|商业.*摄影|写真.*摄影|儿童.*摄影|婚纱.*拍摄|旅拍', t_lower):
        return '摄影师'
    if re.search(r'插画|插画.*师|手绘|商业.*插画|绘本|漫画|原画|概念.*设计|角色.*设计.*原画|场景.*原画', t_lower):
        if '原画' in t_lower: return '原画师'
        return '插画师'
    if re.search(r'3d|三维|建模|3d.*建模|3d.*设计|三维.*建模|maya|blender|zbrush|3ds.*max|substance', t_lower):
        return '3D设计师'
    if re.search(r'动画|动画.*师|动画.*设计|动漫|motion.*graphic|mg.*动画|flash.*动画|spine.*动画|动作.*设计|骨骼.*绑定|动画.*制作', t_lower):
        return '动画师'
    if re.search(r'ui.*设计|ui.*设计师|用户.*界面|gui.*设计|交互.*设计|ux.*设计|人机.*交互', t_lower):
        return 'UI设计师'
    if re.search(r'编辑|编辑.*记者|内容.*编辑|文字.*编辑|出版.*编辑|新媒体.*编辑|网站.*编辑|频道.*编辑|专栏.*编辑|校对|审稿|采编', t_lower):
        return '编辑'
    if re.search(r'导演|编导|栏目.*导演|节目.*导演|影视.*导演|电视.*导演|短视频.*编导|节目.*编导|mcn.*编导|内容.*编导', t_lower):
        return '导演/编导'
    if re.search(r'翻译|英语.*翻译|日语.*翻译|韩语.*翻译|法语.*翻译|德语.*翻译|西班牙语.*翻译|口译|笔译|译员|本地化.*翻译|同声.*传译', t_lower):
        return '翻译'
    if re.search(r'广告.*创意|创意.*总监|美术.*指导|广告.*策划|广告.*文案|创意.*策划|创意.*设计|广告.*设计|digital.*创意', t_lower):
        return '广告创意'
    if re.search(r'服装.*设计|服装.*设计师|时装.*设计|服饰.*设计|童装.*设计|男装.*设计|女装.*设计|内衣.*设计|配饰.*设计|制版|打版|服装.*制版|样衣|版师', t_lower):
        return '服装设计师'
    if re.search(r'工业.*设计|产品.*设计|产品.*外观|id.*设计|结构.*设计.*产品|rhino|creo|solidworks.*设计', t_lower):
        return '工业设计师'
    if re.search(r'美工|美工.*设计|网店.*美工|淘宝.*美工|电商.*设计|电商.*美工|修图|修图师|精修|照片.*后期|人像.*后期', t_lower):
        return '美工'
    if re.search(r'音频.*编辑|录音|音频.*制作|音频.*处理|混音|配音|广播.*编辑|有声.*书|音频.*后期', t_lower):
        return '录音/配音'

    # New industry categories
    # Legal
    if re.search(r'法律|法务|律师|合规|律所|法律.*顾问|法诉|仲裁|知识产权|专利.*代理人|商标|职务.*发明|版权|法务.*经理|法务.*专员|法务.*主管|合同.*审核|合同.*管理|风险.*合规|诉讼|尽调|尽调.*专员|反垄断|数据.*合规|数据.*隐私', t_lower):
        return '法务专员'

    # HR/Admin
    if re.search(r'行政|前台|秘书|文员|总务|后勤|办公室.*管理|行政.*助理|行政.*专员|行政.*主管|行政.*经理|行政.*总监|前台.*接待|前台.*文员|前台.*行政|公司.*前台|综合.*管理|综合.*文员|总助|总裁.*助理|总经理.*助理|董事长.*助理|董事长.*秘书|老板.*助理', t_lower):
        return '行政专员'
    if re.search(r'人事|人力|人力资源|hr|hrbp|人事.*专员|人事.*行政|人事.*助理|人事.*主管|招聘|招聘.*专员|招聘.*主管|薪资|薪酬|绩效|绩效.*专员|绩效考核|员工.*关系|培训.*专员|入职.*办理|社保.*专员|公积金.*专员|档案.*管理.*人事|劳动关系|劳动合同', t_lower):
        if '招聘' in t_lower: return '招聘专员'
        if '薪酬' in t_lower or '薪资' in t_lower or '绩效' in t_lower: return '薪酬专员'
        if '培训' in t_lower: return '培训专员'
        if '劳动关系' in t_lower or '劳动合同' in t_lower: return '劳动关系专员'
        if 'hrbp' in t_lower: return 'HRBP'
        return '人事专员'

    # Security/Property
    if re.search(r'保安|门卫|巡逻|安保|安防|消防.*控制|消防.*中控|监控.*员|监控.*值班|秩序.*维护|秩序.*员|安管|安管.*员|安全.*防范|报警.*中心|消控|消控.*员|安全.*巡视', t_lower):
        return '保安'

    # Food service
    if re.search(r'厨师|烹饪|帮厨|厨工|面点|面点.*师|烘焙|烘培|面包|蛋糕.*师|裱花|咖啡师|咖啡.*制作|调酒|调酒.*师|奶茶|奶茶.*制作|茶饮|茶饮.*师|餐厅.*经理|餐厅.*主管|餐饮.*经理|餐饮.*管理|后厨|配菜|切配|切菜|打荷|上什|烧腊|冷菜|凉菜|蒸菜|灶台|炒锅|日料|日式.*料理|西餐|中餐|粤菜|川菜|湘菜|本帮菜|小吃|烧烤|铁板烧|刺身|寿司|洗碗|洗碗.*工|洗碗.*阿姨|传菜|传菜.*员|服务员|餐饮.*服务|迎宾|领位|咨客|吧员|吧台', t_lower):
        if '厨师' in t_lower or '烹饪' in t_lower or '炒锅' in t_lower or '灶台' in t_lower: return '厨师'
        if '面点' in t_lower: return '面点师'
        if '烘焙' in t_lower or '烘培' in t_lower or '面包' in t_lower: return '烘焙师'
        if '咖啡' in t_lower: return '咖啡师'
        if '调酒' in t_lower: return '调酒师'
        if '奶茶' in t_lower or '茶饮' in t_lower: return '奶茶店员'
        if '洗碗' in t_lower: return '洗碗工'
        if '配菜' in t_lower or '切配' in t_lower or '切菜' in t_lower: return '配菜员'
        if '帮厨' in t_lower or '厨工' in t_lower: return '帮厨'
        if '传菜' in t_lower: return '服务员'
        return '服务员'

    # Home services
    if re.search(r'保洁|清洁|打扫|家政|保姆|月嫂|育婴|育儿|育儿.*嫂|护工|护理.*老人|养老.*护理|养老.*护理员|收纳|整理.*师|家电.*清洗|除螨|钟点工|小时工.*保洁|家庭.*管家|私人.*管家|生活.*管家|月子.*中心|月子.*护理|产康|产后.*康复', t_lower):
        if '保洁' in t_lower or '清洁' in t_lower or '打扫' in t_lower: return '保洁'
        if '保姆' in t_lower: return '保姆'
        if '月嫂' in t_lower or '月子' in t_lower or '产康' in t_lower: return '月嫂'
        if '护工' in t_lower or '护理.*老人' in t_lower or '养老' in t_lower: return '护工'
        if '收纳' in t_lower or '整理' in t_lower: return '收纳师'
        if '家电.*清洗' in t_lower or '除螨' in t_lower: return '家电清洗师'
        return '保洁'

    # Beauty/Wellness
    if re.search(r'美容|美容.*师|美发|美发.*师|发型|发型.*师|理发|理发.*师|美甲|美甲.*师|化妆|化妆.*师|造型|造型.*师|美睫|美睫.*师|纹绣|纹眉|半永久|皮肤.*管理|皮肤.*管理师|医美|医美.*顾问|医美.*咨询|光电.*操作|脱毛|spa|spa.*技师|养生|养生.*技师|按摩|按摩.*师|足疗|足疗.*师|足浴|采耳|采耳.*师|艾灸|艾灸.*师|拔罐|刮痧|理疗|理疗.*师|推拿|推拿.*师|香薰', t_lower):
        if '美发' in t_lower or '发型' in t_lower or '理发' in t_lower: return '美发师'
        if '美甲' in t_lower: return '美甲师'
        if '化妆' in t_lower or '造型' in t_lower: return '化妆师'
        if '美睫' in t_lower: return '美睫师'
        if '纹绣' in t_lower or '纹眉' in t_lower: return '纹绣师'
        if '皮肤.*管理' in t_lower or '医美' in t_lower: return '皮肤管理师'
        if 'spa' in t_lower: return 'SPA技师'
        if '按摩' in t_lower or '推拿' in t_lower: return '按摩师'
        if '足疗' in t_lower or '足浴' in t_lower: return '足疗师'
        if '采耳' in t_lower: return '采耳师'
        if '养生' in t_lower: return '养生技师'
        return '美容师'

    # Hotels/Travel
    if re.search(r'酒店.*前台|酒店.*接待|酒店.*管家|酒店.*经理|酒店.*主管|酒店.*销售|前台.*接待.*酒店|前厅.*经理|前厅.*主管|前厅.*接待|礼宾|门童|行李.*员|客房.*服务员|客房.*主管|pa.*保洁|公共区域.*保洁|酒店.*维修|酒店.*安保', t_lower):
        if '前台' in t_lower or '接待' in t_lower or '礼宾' in t_lower: return '酒店前台'
        if '客房' in t_lower: return '客房服务员'
        return '酒店前台'
    if re.search(r'导游|旅游.*顾问|旅游.*策划|旅游.*销售|旅行.*顾问|旅行社|地接|全陪|出境.*领队|签证.*专员|签证.*顾问|票务|机票.*操作|计调|旅游.*计调|旅游.*产品|旅游.*规划|景区.*管理|景区.*运营|景区.*讲解|民宿.*管家|民宿.*前台|民宿.*运营', t_lower):
        if '导游' in t_lower or '领队' in t_lower: return '导游'
        if '签证' in t_lower: return '签证专员'
        if '票务' in t_lower or '机票' in t_lower: return '票务员'
        if '计调' in t_lower: return '旅游计调'
        if '民宿' in t_lower: return '民宿管家'
        return '导游'

    # Sports/Fitness
    if re.search(r'健身.*教练|健身.*顾问|健身.*指导|健身.*主管|私教|私人.*教练|体能.*教练|体适能|力量.*教练|搏击.*教练', t_lower):
        return '健身教练'
    if re.search(r'瑜伽|瑜伽.*老师|瑜伽.*教练|瑜伽.*导师', t_lower):
        return '瑜伽老师'
    if re.search(r'游泳.*教练|游泳.*老师|游泳.*救生|救生.*员|水上.*运动.*教练', t_lower):
        return '游泳教练'

    # Agriculture
    if re.search(r'农业|农艺|农技|种植|农业.*技术|农业.*员|农业.*推广|农业.*销售|农业.*管理|农业.*科研|农业.*服务|农作物|大田.*种植|蔬菜.*种植|果树.*种植|茶叶.*种植|中药材.*种植|菌类.*种植|花卉.*种植|苗圃|育苗|种子|育种|种业|农业.*机械|农机', t_lower):
        return '农业技术员'
    if re.search(r'养殖|畜牧|畜牧.*师|养猪|养鸡|养牛|养羊|水产.*养殖|渔业|渔业.*技术|渔场|鱼塘|虾塘|贝类.*养殖|特种.*养殖|兽医|兽医.*技术|动物.*营养|饲料|饲料.*销售|饲料.*研发|预混料|动保|兽药|动物.*保健', t_lower):
        if '兽医' in t_lower: return '兽医'
        if '饲料' in t_lower: return '饲料销售'
        return '养殖技术员'
    if re.search(r'林业|森林|林木|造林|抚育|湿地|自然.*保护|护林|林场', t_lower):
        return '林业技术员'
    if re.search(r'农药|化肥|农药.*销售|肥料.*销售|农业.*投入品|植保|植保.*员|农资|农资.*销售', t_lower):
        return '农药销售'

    # New Energy
    if re.search(r'新能源|光伏|太阳能|风电|风力.*发电|储能|锂电池|锂电|动力.*电池|磷酸铁锂|三元.*电池|钠离子.*电池|固态.*电池|氢能|燃料电池|充电桩|充电.*站|换电|生物质|地热|潮汐.*能', t_lower):
        if '光伏' in t_lower or '太阳能' in t_lower: return '光伏工程师'
        if '风电' in t_lower or '风力' in t_lower: return '风电工程师'
        if '储能' in t_lower: return '储能工程师'
        if '锂电' in t_lower or '电池' in t_lower: return '锂电工程师'
        return '新能源销售'

    # Chemical
    if re.search(r'化工|化学.*工程|化学.*分析|化学.*实验|化学.*检验|化妆品.*研发|化妆品.*配方|涂料|橡胶|塑料.*工程|高分子|日化|日化.*研发|试剂|化学.*合成|有机.*合成|制药.*工程|化工.*工艺|精细.*化工|石油.*化工', t_lower):
        if '化妆品' in t_lower: return '化妆品研发'
        if '涂料' in t_lower: return '涂料工程师'
        if '化学.*分析' in t_lower or '实验' in t_lower or '检验' in t_lower: return '化学分析员'
        return '化工工程师'

    # Entertainment
    if re.search(r'演员|艺人|练习生|歌手|模特|群演|特约.*演员|配音.*演员|声优|舞者|舞蹈.*演员|乐队|艺人.*助理|艺人.*经纪|经纪.*人|演出.*经纪|选角|casting|剧组.*场务|舞台.*监督|制片.*助理|制片.*主任|执行.*制片|编剧|剧本|综艺.*导演|综艺.*编剧|娱乐.*法务', t_lower):
        if '导演' in t_lower: return '导演'
        if '编剧' in t_lower: return '编剧'
        if '演员' in t_lower or '艺人' in t_lower or '歌手' in t_lower or '模特' in t_lower or '群演' in t_lower or '舞者' in t_lower: return '演员'
        if '经纪' in t_lower or 'casting' in t_lower: return '经纪人'
        if '制片' in t_lower: return '制片人'
        return '演员'

    # Automotive
    if re.search(r'汽车.*销售|4s.*店|汽车.*顾问|汽车.*维修|汽修|汽车.*修理|汽车.*电工|汽车.*钣金|汽车.*喷漆|汽车.*美容|洗车|汽车.*装潢|汽车.*改装|二手车|二手车.*销售|二手车.*评估|二手车.*鉴定|车险|车险.*理赔|车险.*销售|汽车.*保险|汽车.*检测|汽车.*保养|汽车.*机修|轮胎.*工|四轮.*定位|汽车.*配件|汽车.*售后|事故.*车|查勘|定损', t_lower):
        if '销售' in t_lower or '顾问' in t_lower: return '汽车销售'
        if '维修' in t_lower or '汽修' in t_lower or '机修' in t_lower: return '汽车维修工'
        if '美容' in t_lower or '洗车' in t_lower: return '汽车美容师'
        if '二手车' in t_lower: return '二手车评估师'
        if '钣金' in t_lower: return '钣金工'
        if '喷漆' in t_lower: return '喷漆工'
        if '车险' in t_lower or '查勘' in t_lower or '定损' in t_lower: return '车险理赔'
        return '汽车维修工'

    # Environmental
    if re.search(r'环保|环境.*工程|环境.*检测|环境.*监测|污水|废水.*处理|水处理|给水.*处理|净水|中水.*回用|固废|固体.*废物|危险.*废物|大气.*治理|废气.*处理|除尘|脱硫|脱硝|碳.*排放|碳.*中和|碳.*达峰|碳.*交易|碳.*资产管理|环境影响.*评价|环评|环评.*工程师|环境.*咨询|环境.*管理|环境.*体系|清洁.*生产|节能|节能.*评估|绿色.*建筑|LEED|ESG|可持续', t_lower):
        if '环评' in t_lower or '环境影响' in t_lower: return '环评工程师'
        if '碳' in t_lower or 'esg' in t_lower: return '碳排放管理员'
        return '环保工程师'

    # Consulting
    if re.search(r'咨询|管理.*咨询|战略.*咨询|it.*咨询|技术.*咨询|人力.*咨询|财务.*咨询|猎头|猎头.*顾问|人才.*顾问|认证.*咨询|体系.*认证|iso.*认证|验厂.*咨询|移民.*顾问|海外.*移民|出国.*咨询|婚恋|婚介|红娘|婚恋.*顾问|相亲|婚恋.*咨询|匹配.*师|金融.*顾问|理财.*顾问|保险.*顾问', t_lower):
        if '猎头' in t_lower: return '猎头顾问'
        if '保险' in t_lower: return '保险顾问'
        if '婚恋' in t_lower or '婚介' in t_lower or '红娘' in t_lower: return '婚恋顾问'
        if '移民' in t_lower: return '移民顾问'
        return '咨询顾问'

    # Quality/Inspection
    if re.search(r'质检|质量.*检验|化验|化验.*员|检测.*工程师|认证.*审核|体系.*审核|iso.*审核|品控|品质.*控制|试验.*员|实验.*员.*检测|无损.*检测|无损.*探伤|ndt|rt.*检测|ut.*检测|mt.*检测|pt.*检测|计量|计量.*员|校准|校验|黄金.*检测|珠宝.*检测|贵金属.*检测', t_lower):
        if '无损' in t_lower or 'ndt' in t_lower: return '无损检测员'
        if '化验' in t_lower: return '化验员'
        if '计量' in t_lower: return '计量员'
        return '质检员'

    # Customer service
    if re.search(r'客服|客户.*服务|热线|呼叫.*中心|400.*客服|微信.*客服|淘宝.*客服|天猫.*客服|京东.*客服|拼多多.*客服|在线.*客服|电话.*客服|语音.*客服|投诉.*处理|投诉.*专员|回访|满意度.*调查|客服.*主管|客服.*经理|客服.*组长|vip.*客服|大客户.*客服', t_lower):
        if '电话' in t_lower or '热线' in t_lower or '呼叫' in t_lower or '400' in t_lower: return '电话客服'
        if '售后' in t_lower: return '售后客服'
        if '售前' in t_lower: return '售前客服'
        if '投诉' in t_lower: return '投诉处理专员'
        if '在线' in t_lower or '微信' in t_lower or '淘宝' in t_lower or '天猫' in t_lower or '京东' in t_lower: return '在线客服'
        return '客服专员'

    # Clothing/Textile
    if re.search(r'服装|时装|成衣|纺织|面料|布料|样衣|裁缝|车工.*服装|缝纫|缝纫.*工|针织|毛织|制衣|童装|女装|男装|内衣|婚纱|礼服|运动.*服装|户外.*服装|羽绒服|皮草|皮革|裘皮|制版|打版|版师|推档|放码|排料|裁剪|成衣.*跟单|服装.*跟单|面料.*采购|面料.*开发|服装.*qc|服装.*质检|跟单.*员|qc.*跟单', t_lower):
        if '跟单' in t_lower: return '跟单员'
        if '打版' in t_lower or '制版' in t_lower or '版师' in t_lower: return '服装打版师'
        if '缝纫' in t_lower or '车工' in t_lower or '裁缝' in t_lower: return '缝纫工'
        if '设计' in t_lower: return '服装设计师'
        return '服装设计师'

    return None


# Apply matching
new_synonym_count = 0
for title, cnt in unclassified:
    if title in existing_titles:
        continue
    if title in existing_syns:
        continue

    std = match_title(title)
    if std and std in existing_titles:
        all_synonyms[title] = std
        new_synonym_count += 1

print(f"New synonyms generated: {new_synonym_count}")

# Count what's still unmatched
still_unmatched = [(t, c) for t, c in unclassified
                   if t not in existing_titles and t not in existing_syns and t not in all_synonyms]
print(f"Still unmatched after all rules: {len(still_unmatched)} titles, {sum(c for _,c in still_unmatched)} records")

# Show top unmatched
print("\n=== TOP 50 STILL UNMATCHED ===")
for i, (title, cnt) in enumerate(sorted(still_unmatched, key=lambda x: -x[1])[:50]):
    print(f"{i+1}. [{cnt}] {title}")

# Write SQL
sql_file = 'D:/study/实验_提交版/scripts/category_synonym_updates.sql'
with open(sql_file, 'w', encoding='utf-8') as f:
    f.write("-- ==========================================\n")
    f.write("-- Category & Synonym Updates\n")
    f.write(f"-- Generated: {len(all_sql)} category inserts, {len(all_synonyms)} synonym inserts\n")
    f.write("-- ==========================================\n\n")

    f.write("-- 1. New & Extended Categories\n")
    for line in all_sql:
        f.write(line + '\n')

    f.write(f"\n-- 2. Synonyms ({len(all_synonyms)} rows)\n")
    f.write("INSERT INTO synonym_dict (raw_word, std_word) VALUES\n")
    values = []
    for raw, std in all_synonyms.items():
        safe_raw = raw.replace("'", "\\'").replace('\\', '\\\\')
        safe_std = std.replace("'", "\\'").replace('\\', '\\\\')
        values.append(f"('{safe_raw}', '{safe_std}')")
    f.write(",\n".join(values) + ";\n")

print(f"\nSQL written to: {sql_file}")
print(f"Total SQL statements: {len(all_sql)} categories + {len(all_synonyms)} synonyms")
conn.close()
