.PHONY: start all packages gopackages bin dotfiles etc

start:
	@echo "Specify target: <all|packages|bin|dotfiles|etc>"


all: packages bin dotfiles etc gopackages


packages:
	@echo "[i] Updating Packages"
	@sudo apt-get update -qq
	@echo "[i] Installing Packages"
	@sudo apt-get install -qq $(shell cat $(CURDIR)/packages)

gopackages:
	@GOPATH="~/.go"
	@echo "[i] go packages to $$GOPATH"
	@go get -u $(shell cat packages.golang)

bin:
	@echo "[i] Bin files"
	@for file in $(shell find $(CURDIR)/bin -type f -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

dotfiles:
	@echo "[i] .files"

	@for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".irssi" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;

	@ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	@ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;
	@ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;

etc:
	@echo "[i] etc files"
	@for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo ln -f $$file $$f; \
	done
	@systemctl --user daemon-reload
	@sudo systemctl daemon-reload

dotvim:
	@echo "[i] Cloning remote vim"
	@git clone https://github.com/mcrmonkey/.vim ~/.vim

