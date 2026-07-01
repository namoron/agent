# agent

このPC（複数台）で共通の，Claude Code / Codex のユーザレベル方針を管理するrepoです．

## 中身

- `user-level/CLAUDE.md`：Claude Code のユーザ共通方針の正本．`~/.claude/CLAUDE.md` から `@import` で参照される．
- `user-level/AGENTS.md`：Codex のユーザ共通方針の正本．`~/.codex/AGENTS.md` から実ファイルsymlinkされる．

内容は，プロジェクトの種類（研究・Web開発・その他）を問わず共通する最小限の方針（モデル方針，作業スタイル，コミュニケーション，コミットメッセージ規則，安全性）に限る．
プロジェクト固有の詳細ルールは，各プロジェクトの`AGENTS.md`/`CLAUDE.md`に書く．

## 複数PCでのセットアップ

1. このrepoを `~/repo/agent` にclone する．
2. `~/.claude/CLAUDE.md` に `@` + このrepoの `user-level/CLAUDE.md` の絶対パスを1行書く．
3. `~/.codex/AGENTS.md` を，このrepoの `user-level/AGENTS.md` への実ファイルsymlinkにする（Windowsでは開発者モードが必要）．

## 経緯

以前はここに研究・Python向けのagentテンプレート一式（`AGENTS.md`，`CLAUDE.md`，`agents/`，`.codex/`，`.github/`，`workspace-entry-template/`）を置いていましたが，
実運用側（各研究repo）が独自に進化して内容が乖離し，同期されないまま陳腐化したため削除しました．
現在はユーザレベル共通方針の配布だけに役割を絞っています．
