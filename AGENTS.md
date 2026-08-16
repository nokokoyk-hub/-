# AGENTS.md — ちゃぴ設定リポ（Codex用）

このリポジトリは、のん × ちゃぴチームのAI設定を管理する正本です。

## 最初に読むもの

1. `codex-kit/global/AGENTS.md` — Codex共通のちゃぴ人格・応対・安全・作業ルール
2. `shared/AI_WORKFLOW.md` — Notion・GitHub・Obsidian・各種チャットの役割分担と突合せ手順
3. `README.md` — このリポの構成と入口
4. `docs/current_state.md` と最新の `docs/handoff/` — 現在地と次の作業
5. 変更対象に応じて `codex-kit/` または `claude-kit/` 配下のREADME・設定・skills

`codex-kit/global/AGENTS.md` の「ちゃぴ」設定は、このリポ内でも必ず適用してください。

## 作業ルール

- 日時は日本時間（JST）で確認する。
- 作業前に、修正対象・関係ファイル・読むファイル・波及箇所・変更しない箇所を整理する。
- 指定箇所だけでなく、関連する設定・参照先・導入手順への影響を確認する。
- Claude Code用ファイルをCodex向けへ流用するときは、ファイル名・ツール名・エージェント仕様の違いをそのままコピーしない。
- 既存の `claude-kit/` を壊さず、共通方針は `shared/`、Codex固有設定は `codex-kit/`、Claude固有設定は `claude-kit/` へ分ける。
- 秘密情報をコミットしない。このリポは公開されている前提で扱う。
- mainへ直接書かず、原則として `codex/` ブランチとPRを使う。
- コミットメッセージとPR本文は、変更理由・影響・確認結果が分かる日本語で書く。

## Codex設定の正本

- 全リポ共通のCodex設定：`codex-kit/global/AGENTS.md`
- Codexクラウドへの導入：`codex-kit/setup.sh`
- このリポ固有のCodex設定：ルートの `AGENTS.md`
- 導入・確認手順：`codex-kit/README.md`

変更はこのリポを先に直し、PRを確認してmainへマージしてから各環境へ反映します。

## 正本

- 全体の担当・優先順位・進捗要約はNotion。
- 各プロジェクトの実コード・正確な進捗・構成・北極星はGitHub。
- AI共通の横断記憶・判断理由・失敗・環境知識はObsidian。
- 詳細は `shared/AI_WORKFLOW.md` に従う。

---

のん × ちゃぴ ☕🔥
