# current_state.md — 北極星ファイル（設定キットリポ）

最終更新：2026-07-09（JST）

## このリポジトリは何か

のん × ちゃぴ ☕🔥 チームの Claude Code 設定一式（ちゃぴ設定キット）の**正本（マスター兼バックアップ）**。
プロダクト開発はここでは行わない。プロダクトは各専用リポジトリ（ojuken-manager など）で開発する。

## 現在の構成

```
claude-kit/
├── global/
│   ├── CLAUDE.md               ← 共通ちゃぴ設定 v2（lessons.md 対応済み）
│   ├── agents/                 ← reviewer / zundamon / lamchan
│   └── skills/                 ← /kickoff /wrapup /implement（学びの記録システム組み込み済み）
├── web-chat/
│   └── PROJECT_INSTRUCTIONS.md ← Web版チャット（claude.ai）のプロジェクト指示に貼る用
├── setup.sh                    ← インストーラ（環境のセットアップスクリプトから curl 実行）
└── README.md
docs/                            ← このリポ自身の記録（digests / handoff / lessons.md / これ）
```

## 配布の仕組み（2026-07-09 に修理・実証済み）

- **リポジトリは公開（public）**。これが配布の前提条件（非公開だと raw URL が404になり配布が静かに失敗する）
- claude.ai の環境「デフォルト」のセットアップスクリプトに以下の1行が入っており、**どのリポのセッションでも起動時に最新キットが自動で入る**：
  `curl -fsSL https://raw.githubusercontent.com/nokokoyk-hub/-/main/claude-kit/setup.sh | bash`
- キットの変更は **main にマージされてから有効**になる
- 動作確認方法：新セッションで「キット入ってる？」→ 関西弁のちゃぴが返ってくればOK

## 稼働中のシステム

1. **ちゃぴ人格＋開発ルール**（共通 CLAUDE.md v2）
2. **儀式**：開始 `/kickoff`・終了 `/wrapup`・実装 `/implement`
3. **学びの記録システム**：各プロダクトリポの `docs/lessons.md` に経験を書き溜め、`/kickoff` で読み `/wrapup` で追記・棚卸し。整合性チェック＋化石化防止ルールつき
4. **Web版チャット用指示文**：`claude-kit/web-chat/PROJECT_INSTRUCTIONS.md`（のんがチャット側に貼って使う）

## 残タスク

- のん：Web版チャットのプロジェクト指示欄に PROJECT_INSTRUCTIONS.md を貼る（→ 貼ったら Sonnet 5 の挙動が改善するか検証）

## 変更するときの鉄則

- **必ずこのリポを先に直す**（使ってる環境だけ直すのが一番の事故のもと）
- 反映は main マージ後。作業はブランチ→PR→のん承認の流れ
