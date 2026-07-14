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

- **Smart Autosuggestions** — Commands you're starting to type are suggested first; if nothing starts with your text, your whole history is searched for it *anywhere* in a command, shown with a `»` arrow. Case doesn't matter (e.g., typing `GOOGLE` finds `curl -I google.com`).
- **History Search with Arrow Keys** — Type a keyword, then press **Up / Down** to scroll through every past command that contains it.
- **Syntax Highlighting** — Commands turn green if valid, red if not — in real time as you type.
- **Clean Prompt** — Shows `~/short/path (branch*) ↑1 ↓2 ❯`. Inside a Git repo, you see the branch name, whether you have uncommitted changes, and how many commits you're ahead/behind the remote. The arrow turns pink if the last command failed.
- **Auto-CD** — Type a directory path and press Enter. No need to type `cd` first.
- **Colorful File Listings** — Files and folders get distinct colors that look good on both light and dark backgrounds.
- **Better Defaults** — Case-insensitive Tab completion, smarter history (no duplicates), up to 100,000 commands saved, and everyday keys that just work (Home / End / Fn+Delete / Option+Arrow word jumps).
- **Dev Tools Installer (`install-dev-tool`)** — An interactive menu to install Bun, Go, Homebrew, Node.js, Python & uv, Rust, JDK (Eclipse Temurin LTS), Codex, Git, OrbStack, Android Studio, VSCode, DBeaver, MongoDB Compass, Antigravity, Claude, Google Chrome, and OmniDiskSweeper. Navigate with arrow keys, pick what you need.
- **Mac Cleanup (`clean-my-mac`)** — An interactive tool that reclaims disk space from regenerable developer caches and build artifacts (Xcode, Go, Node/npm/pnpm/yarn, Gradle, Maven, Cargo, Python, Homebrew, Playwright, and more), clears Electron/browser/app caches, offers to sweep project junk grouped per repo so you pick which projects to clean (`node_modules`, `dist`, build output, git-ignored files), reclaims Docker/Podman space, and surfaces leftover data from apps you've uninstalled. Categories are defined in editable JSON files; it shows *what* and *why* for every item, never deletes without confirmation, and even runs standalone via `curl … | bash`.

---

## How to Use

### 1. Smart Autosuggestions

As you type, Zsh shows a faded suggestion from your history. Suggestions that **start with** your text are preferred; when nothing starts with it, the most recent command **containing** it is shown after a `»` arrow.

- **Starts with your text**: Type `curl` → see ` -I google.com` in gray. Press `→` or `Ctrl+F` to accept.
- **Contains your text**: Type `google` → see `» curl -I google.com`.
  - Press **`→`** or **`Ctrl+F`** to accept the whole suggestion.
  - Press **`Option+→`** (or `Alt+F`) to accept one word at a time.
- **Browse more matches**: Press **Up Arrow** to replace the line with another match, then keep pressing **Up / Down** to cycle through all matches.

> ⚠️ **Enter always runs exactly what you typed** — never the faded suggestion. To run a `»` suggestion, accept it first with `→` (or `Ctrl+F`), then press Enter.

### 2. Auto-CD

Just type a path and press Enter:
```bash
~/Downloads  # goes to ~/Downloads
..           # goes up one folder
```

> If a folder shares its name with a command (e.g. `test`), the command wins. Add a slash to force the cd: `test/`.

### 3. Git-Aware Prompt

- Shows `~/short/path (branch*) ↑1 ↓2 ❯ `. Long paths are automatically truncated.
- Pink `*` = you have unstaged changes. Green `+` = you have staged changes.
- Green `↑N` = N commits ahead of the remote (to push). Pink `↓N` = N commits behind (to pull). Hidden when in sync.
- Arrow `❯` turns pink if the last command failed.

### 4. Dev Tools Installer (`install-dev-tool`)

Run `install-dev-tool` to open an interactive menu.

![install-dev-tool](install-dev-tool.png)

- **Navigate**: Use **Up / Down / Left / Right** arrow keys to move the cursor (`❯`).
- **Select tools**: Press **Space** or **Enter** to check/uncheck a tool (`[ ]` ↔ `[✓]`), or type its number (for items 10–17, type both digits quickly).
- **Actions (single line at bottom)**:
  - **Install**: Move to `[I] Install` and press **Enter** (or type `I`).
  - **Select all**: Move to `[A] Toggle All` and press **Enter** (or type `A`).
  - **Update all outdated**: Move to `[U] Select Outdated` and press **Enter** (or type `U`), or run `install-dev-tool --update-all` from your terminal (it exits when done).
  - **Quit**: Move to `[E] Exit` and press **Enter** (or type `E`, `Q`, `Esc`, or `Ctrl+C`).
- **CLI flags**: `install-dev-tool --help` lists all options (`-u/--update-all`, `-a/--all`).

**Good to know:**
- Bun installs via its official script (`https://bun.sh/install`) to `~/.bun/bin`.
- Go and Node.js install to `~/.local/` — no `sudo` needed, even for global npm packages.
- Homebrew installs via its official script (`https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh`) and configures `shellenv`.
- Python installs along with `uv` (Astral's fast Python package & project manager).
- JDK installs official Eclipse Temurin LTS release and configures `JAVA_HOME`.
- Desktop apps (VSCode, Claude, OrbStack, MongoDB Compass, DBeaver, Google Chrome, Android Studio, Antigravity, OmniDiskSweeper) are downloaded and placed in `/Applications` automatically.
- Git is installed through Apple's official `xcode-select --install`.
- The installer checks for the latest versions automatically on startup.

### 5. Mac Cleanup (`clean-my-mac`)

Run `clean-my-mac` to open an interactive cleanup menu. It scans your Mac and groups everything it can safely reclaim into categories, each showing how much space it would free.

It also **runs standalone** — no need to install setup-zsh first:

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/bin/clean-my-mac | bash
# dry-run (look only, delete nothing):
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/bin/clean-my-mac | bash -s -- --dry-run
```

- **Navigate**: Use **Up / Down** arrows (or `j` / `k`) to move the cursor (`❯`).
- **Select**: Press **Space** or **Enter** to check/uncheck a category (`[ ]` ↔ `[✓]`). Safe, regenerable caches are pre-selected; riskier items (Maven repo, Playwright, crash logs), project folders, and orphaned app data start **unchecked**.
- **Details**: Press **`d`** to see the exact paths and sizes inside the highlighted category.
- **Bulk**: **`a`** selects all, **`n`** selects none, **`s`** resets to the safe defaults.
- **Clean**: Press **`c`** to review an itemized plan (what gets **deleted** vs. **moved to Trash**, plus the total), then confirm with `y`.
- **Quit**: Press **`q`** (or `Esc`).

**What it removes:**
- **Developer caches & build artifacts** — Xcode DerivedData/DeviceSupport, Go build & module cache, npm/pnpm/yarn caches, Gradle, Maven, Cargo, Python (pip/uv/poetry), Bun, CocoaPods, JetBrains, Playwright, and the Homebrew download cache.
- **Electron, browser & app caches** — disk/GPU/code caches for Electron apps (VS Code, Claude, Slack, …) and browsers (Chrome, Brave, Edge, Vivaldi, Arc, Firefox).
- **Project junk (grouped per project)** — after the cache scan, an interactive run offers to scan your code repos and lists what it finds **grouped by project** (one git repo = one row) so you can pick exactly which repos to clean. Each row shows its reclaimable size and what's inside (`node_modules`, `dist`, `build`, `target`, `__pycache__`, and git-ignored files); regenerable build/dependency dirs are deleted, while any other git-ignored item (a local `.env`/config) is moved to the Trash so it can be recovered. Junk that isn't inside a git repo — language/tool caches, global npm, editor extensions — is left to the cache categories, never mistaken for one of your projects. Pass `clean-my-mac -p` to force the repo scan in non-interactive/scripted runs.
- **Docker / Podman** — reclaims stopped containers, unused images, and build cache via `system prune -af` (opt-in). Named volumes / databases are never touched.
- **Orphaned app data** — leftover `Application Support` / `Caches` / `Preferences` folders whose owning app is no longer installed.

**Editable patterns.** Every category is described by JSON "pattern" files (in the [`clean-my-mac-rules/`](clean-my-mac-rules/) folder, installed to `~/.zsh/setup-zsh/clean-my-mac-rules`, or downloaded when running standalone). Edit them to add or remove targets — no code changes. Point at your own set with `clean-my-mac --patterns <dir-or-url>`.

**Good to know:**
- Caches and build output are deleted permanently (that's the point). **Orphaned app data and git-ignored files are moved to the Trash**, so you can restore them.
- App sandboxes and anything Apple/system-owned are never touched, and high-value folders (`~/Documents`, `~/Desktop`, `~/Downloads`, `~/Pictures`, `~/.ssh`, iCloud Drive, …) are never deleted regardless of what a pattern says. The installed-app list is read from LaunchServices, so still-installed prefPanes, plugins, and drivers aren't mistaken for orphaned.
- Project scanning is **off by default** (`-p` to enable) because scanning your home folder is slower.
- `clean-my-mac --dry-run` shows what could be freed without deleting anything. `clean-my-mac --yes` non-interactively clears the pre-selected safe caches (skips project folders, orphaned data, and the Trash). `clean-my-mac --help` lists all options.
- Every run is logged to `~/.zsh/setup-zsh/clean.log`.

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
