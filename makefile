SHELL := /bin/bash

.PHONY: install git stow update zsh defaults all

defaults:
	@./scripts/install.sh

git:
	@./scripts/git/setup.sh

stow:
	@./homefiles/stow-packages.sh stow

restow:
	@./homefiles/stow-packages.sh restow
