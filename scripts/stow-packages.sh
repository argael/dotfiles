#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PACKAGES_FILE="${PACKAGES_FILE:-$REPO_ROOT/packages.txt}"
TARGET_DIR="${STOW_TARGET:-$HOME}"

usage() {
  cat <<USAGE
Usage: $(basename "$0") <list|dry|stow|restow|adopt|unstow> [package...]

Environment:
  STOW_TARGET   Override target directory (default: \$HOME)
  PACKAGES_FILE Override packages file path (default: ./packages.txt)
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
    scripts|.git|.github|.idea|.vscode)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

load_packages_from_file() {
  local file="$1"
  grep -Ev '^[[:space:]]*(#|$)' "$file" | awk '{print $1}'
}

discover_packages() {
  local dir base
  for dir in "$REPO_ROOT"/*/; do
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
  local line
  if [ "${#packages[@]}" -eq 0 ]; then
    if [ -f "$PACKAGES_FILE" ]; then
      while IFS= read -r line; do
        [ -n "$line" ] && packages+=("$line")
      done < <(load_packages_from_file "$PACKAGES_FILE")
    else
      while IFS= read -r line; do
        [ -n "$line" ] && packages+=("$line")
      done < <(discover_packages)
    fi
  fi

  if [ "${#packages[@]}" -eq 0 ]; then
    echo "Error: no packages found" >&2
    exit 1
  fi

  case "$mode" in
    list)
      printf '%s\n' "${packages[@]}"
      ;;
    dry)
      (cd "$REPO_ROOT" && stow --dotfiles -n -v -t "$TARGET_DIR" "${packages[@]}")
      ;;
    stow)
      (cd "$REPO_ROOT" && stow --dotfiles -v -t "$TARGET_DIR" "${packages[@]}")
      ;;
    restow)
      (cd "$REPO_ROOT" && stow --dotfiles -R -v -t "$TARGET_DIR" "${packages[@]}")
      ;;
    adopt)
      (cd "$REPO_ROOT" && stow --dotfiles --adopt -v -t "$TARGET_DIR" "${packages[@]}")
      ;;
    unstow)
      (cd "$REPO_ROOT" && stow --dotfiles -D -v -t "$TARGET_DIR" "${packages[@]}")
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

if [ "$mode" != "list" ]; then
  require_stow
fi
run_stow "$mode" "$@"
