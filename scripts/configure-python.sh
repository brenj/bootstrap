#!/usr/bin/env bash
#

# Configure Python tooling for the machine
set -euo pipefail

log()  { printf "\n[+] %s\n" "$*"; }
BREW_PREFIX="$(brew --prefix)"
BREW_PYTHON="$BREW_PREFIX/bin/python3"

log "Installing pynvim into Homebrew Python for Vim"
"$BREW_PYTHON" -m pip install --upgrade pip --break-system-packages
"$BREW_PYTHON" -m pip install --upgrade pynvim --break-system-packages

log "Done: python provider $("$BREW_PYTHON" --version)"
