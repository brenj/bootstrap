#!/bin/bash
#
# Provision a macOS machine.

PACKAGES_FILE='./macOS/packages'

xcode-select --install &>/dev/null

echo "[+] Installing packages"
while read -r package; do
  echo "Brewing formula ${package}"
  brew install "${package}"
done <"${PACKAGES_FILE}"
