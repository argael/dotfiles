#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_DEFAULTS="$SCRIPT_DIR/macos-defaults.local.sh"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "macos-defaults.sh is intended for macOS. Skipping."
  exit 0
fi

if [ -f "$LOCAL_DEFAULTS" ]; then
  bash "$LOCAL_DEFAULTS"
  exit 0
fi

echo "No local defaults script found at $LOCAL_DEFAULTS"
echo "Create it to apply your macOS 'defaults write' customizations."
