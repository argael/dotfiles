#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_ROOT="$SCRIPT_DIR"
TARGET_DIR="${STOW_TARGET:-$HOME}"

usage() {
  cat <<USAGE
Usage: $(basename "$0") <stow|restow> [package...]

Environment:
  STOW_TARGET   Override target directory (default: \$HOME)
USAGE
}

require_stow() {
  command -v stow >/dev/null 2>&1 || {
    echo "Error: stow is not installed" >&2
    exit 1
  }
}

is_excluded_dir() {
  case "$1" in
    .git|.github|.idea|.vscode)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

discover_packages() {
  local dir base
  for dir in "$STOW_ROOT"/*/; do
    [ -d "$dir" ] || continue
    base="$(basename "$dir")"
    is_excluded_dir "$base" && continue
    printf '%s\n' "$base"
  done | sort
}

run_stow() {
  local mode="$1"
  shift

  local -a packages=("$@")
  if [ "${#packages[@]}" -eq 0 ]; then
    while IFS= read -r line; do
      [ -n "$line" ] && packages+=("$line")
    done < <(discover_packages)
  fi

  if [ "${#packages[@]}" -eq 0 ]; then
    echo "Error: no packages found" >&2
    exit 1
  fi

  case "$mode" in
    stow)
      (cd "$STOW_ROOT" && stow --dotfiles -v -t "$TARGET_DIR" "${packages[@]}")
      ;;
    restow)
      (cd "$STOW_ROOT" && stow --dotfiles --adopt -R -v -t "$TARGET_DIR" "${packages[@]}")
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

mode="${1:-}"
if [ -z "$mode" ]; then
  usage
  exit 1
fi
shift || true

require_stow
run_stow "$mode" "$@"
