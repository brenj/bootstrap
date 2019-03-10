.PHONY: configure_mac configure_node configure_shell gentoo

configure_mac: configure_node configure_shell

configure_node:
	scripts/configure-node.sh

configure_shell:
	scripts/configure-shell.sh

gentoo:
	cd linux/gentoo && vagrant up && vagrant ssh
