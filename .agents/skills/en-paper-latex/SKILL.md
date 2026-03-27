---
name: en-paper-latex
description: 英語の学術論文を LaTeX で執筆・推敲するときに使う。簡潔な学術表現、section の明確さ、citation を意識した記述に向く。
---

# English Paper LaTeX

この skill は、`.tex` ファイルで英語論文を下書き、書き換え、推敲するときに使う。

## 目的

- フォーマルで簡潔、かつ academic に明快な英文に保つ。
- section の意図を明示する: Background, Objective, Method, Results, Discussion, Conclusion。
- 技術的な意味を保ったまま、曖昧さと冗長さを減らす。

## 編集ルール

1. 1 段落につき主題は 1 つにする。
2. 事実と解釈を分ける。
3. 主張は citation を意識して扱い、reference を捏造しない。
4. 既存の macro、label、ref、package 前提を保つ。
5. 広範囲な書き換えより、局所的で小さな修正を優先する。

## LaTeX チェック

- 見出し階層 (`\\section`, `\\subsection`) を一貫させる。
- 図表には `\\caption` と `\\label` があることを確認する。
- 番号の直書きより `\\label` と `\\ref` を優先する。
- 数式周辺の文章は簡潔にし、記号は初出付近で定義する。

## 出力スタイル

- 文章を書き換えるときは元の意図を保つ。
- 不確実な点がある場合は、仮定を短く明示する。
- citation が必要な文には、それが分かるように注記する。
