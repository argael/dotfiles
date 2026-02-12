# Dotfiles

This repository uses GNU Stow with `--dotfiles`.

## Daily usage

```bash
make hooks
make packages
make dry
make stow
make restow
make adopt
make unstow
```

To target another directory:

```bash
STOW_TARGET=/tmp/test-home make stow
```

To run only specific packages:

```bash
make stow PACKAGES="zsh ghostty"
```

## Package selection

Default source is `packages.txt`.
If `packages.txt` is missing, packages are auto-detected from top-level directories (excluding `scripts` and VCS/editor folders).

## macOS bootstrap

```bash
make bootstrap
make hooks
make defaults
make all
```

`make hooks` sets `core.hooksPath=.githooks` and enables the local `pre-commit` secret scan.

## Remote install

```bash
curl -fsSL https://raw.githubusercontent.com/<user>/<repo>/<branch>/scripts/install.sh \
  | bash -s -- https://github.com/<user>/<repo>.git <branch>
```

You can also set:
- `DOTFILES_REPO`
- `DOTFILES_BRANCH`
- `DOTFILES_DIR`
