# agent

`everything-claude-code` を参考に、最新の GitHub Copilot と Codex の agent 機能へ寄せた最小テンプレートです。

## Included

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

## Current Agent Roles

- Copilot: `python-dev`, `python-architect`, `python-reviewer`, `docs-researcher`
- Codex: `python_dev`, `python_architect`, `python_reviewer`, `explorer`, `docs_researcher`

## Current Skill Set

- `python-tdd`
- `python-review`
- `python-patterns`
