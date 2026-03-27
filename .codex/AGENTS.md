# Codex 向け補足ガイド (Python 中心)

このファイルは、このリポジトリで OpenAI Codex を使うときのために、ルートの `AGENTS.md` を補足するものである。
置き換えではなく、ルートの指示とあわせて使うこと。

## 目的

- `everything-claude-code` の設計意図を Codex 向けに移し替える。
- Python-first、test-first、review-heavy の進め方を維持する。
- 広く浅い変更よりも、明示的で十分な reasoning depth を優先する。
- このリポジトリで使っている Codex の機能
  - `AGENTS.md` の階層適用
  - project-local config
  - subagents
  - skills
  - MCP ベースの docs lookup
    を前提に支援する。

## モデルと reasoning policy

このリポジトリ構成では、Codex は Claude model を直接使わない。
その代わり、Claude 前提の設計意図を Codex の reasoning effort に次のように対応づける。

- 通常 `Claude Sonnet` を想定していたタスクでは `model_reasoning_effort = "high"` を使う。
- 通常 `Claude Opus` を想定していたタスクでは `model_reasoning_effort = "xhigh"` を使う。

この対応は、project-local の Codex agent 全体で一貫して使うこと。

## Python workflow

1. 編集前に既存コード、テスト、近いモジュールを読む。
2. 非自明な作業では、ファイル変更前に短い計画を立てる。
3. 新しい振る舞いやバグ修正では test-first を優先する。
4. 差分は小さく保ち、現在の構造に沿わせる。
5. まず最小限の relevant scope を検証し、必要に応じて広げる。

## Python coding rules

- `PEP 8` を守り、関数シグネチャには型ヒントを付ける。
- `os.path` より `pathlib.Path` を優先する。
- `%` formatting や `.format()` より f-string を優先する。
- 場当たり的な `print()` デバッグより `logging` を優先する。
- ビジネスロジックは framework や I/O の glue code から分離する。
- 引数が増えてきたら `dataclass` や DTO 的な明確なオブジェクトを検討する。

## テストとレビュー

- 既定の testing framework は `pytest` とする。
- unit、integration、重要な regression path をカバーする。
- テスト不足、例外の握りつぶし、弱い validation、型の drift は実際の不具合として扱う。
- レビュー所見は、style より先に correctness、regression、security、test gap を優先する。

## セキュリティ

- secret、key、password、token をハードコードしない。
- 外部入力、ファイル内容、API response は未信頼データとして扱う。
- parameterized query と安全な subprocess invocation を使う。
- path traversal、unsafe deserialization、広すぎる例外処理に注意する。

## ローカル Codex roles

- `python_dev`: Python 実装と集中的なバグ修正, `high`
- `python_architect`: 分解、設計、リスクの高い refactor, `xhigh`
- `python_reviewer`: correctness と security を重視した review, `xhigh`
- `explorer`: read-only の根拠収集, `high`
- `docs_researcher`: docs と API の確認, `high`
- `jp_paper_latex`: 日本語学術 LaTeX の執筆・推敲, `high`
- `en_paper_latex`: 英語学術 LaTeX の執筆・推敲, `high`
- `evaluator`: checkpoint の評価と verification loop, `xhigh`
- `worktree_orchestrator`: 並列 worktree と subagent の調整, `xhigh`

## Skills

タスクに合うなら、`.agents/skills/` 配下の repository skill を優先する。

- `python-tdd`: test-first の Python 実装
- `python-review`: Python の差分レビューとリスク評価
- `python-patterns`: 構造、型付け、boundary 設計の判断
- `jp-paper-latex`: 日本語 LaTeX 論文の執筆・推敲
- `en-paper-latex`: 英語 LaTeX 論文の執筆・推敲

これらの skill には `agents/openai.yaml` metadata も含まれており、Codex が skill-aware な flow で発見しやすくなっている。

## 検証コマンド

リポジトリにあるものだけを使うこと。

- `pytest`
- `pytest --cov=src --cov-report=term-missing`
- `ruff check .`
- `black --check .`
- `isort --check-only .`
- `bandit -r src/`

## 並列作業の指針

- 編集を委譲する前に、read-only の調査には `explorer` を使う。
- タスクを独立した write scope や別 worktree に分けられるなら `worktree_orchestrator` を使う。
- 実装後は `evaluator` を使って checkpoint を確認し、残るリスクを要約して feedback loop を締める。
