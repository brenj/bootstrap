.PHONY: env gentoo git-prompt node shell

env: shell git-prompt node

gentoo:
	cd linux/gentoo && vagrant up && vagrant ssh

git-prompt:
	scripts/git-prompt.sh

node:
	scripts/node.sh

shell:
	scripts/shell.sh
