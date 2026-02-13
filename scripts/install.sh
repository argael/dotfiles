#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
  Darwin)
    exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/macos/install-macos.sh"
    ;;
  Linux)
    exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/linux/install-linux.sh"
    ;;
  *)
    echo "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac
