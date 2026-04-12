# workspace-entry-template

このディレクトリは直接使うものではなく、各ワークスペースのルートへコピーして使うための入口ファイル雛形である。

## 想定レイアウト

この雛形は、共有設定 repo がワークスペース直下の `agent/` に置かれている前提で書かれている。

```text
your-workspace/
├─ agent/
│  ├─ AGENTS.md
│  ├─ CLAUDE.md
│  ├─ .codex/
│  ├─ .github/
│  └─ agents/
├─ AGENTS.md
├─ CLAUDE.md
├─ .codex/
└─ .github/
```

## 使い方

1. `agent/` repo をワークスペース直下へ置く。
2. この `workspace-entry-template/` の中身を、対象ワークスペースのルートへコピーする。
3. `agent/` のディレクトリ名を変えた場合は、コピー先ファイル内の参照パスも更新する。

## 含まれる入口

- `AGENTS.md`: 共通入口。Codex の起点にも使う。
- `CLAUDE.md`: Claude Code 用の入口。
- `.codex/AGENTS.md`: Codex 用の tool-specific bridge。
- `.github/copilot-instructions.md`: GitHub Copilot 用の入口。
- `.github/AGENTS.md`: Copilot 用の補助入口。

## 補足

- この雛形は「入口だけ」を置くためのものであり、full feature をすべて workspace 側へ複製するものではない。
- Claude の subagent、Codex の `.codex/agents/*.toml`、Copilot の `.github/agents/*.agent.md` などの本体は `agent/` 側を参照する前提である。
