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

# ─── Masterskill symlinks ───
MASTERSKILL_RUNTIME="$HOME/Antigravity/.agent/Configuration/.gemini/antigravity/skills/masterskill"
MASTERSKILL_REPO="$REPO_ROOT/masterskill/masterskill"
REFERENCES_REPO="$REPO_ROOT/masterskill/references"

if [ ! -f "$MASTERSKILL_REPO/SKILL.md" ]; then
  echo "Missing masterskill SKILL.md in repo: $MASTERSKILL_REPO/SKILL.md" >&2
  exit 1
fi

mkdir -p "$MASTERSKILL_RUNTIME/config"

# Backup and symlink SKILL.md
if [ -f "$MASTERSKILL_RUNTIME/SKILL.md" ] && [ ! -L "$MASTERSKILL_RUNTIME/SKILL.md" ]; then
  cp "$MASTERSKILL_RUNTIME/SKILL.md" "$MASTERSKILL_RUNTIME/SKILL.md.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backed up runtime SKILL.md"
fi
rm -f "$MASTERSKILL_RUNTIME/SKILL.md"
ln -s "$MASTERSKILL_REPO/SKILL.md" "$MASTERSKILL_RUNTIME/SKILL.md"
echo "Linked SKILL.md -> $MASTERSKILL_REPO/SKILL.md"

# Backup and symlink references/
if [ -d "$MASTERSKILL_RUNTIME/references" ] && [ ! -L "$MASTERSKILL_RUNTIME/references" ]; then
  cp -r "$MASTERSKILL_RUNTIME/references" "$MASTERSKILL_RUNTIME/references.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backed up runtime references/"
fi
rm -rf "$MASTERSKILL_RUNTIME/references"
ln -s "$REFERENCES_REPO" "$MASTERSKILL_RUNTIME/references"
echo "Linked references/ -> $REFERENCES_REPO"
