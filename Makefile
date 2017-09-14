.PHONY: gentoo mac node shell

gentoo:
	cd linux/gentoo && vagrant up && vagrant ssh

mac:
	node shell

node:
	scripts/node.sh

shell:
	scripts/shell.sh
