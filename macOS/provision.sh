#!/bin/bash
#
# Provision a macOS machine.

BREW_PACKAGES='./macOS/brew-packages'
CASK_PACKAGES='./macOS/cask-packages'

xcode-select --install &>/dev/null
read -n 1 -p "[+] Waiting for developer-tools install. Done (y/n)?: " input
if [ "${input}" != 'y' ]; then
  exit 1
fi

echo -e "\n[+] Installing Brew and Cask"
sudo chown -R $(whoami) /usr/local/*
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap homebrew/cask

echo "[+] Installing cask packages"
brew install $(cat "${CASK_PACKAGES}")

echo "[+] Installing brew packages"
brew install $(cat "${BREW_PACKAGES}")

echo "[+] Configuring git"
read -p "Enter your GitHub name: " name
git config --global user.name "${name}"
read -p "Enter your GitHub email: " email
git config --global user.email "${email}"

cd

echo "[+] Configuring mac"
make -C bootstrap configure_mac

echo "[+] Removing bootstrap.zip"
rm bootstrap.zip
rm -rf bootstrap

echo "[+] Cloning bootstrap.zip"
git clone https://github.com/brenj/bootstrap.git
