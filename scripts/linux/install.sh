#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/argael/dotfiles.git}"
BRANCH="${DOTFILES_BRANCH:-main}"
DEST_DIR="${DOTFILES_DIR:-$HOME/Dotfiles}"

# Ensure this script runs only on Linux.
[ "$(uname -s)" = "Linux" ] || {
  echo "This installer is for Linux only."
  exit 1
}

# Install base requirements when needed (Debian/Ubuntu path).
if ! command -v git >/dev/null 2>&1 || ! command -v stow >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y git curl stow
  else
    echo "git, curl and stow are required. Install them, then run again."
    exit 1
  fi
fi

# Clone the repo on first run, otherwise update it.
if [ -d "$DEST_DIR/.git" ]; then
  git -C "$DEST_DIR" fetch origin --prune
  git -C "$DEST_DIR" checkout "$BRANCH"
  git -C "$DEST_DIR" pull --ff-only origin "$BRANCH"
else
  git clone --branch "$BRANCH" "$REPO_URL" "$DEST_DIR"
fi

# Configure git hooks and apply dotfiles with stow.
"$DEST_DIR/scripts/git/setup.sh"
"$DEST_DIR/homefiles/stow-packages.sh" stow

echo "Done."
