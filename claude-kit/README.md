# ちゃぴ設定キット ☕🔥

のん × ちゃぴチームの Claude Code 設定一式。**このリポジトリが設定の正本（バックアップ兼マスター）**。
特定のモデルに依存しない書き方にしてあるので、モデルが世代交代しても中身を変えずに使い続けられる。

## 中身

```
claude-kit/
├── global/
│   ├── CLAUDE.md              ← 全リポジトリ共通のちゃぴ設定（v2）
│   ├── agents/
│   │   ├── reviewer.md        ← レビュアーちゃぴ（レビュー・設計／Opus 系）
│   │   ├── zundamon.md        ← ずんだもん（実装／Sonnet 系）
│   │   └── lamchan.md         ← ラムちゃん（テスト・デバッグ／Sonnet 系）
│   └── skills/
│       ├── kickoff/SKILL.md   ← /kickoff  作業開始の儀式
│       ├── wrapup/SKILL.md    ← /wrapup   作業終了の儀式（北極星更新など）
│       └── implement/SKILL.md ← /implement 実装パイプライン
└── README.md                  ← これ
```

## 導入方法

### パソコンの Claude Code に入れる場合

ターミナルは触らなくてええよ。Claude Code のセッションでちゃぴにこう頼むだけ：

> このリポジトリの claude-kit/global の中身を ~/.claude/ に反映して

（`CLAUDE.md` → `~/.claude/CLAUDE.md`、`agents/` → `~/.claude/agents/`、`skills/` → `~/.claude/skills/` にコピーされれば完了）

### 特定のリポジトリだけに入れる場合（Web 版でも効く）

対象リポジトリのセッションでちゃぴにこう頼む：

> nokokoyk-hub/- の claude-kit/global の agents と skills をこのリポの .claude/ に入れて、CLAUDE.md の内容をこのリポの CLAUDE.md に取り込んで

リポジトリにコミットされるので、Web 版・スマホからのセッションでも毎回読み込まれる。

## 使い方（毎日の流れ）

1. セッション開始 → `/kickoff` （現在地と今日の計画を確認）
2. まとまった実装 → `/implement` （実装→テスト→レビューが自動で回る）
3. 軽い相談・小修正 → 普通にちゃぴと会話
4. 終わるとき → `/wrapup` （ダイジェスト・北極星更新・引き継ぎメモまで完遂）

## 設定を変えたいとき

このリポジトリのファイルを直してから、上の導入方法でもう一度反映する。
**「使ってる環境の設定だけ直して、このリポを直し忘れる」のが一番の事故のもと**なので、必ずこっちを先に直すこと。
