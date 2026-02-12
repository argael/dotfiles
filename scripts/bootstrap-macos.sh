#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BREWFILE="${BREWFILE:-$REPO_ROOT/Brewfile}"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "bootstrap-macos.sh is intended for macOS. Skipping."
  exit 0
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install || true
  echo "Xcode CLT installation started. Re-run bootstrap once installation completes."
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Error: Homebrew is still unavailable after installation" >&2
  exit 1
fi

if [ -f "$BREWFILE" ]; then
  echo "Applying Brewfile: $BREWFILE"
  brew bundle --file="$BREWFILE"
fi

if ! command -v stow >/dev/null 2>&1; then
  echo "Installing stow via brew..."
  brew install stow
fi

echo "macOS bootstrap complete."
