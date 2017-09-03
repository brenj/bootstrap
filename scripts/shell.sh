#!/bin/bash
#
# Configure my shell environment staples (dotfiles, vim, etc.).

STARTING_DIR="$(pwd)"

cd

if [ -d ".vim" ]; then
  echo "[-] Removing existing .vim directory"
  rm -rf .vim
fi

if [ -d "dotfiles" ]; then
  echo "[-] Removing existing dotfiles directory"
  rm -rf dotfiles
fi

echo "[+] Cloning dotfiles"
git clone https://github.com/brenj/dotfiles.git

echo "[+] Configuring dotfiles"
ln -sf dotfiles/.bashrc .bashrc
ln -sf dotfiles/.bash_aliases .bash_aliases
ln -sf dotfiles/.bash_profile .bash_profile
ln -sf dotfiles/.gvimrc .gvimrc
ln -sf dotfiles/.tern-config .tern-config
ln -sf dotfiles/.tmux.conf .tmux.conf
ln -sf dotfiles/.vimrc .vimrc
ln -sf dotfiles/.vim .vim
ln -sf dotfiles/.eslintrc .eslintrc
ln -sfh dotfiles/.xmonad .xmonad

echo "[+] Sourcing files"
. .bashrc

mkdir .vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
echo "[+] Installing vim plugins"
vim +PluginInstall +qall &>/dev/null

echo "[+] Configuring YouCompleteMe"
cd .vim/bundle/YouCompleteMe
./install.py --clang-completer --tern-completer

cd

echo "[+] Configuring NeoVim"
mkdir -p .config
ln -sfh ../dotfiles/.vim .config/nvim

cd "${STARTING_DIR}"
