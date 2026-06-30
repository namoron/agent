# CLAUDE.md

このワークスペースでは、Claude Code 用の project instructions を `agent/` ディレクトリで共有管理している。

最初に `agent/AGENTS.md` と `agent/CLAUDE.md` を読み、このワークスペースの指示として扱うこと。

subagent が必要な場合は `agent/agents/*.md` を参照し、役割に応じて使い分けること。

- 実装、修正、テスト更新: `agent/agents/python-dev.md`
- 設計、分解、段階計画: `agent/agents/python-architect.md`
- review、回帰確認、再現性点検: `agent/agents/python-reviewer.md`
- docs / API 仕様確認: `agent/agents/docs-researcher.md`
- read-only の探索: `agent/agents/explorer.md`
- 日本語 LaTeX 論文の執筆・推敲: `agent/agents/jp-paper-latex.md`
- 英語 LaTeX 論文の執筆・推敲: `agent/agents/en-paper-latex.md`

`agent/` 側の指示が更新された場合は、そちらを正本として追従すること。
