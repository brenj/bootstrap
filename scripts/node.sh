#!/bin/bash
#
# Install node and npm for development.

NVM_VERSION="v0.30.2"
RAW_URL="https://raw.githubusercontent.com"
STARTING_DIR="$(pwd)"

cd

echo "[+] Installing node"
wget -q -O - ${RAW_URL}/creationix/nvm/${NVM_VERSION}/install.sh |bash
. .nvm/nvm.sh
nvm install node &>/dev/null && nvm current >.nvmrc

export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

cd "${STARTING_DIR}"
