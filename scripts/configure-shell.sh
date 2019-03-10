#!/bin/bash
#
# Configure my shell environment staples (dotfiles, vim, etc.).

REPOS="dotfiles dragon tools"
STARTING_DIR="$(pwd)"

cd

if [ -d ".vim" ]; then
  echo "[-] Removing existing .vim directory"
  rm -rf .vim
fi

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
