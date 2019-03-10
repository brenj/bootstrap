#!/bin/bash
#
# Provision a Gentoo machine.

PACKAGES_FILE='packages'

echo "[+] Downloading configuration files"
# Cloning won't work until git is recompiled (later)
wget -q https://github.com/brenj/dotfiles/archive/master.zip
unzip -qq master.zip
mv dotfiles-master dotfiles
rm master.zip

wget -q https://github.com/brenj/bootstrap/archive/master.zip
unzip -qq master.zip
mv bootstrap-master bootstrap
rm master.zip
cd bootstrap/linux/gentoo

sudo rm -rf /etc/portage/package.use
sudo rm -rf /etc/portage/package.accept_keywords

echo "[+] Installing Gentoo configuration files"
sudo cp package.use /etc/portage
sudo cp package.accept_keywords /etc/portage

echo "[+] Updating the portage tree"
sudo emerge-webrsync --quiet

echo "[+] Installing packages"
while read -r package; do
  echo "Emerging package ${package}"
  sudo emerge --quiet "${package}" &>/dev/null
done <"${PACKAGES_FILE}"

cd

echo "[+] Configuring environment"
make -C bootstrap configure_node
make -C bootstrap configure_shell
