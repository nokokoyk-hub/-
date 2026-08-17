# Codexクラウド環境設定 — ojuken-manager（お受験マネージャー）

対象：`nokokoyk-hub/ojuken-manager` を扱うCodexクラウド環境
最終更新：2026-08-17（JST）

## 前提（実測済みの事実）

2026-08-17に、同種のクラウドコンテナ（Node 22 / npm 10）で全経路を実測した。

| 工程 | コマンド | 結果 |
|---|---|---|
| 依存インストール | `npm ci` | ✅ 成功 |
| テスト | `CI=true npx react-scripts test --watchAll=false` | ✅ 8件全部パス |
| 本番ビルド | `npm run build` | ✅ 成功 |

- **必須の環境変数はない**。Supabase接続情報（URL・公開用キー）はコードにフォールバック値があり、環境変数なしでビルド・テストが通る
- `.npmrc` の `legacy-peer-deps=true` はリポに入っており、`npm ci` がそのまま読む。環境側の追加設定は不要

## クラウドで苦戦する典型原因

Codexクラウドは「**Setup / Maintenance script の実行中だけネット有効 → エージェント作業中はネット遮断（デフォルト）**」で動く。

Setup script に `npm ci` が無いと、Codexは作業中に `node_modules` が無いことに気づき、ネットが無い状態で `npm install` を試みて失敗する。失敗の理由（ネット遮断）はエラーからは分かりにくく、リトライや回避策の試行で時間と使用量が溶ける。**「ローカルは安定、クラウドは苦戦」の正体はほぼこれ**（ローカルは一度入れた `node_modules` が残り続けるため）。

## 設定内容（Codexクラウドの環境設定画面に貼る）

### Setup script

```bash
set -euo pipefail

# 1. ちゃぴ共通設定（人格・作業ルール・暴走ガード）
curl -fsSL https://raw.githubusercontent.com/nokokoyk-hub/-/main/codex-kit/setup.sh | bash

# 2. 依存インストール（ネットが使えるのはこの工程だけ。ここで必ず済ませる）
cd /workspace/ojuken-manager
npm ci
```

### Maintenance script

Setup と同じ内容を貼る。キャッシュ済みコンテナでも、最新のちゃぴ設定と lockfile 変更後の依存を取り込むため。

```bash
set -euo pipefail
curl -fsSL https://raw.githubusercontent.com/nokokoyk-hub/-/main/codex-kit/setup.sh | bash
cd /workspace/ojuken-manager
npm ci
```

### Environment variables

登録不要（フォールバック値で動作する）。

Supabase の接続先やキーを切り替えたい場合のみ、次の2つを登録する。

- `REACT_APP_SUPABASE_URL`
- `REACT_APP_SUPABASE_ANON_KEY`（公開用 anon キーのみ。service_role キーは絶対に登録しない）

### Agent internet access

**Off（デフォルト）のままでよい**。ビルド・テスト・実装にネットは不要（実測済み）。
On にする場合は、必要なドメインだけの許可リストにする。全開放はしない。

### コンテナイメージ・ランタイム

デフォルト（universal イメージ）でよい。Node 18〜22 のいずれでも動作する想定（Node 22 で実測済み）。

## 導入後の確認手順（3分）

1. 環境のキャッシュをリセットする（古いコンテナに壊れた状態が残っている可能性があるため、初回は必ず）
2. **新しい**タスクで軽い依頼を投げる：
   > `npm test` と `npm run build` を実行して、結果だけ報告して。終わったら止まってな。
3. 次を確認する：
   - テストとビルドが通る（依存インストールで詰まらない）
   - 関西弁のちゃぴで応対する（共通設定が入っている）
   - 頼んだこと以外へ広がらず、報告して止まる（暴走ガードが効いている）

## トラブルの見分け方

| 症状 | 原因の見当 | 対処 |
|---|---|---|
| `npm install` / `npm ci` がタイムアウト・ENOTFOUND | エージェント作業中のネット遮断 | Setup / Maintenance script に `npm ci` を入れる（このファイルの設定を貼り直す） |
| `react-scripts: not found` | `node_modules` 不在（Setup script 未実行・失敗） | 環境キャッシュをリセットして Setup script を再実行 |
| テストが対話モードで止まる | watch モードで起動している | `CI=true` を付けるか `--watchAll=false` を渡す |
| 敬語のCodexが出てくる | ちゃぴ共通設定が未導入 | Setup / Maintenance script の1行目を確認 |
| 頼んでいない作業を続ける | 暴走ガード未反映（古いコンテナ・古いチャット） | キャッシュリセット＋新しいタスクで再確認 |

## 変更するときの鉄則

この設定を変えるときも、必ずこのリポ（`codex-kit/environments/ojuken-manager.md`）を先に直し、mainマージ後にCodexクラウドの画面へ反映する。画面だけ直すのが一番の事故のもと。

---

のん × ちゃぴ ☕🔥
