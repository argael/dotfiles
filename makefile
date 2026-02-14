SHELL := /bin/bash

.PHONY: install git stow update zsh defaults all brew brew-common brew-work brew-personal

defaults:
	@./scripts/install.sh

git:
	@./scripts/git/setup.sh

stow:
	@./homefiles/stow-packages.sh stow

restow:
	@./homefiles/stow-packages.sh restow

brew:
	@./scripts/macos/brew.sh common

brew-common:
	@./scripts/macos/brew.sh common

brew-work:
	@./scripts/macos/brew.sh work

brew-personal:
	@./scripts/macos/brew.sh personal
