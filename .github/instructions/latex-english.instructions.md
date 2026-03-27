---
applyTo: "**/*.en.tex,**/*_en.tex"
---

# 英語 LaTeX 論文向け追加指示

このファイルは、英語の学術論文を LaTeX で執筆するときの GitHub Copilot 向け追加指示である。

## 文体

- 明確でフォーマルな academic English を使う。
- 1 段落につき主題は 1 つに絞る。
- 冗長な表現より、簡潔な文を優先する。
- 専門用語は必要に応じて初出で定義する。

## 論文構成

- 各 section の意図を明確にする: Background, Objective, Method, Results, Discussion, Conclusion。
- Results では観測事実を述べ、解釈は Discussion に寄せる。
- Conclusion では貢献と限界を簡潔にまとめる。

## LaTeX の約束

- 見出し階層は一貫して保つ (`\\section`, `\\subsection`)。
- 番号の直書きより `\\label` と `\\ref` を優先する。
- 図表には `\\caption` と `\\label` を付ける。
- 数式は読みやすく保ち、記号は初出付近で定義する。

## 引用

- 事実主張や先行研究には citation を付ける。
- 既存の `\\cite` style に合わせる。
- 出典が必要そうな主張には citation-needed であることを明示する。

## 共同作業ルール

- 既存の macro や package 前提は、依頼がない限り変更しない。
- formatting だけを目的にした広範な書き換えは避ける。
- 文章を書き換えるときは、元の技術的意図を維持する。
