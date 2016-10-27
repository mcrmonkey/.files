.PHONY: all packages bin dotfiles etc test shellcheck

all: packages bin dotfiles etc


packages:
	@echo "Packages - "
	@echo "  - Updating"
	@sudo apt-get update -qq 
	@echo "  - Installing"
	@sudo apt-get install -qq $(shell cat $(CURDIR)/packages) 

bin:
	@echo "Bin files - "
	
	
	# add aliases for things in bin
	@for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

	#sudo ln -sf $(CURDIR)/bin/browser-exec /usr/local/bin/xdg-open; \

dotfiles:
	
	@echo ".files - "
	
	
	# add aliases for dotfiles
	@for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".travis.yml" -not -name ".git" -not -name ".*.swp" -not -name ".travis.yml" -not -name ".irssi" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	@ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;
	ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;

etc:
	@echo "etc files - "
	@for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo ln -f $$file $$f; \
	done
	@systemctl --user daemon-reload
	@sudo systemctl daemon-reload

