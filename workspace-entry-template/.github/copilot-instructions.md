# GitHub Copilot Workspace Bridge

このワークスペースでは、GitHub Copilot 用の repository instructions を `agent/.github/` で共有管理している。

まず次を読むこと。

1. `agent/AGENTS.md`
2. `agent/.github/AGENTS.md`
3. `agent/.github/copilot-instructions.md`

役割別 agent や path-specific instructions が必要な場合は次を参照すること。

- `agent/.github/agents/*.agent.md`
- `agent/.github/instructions/*.instructions.md`
- `agent/.github/hooks/`

このファイルは、Copilot がワークスペース直下から入口を見つけるための bridge としてのみ使う。
