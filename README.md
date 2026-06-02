# Global AI Config

Portable global AI configuration for VS Code/Copilot and AntiGravity.

## Goals

- Keep a shared global AI asset catalog under Git.
- Use VS Code/Copilot native global customization locations.
- Keep AntiGravity compatibility.
- Do not auto-load skills, agents, workflows or frameworks.
- Access catalog assets only on explicit user request.
- Keep secrets out of Git.

## Main paths

Repository:

```txt
~/AI/global-ai-config
```

Shared catalog:

```txt
~/AI/global-ai-config/biblioteca/Biblioteca_Global
```

VS Code/Copilot runtime symlinks:

```txt
~/.copilot/instructions
~/.copilot/skills
~/.copilot/agents
~/.copilot/prompts
```

## Bootstrap VS Code

```bash
cd ~/AI/global-ai-config
bash scripts/bootstrap-vscode.sh
```

## Security

Do not commit tokens, API keys, secrets, `.env.local`, credentials or local machine config.
