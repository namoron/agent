# GitHub Copilot Repository Instructions

このリポジトリでは、GitHub Copilot は `everything-claude-code` の設計思想を参考にして動作すること。

## Model Policy

- GitHub Copilot Chat や通常の対話では、まず `Claude Sonnet 4.5` または `Claude Opus 4.5` を優先する。
- Chat で上記モデルが利用不可、または使用上限に達している場合は `Gemini 3 Pro` にフォールバックする。
- ユーザーが別モデルを明示していない限り、この優先順位を維持する。
- GitHub Copilot coding agent では `.github/agents/` の custom agent を優先して使う。
- coding agent 側で `Gemini` が選べない環境では、`Auto` またはプラットフォーム既定モデルへフォールバックしてよい。

## Agent Usage

- agent 作業時は、まずリポジトリ直下の `AGENTS.md` を参照する。
- Python の実装や修正には `python-dev` agent を優先する。
- 設計、分解、移行計画には `python-architect` agent を優先する。
- Python のレビューや回帰確認には `python-reviewer` agent を優先する。
- API 仕様やバージョン依存の確認には `docs-researcher` agent を優先する。
- agent は小さな差分、明示的な検証、既存構成との整合を重視する。

## Current Repository Features

- repository instructions
- path-specific Python instructions
- custom agents
- repository hooks
- session memory capture hooks that write learning candidates to `.git/copilot-memory/`
- Codex-compatible skills mirrored under `.agents/skills/`

## Working Style

- いきなり実装に飛び込まず、まず要件・影響範囲・既存実装を確認する。
- 複雑な変更は、`計画 -> テスト -> 実装 -> 検証` の順で進める。
- 新規機能や修正では、可能なら先にテストケースを追加または更新する。
- 小さく焦点の合った変更を優先し、無関係なリファクタリングを混ぜない。
- 説明や提案は簡潔にしつつ、判断理由が分かるようにする。

## Code Quality

- 多数の巨大ファイルより、責務の明確な小さめのファイルを好む。
- 読みやすい命名を優先し、深いネストや過度に長い関数を避ける。
- 既存の設計・命名・ディレクトリ構成に合わせる。
- ハードコード値を増やさず、定数・設定・環境変数に寄せる。
- エラーは握りつぶさず、利用者向けメッセージと開発者向け文脈を分けて扱う。

## Testing And Validation

- 重要な変更では、ユニットテスト・統合テスト・主要フロー検証を意識する。
- 実装後は、変更範囲に応じたテスト・lint・型チェックを優先して提案または実行する。
- テストが失敗した場合は、テストだけを都合よく変えず、原因を切り分けて修正する。

## Security

- シークレット、トークン、秘密鍵、接続情報をコードへ直書きしない。
- 外部入力、API 応答、ファイル入力は常に未信頼データとして扱う。
- SQL、シェル、テンプレート、ファイルパス周りはインジェクションを避ける実装を優先する。
- エラーメッセージに機密情報や内部実装詳細を含めない。

## Communication

- ユーザーへの説明は日本語を基本とし、必要に応じて英語の識別子やコマンドを併記する。
- レビュー時はまず重大な問題、次にリスク、最後に改善案の順で伝える。
- 不明点がある場合は、勝手に大きく逸脱せず、妥当な仮定を置いて最小変更で進める。
