# agent

`everything-claude-code` を参考にしつつ、最新の GitHub Copilot と Codex の agent 機能へ寄せた最小構成のテンプレートです。

## 含まれるもの

- 共通ルール: `AGENTS.md`
- GitHub Copilot:
  - `.github/copilot-instructions.md`
  - `.github/instructions/python.instructions.md`
  - `.github/agents/*.agent.md`
  - `.github/hooks/`
- Codex:
  - `.codex/AGENTS.md`
  - `.codex/config.toml`
  - `.codex/agents/*.toml`
  - `.agents/skills/*/SKILL.md`
  - `.agents/skills/*/agents/openai.yaml`

## 現在の Agent Roles

- Copilot: `python-dev`, `python-architect`, `python-reviewer`, `docs-researcher`
- Codex: `python_dev`, `python_architect`, `python_reviewer`, `explorer`, `docs_researcher`, `evaluator`, `worktree_orchestrator`

## 現在の Skill 一覧

- `python-tdd`
- `python-review`
- `python-patterns`

## 補助機能

- Copilot の hook ベース memory capture は、セッション候補を `.git/copilot-memory/` に書き出す
- Codex には、検証を強める `evaluator` と並列実行計画を助ける `worktree_orchestrator` が含まれる
