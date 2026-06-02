import json
import re

with open("all_skills_dump.json", "r", encoding="utf-8") as f:
    skills = json.load(f)

irrelevant = []

# Keywords that suggest irrelevance to the AntiGravity (Gemini-native) ecosystem
# AntiGravity is meant to be a standalone, autonomous assistant powered by Gemini.
# Skills for specific other LLM clients/wrappers or competing ecosystems might be noisy.
keywords = [
    r"\bopenai\b", r"\bchatgpt\b", r"\bgpt-4\b", r"\bgpt-3\b", r"\bgpt4\b", r"\bgpt3\b",
    r"\bcopilot\b", r"\bmidjourney\b", r"\bdall-e\b", r"\bperplexity\b",
    r"\bdevin\b", r"\bcursor\b", r"\bwindsurf\b", r"\bcline\b", r"\broo\b", r"\baider\b"
]

pattern = re.compile("|".join(keywords), re.IGNORECASE)

for s in skills:
    text = f"{s['name']} {s['description']}"
    if pattern.search(text):
        irrelevant.append(s)

for s in irrelevant:
    print(f"- {s['path']} ({s['name']})")
print(f"\nTotal potential irrelevant: {len(irrelevant)}")
