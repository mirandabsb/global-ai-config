name: bootstrap-masterskill
summary: Bootstrap master skill compatibility with the shared AI config.

Run the runtime bootstrap script to point the local project to the global shared library and update masterskill settings.

Steps:
1. `cd ~/AI/global-ai-config`
2. `bash scripts/bootstrap-masterskill.sh`
3. Confirm `~/Antigravity/.agent/Biblioteca_Global` is a symlink to `~/AI/global-ai-config/biblioteca/Biblioteca_Global`.
4. Confirm `~/Antigravity/.agent/Configuration/.gemini/config/skills/masterskill/config/settings.json` contains the shared library path and explicit-load policy.
