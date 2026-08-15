# current_state.md — 北極星ファイル（設定キットリポ）

最終更新：2026-08-15（JST）

## このリポジトリは何か

のん × ちゃぴ ☕🔥 チームの Claude Code 設定一式（ちゃぴ設定キット）の**正本（マスター兼バックアップ）**。
プロダクト開発はここでは行わない。プロダクトは各専用リポジトリ（ojuken-manager など）で開発する。

加えて、**AI共通の記憶基盤（Notion / GitHub / Obsidian）をどう繋ぐか**の手順書もここに置く。

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
shared/
└── AI_WORKFLOW.md              ← Notion・GitHub・Obsidian・各種チャットの正本分担（共通方針の正本）
AGENTS.md                       ← Codex 用のリポジトリ指示
docs/                           ← このリポ自身の記録
├── current_state.md            ← これ（北極星）
├── lessons.md                  ← ちゃぴの経験メモ
├── setup-obsidian-github.md    ← Obsidian Vault を GitHub に繋ぐ手順（のん専用・実施済み）
├── digests/                    ← 日次ダイジェスト
└── handoff/                    ← 次回引き継ぎメモ
```

## 配布の仕組み（2026-07-09 に修理・実証済み）

- **リポジトリは公開（public）**。これが配布の前提条件（非公開だと raw URL が404になり配布が静かに失敗する）
- claude.ai の環境「デフォルト」のセットアップスクリプトに以下の1行が入っており、**どのリポのセッションでも起動時に最新キットが自動で入る**：
  `curl -fsSL https://raw.githubusercontent.com/nokokoyk-hub/-/main/claude-kit/setup.sh | bash`
- キットの変更は **main にマージされてから有効**になる
- 動作確認方法：新セッションで「キット入ってる？」→ 関西弁のちゃぴが返ってくればOK

## AI記憶基盤の接続状況（2026-08-15 完成）

3つの正本すべてが、ちゃぴ（クラウド）から到達可能になった。

| 正本 | 実体 | ちゃぴから | 備考 |
|---|---|---|---|
| **Notion**（全体司令塔） | Notion ワークスペース | ✅ | MCP 接続 |
| **GitHub**（現場正本） | 各プロジェクトリポジトリ | ✅ | |
| **Obsidian**（AI共通の外部脳） | `nokokoyk-hub/Obsidian-Vault-` | ✅ | **2026-08-15 接続** |

### Obsidian（AI開発脳）の構成

```
のん（Obsidian）
   ↕ Obsidian Git プラグイン（10分ごとに自動 commit-and-sync / 起動時 auto pull）
GitHub: nokokoyk-hub/Obsidian-Vault-（Private）
   ↕ add_repo
ちゃぴ（クラウドセッション）

Codex（のんのPC）→ ローカル Vault を MCP 経由で直接読み書き
```

- **Vault の実体**：`C:\Users\nokok\Obsidian Vault`（OneDrive の**外**）
- **AI開発脳の正本パス**：`C:\Users\nokok\Obsidian Vault\AI開発脳\`
- **リポジトリ名は `Obsidian-Vault-`（末尾ハイフン）**。ちゃぴが繋ぐときは正確な名前が要る
- **旧 Vault**（`OneDrive\ドキュメント\Obsidian Vault`）は安全網として**凍結**。読み書き・検索いずれもしない
- 手順の詳細と事故例は `docs/setup-obsidian-github.md` に集約

## 稼働中のシステム

1. **ちゃぴ人格＋開発ルール**（共通 CLAUDE.md v2）
2. **儀式**：開始 `/kickoff`・終了 `/wrapup`・実装 `/implement`
3. **学びの記録システム**：各プロダクトリポの `docs/lessons.md` に経験を書き溜め、`/kickoff` で読み `/wrapup` で追記・棚卸し。整合性チェック＋化石化防止ルールつき
4. **Web版チャット用指示文**：`claude-kit/web-chat/PROJECT_INSTRUCTIONS.md`（のんがチャット側に貼って使う）
5. **AI開発脳（Obsidian）**：ちゃぴ・Codex 共通の外部脳。自動同期で常時つながっている

## 残タスク

- のん：Web版チャットのプロジェクト指示欄に PROJECT_INSTRUCTIONS.md を貼る（→ 貼ったら Sonnet 5 の挙動が改善するか検証）※2026-07-09 からの持ち越し
- 旧 Vault（OneDrive 配下）の削除判断。1〜2週間の様子見後（目安：2026-08 下旬）
- デスクトップへ退避した入れ子フォルダ（`.git` と `.gitattributes` のみ）の削除

## 変更するときの鉄則

- **必ずこのリポを先に直す**（使ってる環境だけ直すのが一番の事故のもと）
- 反映は main マージ後。作業はブランチ→PR→のん承認の流れ
- 保存場所や参照先を変えるときは、**そこを読み書きしている人・ツールを先に全部洗い出す**
  （2026-08-15 の教訓。詳細は `docs/lessons.md`）
