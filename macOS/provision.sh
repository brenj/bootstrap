#!/usr/bin/env bash
#
# Provision macOS

set -euo pipefail
log()  { printf "\n[+] %s\n" "$*"; }
warn() { printf "\n[!] %s\n" "$*"; }

BREW_PACKAGES='./macOS/brew-packages'
CASK_PACKAGES='./macOS/cask-packages'

# ---- Xcode Command Line Tools ----
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools"
  xcode-select --install >/dev/null 2>&1 || true
  warn "Finish the Xcode CLT install dialog, then re-run this script."
  exit 1
else
  log "Xcode Command Line Tools already installed"
fi

# ---- Homebrew ----
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Load brew into PATH for this script session
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  log "Homebrew already installed"
fi

log "Updating Homebrew"
brew update

# ---- Install formulae ----
log "Installing brew packages"
grep -v '^\s*#' "$BREW_PACKAGES" | grep -v '^\s*$' | xargs brew install

# ---- Install casks ----
log "Installing cask packages"
grep -v '^\s*#' "$CASK_PACKAGES" | grep -v '^\s*$' | xargs brew install --cask

log "Upgrading packages"
brew upgrade
brew upgrade --cask || true
brew cleanup

# ---- Git config ----
log "Configuring git (only if unset)"
if ! git config --global user.name >/dev/null; then
  read -r -p "Enter your GitHub name: " name
  git config --global user.name "$name"
fi
if ! git config --global user.email >/dev/null; then
  read -r -p "Enter your GitHub email: " email
  git config --global user.email "$email"
fi

# ---- Configure shell + node ----
log "Configuring shell environment"
./scripts/configure-shell.sh

log "Configuring node environment"
./scripts/configure-node.sh

log "Provision complete"
