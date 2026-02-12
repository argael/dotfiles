#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO:-${1:-}}"
BRANCH="${DOTFILES_BRANCH:-${2:-main}}"
DEST_DIR="${DOTFILES_DIR:-$HOME/Dotfiles}"

if [ -z "$REPO_URL" ]; then
  echo "Error: repository URL is required."
  echo "Use: curl -fsSL <raw install.sh url> | bash -s -- https://github.com/<user>/<repo>.git [branch]"
  exit 1
fi

if [ -d "$DEST_DIR/.git" ]; then
  echo "Updating existing dotfiles repo in $DEST_DIR"
  git -C "$DEST_DIR" fetch --all --prune
  git -C "$DEST_DIR" checkout "$BRANCH"
  git -C "$DEST_DIR" pull --ff-only origin "$BRANCH"
else
  echo "Cloning dotfiles repo to $DEST_DIR"
  git clone --branch "$BRANCH" "$REPO_URL" "$DEST_DIR"
fi

"$DEST_DIR/scripts/bootstrap-macos.sh"
"$DEST_DIR/scripts/install-hooks.sh"
"$DEST_DIR/scripts/stow-packages.sh" stow
"$DEST_DIR/scripts/macos-defaults.sh"

echo "Installation complete."
