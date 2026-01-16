.PHONY: provision configure_mac configure_node configure_shell

provision:
	macOS/provision.sh

configure_mac: configure_node configure_shell

configure_node:
	scripts/configure-node.sh

configure_shell:
	scripts/configure-shell.sh
