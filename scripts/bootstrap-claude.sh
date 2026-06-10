#!/usr/bin/env bash
# Bootstrap Claude Code agents from Biblioteca_Global catalog
set -euo pipefail

CATALOG="$HOME/AI/global-ai-config/biblioteca/Biblioteca_Global"
AGENTS_DIR="$HOME/.claude/agents"

echo "==> Bootstrap Claude Code — Biblioteca_Global"
echo "    Catálogo: $CATALOG"
echo "    Agentes:  $AGENTS_DIR"
echo ""

mkdir -p "$AGENTS_DIR"

CORE_AGENTS=(
  "orchestrator"
  "project-planner"
  "product-manager"
  "backend-specialist"
  "frontend-specialist"
  "debugger"
  "explorer-agent"
)

echo "Agentes core a instalar:"
for agent in "${CORE_AGENTS[@]}"; do
  echo "  - $agent"
done
echo ""
read -rp "Confirmar instalação? [s/N] " confirm
[[ "$confirm" =~ ^[sS]$ ]] || { echo "Cancelado."; exit 0; }

installed=0
skipped=0

for agent in "${CORE_AGENTS[@]}"; do
  src="$CATALOG/agents/${agent}.md"
  dst="$AGENTS_DIR/${agent}.md"

  if [ ! -f "$src" ]; then
    echo "  [SKIP] $agent — arquivo não encontrado em catálogo"
    ((skipped++)) || true
    continue
  fi

  if [ -e "$dst" ]; then
    echo "  [SKIP] $agent — já existe em $AGENTS_DIR"
    ((skipped++)) || true
    continue
  fi

  ln -s "$src" "$dst"
  echo "  [OK]   $agent"
  ((installed++)) || true
done

echo ""
echo "Instalados: $installed | Ignorados: $skipped"
echo ""
echo "Skill master já em: $AGENTS_DIR/master.md"
echo "Para instalar agente individual: /master instale agente de <nome>"
echo "Para listar catálogo: /master liste"
