#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/argael/dotfiles.git}"
BRANCH="${DOTFILES_BRANCH:-main}"
DEST_DIR="${DOTFILES_DIR:-$HOME/Dotfiles}"

# Ensure this script runs only on macOS.
[ "$(uname -s)" = "Darwin" ] || {
  echo "This installer is for macOS only."
  exit 1
}

# Ensure git is available via Xcode Command Line Tools.
if ! command -v git >/dev/null 2>&1; then
  xcode-select -p >/dev/null 2>&1 || xcode-select --install || true
  echo "Install Xcode Command Line Tools, then run the installer again."
  exit 0
fi

# Clone the repo on first run, otherwise update it.
if [ -d "$DEST_DIR/.git" ]; then
  git -C "$DEST_DIR" fetch origin --prune
  git -C "$DEST_DIR" checkout "$BRANCH"
  git -C "$DEST_DIR" pull --ff-only origin "$BRANCH"
else
  git clone --branch "$BRANCH" "$REPO_URL" "$DEST_DIR"
fi

# Run macOS bootstrap, configure git hooks, apply dotfiles, then macOS defaults.
"$DEST_DIR/scripts/macos/bootstrap.sh"
"$DEST_DIR/scripts/git/setup.sh"
"$DEST_DIR/homefiles/stow-packages.sh" stow
"$DEST_DIR/scripts/macos/defaults.sh"

echo "Done."
