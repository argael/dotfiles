# Dotfiles

This repository uses to configure fresh install of macOS and Lunix. It also use GNU Stow with `--dotfiles`.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/argael/dotfiles/main/scripts/install.sh | bash
```

The installer auto-detects the OS:
- macOS: runs `scripts/macos/install.sh`
- Linux: runs `scripts/linux/install.sh`

On a fresh macOS login, the installer first ensures Xcode Command Line Tools are installed (required for `git`).
If macOS opens an installation dialog, complete it, then run the same command again.

You can override with:
- `DOTFILES_REPO`
- `DOTFILES_BRANCH`
- `DOTFILES_DIR`

---

## Daily usage

```bash
make git        # To install GIT configuration
make stow       # To install Configuration files
make restow     # To recreate Configuration file links
```

> **Stow Package selection**
> Packages are auto-detected from package directories under `homefiles/`.
