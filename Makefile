.PHONY: help all package-cache base-packages ruby ruby-packages gitconfig install_go bin dotfiles dotvim gnome-settings app-shortcuts
SHELL = /bin/bash
.DEFAULT_GOAL = help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

all: package-cache base-packages ruby ruby-packages bin dotfiles install_go dotvim gitconfig ## - Do everything below

package-cache: ## - Update apt package cache
	@echo "[i] Updating Packages"
	@sudo apt-get update -qq

base-packages: package-cache ## - Install base packages
	@echo "[i] Installing Packages"
	@sudo apt-get install -qq $(shell cat $(CURDIR)/packages.base)

ruby: package-cache ## - Install ruby
	@echo "[i] Installing ruby"
	@sudo apt-get install -qq ruby rake

ruby-packages: ## - Install ruby packages via gem
	@echo "[i] Installing Gem Packages"
	@sudo gem install $(shell cat $(CURDIR)/packages.gems)

gitconfig: ## - install gitconfig as a git include
	@echo "[i] Popping git include"
	@git config --global include.path "~/.git-config"

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
	@./scripts/gnome-settings

app-shortcuts: ## - Install .desktop shortcuts
	@echo "[i] Installing .desktop shortcuts"
	@for file in $(shell find $(CURDIR)/apps -type f); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/.local/share/applications/$$f; \
		done
