#!/bin/bash

# Zsh Setup Script for MacBook
# Enforces syntax highlighting, custom prompt, and custom match-any zsh-autosuggestions.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting Zsh Setup ===${NC}"

# 1. Platform Check
if [[ "$OSTYPE" != "darwin"* ]]; then
	echo -e "${RED}Error: This script is intended for macOS only.${NC}"
	exit 1
fi

# 2. Dependency Checks
for cmd in curl unzip zsh awk; do
	if ! command -v "$cmd" &>/dev/null; then
		echo -e "${RED}Error: '$cmd' is not installed or not in PATH.${NC}"
		exit 1
	fi
done

# 3. Create Isolated Plugins Directory (avoids collision with ~/.zsh/plugins)
PLUGIN_DIR="$HOME/.zsh/setup-zsh/plugins"
echo -e "${BLUE}Creating isolated plugins directory at $PLUGIN_DIR...${NC}"
mkdir -p "$PLUGIN_DIR"

# 4. Install Plugins (Syntax Highlighting, Substring Search & Autosuggestions)
SYNTAX_DIR="$PLUGIN_DIR/zsh-syntax-highlighting"
SUBSTRING_DIR="$PLUGIN_DIR/zsh-history-substring-search"
SUGGEST_DIR="$PLUGIN_DIR/zsh-autosuggestions"

# Determine script directory if run from local file
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]}" && -f "${BASH_SOURCE[0]}" ]]; then
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [[ -n "$SCRIPT_DIR" && -d "$SCRIPT_DIR/plugins/zsh-autosuggestions" && -d "$SCRIPT_DIR/plugins/zsh-syntax-highlighting" && -d "$SCRIPT_DIR/plugins/zsh-history-substring-search" ]]; then
	echo -e "${BLUE}Installing plugins from local repository...${NC}"
	rm -rf "$SYNTAX_DIR" "$SUBSTRING_DIR" "$SUGGEST_DIR"
	cp -R "$SCRIPT_DIR/plugins/zsh-syntax-highlighting" "$SYNTAX_DIR"
	cp -R "$SCRIPT_DIR/plugins/zsh-history-substring-search" "$SUBSTRING_DIR"
	cp -R "$SCRIPT_DIR/plugins/zsh-autosuggestions" "$SUGGEST_DIR"
	
	if [[ -d "$SCRIPT_DIR/bin" ]]; then
		echo -e "${BLUE}Installing bin directory from local repository...${NC}"
		mkdir -p "$HOME/.zsh/setup-zsh/bin"
		cp -R "$SCRIPT_DIR/bin/"* "$HOME/.zsh/setup-zsh/bin/"
		chmod +x "$HOME/.zsh/setup-zsh/bin/"*
	fi
	echo -e "${GREEN}✓ Plugins installed from local repository.${NC}"
else
	echo -e "${BLUE}Downloading plugins from openhoangnc/setup-zsh repository...${NC}"
	rm -rf "$SYNTAX_DIR" "$SUBSTRING_DIR" "$SUGGEST_DIR"
	# No .zip suffix: BSD mktemp (macOS) only substitutes TRAILING Xs, so a
	# "setup-zsh.XXXXXX.zip" template is taken literally (no randomization) and
	# would collide on reruns; unzip reads magic bytes, so the extension is moot.
	TEMP_ZIP=$(mktemp /tmp/setup-zsh.XXXXXX)
	TEMP_DIR=$(mktemp -d /tmp/setup-zsh.XXXXXX)
	curl -fsSL https://github.com/openhoangnc/setup-zsh/archive/refs/heads/main.zip -o "$TEMP_ZIP"
	unzip -q -o "$TEMP_ZIP" -d "$TEMP_DIR"
	
	mv "$TEMP_DIR"/setup-zsh-main/plugins/zsh-syntax-highlighting "$SYNTAX_DIR"
	mv "$TEMP_DIR"/setup-zsh-main/plugins/zsh-history-substring-search "$SUBSTRING_DIR"
	mv "$TEMP_DIR"/setup-zsh-main/plugins/zsh-autosuggestions "$SUGGEST_DIR"
	
	if [[ -d "$TEMP_DIR/setup-zsh-main/bin" ]]; then
		echo -e "${BLUE}Installing bin directory from openhoangnc/setup-zsh repository...${NC}"
		mkdir -p "$HOME/.zsh/setup-zsh/bin"
		cp -R "$TEMP_DIR/setup-zsh-main/bin/"* "$HOME/.zsh/setup-zsh/bin/"
		chmod +x "$HOME/.zsh/setup-zsh/bin/"*
	fi
	rm -rf "$TEMP_ZIP" "$TEMP_DIR"
	echo -e "${GREEN}✓ Plugins installed from openhoangnc/setup-zsh repository.${NC}"
fi

# 5. Install CleanDevMac (cdm)
#    The Mac cleanup tool lives in its own repository now — cleandevmac/cdm —
#    so pull the latest released build rather than vendoring a copy here.
#    A failed download must not abort the whole setup, so this step only warns.
BIN_DIR="$HOME/.zsh/setup-zsh/bin"
echo -e "${BLUE}Installing CleanDevMac (cdm) from cleandevmac/cdm...${NC}"
mkdir -p "$BIN_DIR"
TEMP_CDM=$(mktemp /tmp/cdm.XXXXXX)
if curl -fsSL https://github.com/cleandevmac/cdm/releases/latest/download/cdm -o "$TEMP_CDM" && [[ -s "$TEMP_CDM" ]]; then
	mv "$TEMP_CDM" "$BIN_DIR/cdm"
	# 755, not `chmod +x`: mktemp creates 0600, so +x would leave an odd 0711.
	chmod 755 "$BIN_DIR/cdm"
	# Keep the old command name working for anyone who installed setup-zsh back
	# when the tool was vendored here. Replaces the retired script in place.
	ln -sf cdm "$BIN_DIR/clean-my-mac"
	# Rules ship with cdm now; the vendored copies are dead weight.
	rm -rf "$HOME/.zsh/setup-zsh/clean-my-mac-rules"
	echo -e "${GREEN}✓ cdm installed (run 'cdm', or 'clean-my-mac').${NC}"
else
	rm -f "$TEMP_CDM"
	echo -e "${RED}Warning: could not download cdm. Skipping — re-run this script to retry.${NC}"
fi

# 6. Auto-detect installed dev tools and regenerate env.zsh
ENV_FILE="$HOME/.zsh/setup-zsh/env.zsh"

_update_env_block() {
	local marker="$1"
	local content="$2"

	mkdir -p "$(dirname "$ENV_FILE")"
	touch "$ENV_FILE"

	local temp_file
	temp_file=$(mktemp /tmp/env_zsh.XXXXXX)
	awk -v start="# >>> ${marker} >>>" -v end="# <<< ${marker} <<<" '
		$0 == start {p=1; next}
		$0 == end {p=0; next}
		!p
	' "$ENV_FILE" > "$temp_file"

	if [[ -n "$content" ]]; then
		echo -e "# >>> ${marker} >>>\n${content}\n# <<< ${marker} <<<" >> "$temp_file"
	fi

	mv "$temp_file" "$ENV_FILE"
}

_needs_env_block() {
	local marker="$1"
	[[ ! -f "$ENV_FILE" ]] && return 0
	! grep -q "# >>> ${marker} >>>" "$ENV_FILE"
}

# Bun
if ([[ -x "$HOME/.bun/bin/bun" ]] || command -v bun &>/dev/null) && _needs_env_block "Bun"; then
	echo -e "${BLUE}Detected Bun, adding to PATH...${NC}"
	_update_env_block "Bun" "export BUN_INSTALL=\"\$HOME/.bun\"\nexport PATH=\"\$BUN_INSTALL/bin:\$PATH\""
fi

# Go
if [[ -x "$HOME/.local/go/bin/go" ]] && _needs_env_block "Go"; then
	echo -e "${BLUE}Detected Go at ~/.local/go, adding to PATH...${NC}"
	_update_env_block "Go" "export GOROOT=\"\$HOME/.local/go\"\nexport GOPATH=\"\$HOME/go\"\nexport PATH=\"\$GOROOT/bin:\$GOPATH/bin:\$PATH\""
fi

# Node
if [[ -x "$HOME/.local/node/bin/node" ]] && _needs_env_block "Node"; then
	echo -e "${BLUE}Detected Node.js at ~/.local/node, adding to PATH...${NC}"
	_update_env_block "Node" "export PATH=\"\$HOME/.local/node/bin:\$PATH\""
fi

# Rust
if [[ -x "$HOME/.cargo/bin/rustc" ]] && _needs_env_block "Rust"; then
	echo -e "${BLUE}Detected Rust at ~/.cargo, adding to PATH...${NC}"
	_update_env_block "Rust" "export PATH=\"\$HOME/.cargo/bin:\$PATH\""
fi

# OrbStack
if [[ -d "/Applications/OrbStack.app/Contents/MacOS/bin" ]] && _needs_env_block "OrbStack"; then
	echo -e "${BLUE}Detected OrbStack, adding to PATH...${NC}"
	_update_env_block "OrbStack" "if [[ -d \"/Applications/OrbStack.app/Contents/MacOS/bin\" ]]; then\n  export PATH=\"/Applications/OrbStack.app/Contents/MacOS/bin:\$PATH\"\nfi"
fi

# VSCode
if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]] && _needs_env_block "VSCode"; then
	echo -e "${BLUE}Detected VSCode, adding to PATH...${NC}"
	_update_env_block "VSCode" "export PATH=\"/Applications/Visual Studio Code.app/Contents/Resources/app/bin:\$PATH\""
fi

# Python aliases & uv
if (command -v python3 &>/dev/null || command -v uv &>/dev/null || [[ -x "$HOME/.local/bin/uv" ]]) && _needs_env_block "Python"; then
	echo -e "${BLUE}Detected Python3 / uv, adding PATH and aliases...${NC}"
	_update_env_block "Python" "export PATH=\"\$HOME/.local/bin:\$PATH\"\nalias python=\"python3\"\nalias pip=\"pip3\""
fi

# JDK (Eclipse Temurin LTS)
if command -v /usr/libexec/java_home &>/dev/null && /usr/libexec/java_home &>/dev/null && _needs_env_block "JDK"; then
	echo -e "${BLUE}Detected Java JDK, adding JAVA_HOME...${NC}"
	_update_env_block "JDK" "if command -v /usr/libexec/java_home &>/dev/null; then\n  export JAVA_HOME=\"\$(/usr/libexec/java_home 2>/dev/null)\"\n  export PATH=\"\$JAVA_HOME/bin:\$PATH\"\nfi"
fi

# Android Studio / SDK
if [[ -d "$HOME/Library/Android/sdk" || -d "/Applications/Android Studio.app" ]] && _needs_env_block "AndroidStudio"; then
	echo -e "${BLUE}Detected Android Studio / SDK, adding environment variables...${NC}"
	_update_env_block "AndroidStudio" "export ANDROID_HOME=\"\$HOME/Library/Android/sdk\"\nexport ANDROID_SDK_ROOT=\"\$HOME/Library/Android/sdk\"\nexport PATH=\"\$ANDROID_HOME/emulator:\$ANDROID_HOME/platform-tools:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools/bin:\$PATH\""
fi

# Codex
if [[ -x "$HOME/.local/bin/codex" ]] && _needs_env_block "Codex"; then
	echo -e "${BLUE}Detected Codex at ~/.local/bin/codex, adding to PATH...${NC}"
	_update_env_block "Codex" "export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# Homebrew
if ([[ -x "/opt/homebrew/bin/brew" ]] || [[ -x "/usr/local/bin/brew" ]] || command -v brew &>/dev/null) && _needs_env_block "Homebrew"; then
	echo -e "${BLUE}Detected Homebrew, adding to PATH...${NC}"
	_update_env_block "Homebrew" "if [[ -x \"/opt/homebrew/bin/brew\" ]]; then\n  eval \"\$(/opt/homebrew/bin/brew shellenv)\"\nelif [[ -x \"/usr/local/bin/brew\" ]]; then\n  eval \"\$(/usr/local/bin/brew shellenv)\"\nfi"
fi

# 7. Save original ~/.zshrc for comparison, then update
ZSHRC="$HOME/.zshrc"
ORIGINAL_RC=""
if [[ -f "$ZSHRC" ]]; then
	ORIGINAL_RC=$(mktemp /tmp/zshrc_original.XXXXXX)
	cp "$ZSHRC" "$ORIGINAL_RC"
else
	touch "$ZSHRC"
fi

# 8. Clean existing setup-zsh configuration block to allow safe re-runs
echo -e "${BLUE}Cleaning any existing setup-zsh configuration block...${NC}"
TEMP_RC=$(mktemp /tmp/zshrc.XXXXXX)
awk '/# >>> setup-zsh >>>/{p=1;next}/# <<< setup-zsh <<</{p=0;next}!p' "$ZSHRC" > "$TEMP_RC"
mv "$TEMP_RC" "$ZSHRC"

# 9. Append the configuration block to ~/.zshrc
echo -e "${BLUE}Appending Zsh configuration block to ~/.zshrc...${NC}"
cat << 'EOF' >> "$ZSHRC"
# >>> setup-zsh >>>
# -------------------------------------------------------------
# Zsh Settings (Managed by setup-zsh)
# -------------------------------------------------------------

# 1. Zsh History Settings
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Auto-CD (type directory path without cd to enter)
setopt AUTO_CD

# Keyboard defaults: Emacs keymap regardless of $EDITOR, plus everyday macOS keys
bindkey -e
bindkey '^[[H' beginning-of-line     # Home
bindkey '^[[F' end-of-line           # End
bindkey '^[[3~' delete-char          # Fn+Delete (forward delete)
bindkey '^[[1;3C' forward-word       # Option+Right
bindkey '^[[1;3D' backward-word      # Option+Left
bindkey '^[[1;5C' forward-word       # Ctrl+Right
bindkey '^[[1;5D' backward-word      # Ctrl+Left

# Enable tab completion (full security audit at most once a day)
autoload -Uz compinit
() {
	setopt local_options extended_glob
	if [[ ! -f $HOME/.zcompdump || -n $HOME/.zcompdump(#qN.mh+24) ]]; then
		compinit
	else
		compinit -C
	fi
}

# 2. Syntax Highlighting
if [[ -f ~/.zsh/setup-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source ~/.zsh/setup-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# 3. History Substring Search (Cycle matches with Up/Down Arrows)
if [[ -f ~/.zsh/setup-zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
	source ~/.zsh/setup-zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

	# Ensure all unique matching history entries are found
	HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

	# Bind arrow keys for history substring search
	bindkey '^[[A' history-substring-search-up
	bindkey '^[[B' history-substring-search-down
	if [[ -n "$terminfo[kcuu1]" ]]; then
		bindkey "$terminfo[kcuu1]" history-substring-search-up
	fi
	if [[ -n "$terminfo[kcud1]" ]]; then
		bindkey "$terminfo[kcud1]" history-substring-search-down
	fi
fi

# 4. Autosuggestions Core Setup
if [[ -f ~/.zsh/setup-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source ~/.zsh/setup-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

	# Customize autosuggest style (clean, beautiful gray)
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

	# Configure strategies: exact-prefix history first, then substring (match_any).
	# Prefix matches align with what you're typing; » substring is the fallback.
	ZSH_AUTOSUGGEST_STRATEGY=(history match_any)


	# -------------------------------------------------------------
	# 5. Custom Match-Any (Substring) Strategy and Widgets
	# -------------------------------------------------------------
	
	# Define custom match_any strategy (case-insensitive substring)
	_zsh_autosuggest_strategy_match_any() {
		emulate -L zsh
		setopt EXTENDED_GLOB
		local prefix="${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}"
		local pattern="(#i)*$prefix*"
		if [[ -n $ZSH_AUTOSUGGEST_HISTORY_IGNORE ]]; then
			pattern="($pattern)~($ZSH_AUTOSUGGEST_HISTORY_IGNORE)"
		fi
		typeset -g suggestion="${history[(r)$pattern]}"
	}

	# Override internal suggestion fetcher to allow substring matching
	_zsh_autosuggest_fetch_suggestion() {
		typeset -g suggestion
		local -a strategies
		local strategy

		strategies=(${=ZSH_AUTOSUGGEST_STRATEGY})

		for strategy in $strategies; do
			# Try to get a suggestion from this strategy
			_zsh_autosuggest_strategy_$strategy "$1"

			if [[ "$strategy" == "match_any" ]]; then
				# For match_any, check that the suggestion contains the buffer case-insensitively
				[[ "${suggestion:l}" != *"${1:l}"* ]] && unset suggestion
			else
				# Standard prefix match requirement
				[[ "$suggestion" != "$1"* ]] && unset suggestion
			fi

			[[ -n "$suggestion" ]] && break
		done
	}

	# Override suggestion display function
	_zsh_autosuggest_suggest() {
		emulate -L zsh
		local suggestion="$1"
		typeset -g _ZSH_AUTOSUGGEST_CURRENT_SUGGESTION="$suggestion"

		if [[ -n "$suggestion" ]] && (( $#BUFFER )); then
			if [[ "${suggestion:l}" == "${BUFFER:l}"* ]]; then
				# Case-insensitive prefix match display
				POSTDISPLAY="${suggestion#${suggestion[1,$#BUFFER]}}"
			else
				# Substring match display (add subtle indicator)
				POSTDISPLAY=" » $suggestion"
			fi
		else
			POSTDISPLAY=
		fi
	}

	# Override accept function to correctly handle substring suggestions
	_zsh_autosuggest_accept() {
		local -i retval max_cursor_pos=$#BUFFER

		if [[ "$KEYMAP" = "vicmd" ]]; then
			max_cursor_pos=$((max_cursor_pos - 1))
		fi

		if (( $CURSOR != $max_cursor_pos || !$#POSTDISPLAY )); then
			_zsh_autosuggest_invoke_original_widget $@
			return
		fi

		if [[ -n "$_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION" ]] && \
			[[ "$POSTDISPLAY" == " » "* || "$BUFFER" != "${_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION[1,$#BUFFER]}" ]]; then
			# Substring or case-insensitive match: take the history entry verbatim
			# (appending would keep the wrong-case text the user typed)
			BUFFER="$_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION"
		else
			BUFFER="$BUFFER$POSTDISPLAY"
		fi

		POSTDISPLAY=

		_zsh_autosuggest_invoke_original_widget $@
		retval=$?

		if [[ "$KEYMAP" = "vicmd" ]]; then
			CURSOR=$(($#BUFFER - 1))
		else
			CURSOR=$#BUFFER
		fi

		return $retval
	}

	# Override execute function (accept suggestion and run it; unbound by default —
	# add widget names to ZSH_AUTOSUGGEST_EXECUTE_WIDGETS to enable)
	_zsh_autosuggest_execute() {
		if [[ -n "$_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION" ]] && \
			[[ "$POSTDISPLAY" == " » "* || "$BUFFER" != "${_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION[1,$#BUFFER]}" ]]; then
			BUFFER="$_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION"
		else
			BUFFER="$BUFFER$POSTDISPLAY"
		fi

		POSTDISPLAY=

		_zsh_autosuggest_invoke_original_widget "accept-line"
	}

	# Override partial accept function (word-by-word accept)
	_zsh_autosuggest_partial_accept() {
		local -i retval cursor_loc
		local original_buffer="$BUFFER"

		if [[ "$POSTDISPLAY" == " » "* ]]; then
			# Case-insensitive index search
			local idx=${${_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION:l}[(i)${(b)${BUFFER:l}}]}
			if (( idx <= $#_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION )); then
				BUFFER="$_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION"
				CURSOR=$((idx + $#original_buffer - 1))
			else
				BUFFER="$BUFFER$POSTDISPLAY"
			fi
		else
			BUFFER="$BUFFER$POSTDISPLAY"
		fi

		_zsh_autosuggest_invoke_original_widget $@
		retval=$?

		cursor_loc=$CURSOR
		if [[ "$KEYMAP" = "vicmd" ]]; then
			cursor_loc=$((cursor_loc + 1))
		fi

		local boundary=$#original_buffer
		if [[ "$POSTDISPLAY" == " » "* ]]; then
			boundary=$((idx + $#original_buffer - 1))
		fi

		if (( cursor_loc > boundary )); then
			POSTDISPLAY="${BUFFER[$(($cursor_loc + 1)),$#BUFFER]}"
			BUFFER="${BUFFER[1,$cursor_loc]}"
		else
			BUFFER="$original_buffer"
		fi

		return $retval
	}
fi

# 6. Colored Prompt (Short Directory, Git status, success/failure indicator)
autoload -Uz vcs_info add-zsh-hook
precmd_vcs_info() { vcs_info }
add-zsh-hook precmd precmd_vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '%F{197}*%f'
zstyle ':vcs_info:git:*' stagedstr '%F{121}+%f'
zstyle ':vcs_info:git:*' formats ' %F{242}(%F{81}%b%u%c%F{242})%f%m'
zstyle ':vcs_info:git:*' actionformats ' %F{242}(%F{81}%b%F{197}|%a%u%c%F{242})%f%m'

# Upstream sync status (fish-style): ↑N commits ahead to push, ↓N behind to pull
zstyle ':vcs_info:git*+set-message:*' hooks git-aheadbehind
+vi-git-aheadbehind() {
	local ab
	ab=$(command git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null) || return
	local behind=${ab[(w)1]} ahead=${ab[(w)2]}
	(( ahead )) && hook_com[misc]+=" %F{121}↑${ahead}%f"
	(( behind )) && hook_com[misc]+=" %F{197}↓${behind}%f"
}

PROMPT='%F{147}%25<…<%~%<<%f${vcs_info_msg_0_} %(?.%F{121}❯%f.%F{197}❯%f) '

# 7. Colors for LS & Directories
export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"
# GNU-style equivalent of LSCOLORS so completion lists match ls colors
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
# Case-insensitive Tab completion (exact-case matches still win)
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# 8. PATH de-duplication
# The environment itself (PATH additions, GOROOT, ANDROID_HOME, ...) is set in
# ~/.zshenv so that non-interactive shells and tools (editors, IDEs, `zsh -c`)
# inherit it too — ~/.zshrc is read only by interactive shells. See the
# setup-zsh block appended to ~/.zshenv below.
typeset -U path PATH
# <<< setup-zsh <<<
EOF

# 10. Backup only if content actually changed
if [[ -n "$ORIGINAL_RC" ]]; then
	if diff -q "$ZSHRC" "$ORIGINAL_RC" > /dev/null 2>&1; then
		echo -e "${GREEN}✓ ~/.zshrc is already up to date, no backup needed.${NC}"
	else
		BACKUP="$ZSHRC.bak.$(date +%Y%m%d%H%M%S)"
		echo -e "${BLUE}Backing up original .zshrc to $BACKUP...${NC}"
		cp "$ORIGINAL_RC" "$BACKUP"
	fi
	rm -f "$ORIGINAL_RC"
fi

echo -e "${GREEN}✓ ~/.zshrc updated successfully!${NC}"

# 11. Create/refresh ~/.zshenv so the environment is available to ALL zsh
#     invocations — login, interactive, scripts, and non-interactive tools
#     (editors, IDEs, cron, `zsh -c ...`). ~/.zshrc is sourced only by
#     interactive shells, so PATH additions placed there are invisible to
#     anything that spawns a non-interactive zsh. Sourcing env.zsh from
#     ~/.zshenv is what makes node/go/etc. resolve for those tools.
echo -e "${BLUE}Updating ~/.zshenv for non-interactive shells...${NC}"
ZSHENV="$HOME/.zshenv"
ORIGINAL_ENV=""
if [[ -f "$ZSHENV" ]]; then
	ORIGINAL_ENV=$(mktemp /tmp/zshenv_original.XXXXXX)
	cp "$ZSHENV" "$ORIGINAL_ENV"
else
	touch "$ZSHENV"
fi

# Clean existing setup-zsh block to allow safe re-runs
TEMP_ENV=$(mktemp /tmp/zshenv.XXXXXX)
awk '/# >>> setup-zsh >>>/{p=1;next}/# <<< setup-zsh <<</{p=0;next}!p' "$ZSHENV" > "$TEMP_ENV"
mv "$TEMP_ENV" "$ZSHENV"

cat << 'EOF' >> "$ZSHENV"
# >>> setup-zsh >>>
# -------------------------------------------------------------
# Environment for ALL zsh invocations (Managed by setup-zsh)
# -------------------------------------------------------------
# ~/.zshenv is sourced by every zsh — login, interactive, scripts, and
# non-interactive tools (editors, IDEs, `zsh -c ...`). Keep this file limited
# to environment setup; interactive-only config (history, keybindings, prompt,
# plugins) lives in ~/.zshrc.
typeset -U path PATH
if [[ -d "$HOME/.zsh/setup-zsh/bin" ]]; then
	export PATH="$HOME/.zsh/setup-zsh/bin:$PATH"
fi
if [[ -f "$HOME/.zsh/setup-zsh/env.zsh" ]]; then
	source "$HOME/.zsh/setup-zsh/env.zsh"
fi
# <<< setup-zsh <<<
EOF

# Backup only if content actually changed
if [[ -n "$ORIGINAL_ENV" ]]; then
	if diff -q "$ZSHENV" "$ORIGINAL_ENV" > /dev/null 2>&1; then
		echo -e "${GREEN}✓ ~/.zshenv is already up to date, no backup needed.${NC}"
	else
		BACKUP_ENV="$ZSHENV.bak.$(date +%Y%m%d%H%M%S)"
		echo -e "${BLUE}Backing up original .zshenv to $BACKUP_ENV...${NC}"
		cp "$ORIGINAL_ENV" "$BACKUP_ENV"
	fi
	rm -f "$ORIGINAL_ENV"
fi
echo -e "${GREEN}✓ ~/.zshenv updated successfully!${NC}"

echo -e "${BLUE}=== Zsh Setup Complete ===${NC}"
echo -e "To apply the changes immediately, please run: ${GREEN}source ~/.zshrc${NC} or restart your terminal."
