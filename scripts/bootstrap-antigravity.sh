#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OLD_PATH="$HOME/Antigravity/.agent/Biblioteca_Global"
NEW_PATH="$REPO_ROOT/biblioteca/Biblioteca_Global"
SETTINGS_PATH="$HOME/Antigravity/.agent/Configuration/.gemini/config/skills/masterskill/config/settings.json"

if [ ! -d "$NEW_PATH" ]; then
  echo "Missing shared library: $NEW_PATH" >&2
  exit 1
fi

if [ -e "$OLD_PATH" ] && [ ! -L "$OLD_PATH" ]; then
  BACKUP="${OLD_PATH}.OLD.$(date +%Y%m%d-%H%M%S)"
  mv "$OLD_PATH" "$BACKUP"
  echo "Backed up old library to $BACKUP"
fi

rm -f "$OLD_PATH"
ln -s "$NEW_PATH" "$OLD_PATH"
echo "Linked $OLD_PATH -> $NEW_PATH"

if [ -f "$SETTINGS_PATH" ]; then
  cp "$SETTINGS_PATH" "${SETTINGS_PATH}.backup.$(date +%Y%m%d-%H%M%S)"
  python3 - <<'PY'
import json
from pathlib import Path
home = Path.home()
settings_path = home / "Antigravity/.agent/Configuration/.gemini/config/skills/masterskill/config/settings.json"
with settings_path.open("r", encoding="utf-8") as f:
    data = json.load(f)
data["skills_folder"] = str(home / "AI/global-ai-config/biblioteca/Biblioteca_Global")
data["global_assets_config"] = str(home / "AI/global-ai-config/config/ai-assets.json")
data["lazy_loading"] = True
data["auto_load_skills"] = False
data["auto_activate_agents"] = False
data["auto_import_workflows"] = False
data["auto_install_frameworks"] = False
data["load_only_on_explicit_user_request"] = True
with settings_path.open("w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
print(f"Updated {settings_path}")
PY
fi
