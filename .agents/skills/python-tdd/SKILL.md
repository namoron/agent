---
name: python-tdd
description: Python の機能追加や修正を test-first で進めるときに使う。シミュレーション、CSV 処理、集計、plot 補助コードの検証も含む。
---

# Python TDD

この skill は、Python の機能追加やバグ修正で test-first が現実的なときに使う。

## 進め方

1. 変えたい振る舞いを 1 文で言い切る。
2. 一番近い既存の test module を見つけ、その構成に合わせる。
3. まず失敗する `pytest` を書く。
4. 最も狭い test target を実行し、想定どおりの理由で失敗することを確認する。
5. そのテストを通すための最小コード変更を実装する。
6. まず対象テストを再実行し、そのあと近いテストへ広げる。
7. 振る舞いがテストで守られてから refactor する。

## テスト設計

- 可能なら 1 テスト 1 振る舞いにする。
- happy path と、最も起こりやすい failure path の両方を押さえる。
- テスト名は実装詳細ではなく振る舞いで付ける。
- 新しい helper を作る前に、既存の fixture や factory を使う。
- 数値系では、shape、列名、期待値、許容誤差、保存ファイル名を明示する。

## Python 前提

- 変更に触れる production code では型ヒントを使う。
- ビジネスロジックは I/O や framework glue から分離する。
- `pathlib.Path`、f-string、`logging` を優先する。
- 乱数やサンプリングを使う場合は、seed や deterministic な条件をテストで固定する。

## 検証

リポジトリにある command だけを使うこと。

- `pytest path/to/test_file.py`
- `pytest -k some_behavior`
- `pytest --cov=src --cov-report=term-missing`
- `ruff check .`

## 中断条件

- 正しい振る舞いが不明な場合は広く推測しない。まず周辺テスト、docstring、呼び出し元コードを読む。
- 失敗テストがより大きな設計問題を示している場合は、変更を広げる前に architecture agent へ切り替える。
