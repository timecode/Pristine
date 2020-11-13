#!/usr/bin/env sh

################################################################################
# Change default shell

echo
echo "Checking default shell settings ..."

if echo "${SHELL}" | grep zsh; then
  echo "... default shell is already zsh (so leaving it that way) ..."
  echo "    To manually (re)set this:"
  echo "    $ chsh -s /bin/zsh"
else
  echo "... changing shell to zsh (permanently) ..."
  chsh -s /bin/zsh
fi
