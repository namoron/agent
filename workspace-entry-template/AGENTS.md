# AGENTS.md

このワークスペースでは、共通の agent 設定を `agent/` ディレクトリで管理する。

最初に `agent/AGENTS.md` を読み、このワークスペースの共通指示として扱うこと。

ツール固有の補足は次を参照すること。

- Claude Code: `agent/CLAUDE.md` と `agent/agents/*.md`
- Codex: `agent/.codex/AGENTS.md`、`agent/.codex/config.toml`、`agent/.codex/agents/*.toml`
- GitHub Copilot: `agent/.github/AGENTS.md`、`agent/.github/copilot-instructions.md`、`agent/.github/agents/*.agent.md`

このファイル自体には最小限の bridge だけを書き、運用ルールの本体は `agent/` 側を正本とする。
