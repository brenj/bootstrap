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

rm -rf /etc/portage/package.use

echo "[+] Installing Gentoo configuration files"
mv package.use /etc/portage/package.use
cp package.accept_keywords/* /etc/portage/package.accept_keywords

echo "[+] Updating the portage tree"
emerge-webrsync --quiet

echo "[+] Installing packages"
while read -r package; do
  echo "Emerging package ${package}"
  emerge --quiet "${package}" &>/dev/null
done <"${PACKAGES_FILE}"

cd

echo "[+] Installing and configuring dev tools"
for script in scripts/*; do
  echo "Running script ${script}"
  [ -f "${script}" ] && [ -x "${script}" ] && "${script}"
done

echo "[+] Cleaning up"
rm -rf bootstrap-master
