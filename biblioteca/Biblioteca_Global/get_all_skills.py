import os
import re
import json

base_dir = os.path.dirname(os.path.abspath(__file__))
skills = []
txt_lines = []

# Varre todos os arquivos SKILL.md recursivamente
for root, dirs, files in os.walk(base_dir):
    for file in files:
        if file == "SKILL.md":
            skill_md = os.path.join(root, file)
            # Caminho relativo da pasta da skill em relação a base_dir
            rel_dir = os.path.relpath(root, base_dir)
            
            try:
                with open(skill_md, "r", encoding="utf-8") as f:
                    content = f.read()
                    
                frontmatter_match = re.match(r"^---\n(.*?)\n---", content, re.DOTALL)
                if frontmatter_match:
                    frontmatter = frontmatter_match.group(1)
                else:
                    frontmatter = content[:500]

                name_match = re.search(r"name:\s*(.+)", frontmatter, re.IGNORECASE)
                desc_match = re.search(r"description:\s*(.+)", frontmatter, re.IGNORECASE)
                
                name = name_match.group(1).strip() if name_match else os.path.basename(root)
                desc = desc_match.group(1).strip() if desc_match else ""
                
                # Limpa aspas do nome se houver
                name = name.strip('"').strip("'")
                
                skills.append({
                    "path": rel_dir,
                    "name": name,
                    "description": desc
                })
                
                txt_lines.append(f"{rel_dir}: {name}")
            except Exception as e:
                pass

# Ordena alfabeticamente pelo caminho relativo
skills.sort(key=lambda x: x["path"])
txt_lines.sort()

# Salva all_skills_dump.json
dump_path = os.path.join(base_dir, "all_skills_dump.json")
with open(dump_path, "w", encoding="utf-8") as f:
    json.dump(skills, f, ensure_ascii=False, indent=2)

# Salva all_skills.txt
txt_path = os.path.join(base_dir, "all_skills.txt")
with open(txt_path, "w", encoding="utf-8") as f:
    f.write("\n".join(txt_lines) + "\n")

print(f"✅ Sincronizadas {len(skills)} skills na Biblioteca Global.")
