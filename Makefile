.PHONY: help all packages gopackages bin dotfiles etc dotvim install_go gempackages gnome-settings
SHELL = /bin/bash
.DEFAULT_GOAL = help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

all: packages bin dotfiles install_go gopackages install_gem dotvim gitconfig ## - Do everything below

gitconfig: ## - install gitconfig as a git include
	@echo "[i] Popping git include"
	@git config --global include.path "~/.git-config"


packages: ## - Install packages
	@echo "[i] Updating Packages"
	@sudo apt-get update -qq
	@echo "[i] Installing Packages"
	@sudo apt-get install -qq $(shell cat $(CURDIR)/packages)

gempackages: ## - Install gem packages
	@echo "[i] Installing Gem Packages"
	@sudo gem install $(shell cat $(CURDIR)/packages.gems)


install_go: ## - Install go
	@$(CURDIR)/scripts/install_golang.sh

bin: ## - Install bin files
	@echo "[i] Bin files"
	@for file in $(shell find $(CURDIR)/bin -type f -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

dotfiles: ## - Install .files
	@echo "[i] .files"

	@for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;

	@ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	@ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;
	@ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;

dotvim: ## - Clone .vim from github
	@echo "[i] Cloning remote vim"
	@git clone --recursive https://github.com/mcrmonkey/.vim ~/.vim

gnome-settings: ## - Apply Gnome settings
	@echo "[i] Applying gnome settings"
	@./gsettings
