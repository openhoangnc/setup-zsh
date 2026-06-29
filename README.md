# setup-zsh

A premium, lightweight Zsh configuration script for macOS that adds syntax highlighting, colored file listings, a sleek minimal prompt, and a custom **match-any (substring) autosuggestions strategy**.

Unlike standard configurations that only suggest commands starting with your typed characters, this setup matches **any substring** in your history and formats them with an elegant completion indicator (`↳`).

## Features

- **Match-Any Autosuggestions**: Suggestions search your entire history for any command containing your input (e.g. typing `google` matches and auto-completes `curl -I google.com`).
- **Syntax Highlighting**: Real-time syntax check (green for valid commands, red for invalid).
- **Sleek Username Prompt**: A modern, minimal prompt showing `username ❯` which turns pink (`username ❯`) if the last command failed.
- **Enhanced Directory Colors**: Customized `LSCOLORS` to give files and directories a vibrant look on light/dark backgrounds.
- **Optimized Defaults**: Enables Zsh tab completion, history appending, duplicate reductions, and increases session history to 100,000 commands.

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


