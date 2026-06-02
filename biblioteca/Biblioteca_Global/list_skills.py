import json

with open("all_skills_dump.json", "r", encoding="utf-8") as f:
    skills = json.load(f)

for s in skills:
    if "_archive" in s['path']:
        continue
    print(f"{s['path'].replace('./', '')}: {s['name']}")
