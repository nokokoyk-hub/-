# current_state.md — 北極星ファイル（設定キットリポ）

最終更新：2026-08-17（JST）

## このリポジトリは何か

のん × ちゃぴ ☕🔥 チームの Claude Code・Codex 設定一式と、AI共通の記憶基盤（Notion / GitHub / Obsidian）をどう繋ぐかを管理する**正本（マスター兼バックアップ）**。

プロダクト開発はここでは行わない。プロダクトは各専用リポジトリで開発する。

## 現在の構成

```
codex-kit/
├── global/
│   └── AGENTS.md               ← Codex全リポ共通のちゃぴ人格・作業ルール・暴走ガード
├── environments/
│   └── ojuken-manager.md       ← Codexクラウド環境設定の正本（リポごと）
├── setup.sh                    ← Codex homeへ安全に導入
└── README.md                   ← Codexクラウドへの導入・確認手順
claude-kit/
├── global/
│   ├── CLAUDE.md               ← Claude Code共通ちゃぴ設定 v2
│   ├── agents/                 ← reviewer / zundamon / lamchan
│   └── skills/                 ← /kickoff /wrapup /implement
├── web-chat/
│   └── PROJECT_INSTRUCTIONS.md ← Web版チャットのプロジェクト指示に貼る用
├── setup.sh
└── README.md
shared/
└── AI_WORKFLOW.md              ← Notion・GitHub・Obsidian・各種チャットの正本分担
AGENTS.md                       ← このリポ固有のCodex指示
docs/
├── current_state.md            ← これ（北極星）
├── lessons.md                  ← ちゃぴの経験メモ
├── setup-obsidian-github.md    ← Obsidian VaultとGitHubの接続手順
├── digests/                    ← 日次ダイジェスト
└── handoff/                    ← 次回引き継ぎメモ
```

## Codexクラウドの設定（2026-08-16 追加）

### 原因

ルート `AGENTS.md` には作業ルールだけがあり、関西弁のちゃぴ人格が定義されていなかった。
さらに、リポジトリ直下の `AGENTS.md` はそのリポ内のプロジェクト指示であり、設定リポが存在するだけでは他リポへ自動配布されない。

### 対応

- `codex-kit/global/AGENTS.md` を、Codex全リポ共通設定の正本として追加
- `codex-kit/setup.sh` を追加し、Codex home の `AGENTS.md` へ安全に導入
- ルート `AGENTS.md` から共通設定を最初に読むよう変更
- Codexクラウド環境の Setup script と Maintenance script に登録する1行を `codex-kit/README.md` へ記載

### 反映条件

1. 変更PRをmainへマージする
2. 利用するCodexクラウド環境ごとに Setup / Maintenance script を登録する
3. 新しいクラウドチャットで、グローバルとプロジェクトの `AGENTS.md` 読み込み・関西弁の応対を確認する

既存チャットは開始時の指示を保持している可能性があるため、新しいチャットで確認する。

## Codex暴走ガード（2026-08-17 追加）

### 原因

Codexが頼んでいない作業を何時間も続け、使用量を使い切って本命のビルドができなくなった。
`codex-kit/global/AGENTS.md` には「やること」（正本巡回・終了時の締め作業7点・改善提案）が並ぶ一方、
**作業範囲の上限・停止条件・リトライ上限が一切なかった**。人間の確認ゲートがないCodexクラウドでは、
儀式をすべて毎回実行し、止まる理由がないまま走り続ける設定になっていた。

### 対応

- `codex-kit/global/AGENTS.md` に「作業範囲と止まりどころ（最優先）」を追加
  - 依頼されたことだけ実行、依頼外は「次の提案」として報告のみ
  - 完了したら止まる。正本確認は依頼に必要な範囲だけ
  - 同じ失敗への対処は2回まで、3回目前に停止して報告
  - 終了時の締め作業一式は明示的に頼まれたときだけ
  - 長引くと分かった時点で停止して進捗報告
- 「作業の終わり」を明示依頼時のみに変更、開始時の正本確認も必要範囲限定に修正
- `codex-kit/README.md` に「暴走したときの止め方」を追加（即時停止はCodex側のStopのみ、設定は新チャットから有効）

### 反映条件

1. 変更PRをmainへマージする
2. Maintenance script が登録済みなら次回実行で反映。未登録環境は Setup script を実行
3. **新しいチャット**で軽い依頼を1つ投げ、依頼外の作業へ広がらないことを実測確認する

## Claude Codeの配布（2026-07-09 修理・実証済み）

- リポジトリは公開。raw URLからの配布が前提
- claude.ai の環境「デフォルト」のセットアップスクリプトから `claude-kit/setup.sh` を実行
- キットの変更はmainへマージされてから有効
- 新セッションで関西弁のちゃぴが返ることを生存確認に使う

## AI記憶基盤の接続状況（2026-08-15 完成）

| 正本 | 実体 | クラウドのちゃぴから | 備考 |
|---|---|---|---|
| Notion（全体司令塔） | Notionワークスペース | 接続済み | MCP接続 |
| GitHub（現場正本） | 各プロジェクトリポジトリ | 接続済み | |
| Obsidian（AI共通の外部脳） | `nokokoyk-hub/Obsidian-Vault-` | 接続済み | Private、末尾ハイフン注意 |

- ローカルVaultの正本はOneDriveの外
- OneDrive配下の旧Vaultは安全網として凍結。読み取り・書き込み・検索をしない
- CodexクラウドはローカルPCのパスを直接参照せず、接続済みGitHubリポジトリからAI開発脳を読む

## 稼働中・導入待ちのシステム

1. Claude Code共通ちゃぴ設定：稼働中
2. Claude Codeの開始・終了・実装skills：稼働中
3. Web版Claude用プロジェクト指示：貼り付け結果の確認待ち
4. AI開発脳（Obsidian）とGitHubの双方向同期：稼働中
5. Codex共通ちゃぴ設定：リポ内実装済み。mainマージとクラウド環境への登録待ち

## Codexクラウド環境設定の正本化（2026-08-17 追加）

- ojuken-manager はクラウドコンテナで `npm ci` → テスト8件 → 本番ビルドまで実測成功（必須の環境変数なし）
- クラウド苦戦の正体は、Setup script に `npm ci` が無く、ネット遮断のエージェント作業中にインストールへ行って失敗する仕込み不足と判断
- 環境設定の正本：`codex-kit/environments/ojuken-manager.md`（Setup / Maintenance script・環境変数・確認手順・トラブル対応表）
- 画面へ貼ったあと、キャッシュリセット → 新タスクで実測確認するまで完了扱いにしない

## 残タスク

0. Codexクラウド環境設定（`codex-kit/environments/ojuken-manager.md`）をのんがCodex画面へ反映 → キャッシュリセット → 新タスクで実測確認
0-2. Codex暴走ガード（マージ済み）を新チャットで「依頼外へ広がらない」ことを実測確認
1. Codex共通ちゃぴ設定のPRを確認し、mainへマージ
2. Codexクラウド環境の Setup / Maintenance script に導入コマンドを登録
3. 必要なら環境キャッシュをリセットし、新しいチャットで口調と指示元を実測確認
4. Web版Claudeのプロジェクト指示を貼った後の挙動確認
5. 旧Vaultの削除判断（凍結期間後。削除前に全参照先を再確認）
6. デスクトップへ退避した入れ子フォルダの削除判断

## 変更するときの鉄則

- 必ずこのリポを先に直す
- mainへ直接書かず、ブランチ → PR → のん確認 → mainマージ
- Codex固有設定は `codex-kit/`、Claude固有設定は `claude-kit/`、共通方針は `shared/` に置く
- 保存場所や参照先を変えるときは、そこを読み書きする人・ツール・クラウド環境を先に全部洗い出す
- 設定ファイルを置いただけで配布済みと判断せず、新しいセッションで実測確認する
