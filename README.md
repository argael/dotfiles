# Dotfiles

This repository uses to configure fresh install of macOS and Lunix. It also use GNU Stow with `--dotfiles`.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/argael/dotfiles/main/scripts/install.sh | bash
```

The installer auto-detects the OS:
- macOS: runs `scripts/macos/install-macos.sh`
- Linux: runs `scripts/linux/install-linux.sh`

On a fresh macOS login, the installer first ensures Xcode Command Line Tools are installed (required for `git`).
If macOS opens an installation dialog, complete it, then run the same command again.

You can override with:
- `DOTFILES_REPO`
- `DOTFILES_BRANCH`
- `DOTFILES_DIR`

---

## Daily usage

```bash
make all
make update
```

To target another directory:

```bash
STOW_TARGET=/tmp/test-home make all
```

## Package selection

Packages are auto-detected from package directories under `homefiles/`.

## macOS bootstrap

```bash
make bootstrap
make hooks
make defaults
make all
```

`make hooks` sets `core.hooksPath=scripts/git/hooks` and enables the local `pre-commit` secret scan.
