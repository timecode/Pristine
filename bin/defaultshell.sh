#!/bin/zsh

################################################################################
# Change default shell

echo ""
if [[ $SHELL != *"/zsh" ]]; then
  echo "Changing shell to zsh (permanently) ..."
  chsh -s /bin/zsh
else
  echo "Default shell is already zsh (so leaving it that way) ..."
fi
