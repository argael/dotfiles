#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/.githooks"

if ! git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository: $REPO_ROOT" >&2
  exit 1
fi

if [ ! -d "$HOOKS_DIR" ]; then
  echo "Error: hooks directory not found: $HOOKS_DIR" >&2
  exit 1
fi

chmod +x "$HOOKS_DIR"/* 2>/dev/null || true
git -C "$REPO_ROOT" config core.hooksPath .githooks

echo "Git hooks installed (core.hooksPath=.githooks)."
