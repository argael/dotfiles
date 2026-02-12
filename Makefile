SHELL := /bin/bash

.PHONY: doctor packages dry stow restow adopt unstow bootstrap defaults all install

doctor:
	@command -v stow >/dev/null || (echo "stow is required" && exit 1)
	@echo "stow: $$(stow --version | head -n1)"
	@if command -v brew >/dev/null; then echo "brew: installed"; else echo "brew: not installed"; fi

packages:
	@./scripts/stow-packages.sh list

dry:
	@./scripts/stow-packages.sh dry $(PACKAGES)

stow:
	@./scripts/stow-packages.sh stow $(PACKAGES)

restow:
	@./scripts/stow-packages.sh restow $(PACKAGES)

adopt:
	@./scripts/stow-packages.sh adopt $(PACKAGES)

unstow:
	@./scripts/stow-packages.sh unstow $(PACKAGES)

bootstrap:
	@./scripts/bootstrap-macos.sh

defaults:
	@./scripts/macos-defaults.sh

all: bootstrap stow defaults

install:
	@./scripts/install.sh
