.PHONY: dotfiles node osx

dotfiles:
	scripts/dotfiles.sh

node:
	scripts/node.sh

osx:
	$(MAKE) -C dotfiles
	$(MAKE) -C node
