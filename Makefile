.PHONY: env gentoo node shell

env: shell node

gentoo:
	cd linux/gentoo && vagrant up && vagrant ssh

node:
	scripts/node.sh

shell:
	scripts/shell.sh
