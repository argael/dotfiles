#!/usr/bin/env bash
set -euo pipefail

OMZ_DIR="${ZSH:-$HOME/.oh-my-zsh}"
CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

PLUGIN_NAME="zsh-shift-select"
PLUGIN_REPO="https://github.com/marlonrichert/zsh-shift-select.git"
PLUGIN_DIR="$CUSTOM_DIR/plugins/$PLUGIN_NAME"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required" >&2
  exit 1
fi

if [ ! -d "$OMZ_DIR" ]; then
  if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is required to install oh-my-zsh" >&2
    exit 1
  fi

  echo "Installing oh-my-zsh into: $OMZ_DIR"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh already installed: $OMZ_DIR"
fi

mkdir -p "$CUSTOM_DIR/plugins"

if [ -d "$PLUGIN_DIR/.git" ]; then
  echo "Updating plugin: $PLUGIN_NAME"
  git -C "$PLUGIN_DIR" pull --ff-only
elif [ -e "$PLUGIN_DIR" ]; then
  echo "Warning: $PLUGIN_DIR exists but is not a git repo. Skipping plugin install." >&2
else
  echo "Installing plugin: $PLUGIN_NAME"
  git clone --depth 1 "$PLUGIN_REPO" "$PLUGIN_DIR"
fi

echo "oh-my-zsh bootstrap complete."
