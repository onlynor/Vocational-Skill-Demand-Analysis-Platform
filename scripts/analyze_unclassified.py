# coding: utf-8
"""
Analyze all unclassified job titles and build:
1. Synonym mappings for titles that match existing categories
2. New industry categories where needed
Output: SQL ready to execute
"""
import pymysql, os, re
from collections import defaultdict, Counter

# Load env
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

# Load all existing data
cur.execute('SELECT id, name, parent_id FROM job_category ORDER BY id')
cats = cur.fetchall()
existing_titles = {r[1] for r in cats}  # all category names
parent_ids = {r[1]: r[0] for r in cats if r[2] is None}  # industry name -> id

cur.execute('SELECT raw_word, std_word FROM synonym_dict')
existing_syns = {r[0]: r[1] for r in cur.fetchall()}

# Get unclassified titles
cur.execute("SELECT title, COUNT(*) as cnt FROM cleaned_jobs WHERE category_id IS NULL GROUP BY title ORDER BY cnt DESC")
unclassified = cur.fetchall()

print(f"Total unclassified unique titles: {len(unclassified)}")
print(f"Total unclassified records: {sum(c for _,c in unclassified)}")

# -----------------------------------------------------------
# STEP 1: Build comprehensive keyword->standard_title mapping
# for existing categories
# -----------------------------------------------------------

# Define standard job titles for each existing industry
# These should match EXACTLY the names in job_category table
existing_standards = {
    # 计算机/互联网
    'Python开发': ['python开发', 'Python开发工程师', 'python工程师', 'python后端', 'python程序员', 'python实习生', 'Python开发实习生', 'python软件开发', 'Python/Python开发', 'Python数据分析', 'Python开发人员'],
    'Java开发': ['java', 'JAVA', 'Java', 'java开发', 'java后端', 'java开发工程师', 'JAVA开发', 'JAVA开发工程师', 'java程序员', 'java后端开发工程师', 'Java开发工程师', '高级java开发', '高级java后端开发工程师', 'java工程师', 'java开发实习生', 'java实习生', 'java后端开发', 'java后端开发工程师', 'java软件工程师', 'java高级开发工程师', 'Java后端开发', 'java后端开发工程', 'JAVA开发工程题', 'Java开发工程', 'J2EE', 'j2ee', 'java软件', 'Java工程师', 'Java开发人员', 'JAVA工程师'],
    '前端开发': ['前端', '前端工程师', '前端开发工程师', 'web前端', 'Web前端', 'WEB前端', '前端程序员', '前端实习生', '前端开发实习生', 'vue前端', 'react前端', '前端开发人员'],
    '后端开发': ['后端', '后端工程师', '后端开发工程师', '后台开发', '后端程序员', '服务端开发'],
    '全栈开发': ['全栈', '全栈工程师', '全栈开发工程师', 'java全栈', 'Java全栈', 'Java全栈开发', 'java全栈开发', 'Java全栈工程师', 'JAVA全栈', '全栈开发人员'],
    'C++开发': ['c++', 'C++', 'c++开发', 'C++开发工程师', 'c++工程师', 'C++程序员', 'c/c++开发'],
    'Golang开发': ['golang', 'Golang', 'go开发', 'Go开发', 'go语言', 'golang开发工程师'],
    'PHP开发': ['php', 'PHP', 'php开发', 'PHP开发工程师'],
    '.NET开发': ['.net', '.NET', '.net开发', 'NET开发'],
    'Node.js开发': ['node', 'nodejs', 'Node', 'node.js开发'],
    'Android开发': ['android', 'Android', '安卓开发', 'android开发'],
    'iOS开发': ['ios', 'iOS', 'ios开发', '苹果开发'],
    '鸿蒙开发': ['鸿蒙'],
    '软件测试': ['软件测试工程师', '功能测试', '测试工程师', '测试', '游戏测试', '游戏测试工程师', '软件测试师', '测试实习生', '软件质量', '测试员'],
    '测试开发': ['测试开发工程师', '自动化测试工程师', '自动化测试', '测试开发人员'],
    '运维工程师': ['运维', '运维开发', '系统运维', 'linux运维', 'Linux运维', '应用运维', '运维实习生'],
    'DBA': ['dba', '数据库管理员'],
    '网络安全': ['网络安全', '安全工程师', '信息安全', '渗透测试', '安全开发'],
    '算法工程师': ['算法', '算法实习生', '视觉算法', '推荐算法', '搜索算法', '机器学习', '深度学习', 'NLP算法', '算法研究员'],
    'NLP工程师': ['nlp', '自然语言处理', 'NLP算法工程师'],
    '数据分析': ['数据分析师', '数据分析实习生', '商业分析', '数据分析专家', '数据分析员', '数据分析岗', '经营分析'],
    '数据开发': ['数据开发', '大数据开发', '数据仓库', 'ETL工程师', '大数据工程师', '数据工程师'],
    '产品经理': ['产品', '产品助理', '产品实习生', '产品专员', 'AI产品经理', '产品运营', '产品总监', '产品负责人'],
    'UI设计师': ['ui设计', 'UI设计', 'UI设计师', 'ui设计师', '视觉设计', 'GUI设计'],
    '游戏开发': ['游戏开发工程师', '游戏程序员', '游戏后端', '游戏前端'],
    '区块链工程师': ['区块链', 'web3', 'Web3', '智能合约'],
    'AI算法工程师': ['AI算法', 'AIGC算法', '大模型算法', 'ai算法', 'AIGC', '大模型', 'AI工程师'],

    # 电气/自动化
    '电气工程师': ['电气', '电气设计', '电气技术员', '电气工程', '电气自动化'],
    '自动化工程师': ['自动化', '自动化技术员'],
    'PLC工程师': ['plc', 'PLC', 'PLC工程师', 'plc电气'],
    '嵌入式开发': ['嵌入式', '嵌入式软件', '嵌入式linux', '单片机', 'arm'],
    '硬件工程师': ['硬件', '硬件开发', '硬件设计', '硬件测试'],
    '电子工程师': ['电子', '电子技术', '电子研发'],
    'FPGA开发': ['fpga', 'FPGA'],
    '单片机工程师': ['单片机开发', 'STM32', 'stm32'],
    '驱动开发': ['驱动', 'BSP'],
    'PCB工程师': ['pcb', 'PCB设计', 'pcb设计'],
    '集成电路IC设计': ['IC设计', 'IC验证', '模拟IC', '数字IC', '版图设计'],
    '机电工程师': ['机电', '机电一体'],
    '电力工程师': ['电力', '电力系统', '电力设计'],
    '通信工程师': ['通信', '5G', '通信协议'],
    '网络工程师': ['网络', '网络运维', '网管', '网络管理员'],
    'FAE工程师': ['fae', 'FAE', '现场应用'],
    '仪器仪表工程师': ['仪表', '仪器'],
    '装配电工': ['装配电工', '电工', '电气装配'],

    # 医学/医疗
    '护士': ['护理', '护士长'],
    '药剂师': ['药师', '药剂', '执业药师'],
    '医药代表': ['医药信息沟通', '医药学术', '医药销售'],
    '药品研发': ['药品注册', '制药'],
    '临床研究员': ['临床协调', '临床监查', 'CRA', 'CRC', 'cra'],
    '医疗器械销售': ['医疗器械', '医疗设备', '器械销售'],
    '健康管理师': ['健康管理', '健康顾问'],

    # 金融/会计
    '会计': ['会计员', '主办会计', '总账会计', '会计助理', '核算会计', '记账会计', '收入会计', '费用会计', '成本会计', '结算会计', '往来会计', '财务会计', '全盘会计', '记账', '代理记账', '记账员'],
    '出纳': ['出纳员', '资金管理'],
    '审计': ['审计员', '审计助理', '内部审计', '外部审计', '审计师', '审计专员', '审计经理'],
    '税务专员': ['税务', '税务师', '税筹'],
    '风控专员': ['风控', '风险控制', '内控', '合规'],
    '财务分析': ['财务分析师', 'FP&A', 'fpa'],
    '财务经理': ['财务主管', '财务总监', 'CFO'],
    '投资分析师': ['投资分析', '行业研究', '研究员'],
    '基金经理': ['投资经理', '基金经理'],
    '证券经纪人': ['证券', '券商'],
    '交易员': ['交易员', '操盘手'],
    '信贷管理': ['信贷'],
    '保险精算师': ['精算'],
    '保险顾问': ['保险', '保险经纪人', '保险销售', '理赔'],
    '核保理赔': ['核保', '理赔'],
    '银行柜员': ['柜员', '银行'],
    '客户经理': ['客户经理', '对公客户'],
    '资产评估师': ['资产评估', '估价'],
    '融资经理': ['融资', '投融资'],
    '理财顾问': ['理财', '财富管理', '理财规划'],
    '成本会计': ['成本', '成本核算'],
    '审计经理': ['高级审计'],

    # 教育/培训
    '教师': ['老师', '学科老师', '任课教师'],
    '外语教师': ['英语老师', '日语老师', '外教', '雅思老师', '托福老师'],
    '数学教师': ['数学老师'],
    '语文教师': ['语文老师'],
    '物理教师': ['物理老师'],
    '化学教师': ['化学老师'],
    '美术教师': ['美术老师', '绘画老师'],
    '音乐教师': ['音乐老师', '钢琴老师', '乐器老师'],
    '体育教师': ['体育老师', '体能老师'],
    '培训讲师': ['培训老师', '培训师', '讲师', '培训专员'],
    '教务管理': ['教务', '教学管理', '学习管理', '学管', '班主任'],
    '课程顾问': ['课程顾问', '招生', '咨询师', '教育顾问', '规划师', '学业规划', '升学规划'],
    '留学顾问': ['留学', '留学咨询'],
    '课程设计师': ['课程设计', '教研', '教研员'],
    '家教': ['家庭教师', '家教', '住家教师'],

    # 建筑/土木
    '建筑设计师': ['建筑设计师', '建筑设计', '建筑方案'],
    '土木工程师': ['土木', '土建'],
    '结构工程师': ['结构工程', '结构设计'],
    '室内设计师': ['室内设计', '室内设计师', '硬装设计', '家装设计', '装修设计', '装饰设计', '全屋定制设计'],
    '项目经理': ['工程经理', '项目总工', '工程总监'],
    '暖通工程师': ['暖通', '暖通设计'],
    '给排水工程师': ['给排水', '水暖'],
    '施工员': ['施工', '施工管理', '施工队长', '施工技术', '现场施工'],
    '安全员': ['安全员', '安全工程', '安全主管', 'HSE'],
    '工程监理': ['监理', '监理员', '监理工程'],
    '预算员': ['预算', '造价', '造价员', '造价工程师'],
    '资料员': ['资料员', '资料管理', '工程资料'],
    '测绘工程师': ['测绘', '测量', '测量员', '测量工程', '测绘工程'],

    # 机械/制造
    '机械工程师': ['机械设计', '机械设计工程师', '机械研发', '机械结构', '非标机械', '非标设计'],
    'CNC工程师': ['cnc', 'CNC', '加工中心', '数控编程', '数控加工'],
    '焊接': ['焊接', '焊工', '电焊', '氩弧焊'],
    '设备工程师': ['设备维修', '设备维护', '设备管理'],
    '钳工': ['钳工', '装配钳工'],
    '电工': ['维修电工'],
    '叉车工': ['叉车', '叉车司机'],
    '质检员': ['品检', '检验员', 'QC', 'qc', '品质检验', '来料检验', 'OQC', 'IPQC', 'FQC'],

    # 销售/市场
    '销售代表': ['销售', '销售员', '销售专员', '销售顾问', '业务员', '销售代表', '销售助理', '销售岗'],
    '电话销售': ['电话销售', '电销', '电话客服', '电话业务'],
    '大客户销售': ['大客户', 'KA销售', 'ka销售', 'B2B销售', 'tob销售', 'ToB销售'],
    '销售经理': ['销售经理', '销售主管', '销售总监', '销售管理'],
    '外贸业务员': ['外贸', '外贸专员', '外贸跟单', '国际贸易', '国贸', '外贸助理'],
    '市场专员': ['市场专员', '市场营销', '市场推广', '市场助理', '市场拓展', '市场企划'],
    '品牌策划': ['品牌', '品牌专员', '品牌推广', '品牌宣传'],
    '活动策划': ['活动策划', '活动执行', '活动运营', '活动专员', '会展'],
    '渠道销售': ['渠道', '渠道管理', '渠道拓展', '代理商', '经销'],
    '招商': ['招商', '招商经理', '招商专员'],

    # 物流/运输
    '物流专员': ['物流', '物流助理', '物流操作', '物流文员'],
    '仓储管理': ['仓库', '仓储', '库管', '仓库管理员', '仓管', '仓库文员', '库房'],
    '采购专员': ['采购', '采购员', '采购助理', '采购工程师', '采购管理'],
    '货运代理': ['货运', '货代'],
    '快递员': ['快递', '配送', '外卖', '送餐', '骑手', '派送'],
    '物流司机': ['司机', '驾驶员', '货运司机', '货车司机', '班车司机'],

    # 传媒/设计
    '平面设计师': ['平面设计', '平面', '海报设计', '版式设计'],
    '视频编辑': ['视频剪辑', '短视频剪辑', '影视剪辑', '后期剪辑', '视频制作', '剪辑师'],
    '文案策划': ['文案', '文案编辑', '新媒体文案', '公众号文案', '内容编辑'],
    '摄影师': ['摄影', '摄影师', '摄像', '摄像师'],
    '插画师': ['插画', '商业插画', '插画设计'],
    '3D设计师': ['3D', '3D建模', '3D设计', '三维', '三维建模'],
    '动画师': ['动画', '动画设计', '动漫', '动作设计'],
    '原画师': ['原画', '角色原画', '场景原画'],
    '编辑': ['编辑', '内容编辑', '文字编辑', '新媒体编辑', '出版编辑', '校对'],
    '导演/编导': ['导演', '编导', '短视频编导', '节目编导'],
    '广告创意': ['创意总监', '美术指导', '创意', '广告策划'],
    '翻译': ['翻译', '英语翻译', '日语翻译', '韩语翻译', '法语翻译', '德语翻译', '口译', '笔译'],
    '服装设计师': ['服装设计', '时装设计', '服装', '制版'],
}

# Also add synonyms from the existing synonym_dict for reference
print(f"\nExisting synonyms in DB: {len(existing_syns)}")

# Build synonym mapping: raw_title -> standard_title
# A raw_title is a "dirty" title that should map to a standard category name
new_synonyms = {}  # lower_case_raw -> standard_title
unmatched_titles = {}  # title -> count for titles that couldn't be mapped

for title, cnt in unclassified:
    if title in existing_titles:
        continue  # already a standard title, skip
    if title in existing_syns:
        continue  # already has a synonym

    t = title.strip().lower()
    matched = False

    for std_name, aliases in existing_standards.items():
        if std_name not in existing_titles:
            continue
        # Check exact match (case insensitive)
        if t == std_name.lower():
            new_synonyms[title] = std_name
            matched = True
            break
        # Check if title contains or is contained by any alias
        for alias in aliases:
            alias_lower = alias.lower().strip()
            if t == alias_lower:
                new_synonyms[title] = std_name
                matched = True
                break
            # Partial match: title starts with or contains alias
            # (for titles like "java开发工程师(J2345)")
            if len(alias_lower) >= 3 and (
                t.startswith(alias_lower) or
                (len(t) <= len(alias_lower) + 8 and alias_lower in t)
            ):
                new_synonyms[title] = std_name
                matched = True
                break
        if matched:
            break

    if not matched:
        unmatched_titles[title] = cnt

print(f"\nNew synonyms found: {len(new_synonyms)}")
print(f"Still unmatched: {len(unmatched_titles)} titles ({sum(unmatched_titles.values())} records)")

# Show sample unmatched for review
print("\n=== TOP 100 UNMATCHED (need review) ===")
sorted_um = sorted(unmatched_titles.items(), key=lambda x: -x[1])
for i, (title, cnt) in enumerate(sorted_um[:100]):
    print(f"{i+1:>3}. [{cnt:>4}] {title}")

# Show new synonym samples
print(f"\n=== NEW SYNONYM SAMPLES ===")
for (raw, std), count in list(Counter(new_synonyms.items()).most_common(50)):
    print(f"  {raw} -> {std}")

# Save to files for SQL generation
synonym_sql = []
for raw, std in new_synonyms.items():
    safe_raw = raw.replace("'", "\\'")
    safe_std = std.replace("'", "\\'")
    synonym_sql.append(f"('{safe_raw}', '{safe_std}')")

print(f"\n=== SQL GENERATED ===")
print(f"-- {len(synonym_sql)} synonym INSERT statements")
print("INSERT INTO synonym_dict (raw_word, std_word) VALUES")
print(",\n".join(synonym_sql[:5]) + ";")
print("...")

# Now categorize unmatched into new industries
# Group by keyword
new_industry_groups = defaultdict(list)
for title, cnt in sorted_um:
    t = title.lower()
    # Remove marketing fluff words
    clean_t = re.sub(r'[（(][^)）]*[)）]', '', t)
    clean_t = re.sub(r'[\d]+k-[\d]+k|[\d]+-[\d]+k|月入|双休|五险|一金|周末|急招|高薪|福利|急聘|包吃住|提供住宿|免费|培训|可兼职|带薪|节日|年终奖|旅游团建|团建|下午茶|生日福利|零食|不限经验|无经验|经验不限|学历不限|可居家|实习生|实习|应届', '', t, flags=re.IGNORECASE)
    clean_t = re.sub(r'[^\w一-鿿/]', '', clean_t)
    clean_t = clean_t.strip('_ -~！·…-')

    if len(clean_t) < 2:
        continue  # Too cleaned, probably junk

    # Try to categorize
    if any(k in t for k in ['法务', '法律', '律师', '合规', '律所', '知识产权', '专利', '法诉', '仲裁']):
        new_industry_groups['法律/合规'].append((title, cnt))
    elif any(k in t for k in ['行政', '前台', '秘书', '文员', '人事', '人力', '招聘', '薪资', '绩效', '劳动关系', 'hr']):
        new_industry_groups['行政/人事'].append((title, cnt))
    elif any(k in t for k in ['物业', '保安', '消防', '安防', '门卫', '巡逻', '消防中控']):
        new_industry_groups['物业/安保'].append((title, cnt))
    elif any(k in t for k in ['餐饮', '厨师', '帮厨', '面点', '烘焙', '服务员', '餐厅', '火锅', '奶茶', '咖啡', '调酒', '洗碗', '食堂', '切配', '配菜', '打荷', '传菜', '送餐', '日料', '烧腊']):
        new_industry_groups['餐饮/服务'].append((title, cnt))
    elif any(k in t for k in ['家政', '保洁', '保姆', '月嫂', '护工', '育儿', '养老', '陪护', '收纳', '家电清洗', '除螨']):
        new_industry_groups['家政/生活服务'].append((title, cnt))
    elif any(k in t for k in ['美容', '美发', '美甲', '化妆', '纹绣', '纹身', '养生', '按摩', '足疗', 'spa', '采耳', '医美', '皮肤管理', '脱毛', '理疗']):
        new_industry_groups['美容/养生'].append((title, cnt))
    elif any(k in t for k in ['酒店', '旅游', '导游', '民宿', '旅行社', '前台接待', '酒店前台', '客房', '票务', '签证', '计调']):
        new_industry_groups['酒店/旅游'].append((title, cnt))
    elif any(k in t for k in ['健身', '教练', '瑜伽', '游泳', '健身教练', '跆拳道', '拳击', '篮球', '足球', '羽毛球', '网球', '高尔夫', '棒球', '滑雪', '潜水', '体适能', '普拉提']):
        new_industry_groups['体育/健身'].append((title, cnt))
    elif any(k in t for k in ['农业', '种植', '养殖', '畜牧', '渔业', '水产', '林业', '种业', '农场', '农技']):
        new_industry_groups['农林牧渔'].append((title, cnt))
    elif any(k in t for k in ['新能源', '光伏', '风电', '锂电', '储能', '充电桩', '生物质']):
        new_industry_groups['新能源'].append((title, cnt))
    elif any(k in t for k in ['化工', '化学', '化妆品研发', '涂料', '橡胶', '塑料', '高分子', '日化', '试剂', '合成']):
        new_industry_groups['化工/日化'].append((title, cnt))
    elif any(k in t for k in ['影视', '演员', '导演', '制片', '编剧', '艺人', '练习生', '歌手', '综艺', '舞台', '剧场', '剧组', '群演', '特约']):
        new_industry_groups['影视/演艺'].append((title, cnt))
    elif any(k in t for k in ['汽车', '4s', '车险', '修车', '二手车', '汽修', '汽车美容', '汽车维修', '汽车销售', '汽车检测']):
        new_industry_groups['汽车'].append((title, cnt))
    elif any(k in t for k in ['环境', '环保', '污水', '给水', '固废', '环评', '碳排放', '碳中和']):
        new_industry_groups['环保/环境'].append((title, cnt))
    elif any(k in t for k in ['咨询', '顾问', '猎头', '顾问式', '企业管理', '战略咨询', '管理咨询']):
        new_industry_groups['咨询/商务服务'].append((title, cnt))
    elif any(k in t for k in ['检测', '质检', '化验', '认证', '品控', '试验', '实验室', '测试员', '无损探伤']):
        new_industry_groups['质检/检测'].append((title, cnt))
    elif any(k in t for k in ['客服', '售前', '售后', '呼叫', '热线']):
        new_industry_groups['客服'].append((title, cnt))
    elif any(k in t for k in ['服装', '纺织', '面料', '样衣', '裁缝', '制衣', '车工', '缝纫']):
        new_industry_groups['服装/纺织'].append((title, cnt))
    elif any(k in t for k in ['直播', '抖音', '快手', '主播', '带货', '内容创作']):
        new_industry_groups['影视/演艺'].append((title, cnt))
    elif any(k in t for k in ['新媒体', '自媒体', '公众号', '内容运营', '小红书', '知乎', '微博']):
        # Map to 传媒/设计
        new_industry_groups['传媒/设计'].append((title, cnt))
    else:
        new_industry_groups['其他待定'].append((title, cnt))

print(f"\n=== NEW INDUSTRY GROUPS ===")
for group, items in sorted(new_industry_groups.items(), key=lambda x: -sum(c for _,c in x[1])):
    total = sum(c for _,c in items)
    if group == '传媒/设计':
        print(f"【{group} (归入现有)】{total}条 {len(items)}种")
    else:
        print(f"【{group}】{total}条 {len(items)}种")
        top5 = sorted(items, key=lambda x: -x[1])[:5]
        for t, c in top5:
            print(f"    [{c}] {t}")

conn.close()
print("\nDone.")
