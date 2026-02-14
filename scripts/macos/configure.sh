#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "scripts/macos/defaults.sh is intended for macOS. Skipping."
  exit 0
fi

# TODO: Add general configuration for macOS, here

echo "Completed!"
