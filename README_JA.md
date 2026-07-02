# setup-zsh

🌐 [English](README.md) | [Tiếng Việt](README_VI.md) | [简体中文](README_ZH.md) | [日本語](README_JA.md)

macOS向けの軽量なZsh設定ツールです。構文ハイライト、カラフルなファイル一覧表示、シンプルなプロンプト、そして**コマンド履歴のどこにマッチしても提案するスマートな自動補全**機能を提供します。

一般的なZsh設定では、入力した文字列で*始まる*コマンドのみを補全提案します。本ツールは履歴*全体*から検索し、一致するコマンドを `»` 矢印とともに表示します。

## インストール（ワンコマンド）

Macのターミナルを開いて、以下のコマンドを実行してください：

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/setup.sh | bash
```

> スクリプトは組み込みツール（`curl`、`unzip`、`zsh`）のみを使用します。GitやXcode Command Line Toolsは不要です。

現在のターミナルセッションに変更を反映します：

```bash
source ~/.zshrc
```

---

## 主な機能

- **スマート自動補全** — 単語を入力すると、コマンドの途中に含まれる場合でも履歴から補全を提案します。大文字・小文字は区別されません（例: `GOOGLE` と入力すると `curl -I google.com` がマッチ）。
- **矢印キーによる履歴検索** — キーワードを入力して **上 / 下** 矢印キーを押すことで、そのキーワードを含む過去のコマンドを順番に参照できます。
- **構文ハイライト** — 入力時にリアルタイムで正しいコマンドは緑色、エラーは赤色で表示されます。
- **シンプルなプロンプト** — `username (branch*) ❯` と表示されます。Gitリポジトリ内ではブランチ名と未コミットの変更が表示されます。直前のコマンドが失敗すると矢印がピンク色に変わります。
- **Auto-CD（自動ディレクトリ移動）** — ディレクトリパスを入力してEnterを押すだけで移動できます。`cd` と入力する必要はありません。
- **カラフルなファイル一覧表示** — ファイルとフォルダが色分けされ、ライトモード・ダークモードのどちらでも見やすくなります。
- **最適なデフォルト設定** — Tab補全の向上、履歴の重複排除、最大10万件のコマンド履歴保存。
- **開発ツールインストーラー (`install-dev-tool`)** — Go、Node.js、Python & uv、Rust、JDK (Eclipse Temurin LTS)、Codex、Git、OrbStack、Android Studio、VSCode、DBeaver、MongoDB Compass、Antigravity、Claude、Google Chrome をインストールできるインタラクティブメニュー。矢印キーで選択できます。

---

## 使い方

### 1. スマート自動補全

入力中、履歴に基づいた薄いテキストの補全提案が表示されます。

- **先頭が一致する場合**: `curl` と入力 → 薄い文字で ` -I google.com` が表示。`Tab` または `→` キーで確定。
- **途中に含まれる場合**: `google` と入力 → `» curl -I google.com` と表示。
  - **`Tab`**、**`→`**、または **`Ctrl+F`** を押して全体を確定。
  - **`Option+→`**（または `Alt+F`）を押して1単語ずつ確定。
- **他のマッチ結果を閲覧**: **上矢印キー** を押すと別のマッチ結果に切り替わり、**上 / 下** 矢印キーで順番に巡回できます。

### 2. Auto-CD（自動ディレクトリ移動）

パスを入力してEnterを押すだけです：
```bash
~/Downloads  # ~/Downloads に移動
..           # 1つ上のフォルダに移動
```

### 3. Git対応プロンプト

- `username (branch*) ❯ ` と表示。
- ピンクの `*` = ステージングされていない変更あり。緑の `+` = ステージング済みの変更あり。
- 矢印 `❯` は直前のコマンドが失敗するとピンク色になります。

### 4. 開発ツールインストーラー (`install-dev-tool`)

`install-dev-tool` を実行してインタラクティブメニューを開きます。

![install-dev-tool](install-dev-tool.png)

- **移動**: **上 / 下** 矢印キーでカーソル（`❯`）を移動。
- **ツール選択**: **スペース** または **Enter** でチェック/解除（`[ ]` ↔ `[✓]`）。
- **インストール**: `[I] Install Selected Tools` に移動して **Enter** を押す（または `I` と入力）。
- **全選択**: `[A] Toggle All` で **Enter** を押す。
- **終了**: `[E] Exit` で **Enter** を押す。

**知っておくと便利:**
- Go と Node.js は `~/.local/` にインストールされます。グローバル npm パッケージのインストールでも `sudo` は不要です。
- Python は `uv`（Astral製の高速なPythonパッケージ＆プロジェクトマネージャー）と一緒にインストールされます。
- JDK は公式の Eclipse Temurin LTS リリースをインストールし、`JAVA_HOME` を自動設定します。
- デスクトップアプリ（VSCode、Claude、OrbStack、MongoDB Compass、DBeaver、Google Chrome、Android Studio、Antigravity）は自動的にダウンロードされ、`/Applications` に配置されます。
- Git は Apple 公式の `xcode-select --install` 経由でインストールされます。
- インストーラーは起動時に自動で最新バージョンを確認します。

---

## アンインストール（ワンコマンド）

すべての設定を削除して元の状態に戻すには：

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/uninstall.sh | bash
```

実行内容：
1. `~/.zshrc` から **setup-zsh の設定を削除**します。ユーザー独自のエイリアスや設定は保護されます。本スクリプトによって作成され、空になったファイルは削除されます。
2. `~/.zsh/setup-zsh/` にある **プラグインフォルダを削除**します。`~/.zsh/` 内の他のファイルには影響しません。

---

## ライセンス

[MIT License](LICENSE) のもとで公開されています。

`plugins/` ディレクトリに以下のサードパーティ製プラグインが含まれています：
- **zsh-syntax-highlighting** — [BSD 3-Clause License](plugins/zsh-syntax-highlighting/COPYING.md)
- **zsh-autosuggestions** — [MIT License](plugins/zsh-autosuggestions/LICENSE)
