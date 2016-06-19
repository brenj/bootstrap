#!/bin/bash
#
# Provision an OS X machine.

if [[ ${EUID} != 0 ]] ; then
  echo "This script must be run as root"
  exit 1
fi

PACKAGES_FILE='packages'

xcode-select --install &>/dev/null

echo "[+] Installing packages"
while read -r package; do
  echo "Brewing formula ${package}"
  brew install "${package}" &>/dev/null
done <"${PACKAGES_FILE}"
