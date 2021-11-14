#!/usr/bin/env sh

################################################################################
# Update the Mac OS, dependencies and Apple Store installs

echo
echo "Checking for Apple Store updates ..."

if mas version >/dev/null 2>&1; then
  mas upgrade
fi

echo
echo "Checking for system updates ..."

softwareupdate --install --all
