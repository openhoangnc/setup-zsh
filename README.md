# setup-zsh

🌐 [English](README.md) | [Tiếng Việt](README_VI.md) | [简体中文](README_ZH.md) | [日本語](README_JA.md)

A lightweight Zsh setup for macOS. It gives you syntax highlighting, colorful file listings, a clean prompt, and **smart autosuggestions that match any part of your command history**.

Most Zsh setups only suggest commands that *start with* what you type. This one searches your *entire* history for any match and shows it with a `»` arrow.

## Install (One Command)

Open Terminal on any Mac and run:

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/setup.sh | bash
```

> The script only uses built-in tools (`curl`, `unzip`, `zsh`). You don't need Git or Xcode Command Line Tools.

Then apply the changes to your current terminal:

```bash
source ~/.zshrc
```

---

## What You Get

- **Smart Autosuggestions** — Type any word and get suggestions from your history, even if it appears in the middle of a command. Case doesn't matter (e.g., typing `GOOGLE` finds `curl -I google.com`).
- **History Search with Arrow Keys** — Type a keyword, then press **Up / Down** to scroll through every past command that contains it.
- **Syntax Highlighting** — Commands turn green if valid, red if not — in real time as you type.
- **Clean Prompt** — Shows `~/short/path (branch*) ❯`. Inside a Git repo, you see the branch name and whether you have uncommitted changes. The arrow turns pink if the last command failed.
- **Auto-CD** — Type a directory path and press Enter. No need to type `cd` first.
- **Colorful File Listings** — Files and folders get distinct colors that look good on both light and dark backgrounds.
- **Better Defaults** — Tab completion, smarter history (no duplicates), and up to 100,000 commands saved.
- **Dev Tools Installer (`install-dev-tool`)** — An interactive menu to install Go, Node.js, Python & uv, Rust, JDK (Eclipse Temurin LTS), Codex, Git, OrbStack, Android Studio, VSCode, DBeaver, MongoDB Compass, Antigravity, Claude, and Google Chrome. Navigate with arrow keys, pick what you need.

---

## How to Use

### 1. Smart Autosuggestions

As you type, Zsh shows a faded suggestion from your history.

- **Starts with your text**: Type `curl` → see ` -I google.com` in gray. Press `Tab` or `→` to accept.
- **Contains your text**: Type `google` → see `» curl -I google.com`.
  - Press **`Tab`**, **`→`**, or **`Ctrl+F`** to accept the whole suggestion.
  - Press **`Option+→`** (or `Alt+F`) to accept one word at a time.
- **Browse more matches**: Press **Up Arrow** to replace the line with another match, then keep pressing **Up / Down** to cycle through all matches.

### 2. Auto-CD

Just type a path and press Enter:
```bash
~/Downloads  # goes to ~/Downloads
..           # goes up one folder
```

### 3. Git-Aware Prompt

- Shows `~/short/path (branch*) ❯ `. Long paths are automatically truncated.
- Pink `*` = you have unstaged changes. Green `+` = you have staged changes.
- Arrow `❯` turns pink if the last command failed.

### 4. Dev Tools Installer (`install-dev-tool`)

Run `install-dev-tool` to open an interactive menu.

![install-dev-tool](install-dev-tool.png)

- **Navigate**: Use **Up / Down** arrow keys to move the cursor (`❯`).
- **Select tools**: Press **Space** or **Enter** to check/uncheck a tool (`[ ]` ↔ `[✓]`).
- **Install**: Move to `[I] Install Selected Tools` and press **Enter** (or type `I`).
- **Select all**: Press **Enter** on `[A] Toggle All` (or type `A`).
- **Update all outdated**: Press **Enter** on `[U] Select Outdated Tools` (or type `U`), or run `install-dev-tool --update-all` directly from your terminal.
- **Quit**: Press **Enter** on `[E] Exit` (or type `E`).

**Good to know:**
- Go and Node.js install to `~/.local/` — no `sudo` needed, even for global npm packages.
- Python installs along with `uv` (Astral's fast Python package & project manager).
- JDK installs official Eclipse Temurin LTS release and configures `JAVA_HOME`.
- Desktop apps (VSCode, Claude, OrbStack, MongoDB Compass, DBeaver, Google Chrome, Android Studio, Antigravity) are downloaded and placed in `/Applications` automatically.
- Git is installed through Apple's official `xcode-select --install`.
- The installer checks for the latest versions automatically on startup.

---

## Uninstall (One Command)

To remove everything and go back to your original settings:

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/uninstall.sh | bash
```

This will:
1. **Remove the setup-zsh config** from your `~/.zshrc` — your own custom aliases and settings are kept safe. If the file was created by this script and is now empty, it gets deleted.
2. **Delete the plugin folder** at `~/.zsh/setup-zsh/` — nothing else in `~/.zsh/` is touched.

---

## License

Licensed under the [MIT License](LICENSE).

Includes these third-party plugins in the `plugins/` directory:
- **zsh-syntax-highlighting** — [BSD 3-Clause License](plugins/zsh-syntax-highlighting/COPYING.md)
- **zsh-autosuggestions** — [MIT License](plugins/zsh-autosuggestions/LICENSE)
