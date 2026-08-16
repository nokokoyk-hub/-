# のん × ちゃぴ ☕🔥 設定リポジトリ

Claude Code・Codex・各種AIチャットで使う「ちゃぴチーム」の設定と、共通の作業ルールを管理するリポジトリ。

## 共通ルール

- [AI共有基盤の役割分担](shared/AI_WORKFLOW.md) — Notion・GitHub・Obsidian・各種チャットの正本分担と突合せ手順
- [AGENTS.md](AGENTS.md) — このリポをCodexで開いたときの指示

## Codex

- 共通ちゃぴ設定 → [codex-kit/global/AGENTS.md](codex-kit/global/AGENTS.md)
- Codexクラウドへの導入と確認 → [codex-kit/README.md](codex-kit/README.md)
- 導入スクリプト → [codex-kit/setup.sh](codex-kit/setup.sh)
- このリポ内では、ルートの `AGENTS.md` がCodex共通設定を最初に読む

## Claude Code

- 設定本体と導入手順 → [claude-kit/README.md](claude-kit/README.md)

## 反映の原則

設定変更はこのリポを先に直し、`codex/` または担当AI用のブランチからPRを作る。確認後にmainへマージし、必要なクラウド環境へ反映する。

## 安全

このリポは公開リポジトリ。パスワード、APIキー、トークン、秘密鍵、公開すべきでない個人情報はコミットしない。
