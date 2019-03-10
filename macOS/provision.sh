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

echo "[+] Installing Brew and Cask"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask

echo "[+] Installing cask packages"
while read -r package; do
  echo "Brewing cask ${package}"
  brew cask install "${package}"
done <"${CASK_PACKAGES}"

echo "[+] Installing brew packages"
while read -r package; do
  echo "Brewing formula ${package}"
  brew install "${package}"
done <"${BREW_PACKAGES}"

echo "[+] Configuring git"
read -p "Enter your GitHub name: " name
git config --global user.name "${name}"
read -p "Enter your GitHub email: " email
git config --global user.email "${email}"

cd

echo "[+] Configuring mac"
make -C bootstrap configure_mac
