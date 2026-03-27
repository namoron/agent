---
name: python-patterns
description: Python コードの設計や refactor で、構造、型付け、service、DTO、validation、テストしやすい境界の作り方に迷うときに使う。
---

# Python Patterns

この skill は、Python コードが「何をするか」だけでなく、「どう構成するか」を決めるときに使う。

## 基本パターン

- module は焦点を絞り、責務の混ざった巨大ファイルを避ける。
- ビジネスルールは transport、CLI、ORM、framework glue から分離する。
- 隠れた mutation より、明示的な data flow を優先する。
- 単純な DTO や設定データには `dataclass` を使う。
- 呼び出し側が具体実装ではなく振る舞いに依存すべきなら `Protocol` を使う。

## 関数設計

- 関数は小さくし、入力と出力を明確にする。
- 渡された object を変更するより、値を返す形を優先する。
- シグネチャが混み合ってきたら、繰り返しパラメータを `dataclass` にまとめる。
- 失敗を黙って握りつぶさず、具体的な例外か明示的な domain result を返す。

## 境界設計

- 外部入力は境界で検証する。
- 必要なら framework object を plain Python structure に変換してから深いビジネスロジックへ渡す。
- side effect はシステムの端に寄せ、unit test を単純に保つ。

## よくある選択

- file path: `pathlib.Path`
- 文字列整形: f-string
- resource cleanup: context manager
- 構造化された共有データ: `dataclass` または `NamedTuple`
- 振る舞いによる抽象化: `Protocol`

## Refactor するとき

1. まずビジネスロジックと side effect の境目を見つける。
2. pure logic を先に切り出す。
3. コードを動かす前に、テストで振る舞いを保護する。
4. そのあとで call site や naming を簡潔にする。
