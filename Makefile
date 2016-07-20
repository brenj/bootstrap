.PHONY: dotfiles gentoo node osx

dotfiles:
	scripts/dotfiles.sh

gentoo:
	cd linux/gentoo && vagrant up && vagrant ssh

node:
	scripts/node.sh

osx:
	$(MAKE) -C dotfiles
	$(MAKE) -C node
