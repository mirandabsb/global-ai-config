#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "== Checking required paths =="
test -d biblioteca/Biblioteca_Global
test -f vscode/copilot/instructions/marcos-core-policy.instructions.md
test -f vscode/copilot/instructions/marcos-global-catalog.instructions.md
test -f vscode/copilot/skills/master-skill/SKILL.md
test -f config/ai-assets.json

echo "== Checking for likely secrets =="
if grep -RInE "(token|api_key|apikey|secret|password|passwd|credential)" . --exclude-dir=.git --exclude='.env.example'; then
  echo "Review matches above before committing."
else
  echo "No obvious secret keywords found."
fi

echo "== Files larger than 50MB =="
find . -type f -size +50M -not -path "./.git/*" -print

echo "Validation complete."
