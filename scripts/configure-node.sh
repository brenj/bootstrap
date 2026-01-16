#!/usr/bin/env bash
#
# Install node + npm for development

set -euo pipefail
log() { printf "\n[+] %s\n" "$*"; }

NVM_VERSION="v0.40.3"
NVM_DIR="${HOME}/.nvm"

if [ ! -d "$NVM_DIR" ]; then
  log "Installing nvm ${NVM_VERSION}"
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
else
  log "nvm already installed"
fi

# shellcheck disable=SC1090
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

log "Installing latest Node"
nvm install node >/dev/null
nvm alias default node >/dev/null

log "Done: node $(node -v), npm $(npm -v)"
