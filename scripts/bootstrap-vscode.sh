#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT

COPILOT_HOME="$HOME/.copilot"
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"

mkdir -p "$COPILOT_HOME"
mkdir -p "$HOME/.config/Code/User"

link_dir() {
  local source="$1"
  local target="$2"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    mv "$target" "$backup"
    echo "Backed up $target to $backup"
  fi

  rm -f "$target"
  ln -s "$source" "$target"
  echo "Linked $target -> $source"
}

link_dir "$REPO_ROOT/vscode/copilot/instructions" "$COPILOT_HOME/instructions"
link_dir "$REPO_ROOT/vscode/copilot/skills" "$COPILOT_HOME/skills"
link_dir "$REPO_ROOT/vscode/copilot/agents" "$COPILOT_HOME/agents"
link_dir "$REPO_ROOT/vscode/copilot/prompts" "$COPILOT_HOME/prompts"

if [ ! -f "$VSCODE_SETTINGS" ]; then
  echo "{}" > "$VSCODE_SETTINGS"
fi

cp "$VSCODE_SETTINGS" "${VSCODE_SETTINGS}.backup.$(date +%Y%m%d-%H%M%S)"

python3 - <<'PY'
import json
from pathlib import Path

settings_path = Path.home() / ".config/Code/User/settings.json"

with settings_path.open("r", encoding="utf-8") as f:
    try:
        settings = json.load(f)
    except json.JSONDecodeError:
        settings = {}

required = {
    "chat.includeApplyingInstructions": True,
    "chat.includeReferencedInstructions": False,
    "chat.instructionsFilesLocations": {
        "~/.copilot/instructions": True,
        ".github/instructions": True
    },
    "chat.useAgentSkills": True,
    "chat.agentSkillsLocations": {
        "~/.copilot/skills": True,
        ".github/skills": True
    },
    "chat.agentFilesLocations": {
        "~/.copilot/agents": True,
        ".github/agents": True
    },
    "chat.promptFilesLocations": {
        "~/.copilot/prompts": True,
        ".github/prompts": True
    },
    "chat.useCustomizationsInParentRepositories": False,
    "chat.useNestedAgentsMdFiles": False,
    "chat.mcp.discovery.enabled": False,
    "github.copilot.chat.additionalReadAccessFolders": [
        str(Path.home() / "AI/global-ai-config/biblioteca/Biblioteca_Global"),
        str(Path.home() / "AI/global-ai-config/config")
    ]
}

for key, value in required.items():
    settings[key] = value

with settings_path.open("w", encoding="utf-8") as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
    f.write("\n")

print(f"Updated {settings_path}")
PY

echo "VS Code/Copilot global AI config bootstrapped."
