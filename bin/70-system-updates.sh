#!/usr/bin/env sh

################################################################################
# Update the Mac OS, dependencies and Apple Store installs

echo

# mas no longer working due to macOS version changes.
# For more information see: https://github.com/mas-cli/mas#known-issues
# if mas version >/dev/null 2>&1; then
#   echo "Currently installed apps from the Mac App Store ..."
#   mas list

#   echo
#   echo "Checking for Mac App Store updates ..."
#   mas upgrade
# fi

echo
echo "Checking for system updates ..."

softwareupdate --install --all
