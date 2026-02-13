SHELL := /bin/bash

.PHONY: install git stow update defaults all

install:
	@./scripts/install.sh

git:
	@./scripts/git/setup.sh

stow:
	@./homefiles/stow-packages.sh stow

update:
	@./homefiles/stow-packages.sh restow

defaults:
	@./scripts/macos/defaults.sh

all: install git stow
