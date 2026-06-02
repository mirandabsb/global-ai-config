---
name: "Marcos Global AI Asset Catalog"
description: "Global cold catalog policy for skills, agents, workflows and frameworks. Use when: the user asks to list, bring, install, recommend, use or activate catalog assets."
applyTo: "**"
---

# Marcos Global AI Asset Catalog

The user has a shared global AI asset catalog used by multiple IDEs.

Global catalog path:

- `${HOME}/AI/global-ai-config/biblioteca/Biblioteca_Global`

Global catalog config:

- `${HOME}/AI/global-ai-config/config/ai-assets.json`

This catalog is shared by:

- VS Code/Copilot
- AntiGravity

Default behavior:

- Know that the catalog exists.
- Know the catalog path.
- Do not scan the catalog automatically.
- Do not preload catalog contents.
- Do not read `SKILL.md` files automatically.
- Do not load `all_skills.txt` automatically.
- Do not activate agents automatically.
- Do not import workflows automatically.
- Do not install frameworks automatically.
- Do not copy assets into the current workspace automatically.
- Do not register the whole catalog as active VS Code skills, agents or prompts.

Only access catalog assets after an explicit user request, such as:

- `/master-skill ...`
- `liste as skills`
- `liste os agentes`
- `liste os workflows`
- `traga a skill de ...`
- `traga o agente de ...`
- `traga o workflow de ...`
- `instale o framework ...`
- `quais skills devo usar para ...`
- `use a skill ...`
- `ative o agente ...`

When asked to access the catalog:

1. Read only the minimum required files.
2. Prefer metadata and inventory files before full content.
3. If multiple matching assets exist, present options.
4. If the user asks only for recommendation, do not import anything.
5. If the user asks to import, copy only the selected asset.
6. Preserve the current workspace structure and Git safety.
