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

# 4. Install Plugins (Syntax Highlighting & Autosuggestions)
SYNTAX_DIR="$PLUGIN_DIR/zsh-syntax-highlighting"
SUGGEST_DIR="$PLUGIN_DIR/zsh-autosuggestions"

# Determine script directory if run from local file
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]}" && -f "${BASH_SOURCE[0]}" ]]; then
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [[ -n "$SCRIPT_DIR" && -d "$SCRIPT_DIR/plugins/zsh-autosuggestions" && -d "$SCRIPT_DIR/plugins/zsh-syntax-highlighting" ]]; then
	echo -e "${BLUE}Installing plugins from local repository...${NC}"
	rm -rf "$SYNTAX_DIR" "$SUGGEST_DIR"
	cp -R "$SCRIPT_DIR/plugins/zsh-syntax-highlighting" "$SYNTAX_DIR"
	cp -R "$SCRIPT_DIR/plugins/zsh-autosuggestions" "$SUGGEST_DIR"
	echo -e "${GREEN}✓ Plugins installed from local repository.${NC}"
else
	echo -e "${BLUE}Downloading plugins from openhoangnc/setup-zsh repository...${NC}"
	rm -rf "$SYNTAX_DIR" "$SUGGEST_DIR"
	TEMP_ZIP=$(mktemp /tmp/setup-zsh.XXXXXX.zip)
	TEMP_DIR=$(mktemp -d /tmp/setup-zsh.XXXXXX)
	curl -L -s https://github.com/openhoangnc/setup-zsh/archive/refs/heads/main.zip -o "$TEMP_ZIP"
	unzip -q -o "$TEMP_ZIP" -d "$TEMP_DIR"
	
	mv "$TEMP_DIR"/setup-zsh-main/plugins/zsh-syntax-highlighting "$SYNTAX_DIR"
	mv "$TEMP_DIR"/setup-zsh-main/plugins/zsh-autosuggestions "$SUGGEST_DIR"
	
	rm -rf "$TEMP_ZIP" "$TEMP_DIR"
	echo -e "${GREEN}✓ Plugins installed from openhoangnc/setup-zsh repository.${NC}"
fi

# 6. Backup existing ~/.zshrc if exists
ZSHRC="$HOME/.zshrc"
if [[ -f "$ZSHRC" ]]; then
	BACKUP="$ZSHRC.bak.$(date +%Y%m%d%H%M%S)"
	echo -e "${BLUE}Backing up existing .zshrc to $BACKUP...${NC}"
	cp "$ZSHRC" "$BACKUP"
else
	touch "$ZSHRC"
fi

# 7. Clean existing setup-zsh configuration block to allow safe re-runs
echo -e "${BLUE}Cleaning any existing setup-zsh configuration block...${NC}"
TEMP_RC=$(mktemp /tmp/zshrc.XXXXXX)
awk '/# >>> setup-zsh >>>/{p=1;next}/# <<< setup-zsh <<</{p=0;next}!p' "$ZSHRC" > "$TEMP_RC"
mv "$TEMP_RC" "$ZSHRC"

# 8. Append the configuration block to ~/.zshrc
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
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Enable tab completion
autoload -Uz compinit
compinit

# 2. Syntax Highlighting
if [[ -f ~/.zsh/setup-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source ~/.zsh/setup-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# 3. Autosuggestions Core Setup
if [[ -f ~/.zsh/setup-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
	source ~/.zsh/setup-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

	# Customize autosuggest style (clean, beautiful gray)
	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

	# Configure strategies (try match_any first, fallback to completion)
	ZSH_AUTOSUGGEST_STRATEGY=(match_any completion)

	# -------------------------------------------------------------
	# 4. Custom Match-Any (Substring) Strategy and Widgets
	# -------------------------------------------------------------
	
	# Define custom match_any strategy
	_zsh_autosuggest_strategy_match_any() {
		emulate -L zsh
		setopt EXTENDED_GLOB
		local prefix="${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}"
		local pattern="*$prefix*"
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
				# For match_any, check that the suggestion contains the buffer
				[[ "$suggestion" != *"$1"* ]] && unset suggestion
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
			if [[ "$suggestion" == "$BUFFER"* ]]; then
				# Standard prefix match display
				POSTDISPLAY="${suggestion#$BUFFER}"
			else
				# Substring match display (add subtle indicator)
				POSTDISPLAY=" ↳ $suggestion"
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

		if [[ "$POSTDISPLAY" == " ↳ "* ]]; then
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

	# Override execute function (accept and run, e.g. Ctrl+F / Right Arrow)
	_zsh_autosuggest_execute() {
		if [[ "$POSTDISPLAY" == " ↳ "* ]]; then
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

		if [[ "$POSTDISPLAY" == " ↳ "* ]]; then
			local idx=${_ZSH_AUTOSUGGEST_CURRENT_SUGGESTION[(i)$BUFFER]}
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
		if [[ "$POSTDISPLAY" == " ↳ "* ]]; then
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

# 5. Colored Prompt (Username Only, success/failure indicator)
PROMPT='%F{147}%n%f %(?.%F{121}❯%f.%F{197}❯%f) '

# 6. Colors for LS & Directories
export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
# <<< setup-zsh <<<
EOF

echo -e "${GREEN}✓ ~/.zshrc updated successfully!${NC}"
echo -e "${BLUE}=== Zsh Setup Complete ===${NC}"
echo -e "Please run: ${GREEN}source ~/.zshrc${NC} to apply the changes to your current terminal session."
