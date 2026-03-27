# GitHub Copilot 向け補足ガイド

このファイルは、GitHub Copilot と GitHub Copilot coding agent 向けに、ルートの `AGENTS.md` を補足するものである。

## 適用範囲

- リポジトリ全体で共通の振る舞いはルートの `AGENTS.md` で定義する。
- Copilot 固有の応答方針は `.github/copilot-instructions.md` で定義する。
- Python 固有の振る舞いは `.github/instructions/python.instructions.md` でさらに細かく定義する。
- LaTeX 論文執筆向けの振る舞いは `.github/instructions/latex.instructions.md` で定義する。
- 英語 LaTeX 論文執筆向けの振る舞いは `.github/instructions/latex-english.instructions.md` で定義する。
- Copilot custom agent は `.github/agents/` 配下に置く。
- このリポジトリでは、Copilot の repository instructions、path-specific instructions、custom agents、repository hooks を利用する。

## モデル方針

- Copilot Chat では `Claude Sonnet 4.5` または `Claude Opus 4.5` を優先する。
- Claude 系 model が使えない、または premium request を使い切った場合は `Gemini 3 Pro` にフォールバックする。
- Copilot coding agent では、汎用実行よりこのリポジトリの custom agent を優先する。
- coding agent 側で希望 model を明示指定できない場合は、`Auto` または platform default のまま継続してよい。

## Agent selection

- 実装、バグ修正、テスト更新には `.github/agents/python-dev.agent.md` を使う。
- 段階的な計画、refactor、リスクの高い分解には `.github/agents/python-architect.agent.md` を使う。
- レビュー、回帰確認、security 観点の点検には `.github/agents/python-reviewer.agent.md` を使う。
- バージョン依存の docs や API 確認には `.github/agents/docs-researcher.agent.md` を使う。
- 日本語論文の LaTeX 執筆・推敲には `.github/agents/jp-paper-latex.agent.md` を使う。
- 英語論文の LaTeX 執筆・推敲には `.github/agents/en-paper-latex.agent.md` を使う。

## 研究・解析タスクでの前提

- 主な対象は、無線通信シミュレーション、数値実験、CSV 処理、プロット生成、論文執筆である。
- frontend や UI 実装の一般論より、再現性、数値整合性、データ列の意味、shape / dtype の正しさを優先する。
- `NVIDIA Sionna`、`TensorFlow`、`NumPy`、`Pandas`、`Matplotlib` に関わる変更では、API の思い込みより一次情報を優先する。
- 研究コードでは、実験条件、seed、出力先、軸ラベル、単位が追跡可能であることを重視する。

## 作業スタイル

- 変更は小さく、明示的で、レビューしやすい形にする。
- 新しい振る舞いやバグ修正では test-first を優先する。
- Python や Python 製ツールの実行は、基本 `uv` を使い、`uv run python` や `uv run pytest` を優先する。
- 既存のファイル配置、命名、アーキテクチャ境界に合わせる。
- 重要な指摘は、優先度の低い cleanup 提案より先に伝える。

## 現在カバーしている機能

- `.github/copilot-instructions.md` による repository-level custom instructions
- `.github/instructions/python.instructions.md` による path-specific Python instructions
- `.github/instructions/latex.instructions.md` による path-specific LaTeX instructions
- `.github/instructions/latex-english.instructions.md` による path-specific English LaTeX instructions
- 実装、設計、レビュー、docs 調査向けの custom agents
- `.github/hooks/` 配下の repository hooks
- prompt、tool outcome、session 終了時の learning candidate を `.git/copilot-memory/` に残す memory-capture hooks
- GitHub 側で repository MCP を設定している場合の、MCP-aware agent extension

## 安全性

- `.github/hooks/` 配下の repository hook と policy 設定に従う。
- 破壊的コマンドや force-push 系 workflow で repository の安全ルールを迂回しない。必要な場合はユーザーの明示依頼を前提とする。
