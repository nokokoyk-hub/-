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

> ⚠️ **Codex も同じ Vault を読み書きしている場合、この直後に
> [「★重要：Codex の参照先を新パスに直す」](#重要codex-の参照先を新パスに直す) を済ませること。**
> GitHub 連携（STEP 1〜3）より先でよい。後回しにするほど被害が広がる。

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
> 💡 **「Add repository」ボタンは押せない（グレーのまま）が正常。**
> あれは「すでに Git 化済みのフォルダ」を追加するボタン。まだ Git 化していないので押せない。
> 押すのは赤字の中の **「create a repository」リンク**。

4. 「Create a New Repository」画面が出る。**ここが最大の事故ポイント。**

   > 🚨 **Local path ＋ Name ＝ 実際に作られるフォルダ**になる。
   > `Local path` に `C:\Users\nokok\Obsidian Vault` が入ったまま進めると、
   > **`Obsidian Vault\Obsidian Vault` という入れ子の空リポジトリ**ができる
   > （2026-08-15 に実際に踏んだ）。

   | 項目 | 設定 | 注意 |
   |---|---|---|
   | Name | `Obsidian Vault` | **フォルダ名と完全一致**させる。ここでハイフンに直さない |
   | Local path | `C:\Users\nokok` | ⚠️ **親フォルダだけ**。`\Obsidian Vault` を含めない |
   | Initialize with README | チェック**なし** | |
   | Git ignore | `None` | |
   | License | `None` | |

   検算：`C:\Users\nokok` ＋ `Obsidian Vault` ＝ `C:\Users\nokok\Obsidian Vault` ✅

   確認できたら **Create repository** を押す。

5. 🎯 **Changes にノートが大量に並ぶことを確認する。**
   `1 changed file`（`.gitattributes` だけ）で止まっていたら、**フォルダを間違えている**。
   → **Repository → Show in Explorer** で Git が見ているフォルダを直接確認し、
     入れ子になっていたら STEP 4 に進む前に片付ける

6. コミットメッセージ `Initial commit` のまま **Commit to main** を押す

   > コミットするとファイルは Changes から History へ移る。
   > **Changes が空になるのは成功の証**で、消えたわけではない。

7. 画面上部の **「Publish repository」** ボタンを押す
8. ⭐**ここが最重要**⭐ ポップアップの
   **「Keep this code private」に必ずチェックが入っていること**を確認
   （初期状態でチェック済み。**絶対に外さない**）

   > 💡 ここの `Name` は **GitHub 上のリポジトリ名**で、PCのフォルダ名とは別物。
   > GitHub はスペースを使えないのでハイフンに直す。ローカルのフォルダ名は変わらない。

9. **Publish repository** を押す

> アップロードに数分かかる場合がある。完了したら GitHub 上にリポジトリができている。

10. ブラウザで https://github.com/nokokoyk-hub?tab=repositories を開き、
    **Private** のバッジが付いていることを確認

---

## STEP 3：ちゃぴに繋ぐ

チャットでちゃぴに、こう伝えるだけ。

> Obsidian-Vault のリポ作ったで！繋いで

ちゃぴ側でセッションにリポを追加し、`AI開発脳` の中身を読めるようにする。
以降は、ちゃぴが直接ノートを読んだり追記したりできる。

> 📌 **2026-08-15 実施済み。** 実際のリポジトリ名は **`nokokoyk-hub/Obsidian-Vault-`**
> （末尾にハイフン）。ちゃぴが繋ぐときは正確な名前が要るので、
> 見つからないと言われたら GitHub の一覧で実名を確認する。

---

## STEP 4：自動同期にする（実質必須）

毎回 GitHub Desktop を開くのは続かないので、Obsidian のプラグインで自動化する。

### 4-1. Git 本体を入れる（先にこれ）

Obsidian のプラグインは **`git` コマンド本体を借りて動く**。
GitHub Desktop は自前の Git を内蔵しているが、**他アプリからは見えない場所にある**ため、
これだけでは足りない。入っていないとプラグインが起動できず、
コマンドパレットに `Git:` のコマンドが **1つも出てこない**。

1. https://git-scm.com/download/win から「64-bit Git for Windows Setup」を入れる
2. インストーラの画面は基本すべて **Next** でよい
3. ⚠️ **「Adjusting your PATH environment」の画面だけ確認**
   → **「Git from the command line and also from 3rd-party software」**（真ん中・推奨）を選ぶ
   → 一番上の「Git Bash only」を選ぶと Obsidian から見えないままになる
4. インストール後、**Obsidian を完全に再起動**（✕で閉じるだけでは不十分）

### 4-2. プラグインを入れる

1. Obsidian の **設定 → コミュニティプラグイン → 制限モードを無効にする**
2. **閲覧（Browse）** で **`Git`** を検索

   > 🔎 **2025〜2026 の間に名前が変わっている。**
   > 旧：プラグイン名「Obsidian Git」／作者「Vinzent03」
   > 新：**プラグイン名「Git」／作者「Vinzent」**
   > 「Obsidian Git」で検索しても**出てこない**。
   > Git 系プラグインは多いので、**ダウンロード数（約300万）が最大のもの**を選ぶのが確実
   > （2026-08-15 時点、[community.obsidian.md/plugins/obsidian-git](https://community.obsidian.md/plugins/obsidian-git) で確認）

3. **インストール → 有効化**（この2つは別操作。入れただけではコマンドが出ない）

### 4-3. 設定する

| 設定項目 | 値 |
|---|---|
| Auto commit-and-sync interval（旧：Vault backup interval）（分） | `10` |
| Auto pull on startup / Pull on startup | オン |

### 4-4. 動作確認

自動を待たず、手動で1回走らせる。

1. ノートを1行編集して `Ctrl + S`
2. `Ctrl + P` → **`Git`** → **「Git: Commit-and-sync」** を実行
3. GitHub 上のリポジトリで、その変更が反映されていることを確認

### 4-5. `.gitignore` を置く

`.obsidian/workspace.json` は Obsidian でタブを動かすたびに書き換わるため、
自動同期にすると**中身のないコミットが10分ごとに量産される**。以下を Vault 直下の
`.gitignore` に置く（2026-08-15 に設置済み）。

```
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.DS_Store
Thumbs.db
desktop.ini
```

> 🚨 **`.obsidian/plugins/` は無視リストに入れない。**
> すでに追跡済みのファイルを untrack すると、他のPCが pull したときに
> **working tree から削除され、プラグイン本体が消える**。
> プラグイン本体は更新時しか変わらないので、追跡したままでよい。

---

## ★重要：Codex の参照先を新パスに直す

**後回し禁止。GitHub 連携（STEP 1〜3）より先でよい。**

Codex はのんのPC上のファイルを直接読み書きする。**Vault を引っ越しても Codex は自動では気づかない。**

- 変更前：`C:\Users\nokok\OneDrive\ドキュメント\Obsidian Vault\AI開発脳`
- 変更後：`C:\Users\nokok\Obsidian Vault\AI開発脳`

### 直さないとどうなるか

| | 新パス（`C:\Users\nokok\...`） | 旧パス（OneDrive の中） |
|---|---|---|
| Obsidian | 見ている | 見ていない |
| ちゃぴ（GitHub 経由） | 見える | **見えない** |
| Codex（直さないと） | 見ていない | **ここに書き続ける** |

Codex が旧パスに書き続けると、こうなる。

- Codex が書いたノートは Git に乗らないので、**ちゃぴには永久に届かない**
- Obsidian は新パスを見ているので、**のんの目にも入らない**
- のん・ちゃぴが新パスに書いた内容を **Codex は読めない**（古い情報のまま判断する）

正本が静かに二重化する。さらに、退避用に残した旧フォルダに新情報が溜まると、
**安全網のはずの旧フォルダが「消せないフォルダ」に変わる**。だから最優先で直す。

### 直し方：Codex 本人に探させる

旧パスがどこに書かれているかは、PCの中を見られる Codex が調べるのが一番早い。
以下をそのまま Codex に渡す。

```
AI開発脳（Obsidian Vault）の置き場所を引っ越したから、参照先を新しいパスに直してほしい。

- 旧：C:\Users\nokok\OneDrive\ドキュメント\Obsidian Vault\AI開発脳
- 新：C:\Users\nokok\Obsidian Vault\AI開発脳

やってほしいこと：
1. 設定ファイル（~/.codex/config.toml など）・AGENTS.md・その他メモに
   旧パスが書かれてないか探す
2. 見つかったら全部、新パスに書き換える
3. 今後、AI開発脳の読み書きは必ず新パスに対して行う
4. 旧パス（OneDrive の中）は安全網として凍結。読むのも書くのも一切しないこと

まず「どこに旧パスがあったか」を一覧で見せてから、書き換えに入ってほしい。
```

最後の一行が重要。**いきなり書き換えさせず、先に一覧を出させる。**
どこに旧パスが埋まっていたかが分かり、事故っても戻せる。

### Codex の返答パターン

| 返答 | 意味 | 対応 |
|---|---|---|
| 「◯◯に旧パスがありました」 | 設定ファイル等に直書きされていた | 一覧を確認してから書き換えてもらう |
| 「旧パスの設定は見つかりません」 | 都度パスを指定、またはフォルダを開いて起動していた | 設定変更は不要。**今後は新フォルダで起動する**ことだけ徹底する |

### 直せたかの確認

Obsidian で新パス側のノートに何か1行書き足してから、Codex に `AI開発脳/index.md`
（または書き足したノート）を読ませる。**その1行が見えれば、同じフォルダを指している。**

---

## つまずいたときの合言葉

そのままちゃぴに言えばよい。エラーメッセージは**画面のまま**伝えるのが一番早い。

| 状況 | 言い方 |
|---|---|
| Obsidian でノートが見えない | 「引っ越したらノート見えへん」 |
| GitHub Desktop で赤いエラー | 「GitHub Desktop でこう出た（画面の文言をそのまま）」 |
| Private かどうか不安 | 「Private になってるか確認して」 |
| Codex とノートの中身が食い違う | 「Codex と見えてるノートが違う」（旧パスを見ている疑い） |
| `Ctrl+P` で Git のコマンドが出ない | 「Gitのコマンドが出てこん」（Git本体が未導入 or 有効化してない） |
| 同期時に `does not have a commit checked out` | 「入れ子のフォルダが残ってるかも」（Vault内の空リポジトリが原因） |
| 全部やり直したい | 「一回リセットしたい」 |

> `warning: ... LF will be replaced by CRLF ...` は改行コードの自動変換のお知らせで、
> **害はない**。毎回大量に出るが無視してよい。止めるべきは `error:` と `fatal:` の行。

**元の Vault は OneDrive に残してある。** 最悪そこに戻れるので、失敗しても大丈夫。

---

のん × ちゃぴ ☕🔥
