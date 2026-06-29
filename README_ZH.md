# setup-zsh

🌐 [English](README.md) | [Tiếng Việt](README_VI.md) | [简体中文](README_ZH.md)


一个专为 macOS 设计的轻量、高端 Zsh 配置脚本，集成了语法高亮、彩色的文件列表、时尚极简的命令提示符，以及自定义的**任意匹配（子字符串）自动建议策略**。

与仅建议以您键入的字符开头的命令的标准配置不同，此设置可匹配历史记录中的**任何子字符串**，并使用优雅的补全指示符（`↳`）对其进行格式化。

## 功能特点

- **任意匹配自动建议 (Match-Any Autosuggestions)**：在您的完整历史记录中不区分大小写地搜索包含输入内容的任何命令（例如，输入 `GOOGLE` 即可匹配并自动补全 `curl -I google.com`）。
- **子字符串历史记录轮转 (Substring History Cycling)**：输入任意关键字，然后按 **上/下方向键** 即可轮转浏览历史记录中包含该关键字的所有命令（不区分大小写）。
- **语法高亮 (Syntax Highlighting)**：实时语法检查（有效命令为绿色，无效命令为红色）。
- **类 Fish 提示符 (Sleek Fish-like Prompt)**：现代极简的提示符显示为 `username (branch*) ❯`。当在 Git 仓库内时，会自动显示当前 Git 分支及其状态（清洁/脏），且命令失败时箭头会变成粉红色。
- **自动切换目录 (Auto-CD)**：无需输入 `cd` 前缀，直接输入目录路径即可快速切换目录。
- **增强的目录颜色 (Enhanced Directory Colors)**：自定义的 `LSCOLORS`，使文件和目录在深色/浅色背景下都具有生动的颜色显示。
- **优化的默认设置 (Optimized Defaults)**：启用 Zsh 的 Tab 标签自动补全、历史记录自动追加、减少重复记录，并将单次会话历史容量增加到 100,000 条命令。

---

## 使用指南

### 1. 任意匹配自动建议 (Match-Any Autosuggestions)
当您输入时，Zsh 会自动从历史记录中建议最近的匹配命令（以淡灰色文字显示）。
- **前缀匹配 (Prefix Match)**：如果您输入 `curl`，它会建议 ` -I google.com`。按 `Tab` 或 `右方向键` 来接受整个建议。
- **子字符串匹配 (Substring Match)**：如果您输入 `google`（或 `GOOGLE`，因为不区分大小写），它将显示 ` ↳ curl -I google.com`。
  - 按 **`Tab`**、**`右方向键`** 或 **`Control + F`** 键来接受完整的建议。
  - 按 **`Option + 右方向键`**（或 `Alt + F`）来**逐词（word-by-word）**接受建议。
- **轮转浏览多个匹配项**：如果建议的命令不是您想要的，按 **上方向键** 可以用最新的历史记录匹配项替换该行，并继续按 **上/下方向键** 轮转浏览历史记录中的所有匹配命令。

### 2. 自动切换目录 (Auto-CD)
为了更快速地切换目录，只需直接输入任何目录路径并按 `Enter` 键即可：
```bash
~/Downloads  # 自动运行 cd ~/Downloads
..           # 自动运行 cd ..
```

### 3. Fish 样式的提示符
- 提示符显示为 `username (branch*) ❯ `。
- 如果当前 Git 分支有未提交的更改，会显示粉红色的 `*`。如果有已暂存的更改，会显示绿色的 `+`。
- 如果上一个命令执行失败，箭头 `❯` 会变成粉红色。

---

## 一键安装

要在全新的 MacBook（或任何现有的 macOS 终端）上设置 Zsh，只需打开终端并运行以下命令：

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/setup.sh | bash
```

*注意：本安装脚本仅使用系统内置工具 (`curl`, `unzip`, `zsh`)，无需安装 Git 或 Xcode 命令行工具即可下载或安装插件。*

脚本运行完成后，在当前终端会话中使更改生效：

```bash
source ~/.zshrc
```

---

## 一键卸载

如果您希望移除此配置并恢复到原始设置，请运行：

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/uninstall.sh | bash
```

这行命令将执行：
1. **安全移除 setup-zsh 配置块**：利用智能起始/结束标记检测逻辑从您的 `~/.zshrc` 文件中移除相关配置，保留您自定义的其他别名或脚本。如果 `.zshrc` 文件原本不存在（是由本脚本从零创建的），卸载后文件将被自动删除。
2. **移除隔离的插件目录**：删除位于 `~/.zsh/setup-zsh/` 下的插件目录（确保不会与您标准的其他 `.zsh` 目录产生冲突）。

---

## 许可证 (License)

本仓库的代码采用 [MIT License](LICENSE) 许可证进行分发。

本安装包在 `plugins/` 目录下重新分发了以下第三方插件：
- **`zsh-syntax-highlighting`**：采用 [BSD 3-Clause License](plugins/zsh-syntax-highlighting/COPYING.md) 许可证。
- **`zsh-autosuggestions`**：采用 [MIT License](plugins/zsh-autosuggestions/LICENSE) 许可证。
