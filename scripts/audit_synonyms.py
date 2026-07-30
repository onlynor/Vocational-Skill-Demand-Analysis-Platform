# coding: utf-8
"""Comprehensive synonym_dict audit"""
from backend.database import SessionLocal
from backend.models import SynonymDict, JobCategory

db = SessionLocal()

std_titles = {r[0] for r in db.query(JobCategory.name).filter(JobCategory.parent_id.isnot(None)).all()}
all_syns = db.query(SynonymDict).all()

with open('/tmp/synonym_audit.txt', 'w', encoding='utf-8') as f:
    f.write(f'=== COMPREHENSIVE SYNONYM AUDIT ===\n')
    f.write(f'Total synonyms: {len(all_syns)}\n')
    f.write(f'Total standard titles: {len(std_titles)}\n\n')

    issues = []
    for s in all_syns:
        problems = []
        if s.std_word not in std_titles:
            problems.append('ORPHAN')
        if s.raw_word in std_titles:
            problems.append('REDUNDANT')
        if s.raw_word == s.std_word:
            problems.append('IDENTITY')
        if len(s.raw_word) <= 3:
            problems.append(f'SHORT({len(s.raw_word)})')
        if problems:
            issues.append((s.raw_word, s.std_word, problems))

    f.write(f'=== ISSUES FOUND: {len(issues)} entries ===\n\n')

    orphans = [(r, s, p) for r, s, p in issues if 'ORPHAN' in p]
    f.write(f'--- ORPHAN (std not in job_category): {len(orphans)} ---\n')
    for raw, std, probs in orphans[:30]:
        f.write(f'  "{raw}" -> "{std}"\n')
    if len(orphans) > 30:
        f.write(f'  ... and {len(orphans) - 30} more\n')

    redundants = [(r, s, p) for r, s, p in issues if 'REDUNDANT' in p]
    f.write(f'\n--- REDUNDANT (raw already a standard title): {len(redundants)} ---\n')
    for raw, std, probs in redundants[:30]:
        f.write(f'  "{raw}" -> "{std}"\n')
    if len(redundants) > 30:
        f.write(f'  ... and {len(redundants) - 30} more\n')

    identities = [(r, s, p) for r, s, p in issues if 'IDENTITY' in p]
    f.write(f'\n--- IDENTITY (raw=std): {len(identities)} ---\n')
    for raw, std, probs in identities:
        f.write(f'  "{raw}" -> "{std}"\n')

    shorts = [(r, s, p) for r, s, p in issues if any(x.startswith('SHORT') for x in p)]
    f.write(f'\n--- SHORT raw_word (<=3 chars): {len(shorts)} ---\n')
    for raw, std, probs in shorts:
        f.write(f'  "{raw}" -> "{std}"\n')

    # CROSS-INDUSTRY ANALYSIS
    f.write(f'\n=== CROSS-INDUSTRY ANALYSIS ===\n')
    cat_rows = db.query(JobCategory).all()
    parent_names = {c.id: c.name for c in cat_rows if c.parent_id is None}
    name_to_parent = {}
    for c in cat_rows:
        if c.parent_id and c.parent_id in parent_names:
            name_to_parent[c.name] = parent_names[c.parent_id]

    dest_industries = {}
    for s in all_syns:
        ind = name_to_parent.get(s.std_word, 'UNKNOWN')
        dest_industries.setdefault(ind, []).append(s)

    industry_keywords = {
        '计算机/互联网': ['java', 'python', '前端', '后端', '算法', '测试', '运维', '数据', '产品经理', 'ui', 'ux', '游戏', '区块链', '嵌入式', 'app', 'web', '软件', '程序', 'golang', 'php', 'c++', 'android', 'ios', '鸿蒙', 'node'],
        '电气/自动化': ['电气', '自动化', 'plc', '硬件', 'pcb', 'fpga', '电子', '电力', '通信', '机电', '仪器', '仪表', '电路', '弱电', '强电', '变电', '输电'],
        '医学/医疗': ['医', '药', '护', '临床', '牙', '口腔', '眼科', '麻醉', '中医', '针灸', '康复', '检验', '影像', 'b超', '彩超', 'ct', 'mri', '放射', '病理', '体检', '兽医', '动物', '护士', '护理', '手术', '制剂', '注射', '输液', '细胞', '基因', '生物', '蛋白'],
        '金融/会计': ['会计', '财务', '审计', '税务', '出纳', '投资', '证券', '基金', '保险', '银行', '信贷', '理财', '融资', '风控', '精算', '交易', '股票', '债券', '期货'],
        '教育/培训': ['教师', '老师', '幼师', '培训', '教务', '课程', '留学', '托管', '家教', '辅导', '幼教', '早教', '书法', '钢琴', '教学', '讲', '授课'],
        '建筑/土木': ['建筑', '土木', '施工', '装修', '室内设计', '暖通', '给排水', '测绘', 'bim', '园林', '景观', '监理', '造价', '预算', '资料员', '安全员', '结构工程师', '土建', '桩基', '幕墙'],
        '机械/制造': ['机械', 'cnc', '数控', '焊接', '钳工', '模具', '注塑', '冲压', '装配', '叉车', '生产', '车间', '操作工', '普工', '包装', '铣', '磨', '镗', '车工', '打磨', '喷涂'],
        '销售/市场': ['销售', '市场', '商务', '外贸', '品牌', '活动', '新媒体', '直播', '客服', '运营', '电话', '渠道', '电商', '营销', '推广'],
        '物流/运输': ['物流', '仓库', '仓储', '配送', '快递', '货运', '司机', '驾驶员', '搬运', '装卸'],
        '传媒/设计': ['设计', '设计师', '平面', '视频', '剪辑', '摄影', '3d', '动画', '文案', '编辑', '记者', '导演', '编导', '美工', '插画'],
        '餐饮/服务': ['厨师', '服务员', '帮厨', '洗碗', '配菜', '面点', '烘焙', '咖啡', '奶茶', '餐厅', '后厨', '传菜'],
        '美容/养生': ['美容', '美发', '美甲', '化妆', 'spa', '按摩', '足疗', '采耳', '养生'],
        '化工/日化': ['化工', '化学', '化妆品', '涂料', '橡胶', '塑料', '高分子', '试剂', '日化'],
        '法律/合规': ['法律', '法务', '律师', '合规', '专利', '知识产权', '合同', '诉讼', '仲裁'],
        '行政/人事': ['行政', '人事', '前台', '秘书', 'hrbp', 'hr', '人力资源', '招聘', '薪酬', '绩效'],
        '汽车': ['汽车', '4s', '二手车', '汽修', '钣金', '喷漆', '车险', '洗车'],
        '新能源': ['光伏', '风电', '储能', '锂电', '电池', '充电桩', '新能源', '太阳能'],
        '农林牧渔': ['农业', '种植', '养殖', '林业', '渔业', '畜牧', '兽医', '农药', '饲料', '园艺'],
        '环保/环境': ['环保', '环境', '污水', '水处理', '固废', '废气', '碳排放', '环评', '除尘', '脱硫'],
        '酒店/旅游': ['酒店', '前台', '客房', '导游', '民宿', '礼宾', '门童', '旅游'],
        '体育/健身': ['健身', '教练', '瑜伽', '游泳', '私教', '篮球', '足球'],
        '服装/纺织': ['服装', '纺织', '面料', '缝纫', '打版', '制版', '样衣', '裁缝'],
    }

    f.write('Suspicious cross-industry mappings (>=2 keywords from different industry):\n')
    cross_count = 0
    for dest_ind, syns in dest_industries.items():
        if dest_ind == 'UNKNOWN':
            continue
        for s in syns:
            raw_lower = s.raw_word.lower()
            for check_ind, keywords in industry_keywords.items():
                if check_ind == dest_ind:
                    continue
                matched = [kw for kw in keywords if kw in raw_lower]
                if len(matched) >= 2:
                    cross_count += 1
                    f.write(f'  "{s.raw_word}" -> "{s.std_word}" ({dest_ind}) | looks like {check_ind}: {matched}\n')
                    break

    f.write(f'\nCross-industry suspicious: {cross_count}\n')

db.close()
print('Audit complete')
