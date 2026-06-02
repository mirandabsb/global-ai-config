# Global AI Config

Portable global AI configuration for VS Code/Copilot and AntiGravity.

## Goals

- Keep a shared global AI asset catalog under Git.
- Use VS Code/Copilot native global customization locations.
- Keep AntiGravity compatibility.
- Do not auto-load skills, agents, workflows or frameworks.
- Access catalog assets only on explicit user request.
- Keep secrets out of Git.

## Repository layout

- `biblioteca/Biblioteca_Global/` — shared catalog contents for AntiGravity and global discovery.
- `vscode/copilot/` — VS Code/Copilot instructions, skills, agents and prompts.
- `config/ai-assets.json` — shared catalog metadata and policy config.
- `scripts/` — bootstrap and validation helpers.
- `.env.example` — local secret placeholders.

## Clone and bootstrap

```bash
git clone git@github.com:mirandabsb/global-ai-config.git ~/AI/global-ai-config
cd ~/AI/global-ai-config
bash scripts/bootstrap-vscode.sh
bash scripts/bootstrap-antigravity.sh
```

## VS Code / Copilot

This repository links into the VS Code Copilot global runtime at:

```txt
~/.copilot/instructions
~/.copilot/skills
~/.copilot/agents
~/.copilot/prompts
```

If you use VS Code, the bootstrap script also updates `~/.config/Code/User/settings.json` with the required Copilot discovery locations.

## AntiGravity

The AntiGravity bootstrap script creates a symlink from:

```txt
~/Antigravity/.agent/Biblioteca_Global
```

to the shared repo catalog at:

```txt
~/AI/global-ai-config/biblioteca/Biblioteca_Global
```

It also updates AntiGravity masterskill settings to use the shared library and explicit load policy.

## Environment variables

Copy `.env.example` to `.env.local` and fill values locally. Do not commit `.env.local`.

```bash
cp .env.example .env.local
```

## Validation

Run the built-in validation before committing or pushing:

```bash
bash scripts/validate.sh
```

## Usage

Use the explicit master skill router to access assets from the shared catalog:

- `/master-skill liste as skills`
- `/master-skill liste os agentes`
- `/master-skill liste os workflows`
- `/master-skill traga a skill de <nome>`
- `/master-skill traga o agente de <nome>`
- `/master-skill traga o workflow de <nome>`
- `/master-skill instale o <framework>`
- `/master-skill quais skills devo usar para <tarefa>`

## Recommended commands

```bash
cd ~/AI/global-ai-config
bash scripts/bootstrap-vscode.sh
bash scripts/bootstrap-antigravity.sh
bash scripts/validate.sh
```

## Security

Do not commit secrets, tokens, credentials or local machine-specific files.
Keep `.env.local` and any generated runtime config out of source control.
