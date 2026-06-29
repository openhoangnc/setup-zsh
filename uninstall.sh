#!/bin/bash

# Zsh Setup Uninstallation Script
# Removes setup-zsh configuration block and deleted the isolated plugin directory.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting Zsh Uninstall ===${NC}"

ZSHRC="$HOME/.zshrc"
PLUGIN_DIR="$HOME/.zsh/setup-zsh"

# 1. Remove configuration block from ~/.zshrc
if [[ -f "$ZSHRC" ]]; then
	echo -e "${BLUE}Removing setup-zsh configuration block from ~/.zshrc...${NC}"
	TEMP_RC=$(mktemp /tmp/zshrc.XXXXXX)
	awk '/# >>> setup-zsh >>>/{p=1;next}/# <<< setup-zsh <<</{p=0;next}!p' "$ZSHRC" > "$TEMP_RC"
	
	# Check if the file is empty or only has empty lines/whitespace
	if [[ ! -s "$TEMP_RC" ]] || ! grep -q '[^[:space:]]' "$TEMP_RC"; then
		echo -e "${BLUE}~/.zshrc is now empty. Deleting file...${NC}"
		rm -f "$ZSHRC"
		rm -f "$TEMP_RC"
	else
		mv "$TEMP_RC" "$ZSHRC"
		echo -e "${GREEN}✓ Removed config block from ~/.zshrc.${NC}"
	fi
else
	echo -e "${GREEN}✓ ~/.zshrc does not exist. Skipping config removal.${NC}"
fi

# 2. Delete the plugins folder
if [[ -d "$PLUGIN_DIR" ]]; then
	echo -e "${BLUE}Removing isolated directory at $PLUGIN_DIR...${NC}"
	rm -rf "$PLUGIN_DIR"
	echo -e "${GREEN}✓ Directory removed.${NC}"
else
	echo -e "${GREEN}✓ Directory $PLUGIN_DIR does not exist. Skipping.${NC}"
fi

echo -e "${GREEN}✓ Uninstall completed successfully!${NC}"
echo -e "Please restart your terminal session or run: ${GREEN}exec zsh${NC} to apply the changes."
