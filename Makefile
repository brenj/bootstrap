.PHONY: provision configure_mac configure_node configure_shell

provision:
	bash macOS/provision.sh

configure_mac: configure_node configure_shell

configure_node:
	bash scripts/configure-node.sh

configure_shell:
	bash scripts/configure-shell.sh
