import json
import re

with open("all_skills_dump.json", "r", encoding="utf-8") as f:
    skills = json.load(f)

# Categories of irrelevance:
# 1. Other AI Coders / IDEs
# 2. Competing LLM Providers (OpenAI, Anthropic) if they enforce locking to those.
# 3. AI UI Generators (v0, bolt, lovable) since AntiGravity does this itself.
# 4. Outdated / overly niche tools.

keywords = [
    r"\blovable\b", r"\bbolt\.new\b", r"\bv0\b", r"\breplit\b", r"\bcursor\b", r"\bwindsurf\b",
    r"\bcline\b", r"\broo\b", r"\baider\b", r"\bdevin\b", r"\bchatgpt\b", r"\bopenai\b", r"\bgpt-4\b",
    r"\bcopilot\b", r"\btabnine\b", r"\bcodeium\b", r"\bcontinue\.dev\b", r"\bcontinue\b"
]

pattern = re.compile("|".join(keywords), re.IGNORECASE)

irrelevant = []
for s in skills:
    # Skip already archived
    if "_archive" in s['path']:
        continue
    text = f"{s['name']} {s['description']} {s['path']}"
    if pattern.search(text):
        irrelevant.append(s)

print("Found matching skills:")
for s in irrelevant:
    print(f"- {s['path']} ({s['name']})")

