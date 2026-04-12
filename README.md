# agent

無線通信シミュレーション、数値実験、論文執筆を主な用途にした、Python 中心の agent テンプレートです。
`everything-claude-code` を参考にしつつ、Claude Code、GitHub Copilot、Codex で使う構成を、研究・解析ワークフロー向けに絞っています。

## 想定する日常タスク

- `NVIDIA Sionna` や周辺ライブラリを使った通信方式シミュレーション
- `NumPy`、`Pandas`、`TensorFlow` を使った実験コード、集計、前処理
- `CSV`、`NPY`、ログの読み書きと実験条件の管理
- `Matplotlib` などによるプロット作成
- 日本語 / 英語 LaTeX 論文の下書き、修正、推敲

## 含まれるもの

- 共通ルール: `AGENTS.md`
- Claude Code:
  - `CLAUDE.md`
  - `agents/*.md`
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

- Claude Code: `python-dev`, `python-architect`, `python-reviewer`, `explorer`, `docs-researcher`, `jp-paper-latex`, `en-paper-latex`
- Copilot: `python-dev`, `python-architect`, `python-reviewer`, `docs-researcher`, `jp-paper-latex`, `en-paper-latex`
- Codex: `python_dev`, `python_architect`, `python_reviewer`, `explorer`, `docs_researcher`, `jp_paper_latex`, `en_paper_latex`

## 現在の Skill 一覧

- `python-tdd`
- `python-review`
- `python-patterns`
- `jp-paper-latex`
- `en-paper-latex`

## 何を重視するか

- 数値的な正しさ、shape / dtype の整合、seed 管理、再現性
- 実験条件、設定値、単位、軸ラベル、出力ファイル名の明確さ
- 小さな差分での修正と、解析コードの読みやすさ
- API やライブラリ挙動についての一次情報確認

## 補助機能

- Copilot の hook ベース memory capture は、セッション候補を `.git/copilot-memory/` に書き出す
- Claude Code では、`CLAUDE.md` と `agents/*.md` を入口にして research / simulation 向けの subagent を使い分ける
- Codex では、探索用の `explorer` と docs 確認用の `docs_researcher` を併用できる
