# AGENTS.md

このファイルはリポジトリ全体で共有する共通指示です。
ツール固有の補足は次を参照します。

- Codex: `.codex/AGENTS.md`
- GitHub Copilot: `.github/AGENTS.md` と `.github/copilot-instructions.md`

## Priority

agent は次の優先順で指示を解釈すること。

1. 最も近い `AGENTS.md`
2. ツール固有の instructions
3. 実行中の agent / role / profile の prompt

## Shared Workflow

- 変更前に既存コード、関連テスト、近い実装例を読む。
- 複雑な変更は `調査 -> 計画 -> テスト -> 実装 -> 検証` の順で進める。
- 新しい振る舞いは、可能なら先に失敗するテストを作る。
- 差分は小さく保ち、無関係なリネームや大規模整形を混ぜない。
- 実装後は変更範囲に応じて `pytest`、`ruff`、`black`、`isort` などの検証を行う。

## Research And Simulation Focus

- 主な対象は Web アプリではなく、Python による数値実験、通信シミュレーション、データ処理、可視化、論文執筆である。
- `NVIDIA Sionna`、`TensorFlow`、`NumPy`、`Pandas`、`Matplotlib`、`CSV` / `NPY` / `JSON` の入出力をよく使う前提で考える。
- UI や frontend の一般論より、実験再現性、数値整合性、shape / dtype / device の正しさを優先する。
- 実験コードでは seed、設定値、単位、軸ラベル、保存先ファイル名が追跡可能であることを重視する。

## Python Expectations

- 型ヒントを優先し、公開関数・重要関数では省略しない。
- `print()` より `logging` を優先する。
- 文字列整形は基本的に f-string を使う。
- パス操作は `pathlib.Path` を優先する。
- ビジネスロジックは I/O 層から分離し、テストしやすい構造を保つ。
- 配列や tensor を扱う処理では、shape、dtype、軸順、broadcast の前提を明確にする。
- 数値計算では、乱数 seed、前処理条件、正規化、集計単位が変わっていないか確認する。
- プロット生成では、軸、凡例、単位、系列名、出力先がコードから追いやすい形を保つ。

## Review Standard

- レビュー時はバグ、例外漏れ、回帰、型不整合、入力検証不足を最優先で確認する。
- 重要な指摘から先に伝え、必要なら再現条件や影響範囲も簡潔に添える。
- テスト不足は明確なリスクとして扱う。
- シミュレーションコードでは、shape mismatch、dtype drift、seed 漏れ、誤った集計軸、単位違い、CSV 列名不整合を高優先で確認する。

## Safety

- シークレット、トークン、鍵、接続情報をコードやログへ出さない。
- `git reset --hard`、`git clean -fdx`、`rm -rf`、`git push --force` などの破壊的操作は、明示依頼なしに実行しない。
- データ削除、スキーマ破壊、本番設定変更につながる操作は人間の確認を前提とする。
