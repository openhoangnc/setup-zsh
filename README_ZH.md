# setup-zsh

🌐 [English](README.md) | [Tiếng Việt](README_VI.md) | [简体中文](README_ZH.md) | [日本語](README_JA.md)

一个轻量的 macOS Zsh 配置工具。自带语法高亮、彩色文件列表、简洁的提示符，以及**能匹配历史记录中任意位置的智能补全建议**。

普通的 Zsh 配置只会推荐以你输入的字符*开头*的命令。这个工具会搜索你的*整个*历史记录，找到任何匹配的命令，并用 `»` 箭头标识出来。

## 安装（一条命令）

在任意 Mac 上打开终端，运行：

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/setup.sh | bash
```

> 脚本只用系统自带工具（`curl`、`unzip`、`zsh`），不需要安装 Git 或 Xcode 命令行工具。

然后让改动在当前终端生效：

```bash
source ~/.zshrc
```

---

## 你会得到什么

- **智能自动建议** — 优先建议以你输入内容开头的命令；如果没有命令以它开头，则会搜索整个历史记录，匹配命令中*任意位置*的内容，并以 `»` 箭头标识。不区分大小写（输入 `GOOGLE` 能匹配到 `curl -I google.com`）。
- **方向键翻阅历史** — 输入关键字后按 **上/下方向键**，逐条浏览包含该关键字的历史命令。
- **语法高亮** — 输入时实时显示：有效命令变绿，无效命令变红。
- **简洁提示符** — 显示 `~/short/path (branch*) ↑1 ↓2 ❯`。在 Git 仓库中会显示分支名、修改状态，以及领先/落后远程的提交数。上一条命令失败时箭头变粉。
- **自动切换目录** — 直接输入路径按回车，不用打 `cd`。
- **彩色文件列表** — 文件和目录有各自的颜色，深色和浅色背景都好看。
- **更好的默认设置** — Tab 补全不区分大小写、更智能的历史记录（自动去重）、最多保存 100,000 条命令，以及开箱即用的常用按键（Home / End / Fn+Delete / Option+方向键按单词跳转）。
- **开发工具安装器 (`install-dev-tool`)** — 交互式菜单，可安装 Bun、Go、Homebrew、Node.js、Python & uv、Rust、JDK (Eclipse Temurin LTS)、Codex、Git、OrbStack、Android Studio、VSCode、DBeaver、MongoDB Compass、Antigravity、Claude、Google Chrome 和 OmniDiskSweeper。用方向键选择即可。
- **Mac 清理工具 (`cdm`)** — 安装 [**CleanDevMac**](https://github.com/cleandevmac/cdm)，我的独立清理工具（它最初就诞生于本仓库）。它能回收可再生的开发者缓存和构建产物（Xcode、Go、Node/npm/pnpm/yarn、Gradle、Maven、Cargo、Python、Homebrew、Playwright 等）所占用的磁盘空间，清理 Electron/浏览器/应用缓存，清扫按仓库分组的项目垃圾，回收 Docker/Podman 空间，并找出你已卸载应用残留的数据 — 未经逐项确认绝不删除任何东西。

---

## 使用方法

### 1. 智能自动建议

输入时，Zsh 会自动显示历史记录中的灰色建议文本。优先显示以你输入内容**开头**的建议；当没有命令以它开头时，会在 `»` 箭头后显示最近一条**包含**该内容的命令。

- **前缀匹配**：输入 `curl` → 看到灰色的 ` -I google.com`。按 `→` 或 `Ctrl+F` 接受。
- **子串匹配**：输入 `google` → 看到 `» curl -I google.com`。
  - 按 **`→`** 或 **`Ctrl+F`** 接受整条建议。
  - 按 **`Option+→`**（或 `Alt+F`）逐词接受。
- **查看更多匹配**：按 **上方向键** 替换为另一个匹配结果，继续按 **上/下** 逐条浏览。

> ⚠️ **回车永远只执行你实际输入的内容** — 绝不会执行灰色建议。要执行 `»` 建议，请先按 `→`（或 `Ctrl+F`）接受它，再按回车。

### 2. 自动切换目录

直接输入路径按回车：
```bash
~/Downloads  # 进入 ~/Downloads
..           # 返回上级目录
```

> 如果文件夹与某个命令同名（例如 `test`），会优先执行命令。在末尾加上斜杠即可强制切换目录：`test/`。

### 3. Git 感知提示符

- 显示 `~/short/path (branch*) ↑1 ↓2 ❯ `。过长的路径会自动截断。
- 粉色 `*` = 有未暂存的修改。绿色 `+` = 有已暂存的修改。
- 绿色 `↑N` = 领先远程 N 个提交（待 push）。粉色 `↓N` = 落后 N 个提交（待 pull）。同步时不显示。
- 箭头 `❯` 在上一条命令失败时变粉。

### 4. 开发工具安装器 (`install-dev-tool`)

运行 `install-dev-tool` 打开交互菜单。

![install-dev-tool](install-dev-tool.png)

- **导航**：用 **上 / 下 / 左 / 右 方向键** 移动光标（`❯`）。
- **选择工具**：按 **空格键** 或 **回车** 勾选/取消（`[ ]` ↔ `[✓]`），或输入对应编号（10–17 号需快速连续输入两位数字）。
- **操作选项（底部单行展示）**：
  - **安装**：移到 `[I] Install` 按 **回车**（或输入 `I`）。
  - **全选**：移到 `[A] Toggle All` 按 **回车**（或输入 `A`）。
  - **选择所有需要更新的工具**：移到 `[U] Select Outdated` 按 **回车**（或输入 `U`），或在终端直接运行 `install-dev-tool --update-all`（完成后自动退出）。
  - **退出**：移到 `[E] Exit` 按 **回车**（或输入 `E`、`Q`、`Esc` 或 `Ctrl+C`）。
- **命令行选项**：`install-dev-tool --help` 列出所有选项（`-u/--update-all`、`-a/--all`）。

**小贴士：**
- Bun 通过其官方脚本 (`https://bun.sh/install`) 安装到 `~/.bun/bin`。
- Go 和 Node.js 安装到 `~/.local/`——不需要 `sudo`，全局安装 npm 包也不需要。
- Homebrew 通过其官方脚本 (`https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh`) 安装并自动配置 `shellenv`。
- Python 会与 `uv`（Astral 出品的高性能 Python 包与项目管理器）一起安装。
- JDK 安装官方 Eclipse Temurin LTS 版本并自动配置 `JAVA_HOME`。
- 桌面应用（VSCode、Claude、OrbStack、MongoDB Compass、DBeaver、Google Chrome、Android Studio、Antigravity、OmniDiskSweeper）会自动下载并放入 `/Applications`。
- Git 通过 Apple 官方的 `xcode-select --install` 安装。
- 安装器启动时会自动检查最新版本。

### 5. Mac 清理工具 (`cdm`)

清理工作现在交给 [**CleanDevMac**](https://github.com/cleandevmac/cdm) — 我的独立工具，它源自本仓库，如今有了自己的仓库。安装时会把最新发行版下载到 `~/.zsh/setup-zsh/bin/cdm`，用 `cdm` 运行即可（旧名称 `clean-my-mac` 依然可用）。

[![CleanDevMac](https://raw.githubusercontent.com/cleandevmac/cdm/main/screenshot.png)](https://github.com/cleandevmac/cdm)

它会打开一个交互式菜单：扫描你的 Mac，把所有能安全回收的内容按类别分组并从大到小排列，只删除你勾选的项目 — 开发者缓存和构建产物、Electron/浏览器/应用缓存、按仓库分组的项目垃圾、Docker/Podman，以及已卸载应用的残留数据。任何东西被删除之前，你都会先看到逐项清理计划。

它还能**独立运行** — 无需先安装 setup-zsh：

```bash
curl -sSL https://github.com/cleandevmac/cdm/releases/latest/download/cdm | bash
# dry-run (look only, delete nothing):
curl -sSL https://github.com/cleandevmac/cdm/releases/latest/download/cdm | bash -s -- -n
```

TUI 按键、完整的清理内容列表、安全保证，以及可编辑的规则 JSON，都记录在 [CleanDevMac 的 README](https://github.com/cleandevmac/cdm#readme) 中。

---

## 卸载（一条命令）

想全部移除、恢复原始设置：

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/uninstall.sh | bash
```

这条命令会：
1. **从 `~/.zshrc` 中移除 setup-zsh 的配置** — 你自己写的别名和设置不受影响。如果文件是脚本创建的且现在为空，会被自动删除。
2. **删除插件目录** `~/.zsh/setup-zsh/` — 不会动 `~/.zsh/` 下的其他内容。

---

## 许可证

采用 [MIT License](LICENSE) 分发。

`plugins/` 目录包含以下第三方插件：
- **zsh-syntax-highlighting** — [BSD 3-Clause License](plugins/zsh-syntax-highlighting/COPYING.md)
- **zsh-autosuggestions** — [MIT License](plugins/zsh-autosuggestions/LICENSE)
