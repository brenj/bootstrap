#!/usr/bin/env bash
#
# Configure shell environment

set -euo pipefail

log()  { printf "\n[+] %s\n" "$*"; }
warn() { printf "\n[!] %s\n" "$*"; }

HOME_DIR="$HOME"
STARTING_DIR="$(pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME_DIR/.bootstrap_backup/$STAMP"

mkdir -p "$HOME_DIR/.config" "$BACKUP_DIR"

clone_or_update() {
  local repo="$1"
  local dest="$2"

  if [ -d "$dest/.git" ]; then
    log "Updating $repo in $dest"
    git -C "$dest" pull --ff-only || warn "Could not fast-forward pull $repo (local changes?)"
  elif [ -e "$dest" ]; then
    warn "$dest exists but is not a git repo; not touching it"
  else
    log "Cloning $repo to $dest"
    git clone "git@github.com:brenj/${repo}.git" "$dest"
  fi
}

backup_if_conflict() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    log "Backing up existing $(basename "$target") to $BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
  fi
}

link_force() {
  local src="$1"
  local dst="$2"
  backup_if_conflict "$dst"
  ln -sfn "$src" "$dst"
}

cd "$HOME_DIR"

# --- Repos ---
clone_or_update "dotfiles" "$HOME_DIR/dotfiles"
clone_or_update "scripts"  "$HOME_DIR/scripts"

# --- Symlink dotfiles (source of truth: ~/dotfiles) ---
log "Linking dotfiles"
link_force "$HOME_DIR/dotfiles/.bashrc"        "$HOME_DIR/.bashrc"
link_force "$HOME_DIR/dotfiles/.bash_aliases" "$HOME_DIR/.bash_aliases"
link_force "$HOME_DIR/dotfiles/.bash_profile" "$HOME_DIR/.bash_profile"
link_force "$HOME_DIR/dotfiles/.vimrc"        "$HOME_DIR/.vimrc"
link_force "$HOME_DIR/dotfiles/.vim"          "$HOME_DIR/.vim"
link_force "$HOME_DIR/dotfiles/.config/pet"   "$HOME_DIR/.config/pet"

# Neovim
link_force "$HOME_DIR/dotfiles/.vim" "$HOME_DIR/.config/nvim"

# VS Code
VSCODE_USER_DIR="$HOME_DIR/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_DIR"
if [ -f "$HOME_DIR/dotfiles/vscode/settings.json" ]; then
  link_force "$HOME_DIR/dotfiles/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
fi
if [ -f "$HOME_DIR/dotfiles/vscode/keybindings.json" ]; then
  link_force "$HOME_DIR/dotfiles/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
fi

# --- vim-plug ---
log "Ensuring vim-plug"
if [ ! -f "$HOME_DIR/.vim/autoload/plug.vim" ]; then
  curl -fLo "$HOME_DIR/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
log "Installing vim plugins"
vim +PlugInstall +qall

# --- shell ---
BREW_BASH="$(brew --prefix)/bin/bash"
if [ -x "$BREW_BASH" ] && grep -q "^${BREW_BASH}$" /etc/shells; then
  DESIRED_SHELL="$BREW_BASH"
else
  DESIRED_SHELL="/bin/bash"
fi
if [ "${SHELL:-}" != "$DESIRED_SHELL" ]; then
  log "Setting default shell to $DESIRED_SHELL"
  chsh -s "$DESIRED_SHELL" "$USER" || warn "Could not change shell (needs password / permissions)"
fi

# --- keychain ---
log "Adding ssh keys to keychain"
keychain "$HOME_DIR/.ssh/"*

log "Done. Backups (if any) are in: $BACKUP_DIR"
cd "$STARTING_DIR"
echo
echo "Restart your terminal (or: source ~/.bashrc) to apply PATH / shell changes."