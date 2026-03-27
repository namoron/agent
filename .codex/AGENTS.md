# Codex 向け補足ガイド (研究・シミュレーション向け Python 中心)

このファイルは、このリポジトリで OpenAI Codex を使うときのために、ルートの `AGENTS.md` を補足するものである。
置き換えではなく、ルートの指示とあわせて使うこと。

## 目的

- `everything-claude-code` の設計意図を Codex 向けに移し替える。
- Python-first、test-first、review-heavy の進め方を維持する。
- 無線通信シミュレーション、数値実験、CSV 処理、可視化、論文執筆に合うように寄せる。
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
2. Python スクリプトや Python 製ツールの実行は、基本 `uv` を使い、`python` や `pytest` を直接呼ぶ代わりに `uv run ...` を優先する。
3. 設計思想、命名規約、既存パターンを把握し、現在の構造に沿う。
4. 必要に応じて標準仕様、論文、実測値、一次情報の docs を確認する。
5. 新しい振る舞いやバグ修正では test-first を優先する。
6. 差分は小さく保ち、現在の構造に沿わせる。
7. まず最小限の relevant scope を検証し、必要に応じて広げる。
8. 実験コードでは、seed、shape、dtype、device、入出力列名、単位が保たれているかを確認する。
9. 重要な変更では、関連ドキュメントや instructions の更新まで責任を持つ。
## Python coding rules

- `PEP 8` を守り、関数シグネチャには型ヒントを付ける。
- `os.path` より `pathlib.Path` を優先する。
- `%` formatting や `.format()` より f-string を優先する。
- 場当たり的な `print()` デバッグより `logging` を優先する。
- ビジネスロジックは framework や I/O の glue code から分離する。
- 引数が増えてきたら `dataclass` や DTO 的な明確なオブジェクトを検討する。
- `NumPy` や tensor を扱う関数では、shape と axis の意味が読み取れる命名を優先する。
- `Pandas` や `CSV` 処理では、列名、index、欠損値、型変換の前提を暗黙にしない。
- `Matplotlib` などの可視化では、タイトル、軸ラベル、凡例、保存先をコード上で追いやすくする。
- `NVIDIA Sionna` や `TensorFlow` を使う場合は、API のバージョン依存挙動を思い込みで補わない。

## 禁止事項・アンチパターン

- プロプライエタリ依存や非標準実装を安易に増やさない。
- 冗長でノイズになるコメントを書かない。例として `# 変数iをインクリメント` のような自明な説明は避ける。
- マジックナンバーを直接埋め込まず、定数、設定、根拠付きのパラメータとして扱う。
- 測定方式、評価指標、集計条件をハードコードせず、差し替えや追跡ができる形にする。
- モジュール分離や責務境界を壊す近道の実装を避ける。
- 重要な変更では、関連ドキュメントや instructions の更新漏れを残さない。
-
## テストとレビュー

- 既定の testing framework は `pytest` とする。
- unit、integration、重要な regression path をカバーする。
- テスト不足、例外の握りつぶし、弱い validation、型の drift は実際の不具合として扱う。
- レビュー所見は、style より先に correctness、regression、security、test gap を優先する。
- 数値系コードでは、shape mismatch、閾値の取り違え、集計軸違い、seed 非固定、期待列欠落を高優先で見る。

## セキュリティ

- secret、key、password、token をハードコードしない。
- 外部入力、ファイル内容、API response は未信頼データとして扱う。
- parameterized query と安全な subprocess invocation を使う。
- path traversal、unsafe deserialization、広すぎる例外処理に注意する。

## コミットメッセージ生成ルール

日本のソフトウェア開発チームの一員として、コミットメッセージは次のルールに従う。

- 言語は日本語のみとし、英語本文は使わない。
- 1 行目は `<type><emoji>: <summary>` 形式を使う。
- 1 行目は 50 文字以内で、要点を簡潔に記述する。
- 2 行目は空行にする。
- 3 行目以降に、変更の理由、背景、詳細を記述する。
- 種類は `feat`、`fix`、`docs`、`style`、`refactor`、`test`、`chore` を使う。

## コミュニケーション

- ユーザーへの説明は日本語を基本とし、必要に応じて英語の識別子やコマンドを併記する。
- レビュー所見は、まず重大な問題、次にリスク、最後に改善案の順で伝える。
- 不明点がある場合は、勝手に大きく逸脱せず、妥当な仮定を置いて最小変更で進める。
## ローカル Codex roles

- `python_dev`: シミュレーション、データ処理、可視化を含む Python 実装と集中的なバグ修正, `high`
- `python_architect`: 実験コードの分解、設計、リスクの高い refactor, `xhigh`
- `python_reviewer`: correctness と再現性を重視した review, `xhigh`
- `explorer`: read-only の根拠収集, `high`
- `docs_researcher`: Sionna / TensorFlow / Python ライブラリの docs と API の確認, `high`
- `jp_paper_latex`: 日本語学術 LaTeX の執筆・推敲, `high`
- `en_paper_latex`: 英語学術 LaTeX の執筆・推敲, `high`

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

- `uv run pytest`
- `uv run pytest --cov=src --cov-report=term-missing`
- `uv run ruff check .`
- `uv run black --check .`
- `uv run isort --check-only .`
- `uv run bandit -r src/`

## 並列作業の指針

- 編集を委譲する前に、read-only の調査には `explorer` を使う。
- 実装後はまず対象テストや最小検証コマンドで確認し、必要なら docs 確認や追加検証へ広げる。

## 対応手順

1. 既存コードと関連ドキュメントを分析する。
2. 設計思想、命名規約、既存パターンを把握する。
3. 必要に応じて標準仕様、論文、実測値を参照する。
4. 一貫性、拡張性、保守性を確認する。
5. 実装提案または実装を行い、必要なら設計根拠を簡潔に説明する。
6. テストと検証を行う。
7. 重要な変更では関連ドキュメントを更新する。

このルールに従い、LAB_simulation プロジェクトの高品質な開発と運用を支援すること。
