---
name: python-review
description: Python の変更を、バグ、回帰、テスト不足、型の問題、セキュリティリスクの観点でレビューするときに使う。style だけの指摘ではなく、リスク優先のコードレビュー向け。
---

# Python Review

この skill は、Python コードのレビューや、merge 前の差分 sanity check を依頼されたときに使う。

## レビュー順序

1. correctness と振る舞いの回帰
2. 例外処理と edge case
3. 足りない、または弱いテスト
4. 型安全性と保守性
5. セキュリティ上の懸念

## 見るポイント

- 例外の握りつぶしや、広すぎる `except`
- mutable default argument
- システム境界での validation 不足
- unsafe な subprocess 利用や shell 文字列補間
- 文字列連結や f-string で組み立てた SQL
- ユーザー制御 path による path traversal risk
- loop 内での N+1 query や繰り返し I/O
- 公開関数に有用な型ヒントがないこと
- 変更された分岐や failure path をカバーしていないテスト

## 出力スタイル

- 要約より先に finding を出す。
- finding は重大度順に並べる。
- file、振る舞い、影響を具体的に示す。
- 振る舞いが変わったなら、テスト不足は実際のリスクとして扱う。

## 役立つ command

- `git diff -- '*.py'`
- `pytest path/to/test_file.py`
- `ruff check .`
- `black --check .`
- `bandit -r src/`

## レビュー基準

高密度で無駄のないフィードバックを優先する。
リスクを明確に下げる場合を除き、広い cleanup は勧めない。
