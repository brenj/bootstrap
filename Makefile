.PHONY: gentoo node osx

gentoo:
	cd linux/gentoo && vagrant up && vagrant ssh

node:
	scripts/node.sh

osx:
	scripts/shell.sh
