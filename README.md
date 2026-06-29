# setup-zsh

🌐 [English](README.md) | [Tiếng Việt](README_VI.md) | [简体中文](README_ZH.md)


A premium, lightweight Zsh configuration script for macOS that adds syntax highlighting, colored file listings, a sleek minimal prompt, and a custom **match-any (substring) autosuggestions strategy**.

Unlike standard configurations that only suggest commands starting with your typed characters, this setup matches **any substring** in your history and formats them with an elegant completion indicator (`↳`).

## Features

- **Match-Any Autosuggestions**: Suggestions search your entire history for any command containing your input case-insensitively (e.g. typing `GOOGLE` matches and auto-completes `curl -I google.com`).
- **Substring History Cycling**: Type a keyword and press the **Up / Down arrow keys** to cycle through all commands in your history containing that keyword (case-insensitive).
- **Syntax Highlighting**: Real-time syntax check (green for valid commands, red for invalid).
- **Sleek Fish-like Prompt**: A modern, minimal prompt showing `username (branch*) ❯` which displays the current Git branch and its state (clean/dirty) if inside a Git repo, and a colored arrow that turns pink if the last command failed.
- **Auto-CD**: Jump to directories instantly by entering the directory path directly without typing the `cd` prefix.
- **Enhanced Directory Colors**: Customized `LSCOLORS` to give files and directories a vibrant look on light/dark backgrounds.
- **Optimized Defaults**: Enables Zsh tab completion, history appending, duplicate reductions, and increases session history to 100,000 commands.

---

## Usage Guide

### 1. Match-Any Autosuggestions
As you type, Zsh will automatically suggest the most recent matching command from your history.
- **Prefix Match**: If you type `curl`, it suggests ` -I google.com` in faint gray. Press `Tab` or `Right Arrow` to accept.
- **Substring Match**: If you type `google` (or `GOOGLE` since it's case-insensitive), it will show ` ↳ curl -I google.com`.
  - Press **`Tab`**, **`Right Arrow`**, or **`Control + F`** to accept the full suggestion.
  - Press **`Option + Right Arrow`** (or `Alt + F`) to accept the suggestion **word-by-word**.
- **Cycle through multiple matches**: If the suggested command isn't the one you wanted, press the **Up Arrow** key to replace the line with the latest match, and continue pressing **Up/Down Arrows** to cycle through all matching commands in your history.

### 2. Auto-CD
To navigate directories faster, simply type any directory path and press `Enter`:
```bash
~/Downloads  # Automatically runs cd ~/Downloads
..           # Automatically runs cd ..
```

### 3. Fish-Style Prompt
- The prompt shows `username (branch*) ❯ `.
- If a Git branch has unstaged changes, a pink `*` is shown. If there are staged changes, a green `+` is shown.
- The arrow `❯` turns pink if the last command returned a non-zero exit code (failed).

---

## Quick Setup (Single Command)

To set up Zsh on a brand-new MacBook (or any existing macOS terminal), simply open Terminal and run the following command:

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/setup.sh | bash
```

*Note: The script uses only built-in tools (`curl`, `unzip`, `zsh`) and does not require Git or Xcode Command Line Tools to download or install plugins.*

After the script finishes, apply the changes to your current session:

```bash
source ~/.zshrc
```

---

## Quick Uninstall (Single Command)

If you wish to remove this configuration and revert to your original settings, run:

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/uninstall.sh | bash
```

This single command will:
1. **Safely remove the custom config block** from your `~/.zshrc` file using a clean marker detection logic, preserving any other custom aliases/scripts you had. If the file was created from scratch and is now empty, it will be deleted.
2. **Remove the isolated plugin folder** located at `~/.zsh/setup-zsh/` (ensuring no collision with your standard plugin folders).

---

## License

This repository is licensed under the [MIT License](LICENSE).

It redistributes the following third-party plugins in the `plugins/` directory:
- **`zsh-syntax-highlighting`**: Licensed under the [BSD 3-Clause License](plugins/zsh-syntax-highlighting/COPYING.md).
- **`zsh-autosuggestions`**: Licensed under the [MIT License](plugins/zsh-autosuggestions/LICENSE).


