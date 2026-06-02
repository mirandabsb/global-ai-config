---
name: master-skill
description: "Global router for explicitly accessing Marcos' shared external catalog of skills, agents, workflows and frameworks. Use when: /master-skill, liste skills, liste agentes, liste workflows, traga skill, traga agente, traga workflow, instale framework, quais skills devo usar."
argument-hint: "[liste|traga|instale|use] [skills|agentes|workflows|framework] [nome]"
user-invocable: true
disable-model-invocation: true
---

# Master Skill

You are the explicit router for Marcos' shared global AI asset catalog.

Catalog path:

- `${HOME}/AI/global-ai-config/biblioteca/Biblioteca_Global`

Catalog config:

- `${HOME}/AI/global-ai-config/config/ai-assets.json`

This skill must only run when explicitly invoked by the user.

Do not activate automatically.

Supported commands:

- `/master-skill liste as skills`
- `/master-skill liste os agentes`
- `/master-skill liste os workflows`
- `/master-skill traga a skill de <name>`
- `/master-skill traga o agente de <name>`
- `/master-skill traga o workflow de <name>`
- `/master-skill instale o <framework>`
- `/master-skill quais skills devo usar para <task>`

Behavior:

1. Identify whether the user wants a skill, agent, workflow, framework or recommendation.
2. Search the external catalog only after explicit invocation.
3. Prefer metadata and summaries before reading full files.
4. If there are multiple matches, ask the user to choose.
5. If the user asks to bring/import an asset, copy only that selected asset into the correct IDE-specific global or workspace location.
6. If the user asks only to inspect, recommend or use, do not copy anything.
7. Never import the entire catalog.
8. Never install frameworks without explicit command.
9. When installing frameworks, update `.gitignore` to exclude local AI configuration folders and files where appropriate.

VS Code/Copilot target locations:

- Global skills: `~/.copilot/skills/<skill-name>/`
- Global agents: `~/.copilot/agents/<agent-name>.agent.md`
- Global prompts/workflows: `~/.copilot/prompts/<workflow-name>.prompt.md`
- Workspace skills: `.github/skills/<skill-name>/`
- Workspace agents: `.github/agents/<agent-name>.agent.md`
- Workspace prompts: `.github/prompts/<workflow-name>.prompt.md`

Runtime target locations:

- Project skills: `.agent/skills/<skill-name>/`
- Project agents: `.agent/agents/<agent-name>/`
- Project workflows: `.agent/workflows/<workflow-name>/`

Use global VS Code/Copilot locations by default when operating inside VS Code, unless the user explicitly asks to install into the current workspace or another IDE.
