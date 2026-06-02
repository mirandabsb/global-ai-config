name: bootstrap-vscode
summary: Bootstrap VS Code/Copilot global AI configuration.

Run the VS Code/Copilot bootstrap script to link the shared catalog into the global `.copilot` runtime.

Steps:
1. `cd ~/AI/global-ai-config`
2. `bash scripts/bootstrap-vscode.sh`
3. Confirm the following symlinks exist:
   - `~/.copilot/instructions`
   - `~/.copilot/skills`
   - `~/.copilot/agents`
   - `~/.copilot/prompts`
4. Open VS Code and verify `chat.includeApplyingInstructions` is enabled.
