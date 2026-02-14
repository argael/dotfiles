#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<USAGE
Usage: $(basename "$0") [common|work|personal|/path/to/file.brew]

Environment:
  BREWFILE   Full path to a Brewfile (used only if no argument is provided)
USAGE
}

resolve_brewfile() {
  local selector="${1:-}"
  local candidate=""

  if [ -z "$selector" ] && [ -n "${BREWFILE:-}" ]; then
    candidate="$BREWFILE"
  elif [ -z "$selector" ]; then
    candidate="$SCRIPT_DIR/brewfiles/common.brew"
  elif [ -f "$selector" ]; then
    candidate="$selector"
  else
    candidate="$SCRIPT_DIR/brewfiles/$selector.brew"
  fi

  if [ ! -f "$candidate" ]; then
    echo "Error: Brewfile not found: $candidate" >&2
    usage >&2
    exit 1
  fi

  printf '%s\n' "$candidate"
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

BREWFILE="$(resolve_brewfile "${1:-}")"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "scripts/macos/brew.sh is intended for macOS. Skipping."
  exit 0
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

  echo "Verifying Brewfile dependencies are installed: $BREWFILE"
  brew bundle check --no-upgrade --file="$BREWFILE"
fi

echo "macOS bootstrap complete."
