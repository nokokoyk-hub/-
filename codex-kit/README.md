# Codex用ちゃぴ設定キット

CodexクラウドやCodex CLIで、どのリポジトリでも共通の「ちゃぴ」設定を読み込むためのキットです。

## 構成

- `global/AGENTS.md`：全リポジトリ共通の人格・応対・安全・作業ルール
- `setup.sh`：上記ファイルを Codex home の `AGENTS.md` へ安全に導入するスクリプト
- `environments/`：Codexクラウドの環境設定（リポごとの Setup / Maintenance script・環境変数・確認手順）の正本。現在は `ojuken-manager.md`

プロジェクト固有のルールは、各リポジトリ直下の `AGENTS.md` に置きます。Codexはグローバル設定を先に、プロジェクト設定を後に読み込みます。

## Codexクラウドへの導入

この変更が `main` にマージされたあと、Codexの対象環境で次の設定を行います。

### Setup script

```bash
curl -fsSL https://raw.githubusercontent.com/nokokoyk-hub/-/main/codex-kit/setup.sh | bash
```

### Maintenance script

キャッシュ済み環境でも最新版を取り込めるよう、Maintenance script にも同じ1行を設定します。

```bash
curl -fsSL https://raw.githubusercontent.com/nokokoyk-hub/-/main/codex-kit/setup.sh | bash
```

セットアップスクリプトは、取得失敗・空ファイル・想定外の内容を検知した場合にエラーで停止します。既存のグローバル `AGENTS.md` がある場合は、変更前の内容を `AGENTS.md.backup-before-chapi-kit` へ退避します。

## 確認方法

新しいCodexクラウドチャットで、次のように聞きます。

> 今読み込んでいる指示元を教えて。自己紹介もして。

次を確認します。

- グローバルの `~/.codex/AGENTS.md` と対象リポの `AGENTS.md` が認識される
- 「ちゃぴ」と名乗り、自然な関西弁で返す
- 堅すぎる敬語へ戻っていない

設定ファイルはCodexの新しい実行開始時に読み込まれます。古いチャットではなく、新しいチャットで確認してください。

## 暴走したときの止め方

`AGENTS.md` はCodexへの「指示」であり、実行時間や使用量を強制的に制限する仕組みではありません。
頼んでいない作業を延々と続けている・使用量を使い切りそうなときは、次の順で止めます。

1. Codex側（クラウドのタスク一覧やチャット画面）で、実行中のタスクを **Stop / キャンセル** する。これが唯一の即時停止手段
2. 止まったら、新しいチャットで「どこまで何をやったか」を確認し、不要な変更が入っていないかPR・差分を確認する
3. 同じ暴走が繰り返されるなら、`global/AGENTS.md` の「作業範囲と止まりどころ」を見直してこのリポで更新し、mainマージ後に各環境へ再配布する

新しい設定は、mainマージ＋Setup / Maintenance script 実行後の**新しいチャット**から効きます。既に走っている古いタスクには効かないため、まず止めることが先です。

## 注意

- この公開リポジトリへ秘密情報を書かない
- `claude-kit/` はClaude Code用。Codexへそのままコピーしない
- プロジェクト側の `AGENTS.override.md` や、より深い階層の指示が後から優先される場合がある
- 全環境へ自動で一括配布されるわけではない。利用するCodexクラウド環境ごとに Setup / Maintenance script の登録が必要

---

のん × ちゃぴ ☕🔥
