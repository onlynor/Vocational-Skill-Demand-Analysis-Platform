import pymysql, os, re

with open('D:/study/实验_提交版/.env', encoding='utf-8') as fh:
    for line in fh:
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

# Parse synonym pairs from SQL file
syns = []
in_syn = False
with open('D:/study/实验_提交版/scripts/category_synonym_updates.sql', encoding='utf-8') as fh:
    for line in fh:
        if '-- 2. Synonyms' in line:
            in_syn = True
            continue
        if not in_syn:
            continue
        if line.strip().startswith('INSERT') or line.strip().startswith('--'):
            continue
        if line.strip().endswith(';'):
            continue
        for m in re.finditer(r"\('([^']*)',\s*'([^']*)'\)", line):
            raw, std = m.group(1), m.group(2)
            syns.append((raw, std))

print(f'Parsed {len(syns)} synonym pairs from SQL file')

added = 0
skipped = 0
errors = 0
for raw, std in syns:
    try:
        cur.execute('INSERT INTO synonym_dict (raw_word, std_word) VALUES (%s, %s)', (raw, std))
        added += 1
    except pymysql.err.IntegrityError:
        skipped += 1
    except Exception as e:
        errors += 1
        if errors <= 5:
            print(f'Error: {str(e)[:80]}')

conn.commit()
print(f'Inserted: {added}, Skipped (dups): {skipped}, Errors: {errors}')
cur.execute('SELECT COUNT(*) FROM synonym_dict')
print(f'Total synonyms in DB: {cur.fetchone()[0]}')
cur.execute('SELECT COUNT(*) FROM job_category')
print(f'Total categories in DB: {cur.fetchone()[0]}')
cur.execute('SELECT COUNT(*) FROM cleaned_jobs WHERE category_id IS NULL')
print(f'Unclassified before pipeline: {cur.fetchone()[0]}')
conn.close()
