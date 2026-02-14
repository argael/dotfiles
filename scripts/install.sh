#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
  Darwin)
    exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/macos/install.sh"
    ;;
  Linux)
    exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/linux/install.sh"
    ;;
  *)
    echo "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac
