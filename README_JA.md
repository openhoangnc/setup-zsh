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

- **スマート自動補全** — 入力中の文字で始まるコマンドが優先的に提案されます。先頭が一致するコマンドがない場合は、履歴全体からコマンド内の*どこか*にその文字を含むものを検索し、`»` 矢印とともに表示します。大文字・小文字は区別されません（例: `GOOGLE` と入力すると `curl -I google.com` がマッチ）。
- **矢印キーによる履歴検索** — キーワードを入力して **上 / 下** 矢印キーを押すことで、そのキーワードを含む過去のコマンドを順番に参照できます。
- **構文ハイライト** — 入力時にリアルタイムで正しいコマンドは緑色、エラーは赤色で表示されます。
- **シンプルなプロンプト** — `~/short/path (branch*) ↑1 ↓2 ❯` と表示されます。Gitリポジトリ内ではブランチ名、未コミットの変更、リモートに対する進み／遅れのコミット数が表示されます。直前のコマンドが失敗すると矢印がピンク色に変わります。
- **Auto-CD（自動ディレクトリ移動）** — ディレクトリパスを入力してEnterを押すだけで移動できます。`cd` と入力する必要はありません。
- **カラフルなファイル一覧表示** — ファイルとフォルダが色分けされ、ライトモード・ダークモードのどちらでも見やすくなります。
- **最適なデフォルト設定** — 大文字・小文字を区別しないTab補全、より賢い履歴（重複排除）、最大10万件のコマンド履歴保存、そして日常的なキーがそのまま使えます（Home / End / Fn+Delete / Option+矢印キーでの単語ジャンプ）。
- **開発ツールインストーラー (`install-dev-tool`)** — Bun、Go、Homebrew、Node.js、Python & uv、Rust、JDK (Eclipse Temurin LTS)、Codex、Git、OrbStack、Android Studio、VSCode、DBeaver、MongoDB Compass、Antigravity、Claude、Google Chrome、OmniDiskSweeper をインストールできるインタラクティブメニュー。矢印キーで選択できます。
- **Macクリーンアップ (`cdm`)** — 筆者の独立ツール [**CleanDevMac**](https://github.com/cleandevmac/cdm)（このリポジトリから生まれました）をインストールします。再生成可能な開発者キャッシュやビルド成果物（Xcode、Go、Node/npm/pnpm/yarn、Gradle、Maven、Cargo、Python、Homebrew、Playwright など）からディスク容量を回収し、Electron／ブラウザ／アプリのキャッシュをクリアし、リポジトリごとにまとめられたプロジェクトのゴミを一掃し、Docker/Podman の空き容量を回収し、アンインストール済みアプリの残存データを洗い出します — 項目ごとの確認なしに削除することは決してありません。

---

## 使い方

### 1. スマート自動補全

入力中、履歴に基づいた薄いテキストの補全提案が表示されます。入力した文字で**始まる**提案が優先され、先頭が一致するコマンドがない場合は、その文字を**含む**最新のコマンドが `»` 矢印の後に表示されます。

- **先頭が一致する場合**: `curl` と入力 → 薄い文字で ` -I google.com` が表示。`→` または `Ctrl+F` キーで確定。
- **途中に含まれる場合**: `google` と入力 → `» curl -I google.com` と表示。
  - **`→`** または **`Ctrl+F`** を押して全体を確定。
  - **`Option+→`**（または `Alt+F`）を押して1単語ずつ確定。
- **他のマッチ結果を閲覧**: **上矢印キー** を押すと別のマッチ結果に切り替わり、**上 / 下** 矢印キーで順番に巡回できます。

> ⚠️ **Enterは常に入力した内容をそのまま実行します** — 薄い文字の提案が実行されることはありません。`»` 提案を実行するには、まず `→`（または `Ctrl+F`）で確定してから Enter を押してください。

### 2. Auto-CD（自動ディレクトリ移動）

パスを入力してEnterを押すだけです：
```bash
~/Downloads  # ~/Downloads に移動
..           # 1つ上のフォルダに移動
```

> フォルダ名がコマンド名と同じ場合（例: `test`）はコマンドが優先されます。末尾にスラッシュを付けると強制的に cd できます: `test/`。

### 3. Git対応プロンプト

- `~/short/path (branch*) ↑1 ↓2 ❯ ` と表示。長いパスは自動的に短縮されます。
- ピンクの `*` = ステージングされていない変更あり。緑の `+` = ステージング済みの変更あり。
- 緑の `↑N` = リモートより N コミット進んでいる（push 待ち）。ピンクの `↓N` = N コミット遅れている（pull 待ち）。同期済みのときは非表示。
- 矢印 `❯` は直前のコマンドが失敗するとピンク色になります。

### 4. 開発ツールインストーラー (`install-dev-tool`)

`install-dev-tool` を実行してインタラクティブメニューを開きます。

![install-dev-tool](install-dev-tool.png)

- **移動**: **上 / 下 / 左 / 右** 矢印キーでカーソル（`❯`）を移動。
- **ツール選択**: **スペース** または **Enter** でチェック/解除（`[ ]` ↔ `[✓]`）。番号の入力でも選択できます（10–17 の項目は2桁を素早く入力）。
- **アクション（最下部1行に集約）**:
  - **インストール**: `[I] Install` に移動して **Enter** を押す（または `I` と入力）。
  - **全選択**: `[A] Toggle All` に移動して **Enter** を押す（または `A` と入力）。
  - **更新が必要な全ツール選択**: `[U] Select Outdated` に移動して **Enter** を押す（または `U` と入力）、またはターミナルから直接 `install-dev-tool --update-all` を実行（完了すると自動的に終了します）。
  - **終了**: `[E] Exit` に移動して **Enter** を押す（または `E`、`Q`、`Esc`、`Ctrl+C` のいずれかを入力）。
- **CLIフラグ**: `install-dev-tool --help` ですべてのオプション（`-u/--update-all`、`-a/--all`）を一覧表示できます。

**知っておくと便利:**
- Bun は公式スクリプト (`https://bun.sh/install`) 経由で `~/.bun/bin` にインストールされます。
- Go と Node.js は `~/.local/` にインストールされます。グローバル npm パッケージのインストールでも `sudo` は不要です。
- Homebrew は公式スクリプト (`https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh`) 経由でインストールされ、`shellenv` が自動設定されます。
- Python は `uv`（Astral製の高速なPythonパッケージ＆プロジェクトマネージャー）と一緒にインストールされます。
- JDK は公式の Eclipse Temurin LTS リリースをインストールし、`JAVA_HOME` を自動設定します。
- デスクトップアプリ（VSCode、Claude、OrbStack、MongoDB Compass、DBeaver、Google Chrome、Android Studio、Antigravity、OmniDiskSweeper）は自動的にダウンロードされ、`/Applications` に配置されます。
- Git は Apple 公式の `xcode-select --install` 経由でインストールされます。
- インストーラーは起動時に自動で最新バージョンを確認します。

### 5. Macクリーンアップ (`cdm`)

クリーンアップは [**CleanDevMac**](https://github.com/cleandevmac/cdm) が担当します — このリポジトリから生まれ、現在は独立したリポジトリで開発している筆者自身のツールです。セットアップ時に最新リリースが `~/.zsh/setup-zsh/bin/cdm` にダウンロードされるので、`cdm` で実行できます（従来の `clean-my-mac` という名前も引き続き使えます）。

[![CleanDevMac](https://raw.githubusercontent.com/cleandevmac/cdm/main/screenshot.png)](https://github.com/cleandevmac/cdm)

インタラクティブなメニューが開きます。Macをスキャンし、安全に回収できるものをカテゴリごとにまとめてサイズの大きい順に並べ、チェックした項目だけを削除します — 開発者キャッシュとビルド成果物、Electron／ブラウザ／アプリのキャッシュ、リポジトリごとにまとめられたプロジェクトのゴミ、Docker／Podman、そしてアンインストール済みアプリの残存データ。削除の前には必ず項目ごとの実行計画が表示されます。

**単体でも実行できます** — setup-zsh を先にインストールする必要はありません：

```bash
curl -sSL https://github.com/cleandevmac/cdm/releases/latest/download/cdm | bash
# dry-run (look only, delete nothing):
curl -sSL https://github.com/cleandevmac/cdm/releases/latest/download/cdm | bash -s -- -n
```

TUI のキー操作、削除対象の全リスト、安全性の保証、編集可能なルール JSON については [CleanDevMac の README](https://github.com/cleandevmac/cdm#readme) にすべて記載されています。

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
