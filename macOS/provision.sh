#!/bin/bash
#
# Provision a macOS machine.

PACKAGES_FILE='./macOS/packages'

xcode-select --install &>/dev/null
read -n 1 -p "[+] Waiting for developer-tools install. Done (y/n)?: " input
if [ "${input}" != 'y' ]; then
  exit 1
fi

echo "[+] Installing Brew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "[+] Installing cask packages"
brew tap caskroom/cask
brew cask install xquartz

echo "[+] Installing brew packages"
while read -r package; do
  echo "Brewing formula ${package}"
  brew install "${package}"
done <"${PACKAGES_FILE}"
