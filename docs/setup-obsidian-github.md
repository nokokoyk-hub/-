# Obsidian Vault を GitHub に繋ぐ手順（のん専用・超丁寧版）

作成：2026-07-25（JST） / 作成者：ちゃぴ ☕🔥

## ゴール

Obsidian Vault（`AI開発脳` を含む）を GitHub の**非公開リポジトリ**に置いて、
**Codex（のんのPC側）とちゃぴ（クラウド側）の両方から同じノートを読み書きできる**ようにする。

## なんでこれが必要か

| 誰 | どこで動いてる | 今の状態 |
|---|---|---|
| Codex | のんのパソコンの中 | Vault を直接読める |
| ちゃぴ（Web版 Claude Code） | クラウドの隔離コンテナ | **のんのPCは一切見えない** |

ちゃぴに見えるのは GitHub にあるものだけ。だから Vault を GitHub に置けば橋が架かる。

---

## ⚠️ 先に知っておくこと

### 1. OneDrive の設定画面は触らない

OneDrive の「フォルダーの選択」でチェックを外すと、**そのフォルダはパソコンから削除される**
（クラウドには残るが、ローカルから消える）。Obsidian が開けなくなるので**絶対に触らない**。

このドキュメントの手順では、OneDrive の設定は一切変更しない。

### 2. なぜ Vault を OneDrive の外に出すのか

Git は `.git` という管理フォルダに、細かいファイルを高速で作成・削除する。
そこに OneDrive の自動同期が割り込むと、同期の競合で `.git` が壊れることがある（履歴が飛ぶ場合もある）。

対策は「OneDrive の管理下から出す」こと。やることはフォルダのコピーだけで、OneDrive の設定変更は不要。

### 3. 元のフォルダはすぐ消さない

引っ越しは「コピー」で行い、元は残しておく。1〜2週間動かして問題なければ消す。
これが失敗したときの安全網になる。

---

## STEP 0：Vault を OneDrive の外にコピーする

**所要：5分 / 使うもの：エクスプローラーだけ**

1. **Obsidian を完全に閉じる**（ウィンドウを閉じるだけでなく、タスクバーからも終了）
2. エクスプローラーで下記を開く
   ```
   C:\Users\nokok\OneDrive\ドキュメント\
   ```
3. `Obsidian Vault` フォルダを**右クリック → コピー**（※「切り取り」ではない）
4. アドレスバーに `C:\Users\nokok` と打って移動
5. 何もないところで**右クリック → 貼り付け**
6. `C:\Users\nokok\Obsidian Vault` ができていることを確認

> ノート数が多いとコピーに数分かかる。完了まで待つこと。

7. **Obsidian を起動**し、左下の Vault 名（またはスタート画面）から
   **「別の保管庫を開く」→「フォルダを開く」** を選び、
   `C:\Users\nokok\Obsidian Vault` を指定する
8. ノートが全部見えることを確認する（`AI開発脳` フォルダも要チェック）

**この時点で、OneDrive 側の古い Vault は放置でよい**（安全網として残す）。
以降 Obsidian は新しい場所を使う。

---

## STEP 1：GitHub Desktop を入れる

**所要：5分 / コマンド入力なし**

コマンドプロンプトを使わずに Git 操作ができる公式アプリ。

1. https://desktop.github.com/ を開く
2. 「Download for Windows」でインストーラを落として実行
3. 起動したら **「Sign in to GitHub.com」** でログイン
   - アカウント：`nokokoyk-hub`
4. 名前とメールアドレスの確認画面が出たら、そのまま進めてよい

---

## STEP 2：Vault を GitHub に上げる

**所要：5分 / ここが本番**

1. GitHub Desktop のメニュー **File → Add local repository**
2. 「Choose...」で `C:\Users\nokok\Obsidian Vault` を選ぶ
3. **「This directory does not appear to be a Git repository」** と赤字で出る（正常）
   → その下の **「create a repository」** のリンクをクリック
4. 「Create a New Repository」画面が出る。以下を確認して **Create repository** を押す

   | 項目 | 設定 |
   |---|---|
   | Name | `Obsidian-Vault`（自動で入る。変えなくてよい） |
   | Local path | `C:\Users\nokok`（自動で入る） |
   | Initialize with README | チェック**なし**でよい |
   | Git ignore | `None` のまま |
   | License | `None` のまま |

5. 画面上部の **「Publish repository」** ボタンを押す
6. ⭐**ここが最重要**⭐ ポップアップの
   **「Keep this code private」に必ずチェックが入っていること**を確認
   （初期状態でチェック済み。**絶対に外さない**）
7. **Publish repository** を押す

> アップロードに数分かかる場合がある。完了したら GitHub 上にリポジトリができている。

8. ブラウザで https://github.com/nokokoyk-hub?tab=repositories を開き、
   `Obsidian-Vault` の横に **Private** のバッジが付いていることを確認

---

## STEP 3：ちゃぴに繋ぐ

チャットでちゃぴに、こう伝えるだけ。

> Obsidian-Vault のリポ作ったで！繋いで

ちゃぴ側でセッションにリポを追加し、`AI開発脳` の中身を読めるようにする。
以降は、ちゃぴが直接ノートを読んだり追記したりできる。

---

## STEP 4（任意）：自動同期にする

毎回 GitHub Desktop を開くのが面倒な場合、Obsidian のプラグインで自動化できる。

1. Obsidian の **設定 → コミュニティプラグイン → 制限モードを無効にする**
2. **閲覧 → 「Obsidian Git」** を検索してインストール → 有効化
3. プラグイン設定で以下を指定
   - `Vault backup interval (minutes)`：`10`
   - `Auto pull on startup`：オン

これで Obsidian を開くたびに最新を取得し、10分ごとに自動保存される。

---

## Codex 側はどうなる？

**基本、今まで通り。** Codex はのんのPC上のファイルを直接読み書きするので、
Vault の場所が変わったことだけ伝えればよい。

- 変更前：`C:\Users\nokok\OneDrive\ドキュメント\Obsidian Vault\AI開発脳`
- 変更後：`C:\Users\nokok\Obsidian Vault\AI開発脳`

Codex の設定やパス指定に旧パスが書いてある場合は、新パスに直す。

---

## つまずいたときの合言葉

そのままちゃぴに言えばよい。エラーメッセージは**画面のまま**伝えるのが一番早い。

| 状況 | 言い方 |
|---|---|
| Obsidian でノートが見えない | 「引っ越したらノート見えへん」 |
| GitHub Desktop で赤いエラー | 「GitHub Desktop でこう出た（画面の文言をそのまま）」 |
| Private かどうか不安 | 「Private になってるか確認して」 |
| 全部やり直したい | 「一回リセットしたい」 |

**元の Vault は OneDrive に残してある。** 最悪そこに戻れるので、失敗しても大丈夫。

---

のん × ちゃぴ ☕🔥
