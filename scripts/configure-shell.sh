#!/bin/bash
#
# Configure my shell environment staples (dotfiles, vim, etc.).

REPOS="bootstrap dotfiles tools"
STARTING_DIR="$(pwd)"

cd

if [ -d ".tmux" ]; then
  echo "[-] Removing existing .tmux directory"
  rm -rf .tmux
  mkdir .tmux
fi

if [ -d ".vim" ]; then
  echo "[-] Removing existing .vim directory"
  rm -rf .vim
  mkdir .vim
fi

mkdir -p .config

for repo in ${REPOS}; do
  if [ -d "${repo}" ]; then
    echo "[-] Removing existing ${repo} directory"
    rm -rf "${repo}"
  fi
  echo "[+] Cloning ${repo}"
  git clone "git@github.com:brenj/${repo}.git"
done

echo "[+] Configuring dotfiles"
ln -sf dotfiles/.bashrc .bashrc
ln -sf dotfiles/.bash_aliases .bash_aliases
ln -sf dotfiles/.bash_profile .bash_profile
ln -sf dotfiles/.tern-config .tern-config
ln -sf dotfiles/.tmux.conf .tmux.conf
ln -sf dotfiles/.vimrc .vimrc
ln -sf dotfiles/.vim .vim
ln -sf dotfiles/.eslintrc .eslintrc
ln -sfh dotfiles/.config/pet .config/pet
ln -sfh dotfiles/.xmonad .xmonad
ln -sfh dotfiles/.vim .config/nvim

echo "[+] Sourcing files"
. .bashrc

echo "[+] Installing tmux plugins"
mkdir -p .tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
.tmux/plugins/tpm/bin/install_plugins

echo "[+] Installing vim plugins"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall --sync +qa &>/dev/null

echo "[+] Changing default shell to bash"
chsh -s /usr/local/bin/bash "$USER"

echo "[+] Add ssh keys to keychain"
keychain ~/.ssh/

echo "[+] Installing fzf key bindings and fuzzy completion"
# Install useful key bindings and fuzzy completion
$(brew --prefix)/opt/fzf/install

echo "[+] Closing Terminal"
cd "${STARTING_DIR}"
read -p "Restart terminal to apply changes. Press enter to exit script "
